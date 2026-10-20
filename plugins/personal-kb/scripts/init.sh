#!/usr/bin/env bash
# init.sh — 初始化新知识库
# 用法：bash scripts/init.sh <目标目录> <插件根目录>

set -e

TARGET=$1
PLUGIN_DIR=$2
TODAY=$(date +%Y-%m-%d)

source "$PLUGIN_DIR/../../shared/_lib.sh"

log_step "[init] 开始初始化知识库：$TARGET"
echo ""

# 1. 检查目标目录
if [ -d "$TARGET" ] && [ "$(ls -A "$TARGET" 2>/dev/null)" ]; then
  log_warn "⚠️  目标目录已存在且不为空：$TARGET"
  read -p "继续会覆盖同名文件，是否继续？(y/n)：" confirm
  [ "$confirm" != "y" ] && echo "已取消" && exit 0
fi

# 2. 创建目录结构
log_step "[1/4] 创建目录结构..."
mkdir -p \
  "$TARGET/docs/meta/maps" \
  "$TARGET/docs/knowledge" \
  "$TARGET/docs/work" \
  "$TARGET/docs/create" \
  "$TARGET/docs/life" \
  "$TARGET/docs/ref/articles" \
  "$TARGET/docs/ref/books" \
  "$TARGET/docs/projects" \
  "$TARGET/docs/journal" \
  "$TARGET/scripts" \
  "$TARGET/.github/workflows"

# 3. 复制模板文件（替换日期占位符）
log_step "[2/4] 复制模板文件..."
find "$PLUGIN_DIR/template" -type f | while read src; do
  rel="${src#$PLUGIN_DIR/template/}"
  dst="$TARGET/$rel"
  mkdir -p "$(dirname "$dst")"
  # 替换 {{DATE}} 占位符
  sed "s/{{DATE}}/$TODAY/g" "$src" > "$dst"
done

# 各目录 gitkeep（防止空目录不被 Git 追踪）
for dir in knowledge work create life ref/articles ref/books projects journal; do
  touch "$TARGET/docs/$dir/.gitkeep" 2>/dev/null || true
done

# 4. 安装 skills/workflows/scripts
log_step "[3/4] 安装 skills 和工作流..."
bash "$PLUGIN_DIR/scripts/upgrade.sh" "$TARGET" "$PLUGIN_DIR" --silent

# 5. 复制配置文件模板
log_step "[4/4] 生成配置文件..."

# .gitignore
cat > "$TARGET/.gitignore" << 'EOF'
.venv/
kb/
__pycache__/
*.pdf
*.pyc
.DS_Store
site/
EOF

# mkdocs.yml
cat > "$TARGET/mkdocs.yml" << 'EOF'
site_name: 我的个人知识库
theme:
  name: material
  language: zh
  features:
    - navigation.instant
    - navigation.tabs
    - search.highlight
    - search.suggest

nav:
  - 首页: index.md
  - 关于我: meta/about-me.md
  - 使用说明: meta/how-to-use.md
  - 知识库: knowledge/README.md
  - 工作: work/README.md
  - 创作: create/README.md
  - 生活: life/README.md
  - 参考: ref/README.md
  - 日志: journal/README.md
EOF

# docs/index.md
cat > "$TARGET/docs/index.md" << EOF
# 我的个人知识库

这是我个人所有领域知识和经验的持续沉淀。

- 📅 建立时间：$TODAY
EOF

echo ""
log_info "✅ 初始化完成！"
echo ""
echo "下一步："
echo -e "  1. 打开并填写 $TARGET/docs/meta/about-me.md（AI 助手效果的基础）"
echo "  2. cd $TARGET && git init && git add -A && git commit -m 'init'"
echo "  3. python3 -m venv .venv && source .venv/bin/activate"
echo "  4. pip install mkdocs mkdocs-material -i https://pypi.tuna.tsinghua.edu.cn/simple"
echo "  5. mkdocs serve  # 本地预览"
echo ""
