#!/usr/bin/env bash
# personal-hp 统一入口
# 用法：bash install.sh [插件名] [模式] [目标目录]

set -e
HP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "================================================"
echo "  personal-hp · 个人 AI 工作流工具集"
echo "================================================"
echo ""

# 列出可用插件
list_plugins() {
  echo "可用插件："
  echo "  1) personal-kb  — 个人知识库工作流（init/upgrade/update/update-skill）"
  echo "  2) dev          — 程序开发规范（前端/后端/架构，安装到全局 ~/.claude/rules/）"
  echo ""
}

PLUGIN=$1
if [ -z "$PLUGIN" ]; then
  list_plugins
  read -p "选择插件（输入编号或名称）：" choice
  case $choice in
    1|personal-kb) PLUGIN="personal-kb" ;;
    2|dev)         PLUGIN="dev" ;;
    *) echo "无效输入"; exit 1 ;;
  esac
fi

PLUGIN_DIR="$HP_ROOT/plugins/$PLUGIN"

if [ ! -d "$PLUGIN_DIR" ]; then
  echo "插件不存在：$PLUGIN"
  echo ""
  list_plugins
  exit 1
fi

# 把剩余参数传给插件的 install.sh
shift
bash "$PLUGIN_DIR/install.sh" "$@"
