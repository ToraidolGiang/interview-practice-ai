"""Chuyển phiếu chấm đã điền (CSV) thành file nhãn cho metrics.py.

Cách dùng:
  python scripts/gold/import_ratings.py phieu_da_cham.csv --rater nguoi_cham_1

Sinh data/gold/labels/nguoi_cham_1.jsonl. Dừng và liệt kê lỗi nếu phiếu thiếu điểm hoặc điểm sai.
Khi lưu từ Excel, chọn định dạng "CSV UTF-8".
"""

import argparse
import csv
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
LABELS_DIR = ROOT / "data" / "gold" / "labels"
BASE_CODES = ["RELEVANCE", "STRUCTURE", "DEPTH"]
TRUE_VALUES = {"1", "x", "true", "có", "co", "yes"}
FALSE_VALUES = {"", "0", "false", "không", "khong", "no"}


def parse_row(row):
    """Trả về (nhãn, danh sách lỗi) của một dòng phiếu."""
    codes = BASE_CODES + (["CORRECTNESS"] if row["question_type"] == "TECHNICAL" else [])
    scores, problems = {}, []
    for code in codes:
        value = (row.get(code) or "").strip()
        if value in {"1", "2", "3", "4", "5"}:
            scores[code] = int(value)
        else:
            problems.append(f"{row['id']}: {code} phải là số nguyên 1-5, đang là '{value}'")

    flag = (row.get("off_topic") or "").strip().lower()
    if flag not in TRUE_VALUES | FALSE_VALUES:
        problems.append(f"{row['id']}: off_topic không hợp lệ '{flag}'")
    return {"id": row["id"], "scores": scores, "off_topic": flag in TRUE_VALUES}, problems


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("sheet", help="File CSV đã chấm")
    parser.add_argument("--rater", required=True, help="Tên người chấm, dùng làm tên file nhãn")
    args = parser.parse_args()
    if args.rater.startswith("claude"):
        parser.error("Tên bắt đầu bằng 'claude' dành cho nhãn nháp, không dùng cho người chấm")

    with open(args.sheet, encoding="utf-8-sig", newline="") as f:
        rows = list(csv.DictReader(f))

    labels, problems = [], []
    for row in rows:
        label, row_problems = parse_row(row)
        labels.append({**label, "rater": args.rater})
        problems.extend(row_problems)
    if problems:
        print("\n".join(problems), file=sys.stderr)
        sys.exit(1)

    target = LABELS_DIR / f"{args.rater}.jsonl"
    with target.open("w", encoding="utf-8", newline="\n") as f:
        for label in sorted(labels, key=lambda item: item["id"]):
            f.write(json.dumps(label, ensure_ascii=False) + "\n")
    print(f"Đã ghi {len(labels)} nhãn vào {target}")


if __name__ == "__main__":
    main()
