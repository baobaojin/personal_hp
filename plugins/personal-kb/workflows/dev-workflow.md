---
name: dev-workflow
description: 做一个具体的开发任务时使用，从任务规格到经验沉淀完整闭环。
触发词：我要做XXX功能、帮我拆解这个任务、开发任务、需求实现。
NOT for：学习新知识（用学习工作流）、日常笔记记录（用 intake）。
---

## 适用场景

工作中做一个具体的开发任务，例如：
- "我要做一个用户权限管理功能"
- "帮我拆解这个需求"
- "这个 bug 怎么修，帮我规划一下"

## 工作流步骤

### Step 1：/spec — 任务规格

明确做什么，写入 `docs/work/<任务-slug>/spec.md`：

```markdown
# <任务名>

## 目标
[一句话描述要做什么，完成标准是什么]

## 技术点
[涉及哪些技术，检索知识库看是否有相关记录]

## 风险
[历史踩过的坑，检索 docs/work/ 中 tag: pitfall 的笔记]

## 完成标准
[什么情况下算完成]
```

### Step 2：/plan-dev — 任务拆解

把任务拆成有序步骤，写入 `docs/work/<任务-slug>/plan.md`：
- 每步 ≤ 30 分钟（碎片时间可执行）
- 每步有明确的验收标准（做完了怎么验证）
- 标注依赖关系（哪步必须在哪步之后）

### Step 3：/build（按步骤循环执行）

- 按 plan.md 逐步执行
- 遇到问题记录到 `docs/work/<任务-slug>/notes.md`
- 踩坑了：用 intake Skill 记录到 `docs/work/`，tags 加 pitfall

### Step 4：/harvest — 经验沉淀

任务完成后，提取可复用的经验：
- 技术类收获 → 用 intake Skill 写入 `docs/knowledge/` 对应目录
- 踩坑记录 → 写入 `docs/work/`，tags: pitfall
- 更新对应知识地图（新掌握的内容从"学习中"移到"已掌握"）

### Step 5：/archive — 归档

- 在 `docs/work/<任务-slug>/spec.md` 的 frontmatter 中将 status 改为 archived
- 在 `docs/journal/` 写一篇任务总结（做了什么、学到了什么、下次注意什么）

## 完成判断

- [ ] spec.md 已完成，目标和完成标准清晰
- [ ] plan.md 已拆解，每步 ≤ 30 分钟
- [ ] 踩坑已记录到 work/ 并打 tag: pitfall
- [ ] 技术收获已写入 knowledge/
- [ ] 任务总结已写入 journal/
