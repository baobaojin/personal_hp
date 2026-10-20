---
title: 系统使用说明
category: meta
tags: [meta, 使用说明]
status: active
created: {{DATE}}
updated: {{DATE}}
---

# 系统使用说明

## 目录结构

```
docs/
├── meta/            # 系统元信息（不是学习内容）
│   ├── about-me.md  # 我是谁，AI 每次对话必读 ← 必须填写
│   ├── how-to-use.md
│   ├── progress.md  # 自动生成，勿手动编辑
│   └── maps/        # 各方向知识地图
├── knowledge/       # 所有主动学习内容
├── work/            # 工作记录、项目日志
├── create/          # 创作输出：文章草稿、作品
├── life/            # 生活：健康、财务、感悟
├── ref/             # 参考资料、文章收藏
│   ├── articles/    # 文章整理
│   └── books/       # 读书笔记
├── projects/        # 个人项目记录
└── journal/         # 日志：daily-note、周复盘
```

## 笔记规范

每篇笔记顶部必须有 YAML frontmatter：

```yaml
---
title: 笔记标题
category: knowledge   # knowledge/work/create/life/ref/journal/projects
tags: []
status: draft         # draft/active/archived
created: YYYY-MM-DD
updated: YYYY-MM-DD
next_review:          # 学习类内容填日期，纳入复习调度
series:               # 可选：学习路线名
series_order:         # 可选：在路线中的顺序
---
```

## Skill 使用方式

直接用自然语言触发，AI 会自动识别：

| 想做的事 | 说什么 |
|---|---|
| 记录新内容 | "记一下..."、"帮我整理..." |
| 整理文章/公众号 | "帮我整理这篇文章" |
| 整理图书笔记 | "帮我整理这本书的第X章" |
| 总结多份材料 | "帮我总结这些资料" |
| 复习 | "今天该复习什么" |
| 学习规划 | "今天学什么" |
| 系统学一个方向 | "我要开始学XXX" |
| 开发任务 | "帮我拆解这个任务" |

## 每日操作

```bash
# 激活环境
source .venv/bin/activate

# 更新进度总览
python3 scripts/progress_stat.py

# 推送到 GitHub
git add -A && git commit -m "$(date +%Y-%m-%d)" && git push
```
