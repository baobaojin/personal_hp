#!/usr/bin/env bash
# update-category.sh — 更新某一类 skills 到目标知识库
# 用法：bash scripts/update-category.sh <目标目录> <插件根目录> [类别]
#
# 类别：skills / skills-extended / workflows
# 不传类别则交互选择

set -e

TARGET=$1
PLUGIN_DIR=$2
CATEGORY=$3

source "$PLUGIN_DIR/../../shared/_lib.sh"

if [ -z "$TARGET" ] || [ -z "$PLUGIN_DIR" ]; then
  echo "用法：bash scripts/update-category.sh <目标目录> <插件根目录> [类别]"
  exit 1
fi

if [ ! -d "$TARGET/.claude" ]; then
  log_error "目标目录未安装 personal-kb 插件（缺少 .claude/）"
  exit 1
fi

VALID_CATEGORIES=("skills" "skills-extended" "workflows")

list_categories() {
  echo "可更新的类别："
  echo "  1) skills           — 基础 Skill（intake/ask/review/plan 等）"
  echo "  2) skills-extended  — 扩展 Skill（文章整理/图书笔记/攻略写作 等）"
  echo "  3) workflows        — 工作流（学习工作流/开发工作流）"
  echo ""
}

# 交互选择
if [ -z "$CATEGORY" ]; then
  list_categories
  read -p "输入类别名称或编号：" choice
  case $choice in
    1|skills)          CATEGORY="skills" ;;
    2|skills-extended) CATEGORY="skills-extended" ;;
    3|workflows)       CATEGORY="workflows" ;;
    *) log_error "无效输入：$choice"; exit 1 ;;
  esac
fi

# 校验类别
valid=false
for c in "${VALID_CATEGORIES[@]}"; do
  [ "$c" = "$CATEGORY" ] && valid=true && break
done

if [ "$valid" = false ]; then
  log_error "未知类别：$CATEGORY"
  echo ""
  list_categories
  exit 1
fi

SRC="$PLUGIN_DIR/$CATEGORY"
DEST="$TARGET/.claude/$CATEGORY"

if [ ! -d "$SRC" ] || [ -z "$(ls "$SRC"/*.md 2>/dev/null)" ]; then
  log_error "源目录为空或不存在：$SRC"
  exit 1
fi

# 列出将要更新的文件
FILES=$(ls "$SRC"/*.md | xargs -I{} basename {})
echo ""
log_info "类别：$CATEGORY"
log_info "文件列表："
for f in $FILES; do
  echo "    $f"
done
echo ""
read -p "确认更新以上文件？(y/n)：" confirm
[ "$confirm" != "y" ] && echo "已取消" && exit 0

mkdir -p "$DEST"
cp "$SRC/"*.md "$DEST/"

echo ""
log_info "✅ 已更新 $CATEGORY（$(echo $FILES | wc -w | tr -d ' ') 个文件）"
