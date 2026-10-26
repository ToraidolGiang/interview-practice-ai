"""Sinh migration Flyway seed câu hỏi từ data/interim/questions_vi.jsonl.

    python scripts/dataset/build_seed_sql.py                  # chỉ câu đã duyệt (APPROVED)
    python scripts/dataset/build_seed_sql.py --allow-pending  # gồm cả câu chưa duyệt, để chạy thử local

- Lấy câu keep=true có review_status APPROVED (duyệt qua scripts/dataset/review_questions.py);
  câu REJECTED luôn bị loại, câu PENDING chỉ được lấy khi có --allow-pending.
- UUID sinh cố định từ id nguồn (uuid5) nên chạy lại cho cùng kết quả.
- Bỏ câu trùng (position, content) để không vi phạm uq_questions_position_content.
- Tạo tài khoản hệ thống ADMIN làm created_by; password_hash không phải BCrypt nên không đăng nhập được.

File sinh ra là migration: được phép sinh lại cho tới khi đã chạy trên môi trường dùng chung
(deploy). Sau đó mọi thay đổi câu hỏi phải viết migration mới (V3, V4...).
"""

import argparse
import json
import sys
import uuid
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_IN = ROOT / "data" / "interim" / "questions_vi.jsonl"
DEFAULT_OUT = ROOT / "backend" / "src" / "main" / "resources" / "db" / "migration" / "V2__seed_questions.sql"

NAMESPACE = uuid.UUID("6f1c2d4e-8a5b-4c3d-9e7f-0a1b2c3d4e5f")
SYSTEM_USER_ID = "00000000-0000-0000-0000-000000000001"
SYSTEM_USER_EMAIL = "system@interview-practice.local"

QUESTION_TYPES = {"BEHAVIORAL", "SITUATIONAL", "TECHNICAL", "INTRO"}
LEVELS = {"EASY", "MEDIUM", "HARD"}


def sql_str(value):
    if value is None:
        return "NULL"
    return "'" + value.replace("'", "''") + "'"


def load_questions(path, allow_pending=False):
    rows, skipped = [], Counter()
    seen = set()
    with path.open(encoding="utf-8") as f:
        for line in f:
            r = json.loads(line)
            if not r["keep"]:
                skipped[f"loại khi chuẩn hoá ({r['drop_reason']})"] += 1
                continue
            if r.get("review_status") == "REJECTED":
                skipped["người duyệt loại"] += 1
                continue
            if r.get("review_status") != "APPROVED" and not allow_pending:
                skipped["chưa duyệt (PENDING)"] += 1
                continue
            if r["question_type"] not in QUESTION_TYPES or r["level"] not in LEVELS or not r["content"]:
                skipped["dữ liệu không hợp lệ"] += 1
                continue
            key = (r["position"], " ".join(r["content"].split()).lower())
            if key in seen:
                skipped["trùng nội dung cùng vị trí"] += 1
                continue
            seen.add(key)
            rows.append(r)
    return rows, skipped


def build_sql(rows):
    licenses = sorted({(r["source"]["repo"], r["source"]["license"], r["source"]["commit"][:12]) for r in rows})
    lines = [
        "-- Flyway migration V2: seed ngân hàng câu hỏi (sinh bởi scripts/dataset/build_seed_sql.py, không sửa tay).",
        "-- Câu hỏi được chuyển thể sang tiếng Việt bằng Gemini từ các nguồn mở sau (giữ ghi nguồn theo license):",
    ]
    lines += [f"--   https://github.com/{repo} ({lic}, commit {commit})" for repo, lic, commit in licenses]
    lines += [
        "-- Danh mục ngành/vị trí: docs/business/Danh_Muc_Nganh_Vi_Tri.md",
        "",
        "-- Tài khoản hệ thống làm created_by cho câu hỏi seed; password_hash không phải BCrypt nên không đăng nhập được",
        "INSERT INTO users (id, full_name, email, password_hash, role, status)",
        f"VALUES ('{SYSTEM_USER_ID}', 'Hệ thống', '{SYSTEM_USER_EMAIL}', '!disabled', 'ADMIN', 'LOCKED');",
        "",
        "INSERT INTO questions (id, content, industry, position, level, question_type, answer_hint, reference_answer, status, created_by) VALUES",
    ]
    values = []
    for r in rows:
        qid = uuid.uuid5(NAMESPACE, r["id"])
        values.append(
            f"('{qid}', {sql_str(r['content'])}, {sql_str(r['industry'])}, {sql_str(r['position'])}, "
            f"'{r['level']}', '{r['question_type']}', {sql_str(r['answer_hint'])}, "
            f"{sql_str(r['reference_answer'])}, 'ACTIVE', '{SYSTEM_USER_ID}')"
        )
    lines.append(",\n".join(values) + ";")
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--in", dest="input", type=Path, default=DEFAULT_IN)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    parser.add_argument("--allow-pending", action="store_true", help="lấy cả câu chưa duyệt (chỉ dùng để chạy thử)")
    args = parser.parse_args()
    sys.stderr.reconfigure(encoding="utf-8")

    rows, skipped = load_questions(args.input, args.allow_pending)
    args.out.write_text(build_sql(rows), encoding="utf-8", newline="\n")

    print(f"Đã ghi {len(rows)} câu hỏi vào {args.out}", file=sys.stderr)
    for (position, qtype), n in sorted(Counter((r["position"], r["question_type"]) for r in rows).items()):
        print(f"  {position:28} {qtype:12} {n}", file=sys.stderr)
    for reason, n in skipped.items():
        print(f"  bỏ qua - {reason}: {n}", file=sys.stderr)


if __name__ == "__main__":
    main()
