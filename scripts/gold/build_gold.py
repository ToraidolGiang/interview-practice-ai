"""Dựng bộ dữ liệu chuẩn #159 từ data/gold/source/*.jsonl.

Sinh ra:
- data/gold/gold_v1.jsonl: câu trả lời kèm câu hỏi và tập (calibration/holdout), không có nhãn
- data/gold/labels/claude_draft.jsonl: nhãn nháp của Claude, KHÔNG phải nhãn người
- data/gold/rater_sheet.csv: phiếu chấm mù cho người (xáo thứ tự, không có nhãn nháp)

Tách tập theo câu hỏi, không theo câu trả lời, để holdout không chứa câu hỏi đã dùng khi chỉnh prompt.
Chạy lại cho cùng kết quả. Chỉ dùng thư viện chuẩn.
"""

import csv
import hashlib
import json
import random
import sys
import uuid
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE_DIR = ROOT / "data" / "gold" / "source"
QUESTIONS = ROOT / "data" / "interim" / "questions_vi.jsonl"
SEED_SQL = ROOT / "backend" / "src" / "main" / "resources" / "db" / "migration" / "V2__seed_questions.sql"
OUT_DIR = ROOT / "data" / "gold"

# Phải trùng scripts/dataset/build_seed_sql.py để id khớp bảng questions
QUESTION_NAMESPACE = uuid.UUID("6f1c2d4e-8a5b-4c3d-9e7f-0a1b2c3d4e5f")
SPLIT_SALT = "gold-v1"
HOLDOUT_PER_TYPE = 2
MIN_WORDS = 15  # dưới mức này pipeline trả ANSWER_TOO_SHORT, không gọi LLM

CRITERIA = {
    "BEHAVIORAL": ["RELEVANCE", "STRUCTURE", "DEPTH"],
    "SITUATIONAL": ["RELEVANCE", "STRUCTURE", "DEPTH"],
    "INTRO": ["RELEVANCE", "STRUCTURE", "DEPTH"],
    "TECHNICAL": ["RELEVANCE", "STRUCTURE", "DEPTH", "CORRECTNESS"],
}
# contrast: câu đối chứng ngắn mà tốt, dài mà yếu, để độ dài không tự dự đoán được điểm
SOURCE_ORDER = ["behavioral", "situational", "technical", "intro", "contrast"]
RATER_COLUMNS = ["RELEVANCE", "STRUCTURE", "DEPTH", "CORRECTNESS", "off_topic"]


def load_questions():
    with QUESTIONS.open(encoding="utf-8") as f:
        return [json.loads(line) for line in f]


def find_question(rows, prefix):
    matches = [r for r in rows if r["id"].startswith(prefix)]
    if len(matches) != 1:
        raise ValueError(f"Mã câu hỏi {prefix} khớp {len(matches)} dòng")
    return matches[0]


def read_source():
    items = []
    for name in SOURCE_ORDER:
        path = SOURCE_DIR / f"{name}.jsonl"
        with path.open(encoding="utf-8") as f:
            for number, line in enumerate(f, 1):
                item = json.loads(line)
                item["origin"] = f"{path.name}:{number}"
                items.append(item)
    return items


def holdout_questions(by_type):
    chosen = set()
    for question_ids in by_type.values():
        ranked = sorted(question_ids, key=lambda q: hashlib.sha256(f"{SPLIT_SALT}:{q}".encode()).hexdigest())
        chosen.update(ranked[:HOLDOUT_PER_TYPE])
    return chosen


def build():
    rows = load_questions()
    seed_sql = SEED_SQL.read_text(encoding="utf-8")
    items = read_source()
    errors = []
    by_type = {}
    prepared = []

    for item in items:
        question = find_question(rows, item["q"])
        qtype = question["question_type"]
        question_uuid = str(uuid.uuid5(QUESTION_NAMESPACE, question["id"]))
        codes = CRITERIA[qtype]
        words = len(item["a"].split())

        if question_uuid not in seed_sql:
            errors.append(f"{item['origin']}: câu hỏi không có trong seed V2")
        if len(item["s"]) != len(codes):
            errors.append(f"{item['origin']}: cần {len(codes)} điểm, có {len(item['s'])}")
        if not all(isinstance(s, int) and 1 <= s <= 5 for s in item["s"]):
            errors.append(f"{item['origin']}: điểm ngoài khoảng 1-5")
        if words < MIN_WORDS:
            errors.append(f"{item['origin']}: chỉ có {words} từ")
        if qtype == "TECHNICAL" and not question.get("reference_answer"):
            errors.append(f"{item['origin']}: câu TECHNICAL thiếu reference_answer")

        by_type.setdefault(qtype, set()).add(question["id"])
        prepared.append((item, question, question_uuid, codes, words))

    transcripts = Counter(item["a"] for item in items)
    errors.extend(f"Trùng câu trả lời: {text[:50]}" for text, count in transcripts.items() if count > 1)
    if errors:
        print("\n".join(errors), file=sys.stderr)
        sys.exit(1)

    holdout = holdout_questions(by_type)
    # Xáo trước khi đánh số: id theo thứ tự file sẽ để lộ mức chất lượng cho người chấm mù
    random.Random(SPLIT_SALT).shuffle(prepared)
    gold, labels = [], []
    for number, (item, question, question_uuid, codes, words) in enumerate(prepared, 1):
        answer_id = f"GOLD-{number:03d}"
        gold.append({
            "id": answer_id,
            "split": "holdout" if question["id"] in holdout else "calibration",
            "question_id": question_uuid,
            "question_type": question["question_type"],
            "position": question["position"],
            "level": question["level"],
            "question": question["content"],
            "reference_answer": question.get("reference_answer") if question["question_type"] == "TECHNICAL" else None,
            "transcript": item["a"],
            "word_count": words,
        })
        labels.append({
            "id": answer_id,
            "rater": "claude-draft",
            "scores": dict(zip(codes, item["s"])),
            "off_topic": item["off"],
            "target_tier": item["t"],
            "note": item["n"],
        })
    return gold, labels


def write_jsonl(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as f:
        for row in rows:
            f.write(json.dumps(row, ensure_ascii=False) + "\n")


def write_rater_sheet(path, gold):
    # utf-8-sig để Excel đọc đúng tiếng Việt
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["id", "question_type", "question", "reference_answer", "transcript", *RATER_COLUMNS])
        for row in gold:
            correctness = "" if row["question_type"] == "TECHNICAL" else "N/A"
            writer.writerow([
                row["id"], row["question_type"], row["question"], row["reference_answer"] or "",
                row["transcript"], "", "", "", correctness, "",
            ])


def main():
    gold, labels = build()
    write_jsonl(OUT_DIR / "gold_v1.jsonl", gold)
    write_jsonl(OUT_DIR / "labels" / "claude_draft.jsonl", labels)
    write_rater_sheet(OUT_DIR / "rater_sheet.csv", gold)
    print(f"{len(gold)} câu trả lời, tập: {dict(Counter(g['split'] for g in gold))}")
    print(f"Loại: {dict(Counter(g['question_type'] for g in gold))}")


if __name__ == "__main__":
    main()
