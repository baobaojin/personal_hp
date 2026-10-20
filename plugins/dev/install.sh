#!/usr/bin/env bash
# dev 插件安装脚本
# 安装程序开发规范到全局 ~/.claude/rules/
# 支持选择安装范围：全部 / 仅前端 / 仅后端 / 仅架构

set -e
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$PLUGIN_DIR/../../shared/_lib.sh"

SCOPE=$1

echo ""
echo "================================================"
echo "  personal-hp · dev 插件（程序开发规范）"
echo "================================================"
echo ""

if [ -z "$SCOPE" ]; then
  echo "选择安装范围："
  echo "  1) all          — 安装全部规范（前端 + 后端 + 架构 + 通用）"
  echo "  2) frontend     — 仅前端规范"
  echo "  3) backend      — 仅后端规范"
  echo "  4) architecture — 仅架构设计规范"
  echo "  5) common       — 仅通用规范（代码质量 + Git）"
  echo ""
  read -p "输入编号（默认 1）：" choice
  choice=${choice:-1}
  case $choice in
    1) SCOPE="all" ;;
    2) SCOPE="frontend" ;;
    3) SCOPE="backend" ;;
    4) SCOPE="architecture" ;;
    5) SCOPE="common" ;;
    *) echo "无效输入"; exit 1 ;;
  esac
fi

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

echo ""
case $SCOPE in
  all)
    install_scope frontend
    install_scope backend
    install_scope architecture
    install_scope common
    ;;
  *)
    install_scope "$SCOPE"
    ;;
esac

echo ""
log_info "安装完成，下次打开 Claude Code 即自动生效。"
