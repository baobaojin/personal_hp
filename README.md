# personal-hp

> 个人 AI 工作流工具集，基于 Claude Code 构建。
> 提供个人知识库管理、前端开发规范等插件，一行命令安装到本地项目。

---

## 包含插件

| 插件 | 用途 | 安装目标 |
|---|---|---|
| `personal-kb` | 个人知识库 AI 工作流（笔记录入、复习、学习规划） | 知识库项目目录 |
| `dev` | 程序开发规范（前端/后端/架构/通用，按需选择） | 全局 `~/.claude/rules/` |

---

## 快速开始

### 方式一：一行命令安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/baobaojin/personal_hp/main/install.sh | bash
```

运行后交互选择插件和安装模式，无需提前 clone 仓库。

也可以直接指定参数，跳过交互：

```bash
# 初始化新知识库
curl -fsSL https://raw.githubusercontent.com/baobaojin/personal_hp/main/install.sh | bash -s -- personal-kb init ~/my-kb

# 安装到已有知识库
curl -fsSL https://raw.githubusercontent.com/baobaojin/personal_hp/main/install.sh | bash -s -- personal-kb upgrade ~/my-kb

# 安装前端开发规范
curl -fsSL https://raw.githubusercontent.com/baobaojin/personal_hp/main/install.sh | bash -s -- dev
```

### 方式二：克隆后安装

```bash
git clone https://github.com/baobaojin/personal_hp.git
cd personal_hp
bash install.sh
```

---

## personal-kb 插件

### 功能

- **4 个基础 Skill**：intake（录入）、ask（问答）、review（复习出题）、plan（学习规划）
- **3 个扩展 Skill**：文章整理、图书笔记、攻略写作
- **2 条工作流**：学习工作流、开发工作流
- **进度统计脚本**：扫描笔记 frontmatter，生成进度总览

### 安装模式

```bash
# 初始化新知识库（从零开始）
bash install.sh personal-kb init ~/my-kb

# 安装到已有知识库
bash install.sh personal-kb upgrade ~/my-kb

# 更新所有 skills/workflows 到最新版本
bash install.sh personal-kb update ~/my-kb

# 更新单个 Skill
bash install.sh personal-kb update-skill ~/my-kb intake

# 查看版本
bash install.sh personal-kb version
```

### 初始化后的目录结构

```
my-kb/
├── CLAUDE.md              # Agent 配置（自动生成）
├── mkdocs.yml             # 静态网页配置
├── .gitignore
├── .claude/               # Skill 和工作流（由本插件安装）
│   ├── skills/
│   ├── skills-extended/
│   └── workflows/
├── scripts/               # 进度统计等脚本
└── docs/
    ├── meta/              # 关于我、知识地图（需要填写）
    │   ├── about-me.md    # ← 必须填写，AI 助手的上下文基础
    │   └── maps/
    ├── knowledge/         # 学习内容
    ├── work/              # 工作记录
    ├── create/            # 创作输出
    ├── life/              # 生活
    ├── ref/               # 参考资料
    ├── projects/          # 个人项目
    └── journal/           # 日志
```

### 初始化后的必要操作

安装完成后，**必须填写 `docs/meta/about-me.md`**，这是 AI 助手了解你的基础。
文件里有详细的填写提示，内容越完整，AI 的建议越准确。

### 使用方式

安装完成后，用 Claude Code 打开知识库目录，直接用自然语言触发 Skill：

| 想做的事 | 说什么 |
|---|---|
| 记录新内容 | "记一下..."、"帮我整理..." |
| 整理文章/公众号 | "帮我整理这篇文章" |
| 整理图书笔记 | "帮我整理这本书的第 X 章" |
| 汇总整理多份资料 | "帮我总结这些资料" |
| 今日复习 | "今天该复习什么" |
| 学习规划 | "今天学什么" |
| 系统学一个方向 | "我要开始学 XXX" |
| 开发任务拆解 | "帮我拆解这个任务" |

### 笔记规范

每篇笔记顶部需要有 YAML frontmatter：

```yaml
---
title: 笔记标题
category: knowledge    # knowledge/work/create/life/ref/journal/projects
tags: []
status: draft          # draft/active/archived
created: 2026-10-19
updated: 2026-10-19
next_review:           # 学习类内容填日期，纳入复习调度
series:                # 可选：学习路线名
series_order:          # 可选：在路线中的顺序
---
```

### 扩展 Skill

后续新增场景，在 `plugins/personal-kb/skills-extended/` 下新建文件，然后：

```bash
# 更新到知识库
bash install.sh personal-kb update ~/my-kb
```

---

## dev 插件

安装程序开发规范到全局 `~/.claude/rules/`，在所有开发项目中自动生效：

```bash
# 安装全部规范
bash install.sh dev

# 安装指定范围
bash install.sh dev frontend     # 仅前端
bash install.sh dev backend      # 仅后端
bash install.sh dev architecture # 仅架构设计
bash install.sh dev common       # 仅通用（代码质量 + Git）
```

包含规范：

| 目录 | 内容 |
|---|---|
| `frontend/` | 命名规范、代码风格、React/Vue/TypeScript 规范、性能、安全 |
| `backend/` | API 设计、数据库规范、错误处理、安全 |
| `architecture/` | 分层原则、模块划分、设计原则（SOLID/KISS/YAGNI）、技术选型 |
| `common/` | 代码质量、Git 工作流、提交规范、PR 规范 |

---

## 项目结构

```
personal-hp/
├── install.sh              # 统一入口
├── shared/
│   └── _lib.sh             # 公共函数库
└── plugins/
    ├── personal-kb/        # 知识库插件
    │   ├── plugin.json     # 版本信息
    │   ├── install.sh
    │   ├── skills/
    │   ├── skills-extended/
    │   ├── workflows/
    │   ├── scripts/
    │   └── template/
    └── dev/                # 程序开发规范插件
        ├── install.sh
        └── rules/
            ├── frontend/
            ├── backend/
            ├── architecture/
            └── common/
```

---

## 版本

当前版本：**v1.0.0**

查看版本：
```bash
bash install.sh personal-kb version
```

---

## License

MIT
