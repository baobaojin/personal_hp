#!/usr/bin/env bash
# sync.sh — 更新进度总览并推送到 GitHub
# 用法：bash sync.sh [commit message]

set -e

KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MSG=${1:-$(date +%Y-%m-%d)}

# 激活虚拟环境（progress_stat.py 需要）
if [ -f "$KB_DIR/.venv/bin/activate" ]; then
  source "$KB_DIR/.venv/bin/activate"
fi

# 更新进度总览
echo "📊 更新进度总览..."
python3 "$KB_DIR/scripts/progress_stat.py"

# 提交并推送
echo "🚀 推送到 GitHub..."
cd "$KB_DIR"
git add -A
git commit -m "$MSG" 2>/dev/null || echo "没有新内容需要提交"
git push

echo "✅ 同步完成"
