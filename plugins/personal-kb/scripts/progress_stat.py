#!/usr/bin/env python3
"""扫描所有笔记，按 status 汇总进度，列出今天到期复习的笔记"""
import re
import datetime
import pathlib
from collections import defaultdict

ROOT = "docs"
today = datetime.date.today().isoformat()
summary = defaultdict(int)
due = []

for p in pathlib.Path(ROOT).rglob("*.md"):
    text = p.read_text(encoding="utf-8")
    m = re.search(r"^status:\s*(.+)", text, re.M)
    status = m.group(1).strip() if m else "未设置"
    summary[status] += 1
    m2 = re.search(r"^next_review:\s*(\S+)", text, re.M)
    if m2 and m2.group(1) <= today:
        due.append(str(p))

lines = [
    "# 学习进度总览\n",
    f"统计日期：{today}\n",
    "\n## 各状态笔记数\n",
]
for k, v in sorted(summary.items()):
    lines.append(f"- {k}：{v} 篇\n")
lines.append("\n## 今天需要复习\n")
if due:
    lines += [f"- {p}\n" for p in due]
else:
    lines.append("- 暂无\n")

pathlib.Path("docs/meta/progress.md").write_text(
    "".join(lines), encoding="utf-8"
)
print(f"已生成进度总览，今天需复习 {len(due)} 篇")
