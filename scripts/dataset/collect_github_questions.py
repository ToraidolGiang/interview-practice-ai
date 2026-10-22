"""Thu thập câu hỏi phỏng vấn từ các repo GitHub có license mở.

Đầu ra: file JSONL, mỗi dòng một câu hỏi tiếng Anh kèm nguồn, license, đáp án gốc (nếu có)
và nhãn phỏng đoán (question_type_guess, level_guess). Bước dịch/chuẩn hoá sang tiếng Việt
và gán nhãn chính thức làm ở bước sau, không làm trong script này.

Chỉ dùng thư viện chuẩn của Python. Cách chạy (từ thư mục gốc repo):

    python scripts/dataset/collect_github_questions.py
    python scripts/dataset/collect_github_questions.py --only react-interview-questions --refresh

Biến môi trường GITHUB_TOKEN (không bắt buộc) giúp tránh giới hạn 60 request/giờ của GitHub API.
"""

import argparse
import hashlib
import html
import json
import os
import re
import sys
import textwrap
import urllib.request
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_CACHE = ROOT / "data" / "raw" / "github"
DEFAULT_OUT = ROOT / "data" / "interim" / "github_questions.jsonl"

# Chỉ nhận license cho phép tái sử dụng có ghi nguồn
ALLOWED_LICENSES = {"MIT", "CC-BY-4.0", "Apache-2.0", "CC0-1.0", "BSD-3-Clause"}

MAX_ANSWER_CHARS = 2000


# ---------------------------------------------------------------------------
# Làm sạch markdown/HTML
# ---------------------------------------------------------------------------

