#!/usr/bin/env bash
# upgrade.sh — 纯安装/更新 skills 和工作流
# 用法：bash scripts/upgrade.sh <目标目录> <person-hp根目录> [--silent]

set -e
source "$(dirname "${BASH_SOURCE[0]}")/../../shared/_lib.sh"

TARGET=$1
HP_ROOT=$2
SILENT=$3

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

[ -z "$SILENT" ] && log_step "[upgrade] 目标：$TARGET"

# 检查目标目录
if [ ! -d "$TARGET" ]; then
  echo "目标目录不存在：$TARGET"
  echo "如果要初始化新知识库，请使用：bash install.sh init"
  exit 1
fi

# 检查是否是已有知识库（有 docs/ 或 CLAUDE.md）
if [ ! -d "$TARGET/docs" ] && [ ! -f "$TARGET/CLAUDE.md" ]; then
  log_warn "⚠️  目标目录看起来不是一个知识库项目（缺少 docs/ 或 CLAUDE.md）"
  read -p "是否仍要继续安装？(y/n)：" confirm
  [ "$confirm" != "y" ] && echo "已取消" && exit 0
fi

# 创建 .claude 目录结构
mkdir -p \
  "$TARGET/.claude/skills" \
  "$TARGET/.claude/skills-extended" \
  "$TARGET/.claude/workflows"

# 复制 skills
[ -z "$SILENT" ] && log_info "安装 skills..."
cp "$HP_ROOT/skills/"*.md "$TARGET/.claude/skills/" 2>/dev/null || true

# 复制 skills-extended
[ -z "$SILENT" ] && log_info "安装 skills-extended..."
cp "$HP_ROOT/skills-extended/"*.md "$TARGET/.claude/skills-extended/" 2>/dev/null || true

# 复制 workflows
[ -z "$SILENT" ] && log_info "安装 workflows..."
cp "$HP_ROOT/workflows/"*.md "$TARGET/.claude/workflows/" 2>/dev/null || true

# 复制 Python 脚本
mkdir -p "$TARGET/scripts"
[ -z "$SILENT" ] && log_info "安装脚本..."
cp "$HP_ROOT/scripts/"*.py "$TARGET/scripts/" 2>/dev/null || true

# 更新 CLAUDE.md（只在不存在时创建，已有则不覆盖）
if [ ! -f "$TARGET/CLAUDE.md" ]; then
  [ -z "$SILENT" ] && log_info "生成 CLAUDE.md..."
  cat > "$TARGET/CLAUDE.md" << 'EOF'
# Personal KB Agent

## 每次对话必读
- 读取 docs/meta/about-me.md 了解用户背景和约束
- 涉及某个学习方向时，读取 docs/meta/maps/<方向>.md

## 知识库索引
- 技术学习相关 → docs/knowledge/<方向>/
- 个人项目 → docs/projects/
- 工作记录相关 → docs/work/
- 生活相关 → docs/life/
- 参考资料 → docs/ref/
- 日志复盘 → docs/journal/
- 回答时区分"知识库里有的记录"和"通用知识"，明确说明来源

## Skill 触发索引

| 触发词 | Skill | 文件 |
|---|---|---|
| 记录、记一下、我刚学了、帮我整理 | intake | .claude/skills/intake.md |
| 复习、出题考我、今天该复习什么 | review | .claude/skills/review.md |
| 今天学什么、帮我安排、学习计划 | plan | .claude/skills/plan.md |
| 我要开始学XXX、帮我规划XXX学习 | 学习工作流 | .claude/workflows/learning-workflow.md |
| 我要做XXX功能、帮我拆解这个任务 | 开发工作流 | .claude/workflows/dev-workflow.md |
| 帮我整理这篇文章/公众号、存一下这篇 | intake-article | .claude/skills-extended/intake-article.md |
| 帮我整理这本书 | intake-book | .claude/skills-extended/intake-book.md |
| 帮我写攻略、整理XXX攻略 | write-guide | .claude/skills-extended/write-guide.md |
| 帮我总结、整理归纳、梳理这些资料 | summarize | .claude/skills-extended/summarize.md |

触发 Skill 后，读取对应文件，严格按文件中的流程执行。

## 全局约束
- 不做最终决策，不替用户选择
- 不编造知识库里没有的"你的记录"
- 涉及健康、财务、职业重大决策：只提供信息和风险分析
- 任务拆解粒度：每件事 ≤ 30 分钟，今天能完成
- 给建议时直接给推荐选项+理由，不列清单让用户自己选
EOF
else
  [ -z "$SILENT" ] && echo -e "${YELLOW}CLAUDE.md 已存在，跳过（不覆盖）"
fi

[ -z "$SILENT" ] && echo ""
[ -z "$SILENT" ] && log_info "✅ 安装完成！"
[ -z "$SILENT" ] && echo ""
[ -z "$SILENT" ] && echo "已安装到 $TARGET/.claude/"
[ -z "$SILENT" ] && echo "用 Claude Code 打开 $TARGET 目录即可使用。"
