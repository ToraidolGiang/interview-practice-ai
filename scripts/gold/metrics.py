"""Tính chỉ số #159: so bộ chấm với nhãn tham chiếu trên bộ dữ liệu chuẩn.

Cách dùng:
  python scripts/gold/metrics.py --ref data/gold/labels/nguoi_cham_1.jsonl --pred ket_qua_lan1.jsonl
  python scripts/gold/metrics.py --ref ... --pred lan1.jsonl --pred lan2.jsonl --pred lan3.jsonl

Mỗi dòng của file nhãn hoặc file dự đoán:
  {"id": "GOLD-001", "scores": {"RELEVANCE": 4, "STRUCTURE": 3, "DEPTH": 3}, "off_topic": false}

Mặc định chỉ tính trên tập calibration. Chỉ dùng --split holdout cho lần đo chốt, sau khi đã ngừng chỉnh prompt.
So hai người chấm với nhau cũng dùng lệnh này: --ref người 1, --pred người 2.
Chỉ dùng thư viện chuẩn.
"""

import argparse
import json
import statistics
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GOLD = ROOT / "data" / "gold" / "gold_v1.jsonl"

# docs/business/Rubric_Cham_Diem.md mục 4, bỏ DELIVERY vì bộ dữ liệu chỉ có văn bản
WEIGHTS = {
    "BEHAVIORAL": {"RELEVANCE": 20, "STRUCTURE": 30, "DEPTH": 40},
    "SITUATIONAL": {"RELEVANCE": 25, "STRUCTURE": 25, "DEPTH": 40},
    "TECHNICAL": {"RELEVANCE": 15, "STRUCTURE": 15, "DEPTH": 25, "CORRECTNESS": 35},
    "INTRO": {"RELEVANCE": 25, "STRUCTURE": 30, "DEPTH": 35},
}
OFF_TOPIC_CAP = 30.0
SCALE = (1, 2, 3, 4, 5)
TARGET_QWK = 0.6


def quadratic_weighted_kappa(a, b, labels=SCALE):
    """QWK trên thang cố định. Trả về None khi không xác định được (mẫu số bằng 0)."""
    if len(a) != len(b) or not a:
        raise ValueError("Hai dãy phải cùng độ dài và không rỗng")
    size = len(labels)
    index = {label: i for i, label in enumerate(labels)}
    observed = [[0] * size for _ in range(size)]
    for x, y in zip(a, b):
        observed[index[x]][index[y]] += 1
    row = [sum(r) for r in observed]
    col = [sum(observed[i][j] for i in range(size)) for j in range(size)]
    total = len(a)
    numerator = denominator = 0.0
    for i in range(size):
        for j in range(size):
            weight = (i - j) ** 2 / (size - 1) ** 2
            numerator += weight * observed[i][j]
            denominator += weight * row[i] * col[j] / total
    return None if denominator == 0 else 1 - numerator / denominator


def _ranks(values):
    order = sorted(range(len(values)), key=lambda i: values[i])
    ranks = [0.0] * len(values)
    i = 0
    while i < len(order):
        j = i
        while j + 1 < len(order) and values[order[j + 1]] == values[order[i]]:
            j += 1
        for k in range(i, j + 1):
            ranks[order[k]] = (i + j) / 2 + 1  # hạng trung bình cho giá trị bằng nhau
        i = j + 1
    return ranks


def spearman(a, b):
    """Hệ số Spearman có xử lý giá trị bằng nhau. Trả về None nếu một dãy là hằng số."""
    if len(set(a)) < 2 or len(set(b)) < 2:
        return None
    return statistics.correlation(_ranks(a), _ranks(b))


def mean_absolute_error(a, b):
    return sum(abs(x - y) for x, y in zip(a, b)) / len(a)


def content_score(question_type, label):
    """Điểm 0-100 từ các tiêu chí LLM, có trần lạc đề; khớp totalScore khi không có Delivery."""
    weights = WEIGHTS[question_type]
    score = sum(w * (label["scores"][code] - 1) / 4 for code, w in weights.items()) * 100 / sum(weights.values())
    return min(score, OFF_TOPIC_CAP) if label.get("off_topic") else score


def load_labels(path):
    with Path(path).open(encoding="utf-8") as f:
        rows = [json.loads(line) for line in f if line.strip()]
    return {row["id"]: row for row in rows}


def load_gold():
    with GOLD.open(encoding="utf-8") as f:
        return [json.loads(line) for line in f]


