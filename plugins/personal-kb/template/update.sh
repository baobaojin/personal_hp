#!/usr/bin/env bash
# update.sh — 从 personal_hp 更新 skills/workflows 到最新版本
# 用法：bash update.sh

set -e

REPO_URL="https://raw.githubusercontent.com/baobaojin/personal_hp/main/install.sh"
TARGET="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 更新 personal-hp 工作流..."
curl -fsSL "$REPO_URL" | bash -s -- personal-kb update "$TARGET"
