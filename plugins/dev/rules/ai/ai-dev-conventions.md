---
name: ai-dev-conventions
description: AI 应用开发规范，涵盖 Prompt 工程、RAG、Agent、LLM API 使用
---

# AI 应用开发规范

## Prompt 工程

- System prompt 和 user prompt 严格分离，不在 user prompt 里塞角色设定
- Prompt 用版本管理，改动要记录原因（prompt 是代码）
- 生产环境 prompt 不能在代码里硬编码，放配置文件或数据库
- 输出格式要求（JSON/Markdown）写在 prompt 末尾，更易遵守

## LLM API 使用

- 必须设置超时和重试（网络抖动常见）
- 流式输出（streaming）用于用户交互，批量任务用普通调用
- token 用量在日志里记录，便于成本分析
- 不同任务按复杂度选模型：简单分类用小模型，复杂推理用大模型

## RAG 开发

- Chunk 大小根据内容类型调整：代码 512，文档 1024，对话 256
- Embedding 模型和向量库要版本锁定，升级需重新构建索引
- 检索结果必须做相关性过滤（score threshold），不能全部传给 LLM
- 知识库更新要有增量机制，不要每次全量重建

## Agent 开发

- Tool 定义要精确：名称、描述、参数类型必须清晰，模型靠描述选工具
- 给 Agent 设置最大步数（max_turns），防止无限循环
- 关键步骤记录日志：调用了哪个工具、入参、出参
- 人机协作节点（需要人工确认的步骤）要显式设计，不能全部自动化

## 安全

- 用户输入不能直接拼进 prompt（prompt injection 攻击）
- RAG 检索出来的内容如果含敏感信息，传给云端 API 前要脱敏
- LLM 输出不能直接执行（eval/exec），必须先验证
