#!/usr/bin/env bash
# frontend 插件安装脚本
# 安装到全局 ~/.claude/rules/，日常前端开发使用

set -e
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$PLUGIN_DIR/../../shared/_lib.sh"

TARGET_RULES="$HOME/.claude/rules/frontend"

echo ""
echo "================================================"
echo "  personal-hp · frontend 插件"
echo "================================================"
echo ""

log_step "[1/1] 安装 rules 到 $TARGET_RULES ..."

mkdir -p "$TARGET_RULES"
cp "$PLUGIN_DIR/rules/"*.md "$TARGET_RULES/"

echo ""
log_info "✅ frontend 插件安装完成"
echo ""
echo "已安装以下规范到 ~/.claude/rules/frontend/："
ls "$TARGET_RULES/"
echo ""
echo "下次打开 Claude Code 即自动生效。"
