---
name: intake-book
description: 整理图书内容、读书笔记到知识库时使用。
triggers: 帮我整理这本书、把这本书的笔记存进来、读书笔记整理。
not_for: 整理文章（用 intake-article）、记录学习内容（用 intake）。
---

## 流程

**Step 1：提取图书基本信息**
- 书名
- 作者
- 出版社（可选）
- 当前整理的章节名和章节序号

**Step 2：提炼章节内容**
- 核心观点（3-5 条）
- 印象深刻的内容或引用
- 和自己已有知识的关联（可选）
- 行动启发（可选：这章内容对我有什么用）

**Step 3：生成结构化笔记**

frontmatter 格式：
```yaml
---
title: <书名> - <章节名>
category: ref
tags: [book, <内容相关标签>]
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
next_review: YYYY-MM-DD    # 默认 14 天后（图书内容复习间隔稍长）
series: <书名>              # 用书名作为系列标识
series_order: <章节序号>    # 章节序号作为顺序
book_title: <书名>
book_author: <作者>
book_chapter: <章节名>
---
```

**Step 4：写入文件**
- 保存到 `docs/ref/books/<书名-slug>/<章节-slug>.md`
- 如果是整本书的第一章，先建书名目录

## 退出检查

- [ ] 图书信息完整（书名、作者、章节）
- [ ] series 和 series_order 已填写（便于按书追踪阅读进度）
- [ ] 保存在 docs/ref/books/<书名>/ 目录下
- [ ] next_review 已设置
