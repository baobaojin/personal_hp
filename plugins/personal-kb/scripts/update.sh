#!/usr/bin/env bash
# update.sh — 整体更新 personal-kb 插件到目标知识库
# 用法：bash scripts/update.sh <目标目录> <插件根目录>
#
# 和 upgrade.sh 的区别：
#   upgrade.sh — 首次安装，CLAUDE.md 不存在时才创建
#   update.sh  — 更新已安装的插件，skills/workflows 全量覆盖，CLAUDE.md 不动

set -e

TARGET=$1
PLUGIN_DIR=$2

source "$PLUGIN_DIR/../../shared/_lib.sh"

if [ -z "$TARGET" ] || [ -z "$PLUGIN_DIR" ]; then
  echo "用法：bash scripts/update.sh <目标目录> <插件根目录>"
  exit 1
fi

if [ ! -d "$TARGET/.claude" ]; then
  log_error "目标目录未安装 personal-kb 插件（缺少 .claude/）"
  echo "请先运行 install.sh upgrade 完成初次安装"
  exit 1
fi

# 读取当前版本
INSTALLED_VERSION="未知"
if [ -f "$TARGET/.claude/version" ]; then
  INSTALLED_VERSION=$(cat "$TARGET/.claude/version")
fi

NEW_VERSION=$(node -e "console.log(require('$PLUGIN_DIR/plugin.json').version)" 2>/dev/null \
  || python3 -c "import json; print(json.load(open('$PLUGIN_DIR/plugin.json'))['version'])" 2>/dev/null \
  || grep '"version"' "$PLUGIN_DIR/plugin.json" | head -1 | sed 's/.*: *"\(.*\)".*/\1/')

echo ""
echo "================================================"
echo "  personal-kb 插件更新"
echo "================================================"
echo ""
log_info "当前版本：$INSTALLED_VERSION"
log_info "新版本：  $NEW_VERSION"
echo ""

if [ "$INSTALLED_VERSION" = "$NEW_VERSION" ]; then
  log_warn "已是最新版本（$NEW_VERSION），是否仍要强制更新？(y/n)"
  read -r confirm
  [ "$confirm" != "y" ] && echo "已取消" && exit 0
fi

# 全量更新 skills
log_step "[1/4] 更新 skills ..."
cp "$PLUGIN_DIR/skills/"*.md "$TARGET/.claude/skills/"

# 全量更新 skills-extended
log_step "[2/4] 更新 skills-extended ..."
cp "$PLUGIN_DIR/skills-extended/"*.md "$TARGET/.claude/skills-extended/"

# 全量更新 workflows
log_step "[3/4] 更新 workflows ..."
cp "$PLUGIN_DIR/workflows/"*.md "$TARGET/.claude/workflows/"

# 更新 Python 脚本
log_step "[4/4] 更新脚本 ..."
cp "$PLUGIN_DIR/scripts/"*.py "$TARGET/scripts/" 2>/dev/null || true

# 写入新版本号
echo "$NEW_VERSION" > "$TARGET/.claude/version"

echo ""
log_info "✅ 更新完成：$INSTALLED_VERSION → $NEW_VERSION"
echo ""

# 打印变更日志
CHANGELOG=$(python3 -c "
import json
data = json.load(open('$PLUGIN_DIR/plugin.json'))
changelog = data.get('changelog', {})
version = '$NEW_VERSION'
print(changelog.get(version, '（无变更说明）'))
" 2>/dev/null || echo "（无变更说明）")

echo "本版本变更：$CHANGELOG"
echo ""
