#!/usr/bin/env bash
# update-skill.sh — 更新单个 Skill 到目标知识库
# 用法：bash scripts/update-skill.sh <目标目录> <插件根目录> [skill名称]
#
# 示例：
#   bash scripts/update-skill.sh ~/personal-kb . intake
#   bash scripts/update-skill.sh ~/personal-kb . write-guide
#   不传 skill 名称则列出所有可用 Skill，交互选择

set -e

TARGET=$1
PLUGIN_DIR=$2
SKILL_NAME=$3

source "$PLUGIN_DIR/../../shared/_lib.sh"

if [ -z "$TARGET" ] || [ -z "$PLUGIN_DIR" ]; then
  echo "用法：bash scripts/update-skill.sh <目标目录> <插件根目录> [skill名称]"
  exit 1
fi

if [ ! -d "$TARGET/.claude" ]; then
  log_error "目标目录未安装 personal-kb 插件（缺少 .claude/）"
  exit 1
fi

# 列出所有可用 Skill
list_skills() {
  echo "可用 Skill："
  echo ""
  echo "  [基础 skills]"
  for f in "$PLUGIN_DIR/skills/"*.md; do
    name=$(basename "$f" .md)
    echo "    $name"
  done
  echo ""
  echo "  [扩展 skills-extended]"
  for f in "$PLUGIN_DIR/skills-extended/"*.md; do
    name=$(basename "$f" .md)
    echo "    $name"
  done
  echo ""
  echo "  [工作流 workflows]"
  for f in "$PLUGIN_DIR/workflows/"*.md; do
    name=$(basename "$f" .md)
    echo "    $name"
  done
  echo ""
}

# 查找 Skill 文件
find_skill_file() {
  local name=$1
  # 依次在 skills、skills-extended、workflows 中查找
  for dir in skills skills-extended workflows; do
    local path="$PLUGIN_DIR/$dir/$name.md"
    if [ -f "$path" ]; then
      echo "$path"
      return 0
    fi
  done
  return 1
}

# 获取 Skill 目标目录
get_target_dir() {
  local name=$1
  for dir in skills skills-extended workflows; do
    if [ -f "$PLUGIN_DIR/$dir/$name.md" ]; then
      echo "$TARGET/.claude/$dir"
      return 0
    fi
  done
}

# 交互选择
if [ -z "$SKILL_NAME" ]; then
  list_skills
  read -p "输入要更新的 Skill 名称：" SKILL_NAME
fi

# 查找源文件
SRC=$(find_skill_file "$SKILL_NAME")
if [ $? -ne 0 ] || [ -z "$SRC" ]; then
  log_error "找不到 Skill：$SKILL_NAME"
  echo ""
  list_skills
  exit 1
fi

DEST_DIR=$(get_target_dir "$SKILL_NAME")
DEST="$DEST_DIR/$SKILL_NAME.md"

# 检查目标是否已存在
if [ -f "$DEST" ]; then
  log_info "当前版本：$DEST"
  log_info "更新来源：$SRC"
  echo ""
  read -p "确认覆盖？(y/n)：" confirm
  [ "$confirm" != "y" ] && echo "已取消" && exit 0
fi

mkdir -p "$DEST_DIR"
cp "$SRC" "$DEST"

echo ""
log_info "✅ 已更新：$SKILL_NAME → $DEST"
