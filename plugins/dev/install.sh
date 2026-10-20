#!/usr/bin/env bash
# dev 插件安装脚本
# 支持安装全部规范，或按方向细粒度选择

set -e
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$PLUGIN_DIR/../../shared/_lib.sh"

SCOPE=$1

echo ""
echo "================================================"
echo "  personal-hp · dev 插件（程序开发规范）"
echo "================================================"
echo ""

# 扫描所有可用规范
list_scopes() {
  echo "可用规范（输入编号或名称）："
  echo ""
  local i=1
  for dir in "$PLUGIN_DIR/rules"/*/; do
    scope=$(basename "$dir")
    files=$(ls "$dir"*.md 2>/dev/null | wc -l | tr -d ' ')
    echo "  $i) $scope  （$files 个规范文件）"
    i=$((i + 1))
  done
  echo "  0) all  — 安装全部规范"
  echo ""
}

# 把编号转成目录名
resolve_scope() {
  local input=$1
  if [ "$input" = "0" ] || [ "$input" = "all" ]; then
    echo "all"
    return
  fi
  # 如果是数字，按序号找对应目录
  if [[ "$input" =~ ^[0-9]+$ ]]; then
    local i=1
    for dir in "$PLUGIN_DIR/rules"/*/; do
      if [ "$i" = "$input" ]; then
        basename "$dir"
        return
      fi
      i=$((i + 1))
    done
    echo ""
    return
  fi
  # 如果是名称，直接验证是否存在
  if [ -d "$PLUGIN_DIR/rules/$input" ]; then
    echo "$input"
  else
    echo ""
  fi
}

install_scope() {
  local scope=$1
  local src="$PLUGIN_DIR/rules/$scope"
  local dest="$HOME/.claude/rules/dev-$scope"

  if [ ! -d "$src" ] || [ -z "$(ls "$src"/*.md 2>/dev/null)" ]; then
    log_warn "跳过 $scope（无规范文件）"
    return
  fi

  mkdir -p "$dest"
  cp "$src/"*.md "$dest/"
  log_info "✅ $scope → $dest"
}

if [ -z "$SCOPE" ]; then
  list_scopes
  read -p "选择要安装的规范：" choice
  SCOPE=$(resolve_scope "$choice")
  if [ -z "$SCOPE" ]; then
    log_error "无效输入：$choice"
    exit 1
  fi
fi

echo ""
if [ "$SCOPE" = "all" ]; then
  log_step "安装全部规范..."
  for dir in "$PLUGIN_DIR/rules"/*/; do
    install_scope "$(basename "$dir")"
  done
else
  RESOLVED=$(resolve_scope "$SCOPE")
  if [ -z "$RESOLVED" ]; then
    log_error "找不到规范：$SCOPE"
    echo ""
    list_scopes
    exit 1
  fi
  install_scope "$RESOLVED"
fi

echo ""
log_info "安装完成，下次打开 Claude Code 即自动生效。"
echo ""
echo "已安装到 ~/.claude/rules/dev-*/ 目录下。"
