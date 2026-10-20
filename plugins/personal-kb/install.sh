#!/usr/bin/env bash
# personal-kb 插件入口脚本
# 用法：bash install.sh <模式> [目标目录] [参数]

set -e
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$PLUGIN_DIR/../../shared/_lib.sh"

MODE=$1
TARGET=$2
ARG=$3

show_help() {
  echo "用法：bash install.sh <模式> [目标目录] [参数]"
  echo ""
  echo "模式："
  echo "  init             初始化新知识库（创建目录结构 + 安装工作流）"
  echo "  upgrade          首次安装工作流到已有知识库"
  echo "  update           整体更新全部 skills/workflows 到最新版本"
  echo "  update-category  更新某一类（skills / skills-extended / workflows）"
  echo "  update-skill     更新单个 Skill（传 skill 名称或交互选择）"
  echo "  version          查看当前插件版本"
  echo ""
  echo "示例："
  echo "  bash install.sh init ~/my-kb"
  echo "  bash install.sh upgrade ~/my-kb"
  echo "  bash install.sh update ~/my-kb"
  echo "  bash install.sh update-category ~/my-kb skills"
  echo "  bash install.sh update-category ~/my-kb workflows"
  echo "  bash install.sh update-skill ~/my-kb intake"
}

# 版本查询不需要 TARGET
if [ "$MODE" = "version" ]; then
  grep '"version"' "$PLUGIN_DIR/plugin.json" | head -1 | sed 's/.*: *"\(.*\)".*/\1/'
  exit 0
fi

if [ -z "$MODE" ]; then
  echo "请选择操作模式："
  echo "  1) init             — 初始化新知识库"
  echo "  2) upgrade          — 首次安装到已有知识库"
  echo "  3) update           — 整体更新所有 skills/workflows"
  echo "  4) update-category  — 更新某一类 skill"
  echo "  5) update-skill     — 更新单个 Skill"
  echo "  6) version          — 查看版本"
  echo ""
  read -p "输入编号：" choice
  case $choice in
    1) MODE="init" ;;
    2) MODE="upgrade" ;;
    3) MODE="update" ;;
    4) MODE="update-category" ;;
    5) MODE="update-skill" ;;
    6) grep '"version"' "$PLUGIN_DIR/plugin.json" | head -1 | sed 's/.*: *"\(.*\)".*/\1/'; exit 0 ;;
    *) echo "无效输入"; exit 1 ;;
  esac
fi

if [ -z "$TARGET" ]; then
  read -p "目标目录路径（默认：./personal-kb）：" TARGET
  TARGET=${TARGET:-./personal-kb}
fi

if [ -n "$TARGET" ]; then
  TARGET="$(cd "$(dirname "$TARGET")" 2>/dev/null && pwd)/$(basename "$TARGET")"
fi

case $MODE in
  init)
    bash "$PLUGIN_DIR/scripts/init.sh" "$TARGET" "$PLUGIN_DIR"
    ;;
  upgrade)
    bash "$PLUGIN_DIR/scripts/upgrade.sh" "$TARGET" "$PLUGIN_DIR"
    ;;
  update)
    bash "$PLUGIN_DIR/scripts/update.sh" "$TARGET" "$PLUGIN_DIR"
    ;;
  update-category)
    bash "$PLUGIN_DIR/scripts/update-category.sh" "$TARGET" "$PLUGIN_DIR" "$ARG"
    ;;
  update-skill)
    bash "$PLUGIN_DIR/scripts/update-skill.sh" "$TARGET" "$PLUGIN_DIR" "$ARG"
    ;;
  *)
    echo "未知模式：$MODE"
    show_help
    exit 1
    ;;
esac