def strip_markup(text):
    text = re.sub(r"`{3}", "`", text)
    text = re.sub(r"<[^>]+>", "", text)
    text = html.unescape(text)
    text = re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", text)  # [chữ](link) -> chữ
    text = re.sub(r"[*_]{2,}", "", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def clean_question(text):
    text = strip_markup(text)
    text = re.sub(r"\s*\*{3}\s*$", "", text)  # "***" = câu chưa có đáp án (test-your-sysadmin-skills)
    return text.strip(" -")


def clean_answer(text):
    text = re.sub(r"\*\*\[⬆ Back to Top\]\(#[^)]*\)\*\*", "", text)
    text = re.sub(r"<details>.*?</details>", "", text, flags=re.S)  # bỏ phần "deep-dive" quá dài
    # Chỉ xoá thẻ HTML ngoài code; trong code block/inline code giữ nguyên (JSX có thẻ <h1>, <div>...)
    parts = re.split(r"(```.*?```|`[^`\n]+`)", textwrap.dedent(text), flags=re.S)
    text = "".join(p if i % 2 else html.unescape(re.sub(r"<[^>]+>", "", p)) for i, p in enumerate(parts))
    text = re.sub(r"\n\s*\n\s*\n+", "\n\n", text)
    text = "\n".join(line.rstrip() for line in text.splitlines()).strip()
    if not text or text.lower().startswith("to be completed"):
        return None
    if len(text) > MAX_ANSWER_CHARS:
        text = text[:MAX_ANSWER_CHARS].rsplit(" ", 1)[0] + " …"
    return text


def strip_front_matter(md):
    return re.sub(r"\A---\n.*?\n---\n", "", md, flags=re.S)


# ---------------------------------------------------------------------------
# Phỏng đoán loại câu hỏi (chỉ là gợi ý, LLM/người duyệt sẽ gán lại)
# ---------------------------------------------------------------------------

INTRO_PATTERNS = [
    r"^tell me (something )?about yourself", r"^why do you want", r"^why are you (interested|looking)",
    r"where do you (see yourself|want to be)", r"^what are you looking for", r"strengths?\b.*weakness",
    r"^why (should we|.* good fit)", r"good fit for (the|this) position", r"^what excites you about",
    r"^tell me (the story of )?how you became",
]
BEHAVIORAL_PATTERNS = [
    r"^tell me about a (time|situation|problem|challenge|recent)", r"^(describe|give (me )?an example of|name|share|state|talk about) ",
    r"^(what|which) (was|is|has been) (the|your) (most|biggest|hardest)", r"^how (did|have) you",
    r"^have you ever", r"^in your professional experience",
]
SITUATIONAL_PATTERNS = [
    r"^if (you|this|someone|your)", r"^imagine", r"^what would you do", r"^how would you (handle|deal|approach|react)",
    r"^suppose",
]


def guess_soft_skill_type(question):
    q = question.lower()
    for pattern_list, label in ((INTRO_PATTERNS, "INTRO"), (SITUATIONAL_PATTERNS, "SITUATIONAL"),
                                (BEHAVIORAL_PATTERNS, "BEHAVIORAL")):
        if any(re.search(p, q) for p in pattern_list):
            return label
    return "BEHAVIORAL"


# ---------------------------------------------------------------------------
# Parser cho từng định dạng markdown
# ---------------------------------------------------------------------------

def parse_bullet_list(md):
    """Danh sách gạch đầu dòng / đánh số dưới các heading ##.

    Dòng con thụt lề (câu hỏi phụ) được nối vào câu hỏi cha.
    Bỏ mục "Coding questions", dòng trong code block và câu kết thúc bằng ":" (trỏ tới code block).
    Trả về list (topic, question, answer=None).
    """
    items, topic, in_code = [], None, False
    for line in strip_front_matter(md).splitlines():
        if line.lstrip().startswith("```"):
            in_code = not in_code
            continue
        if in_code:
            continue
        heading = re.match(r"^#{2,3}\s+(.+)", line)
        if heading:
            topic = strip_markup(heading.group(1))
            continue
        if topic and "coding" in topic.lower():
            continue
        item = re.match(r"^(\s*)(?:[-*]|\d+\.)\s+(.+)", line)
        if not item:
            continue
        indent, text = len(item.group(1)), clean_question(item.group(2))
        if not text or text.lower().startswith("source") or text.endswith(":"):
            continue
        if indent > 0 and items:
            t, q, a = items[-1]
            items[-1] = (t, f"{q} {text}", a)
        else:
            items.append((topic, text, None))
    return items


def parse_bold_qa(md):
    """data-science-interviews/theory.md: **Câu hỏi 👶** rồi đến đáp án, phân tách bởi <br/>."""
    items, topic = [], None
    blocks = re.split(r"^(##\s+.+|\*\*.+\*\*\s*)$", md, flags=re.M)
    current_q = None
    for block in blocks:
        if block is None:
            continue
        if block.startswith("## "):
            topic = strip_markup(block[3:])
            continue
        q = re.match(r"^\*\*(.+)\*\*\s*$", block)
        if q:
            current_q = q.group(1).strip()
            continue
        if current_q:
            items.append((topic, current_q, clean_answer(block.replace("<br/>", ""))))
            current_q = None
    return items


def parse_numbered_headings(md):
    """reactjs-interview-questions: "1.  ### Câu hỏi" rồi đến đáp án."""
    items = []
    parts = re.split(r"^\s*\d+\.\s+###\s+(.+)$", md, flags=re.M)
    # parts = [phần đầu, q1, a1, q2, a2, ...]
    for i in range(1, len(parts) - 1, 2):
        items.append((None, clean_question(parts[i]), clean_answer(parts[i + 1])))
    return items


def parse_details_summary(md):
    """test-your-sysadmin-skills: <details><summary><b>Câu hỏi</b></summary> đáp án </details>.

    Heading ### cho biết cấp độ (Junior/Regular/Senior/Guru), ###### cho biết chủ đề.
    Phần "Simple Questions" là danh sách - <b>...</b> không có đáp án.
    """
    items, level, topic = [], None, None
    pattern = re.compile(
        r"^###\s+.*?<a name=\"([\w-]+)\">"            # nhóm 1: cấp độ
        r"|^######\s+(.+?)\s*\(\d+\)\s*$"             # nhóm 2: chủ đề
        r"|^-\s+<b>(.+?)</b>\s*$"                     # nhóm 3: câu hỏi dạng gạch đầu dòng
        r"|<details>\s*<summary><b>(.+?)</b></summary>(.*?)</details>",  # nhóm 4, 5
        flags=re.M | re.S,
    )
    for m in pattern.finditer(md):
        if m.group(1):
            level = m.group(1)
        elif m.group(2):
            topic = strip_markup(m.group(2))
        elif m.group(3):
            items.append((f"{level}|General", clean_question(m.group(3)), None))
        elif m.group(4):
            items.append((f"{level}|{topic}", clean_question(m.group(4)), clean_answer(m.group(5))))
    return items


# ---------------------------------------------------------------------------
# Khai báo nguồn
# ---------------------------------------------------------------------------

DS_LEVEL = {"👶": "EASY", "⭐️": "MEDIUM", "⭐": "MEDIUM", "🚀": "HARD"}
SYSADMIN_LEVEL = {"simple-questions": None, "junior-sysadmin": "EASY", "regular-sysadmin": "MEDIUM",
                  "senior-sysadmin": "HARD", "guru-sysadmin": "HARD"}


def post_tih_behavioral(topic, question, answer):
    return {"question_type_guess": guess_soft_skill_type(question), "level_guess": None}


def post_technical(topic, question, answer):
    return {"question_type_guess": "TECHNICAL", "level_guess": None}


def post_data_science(topic, question, answer):
    level = None
    for emoji, value in DS_LEVEL.items():
        if emoji in question:
            level = value
    return {
        "content_en": re.sub(r"\s*(👶|⭐️|⭐|🚀|‍)+\s*$", "", question).strip(),
        "question_type_guess": "TECHNICAL",
        "level_guess": level,
    }


def post_sysadmin(topic, question, answer):
    level_key, sub_topic = topic.split("|", 1)
    if level_key == "simple-questions":
        return {"topic": "General", "question_type_guess": guess_soft_skill_type(question), "level_guess": None}
    return {"topic": sub_topic, "question_type_guess": "TECHNICAL", "level_guess": SYSADMIN_LEVEL.get(level_key)}


SOURCES = [
    {
        "key": "tech-interview-handbook",
        "repo": "yangshun/tech-interview-handbook",
        "position": "Software Engineer",
        "files": ["apps/website/contents/behavioral-interview-questions.md"],
        "parser": parse_bullet_list,
        "post": post_tih_behavioral,
    },
    {
        "key": "h5bp-frontend",
        "repo": "h5bp/Front-end-Developer-Interview-Questions",
        "position": "Frontend Developer",
        # Bỏ coding-questions.md vì là bài viết code, không hợp trả lời bằng lời nói
        "files": [f"src/questions/{name}-questions.md" for name in
                  ("general", "html", "css", "javascript", "network", "performance", "testing", "fun")],
        "parser": parse_bullet_list,
        "post": post_technical,
        "topic_from_file": True,
    },
    {
        "key": "react-interview-questions",
        "repo": "sudheerj/reactjs-interview-questions",
        "position": "Frontend Developer",
        "files": ["README.md"],
        "parser": parse_numbered_headings,
        "post": post_technical,
        "topic": "React",
    },
    {
        "key": "data-science-interviews",
        "repo": "alexeygrigorev/data-science-interviews",
        "position": "Data Scientist",
        # Bỏ technical.md vì toàn bài SQL/Python phải viết code
        "files": ["theory.md"],
        "parser": parse_bold_qa,
        "post": post_data_science,
    },
    {
        "key": "sysadmin-skills",
        "repo": "trimstray/test-your-sysadmin-skills",
        "position": "System Administrator / DevOps",
        "files": ["README.md"],
        "parser": parse_details_summary,
        "post": post_sysadmin,
    },
]

# Câu hỏi h5bp general/fun phần lớn là câu hỏi mềm
H5BP_SOFT_FILES = {"general", "fun"}


# ---------------------------------------------------------------------------
# Tải dữ liệu
# ---------------------------------------------------------------------------

def http_get(url, accept=None):
    headers = {"User-Agent": "interview-practice-ai-dataset-collector"}
    if accept:
        headers["Accept"] = accept
    token = os.environ.get("GITHUB_TOKEN")
    if token and "api.github.com" in url:
        headers["Authorization"] = f"Bearer {token}"
    with urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=60) as resp:
        return resp.read()


