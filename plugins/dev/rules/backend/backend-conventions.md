---
name: backend-conventions
description: 后端开发编码规范，涵盖 API 设计、数据库、错误处理、安全
paths: ["**/*.java", "**/*.py", "**/*.go", "**/*.ts"]
---

# 后端开发编码规范

## API 设计

- RESTful 风格，资源用名词复数：`/users`、`/orders`
- 统一响应结构：`{ code, message, data }`
- 错误码有意义，不要全部返回 500
- 接口版本号放 URL：`/api/v1/users`
- 分页参数统一：`page`、`pageSize`，响应带 `total`

## 数据库

- 表名、字段名使用 snake_case
- 必须有 `created_at`、`updated_at` 字段
- 不做物理删除，用 `deleted_at` 软删除
- 索引：高频查询字段必须加索引，联合索引注意顺序
- 禁止在循环中查数据库，批量操作用 `IN` 或批量接口

## 错误处理

- 统一异常处理，不在 controller 层 try-catch 业务异常
- 日志记录异常上下文（入参、用户 ID、trace ID），不只记异常信息
- 对用户的错误提示不暴露内部实现（表名、代码行号等）

## 安全

- 所有外部入参必须校验，不信任前端传值
- SQL 使用参数化查询，禁止拼接 SQL
- 敏感数据（手机号、身份证）存储前脱敏或加密
- 接口权限校验在 middleware 层统一处理
- 日志禁止记录密码、token 等凭据
