#!/usr/bin/env bash
# personal-hp 统一入口
# 用法：
#   本地运行：bash install.sh [插件名] [模式] [目标目录]
#   远程一行：curl -fsSL https://raw.githubusercontent.com/你的用户名/personal_hp/main/install.sh | bash -s -- [插件名] [模式] [目标目录]

set -e

# 远程 pipe 运行时，BASH_SOURCE[0] 是 "bash" 或空，本地文件不存在
# 此时先把仓库下载到临时目录，再重新执行
REPO_URL="https://github.com/baobaojin/personal_hp.git"

if [ ! -f "${BASH_SOURCE[0]}" ] || [ "${BASH_SOURCE[0]}" = "bash" ] || [ "${BASH_SOURCE[0]}" = "/dev/stdin" ]; then
  echo ""
  echo "检测到远程安装模式，正在下载 personal-hp..."

  # 检查 git 是否可用
  if ! command -v git >/dev/null 2>&1; then
    echo "错误：需要安装 git 才能继续"
    exit 1
  fi

  TMP=$(mktemp -d)
  git clone --depth 1 "$REPO_URL" "$TMP/personal_hp" 2>&1 | tail -1
  bash "$TMP/personal_hp/install.sh" "$@"
  rm -rf "$TMP"
  exit 0
fi

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
