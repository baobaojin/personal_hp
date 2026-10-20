---
name: intake
description: 有任何新内容需要记录时使用，包括学到的知识、想法、感悟、工作记录等。
触发词：记录、记一下、我刚学了、我想到了、帮我整理一下。
NOT for：查询知识库、制定计划、复习出题。
---

## 流程

**Step 1：判断内容性质**
- 判断属于哪个顶层分类：
  - `knowledge`：主动学习的技术/技能内容
  - `work`：工作项目、日志、踩坑
  - `create`：文章草稿、作品、创意想法
  - `life`：健康、财务、感悟、日常
  - `ref`：收藏的参考资料、摘录
  - `journal`：daily note、复盘
- 如果是 `knowledge`，进一步确认子目录（frontend/backend/ai/python/algorithm 等）
- 分类不确定时停下来问用户，不要随便放

**Step 2：生成结构化笔记**
- 生成英文 slug 作为文件名（小写字母+数字+连字符，≤50字符）
- 填写完整 frontmatter：

```yaml
---
title: 笔记标题
category: knowledge       # 对应顶层分类
tags: []                  # 打标签，跨目录关联用
status: draft             # draft/active/archived
created: YYYY-MM-DD
updated: YYYY-MM-DD
next_review:              # 学习类内容默认填 7 天后日期
series:                   # 属于某个学习系列时填写
series_order:             # 在该系列中的顺序
---
```

- 学习类内容（category: knowledge）必须设置 next_review
- 属于某个学习路线的内容必须填写 series 和 series_order

**Step 3：写入文件**
- 保存路径：`docs/<category>/<子目录（如有）>/<slug>.md`
- 写入完整笔记内容（frontmatter + 正文）

**Step 4：收尾提示**
- 提示是否需要更新对应的知识地图（`docs/meta/maps/<方向>.md`）
- 如果笔记数量明显增加，提示运行 `python3 scripts/index.py` 重建索引

## 合理化借口表

| AI 可能跳过的步骤 | 反驳 |
|---|---|
| "内容很简单，不用填完整 frontmatter" | frontmatter 是复习调度和 RAG 检索的基础，缺字段就失效 |
| "目录不确定，先随便放一个" | 放错目录后很难找，不如停下来问用户 |
| "学习类内容不用设 next_review" | 不设就永远不会出现在复习队列里，等于白学 |

## 退出检查

- [ ] frontmatter 字段完整（title/category/tags/status/created/updated 必填）
- [ ] 学习类内容有 next_review 日期
- [ ] 文件保存在正确的目录下
- [ ] 已提示用户是否更新知识地图
