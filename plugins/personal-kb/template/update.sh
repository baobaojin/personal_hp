#!/usr/bin/env bash
# update.sh — 从 personal_hp 更新 skills/workflows 到最新版本
#
# 用法：
#   bash update.sh                  # 更新全部
#   bash update.sh intake           # 更新单个 skill
#   bash update.sh skills           # 更新全部基础 skills
#   bash update.sh skills-extended  # 更新全部扩展 skills
#   bash update.sh workflows        # 更新全部工作流

set -e

INSTALL_URL="https://raw.githubusercontent.com/baobaojin/personal_hp/main/install.sh"
TARGET="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARG=$1

if [ -z "$ARG" ]; then
  # 无参数：整体更新
  echo "🔄 更新全部 skills/workflows..."
  curl -fsSL "$INSTALL_URL" | bash -s -- personal-kb update "$TARGET"
else
  case "$ARG" in
    skills|skills-extended|workflows)
      # 更新某一类
      echo "🔄 更新 $ARG ..."
      curl -fsSL "$INSTALL_URL" | bash -s -- personal-kb update-category "$TARGET" "$ARG"
      ;;
    *)
      # 更新单个 skill（按名称查找）
      echo "🔄 更新 skill: $ARG ..."
      curl -fsSL "$INSTALL_URL" | bash -s -- personal-kb update-skill "$TARGET" "$ARG"
      ;;
  esac
fi