def fetch_repo_meta(repo):
    meta = json.loads(http_get(f"https://api.github.com/repos/{repo}"))
    branch = meta["default_branch"]
    commit = json.loads(http_get(f"https://api.github.com/repos/{repo}/commits/{branch}"))
    return {
        "license": (meta.get("license") or {}).get("spdx_id"),
        "branch": branch,
        "commit": commit["sha"],
    }


def load_file(cache_dir, repo, commit, path, refresh):
    """Tải file theo commit SHA cố định để kết quả tái lập được; lưu cache cục bộ."""
    local = cache_dir / repo.replace("/", "__") / commit[:12] / path
    if local.exists() and not refresh:
        return local.read_text(encoding="utf-8")
    text = http_get(f"https://raw.githubusercontent.com/{repo}/{commit}/{path}").decode("utf-8")
    local.parent.mkdir(parents=True, exist_ok=True)
    local.write_text(text, encoding="utf-8")
    return text


def normalize_for_dedup(text):
    return re.sub(r"[^a-z0-9]+", " ", text.lower()).strip()


def collect_source(src, cache_dir, refresh):
    meta = fetch_repo_meta(src["repo"])
    if meta["license"] not in ALLOWED_LICENSES:
        print(f"  BỎ QUA {src['repo']}: license {meta['license']} không nằm trong danh sách cho phép", file=sys.stderr)
        return []

    records = []
    for path in src["files"]:
        md = load_file(cache_dir, src["repo"], meta["commit"], path, refresh)
        file_name = Path(path).stem.replace("-questions", "")
        for topic, question, answer in src["parser"](md):
            if len(question) < 10:
                continue
            record = {
                "content_en": question,
                "answer_en": answer,
                "topic": src.get("topic") or (file_name.upper() if src.get("topic_from_file") else topic),
                "industry": "IT",
                "position": src["position"],
            }
            record.update(src["post"](topic, question, answer))
            if src["key"] == "h5bp-frontend" and file_name in H5BP_SOFT_FILES:
                record["question_type_guess"] = guess_soft_skill_type(record["content_en"])
            record["source"] = {
                "key": src["key"],
                "repo": src["repo"],
                "path": path,
                "commit": meta["commit"],
                "url": f"https://github.com/{src['repo']}/blob/{meta['commit']}/{path}",
                "license": meta["license"],
            }
            record["id"] = hashlib.sha1(f"{src['key']}|{normalize_for_dedup(record['content_en'])}"
                                        .encode("utf-8")).hexdigest()[:16]
            records.append(record)
    return records


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT, help="file JSONL đầu ra")
    parser.add_argument("--cache-dir", type=Path, default=DEFAULT_CACHE, help="thư mục cache file markdown gốc")
    parser.add_argument("--only", nargs="*", help="chỉ chạy các nguồn có key này")
    parser.add_argument("--refresh", action="store_true", help="tải lại, bỏ qua cache")
    args = parser.parse_args()
    sys.stderr.reconfigure(encoding="utf-8")  # console Windows mặc định cp1252, lỗi khi in tiếng Việt

    sources = [s for s in SOURCES if not args.only or s["key"] in args.only]
    seen, records = set(), []
    for src in sources:
        print(f"- {src['repo']}", file=sys.stderr)
        for record in collect_source(src, args.cache_dir, args.refresh):
            key = normalize_for_dedup(record["content_en"])
            if key in seen:
                continue
            seen.add(key)
            field_order = ["id", "content_en", "answer_en", "question_type_guess", "level_guess",
                           "industry", "position", "topic", "source"]
            records.append({k: record.get(k) for k in field_order})

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("w", encoding="utf-8", newline="\n") as f:
        for record in records:
            f.write(json.dumps(record, ensure_ascii=False) + "\n")

    print(f"\nĐã ghi {len(records)} câu hỏi vào {args.out}", file=sys.stderr)
    for (key, qtype), n in sorted(Counter((r["source"]["key"], r["question_type_guess"]) for r in records).items()):
        print(f"  {key:28} {qtype:12} {n}", file=sys.stderr)
    with_answer = sum(1 for r in records if r["answer_en"])
    print(f"  có đáp án gốc: {with_answer}/{len(records)}", file=sys.stderr)


if __name__ == "__main__":
    main()
