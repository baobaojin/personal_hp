#!/usr/bin/env bash
# preview.sh — 本地启动 MkDocs 预览
# 用法：bash preview.sh

set -e

KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 激活虚拟环境
if [ ! -d "$KB_DIR/.venv" ]; then
  echo "⚠️  未找到 .venv，先创建虚拟环境："
  echo "  python3 -m venv .venv"
  echo "  source .venv/bin/activate"
  echo "  pip install mkdocs mkdocs-material -i https://pypi.tuna.tsinghua.edu.cn/simple"
  exit 1
fi

source "$KB_DIR/.venv/bin/activate"
echo "🌐 启动本地预览：http://127.0.0.1:8000"
mkdocs serve