def select_items(gold, ref, split):
    """Câu dùng để đo. Câu ngoài rating_set chỉ được bỏ qua khi nhãn tham chiếu không có.

    Câu trong rating_set mà thiếu nhãn vẫn được giữ lại để validate báo lỗi, không bị bỏ sót âm thầm.
    """
    return [
        item for item in gold
        if (split == "all" or item["split"] == split) and (item["rating_set"] or item["id"] in ref)
    ]


def validate(items, labels, name):
    problems = []
    for item in items:
        label = labels.get(item["id"])
        if label is None:
            problems.append(f"{name}: thiếu {item['id']}")
            continue
        expected = set(WEIGHTS[item["question_type"]])
        if set(label["scores"]) != expected:
            problems.append(f"{name}: {item['id']} cần đúng các tiêu chí {sorted(expected)}")
        elif any(label["scores"][code] not in SCALE for code in expected):
            problems.append(f"{name}: {item['id']} có điểm ngoài thang 1-5")
    return problems


def length_baseline_qwk(items, ref, code):
    """QWK của bộ chấm giả chỉ xếp hạng theo số từ, dùng đúng phân bố điểm tham chiếu.

    Bộ chấm thật phải vượt mốc này, nếu không thì QWK cao có thể chỉ phản ánh độ dài câu trả lời.
    """
    actual = [ref[i["id"]]["scores"][code] for i in items]
    by_length = sorted(range(len(items)), key=lambda k: (items[k]["word_count"], items[k]["id"]))
    fake = [0] * len(items)
    for score, position in zip(sorted(actual), by_length):
        fake[position] = score
    return quadratic_weighted_kappa(actual, fake)


def fmt(value):
    return "n/a" if value is None else f"{value:.3f}"


def report(items, ref, preds):
    first = preds[0]
    codes = ["RELEVANCE", "STRUCTURE", "DEPTH", "CORRECTNESS"]
    lines = [f"{'Tiêu chí':<14}{'n':>5}{'QWK':>8}{'Mốc độ dài':>12}{'MAE':>8}"]
    for code in codes:
        used = [i for i in items if code in WEIGHTS[i["question_type"]]]
        a = [ref[i["id"]]["scores"][code] for i in used]
        b = [first[i["id"]]["scores"][code] for i in used]
        lines.append(f"{code:<14}{len(used):>5}{fmt(quadratic_weighted_kappa(a, b)):>8}"
                     f"{fmt(length_baseline_qwk(used, ref, code)):>12}{mean_absolute_error(a, b):>8.3f}")

    ref_total = [content_score(i["question_type"], ref[i["id"]]) for i in items]
    pred_total = [content_score(i["question_type"], first[i["id"]]) for i in items]
    lines.append("")
    lines.append(f"Điểm tổng 0-100 (n={len(items)}): Spearman {fmt(spearman(ref_total, pred_total))}, "
                 f"MAE {mean_absolute_error(ref_total, pred_total):.2f}")

    lengths = [i["word_count"] for i in items]
    lines.append(f"Thiên lệch độ dài, Spearman(số từ, điểm): tham chiếu {fmt(spearman(lengths, ref_total))}, "
                 f"bộ chấm {fmt(spearman(lengths, pred_total))}")

    if len(preds) > 1:
        deviations = [statistics.stdev([content_score(i["question_type"], p[i["id"]]) for p in preds]) for i in items]
        lines.append(f"Độ lặp lại qua {len(preds)} lần chạy: độ lệch chuẩn trung bình {statistics.mean(deviations):.2f}, "
                     f"lớn nhất {max(deviations):.2f}")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--ref", required=True, help="File nhãn tham chiếu")
    parser.add_argument("--pred", required=True, action="append", help="File dự đoán, lặp lại để đo độ lặp lại")
    parser.add_argument("--split", choices=["calibration", "holdout", "all"], default="calibration")
    args = parser.parse_args()

    ref = load_labels(args.ref)
    items = select_items(load_gold(), ref, args.split)
    preds = [load_labels(path) for path in args.pred]
    problems = validate(items, ref, "ref")
    for path, pred in zip(args.pred, preds):
        problems.extend(validate(items, pred, path))
    if problems:
        print("\n".join(problems[:20]), file=sys.stderr)
        sys.exit(1)

    raters = {ref[i["id"]].get("rater", "") for i in items}
    if any(r.startswith("claude") for r in raters):
        print("CẢNH BÁO: nhãn tham chiếu là nhãn nháp của Claude, không phải người chấm. "
              "Kết quả chỉ dùng để thử quy trình, không đưa vào báo cáo như độ đồng thuận AI với người.\n")
    print(f"Tập: {args.split}, n={len(items)}, mục tiêu QWK >= {TARGET_QWK}\n")
    print(report(items, ref, preds))


if __name__ == "__main__":
    main()
