"""Duyệt câu hỏi qua file CSV thay vì sửa trực tiếp questions_vi.jsonl.

    python scripts/dataset/review_questions.py export              # ghi data/interim/review.csv
    python scripts/dataset/review_questions.py import              # đọc review.csv, cập nhật questions_vi.jsonl

- Chỉ xuất câu keep=true. Mở CSV bằng Excel hoặc Google Sheets (UTF-8), điền cột review_status:
  APPROVED, REJECTED, hoặc để trống/PENDING nếu chưa duyệt.
- Có thể sửa trực tiếp content, position, question_type, level, answer_hint, reference_answer;
  khi import, dòng nào sai luật (enum, vị trí ngoài danh mục, ký hiệu markdown, đáp án không đúng 3-6 ý)
  sẽ bị báo lỗi và không ghi gì cả.
- Câu được sửa nội dung ghi generated_by.edited_by_reviewer = true để biết đã khác bản chuẩn hoá.
"""

import argparse
import csv
import json
import re
import sys
from collections import Counter
from pathlib import Path

import normalize_questions as nq

DEFAULT_CSV = nq.ROOT / "data" / "interim" / "review.csv"
TAXONOMY = nq.ROOT / "docs" / "business" / "Danh_Muc_Nganh_Vi_Tri.md"
STATUSES = {"PENDING", "APPROVED", "REJECTED"}
EDITABLE = ["content", "position", "question_type", "level", "answer_hint", "reference_answer"]
COLUMNS = ["id", "review_status"] + EDITABLE + ["content_en", "source_url"]


def it_positions():
    """Danh sách vị trí ngành IT lấy từ bảng trong Danh_Muc_Nganh_Vi_Tri.md."""
    for line in TAXONOMY.read_text(encoding="utf-8").splitlines():
        if line.startswith("| `IT` |") and "`Chung`" in line:  # bảng vị trí, không phải bảng ngành
            return set(re.findall(r"`([^`]+)`", line.split("|")[2]))
    sys.exit(f"Không tìm thấy dòng vị trí IT trong {TAXONOMY}")


def export(rows, path):
    with path.open("w", encoding="utf-8-sig", newline="") as f:  # BOM để Excel nhận đúng UTF-8
        w = csv.DictWriter(f, fieldnames=COLUMNS)
        w.writeheader()
        for r in rows:
            if r["keep"]:
                w.writerow({**{c: r.get(c) or "" for c in ["id", "review_status"] + EDITABLE},
                            "content_en": r["content_en"], "source_url": r["source"]["url"]})
    print(f"Đã ghi {sum(r['keep'] for r in rows)} câu vào {path}", file=sys.stderr)


def check(row, positions):
    errors = []
    status = (row["review_status"] or "PENDING").strip().upper()
    if status not in STATUSES:
        errors.append(f"review_status '{row['review_status']}' không hợp lệ")
    if row["position"] not in positions:
        errors.append(f"vị trí '{row['position']}' không có trong danh mục")
    result = {"keep": True, "content_vi": row["content"], "question_type": row["question_type"], "level": row["level"],
              "answer_hint": row["answer_hint"], "reference_answer": row["reference_answer"]}
    errors += nq.validate(result, None)
    if row["question_type"] != "TECHNICAL" and row["reference_answer"].strip():
        errors.append("chỉ câu TECHNICAL mới có reference_answer")
    return status, errors


def import_(rows, path):
    by_id = {r["id"]: r for r in rows}
    positions = it_positions()
    with path.open(encoding="utf-8-sig", newline="") as f:
        sheet = list(csv.DictReader(f))
    updates, problems = [], []
    for n, row in enumerate(sheet, start=2):  # dòng 1 là tiêu đề
        row = {k: (v or "").replace("\r\n", "\n").strip() for k, v in row.items()}
        if row["id"] not in by_id or not by_id[row["id"]]["keep"]:
            problems.append(f"dòng {n}: id '{row['id']}' không có hoặc đã bị loại khi chuẩn hoá")
            continue
        status, errors = check(row, positions)
        if errors:
            problems.append(f"dòng {n} ({row['id']}): " + "; ".join(errors))
        updates.append((row, status))
    if problems:
        sys.exit("Không ghi gì, sửa các lỗi sau rồi import lại:\n  " + "\n  ".join(problems))

    stats = Counter()
    for row, status in updates:
        r = by_id[row["id"]]
        changed = [c for c in EDITABLE if (r.get(c) or "") != row[c]]
        for c in changed:
            r[c] = row[c] or None
        if changed:
            r["generated_by"]["edited_by_reviewer"] = True
            stats["sửa nội dung"] += 1
        r["review_status"] = status
        stats[status] += 1
    with nq.DEFAULT_OUT.open("w", encoding="utf-8", newline="\n") as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")
    print(f"Đã cập nhật {nq.DEFAULT_OUT}: " + ", ".join(f"{k} {v}" for k, v in sorted(stats.items())), file=sys.stderr)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("command", choices=["export", "import"])
    parser.add_argument("--csv", type=Path, default=DEFAULT_CSV)
    args = parser.parse_args()
    sys.stderr.reconfigure(encoding="utf-8")

    rows = nq.read_jsonl(nq.DEFAULT_OUT)
    if args.command == "export":
        export(rows, args.csv)
    else:
        import_(rows, args.csv)


if __name__ == "__main__":
    main()
