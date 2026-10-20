---
name: git-workflow
description: Git 工作流、分支命名、提交规范、PR 规范
---

# Git 工作流规范

## 分支命名

- 功能分支：`feature/功能名称`
- 修复分支：`fix/问题描述`
- 热修复：`hotfix/问题描述`

## 提交规范

格式：`<type>: <subject>`

type 类型：`feat` / `fix` / `docs` / `style` / `refactor` / `perf` / `test` / `chore`

规则：
- 使用祈使句，不超过 50 字符，首字母小写，结尾不加句号
- 每次提交只做一件事
- 不提交敏感信息（密码、密钥、token）
- 提交信息描述"为什么"而不只是"做了什么"

## PR 规范

- PR 不超过 400 行（超过则拆分）
- 标题简洁，不超过 70 字符
- 描述说明改动目的、主要变更点、测试步骤
