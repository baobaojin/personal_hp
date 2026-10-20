#!/usr/bin/env bash
# index.sh — 重建 AI 向量索引
# 用法：bash index.sh
# 注意：需要先安装 Ollama 和 llama-index，详见 docs/meta/how-to-use.md

set -e

KB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$KB_DIR/.venv/bin/activate" ]; then
  echo "⚠️  未找到 .venv，请先创建虚拟环境并安装依赖"
  exit 1
fi

source "$KB_DIR/.venv/bin/activate"

if [ ! -f "$KB_DIR/scripts/index.py" ]; then
  echo "⚠️  未找到 scripts/index.py，AI 向量索引功能尚未配置"
  echo "参考文档：docs/meta/how-to-use.md"
  exit 1
fi

echo "🤖 重建 AI 向量索引..."
python3 "$KB_DIR/scripts/index.py"
echo "✅ 索引重建完成"
