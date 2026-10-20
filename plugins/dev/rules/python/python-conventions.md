---
name: python-conventions
description: Python 开发编码规范，涵盖代码风格、类型注解、项目结构、测试
paths: ["**/*.py"]
---

# Python 开发规范

## 代码风格

- 遵循 PEP 8，使用 4 空格缩进
- 每行不超过 88 字符（black 默认值）
- 使用 `black` 格式化，`ruff` 做 lint
- 字符串优先用双引号

## 类型注解

- 所有公共函数必须有类型注解
- 使用 `from __future__ import annotations` 延迟求值
- 优先用 `X | Y` 替代 `Optional[X]`（Python 3.10+）
- 复杂类型用 `TypeAlias` 命名

```python
# 推荐
def get_user(user_id: int) -> User | None:
    ...

# 避免
def get_user(user_id):
    ...
```

## 项目结构

```
project/
├── src/<package>/   # 源码（src layout）
├── tests/           # 测试
├── pyproject.toml   # 依赖和工具配置
└── README.md
```

## 错误处理

- 捕获具体异常，不用裸 `except:`
- 自定义异常继承自 `Exception`，命名以 `Error` 结尾
- 使用 `logging` 记录异常，不用 `print`

## 测试

- 使用 `pytest`，测试文件以 `test_` 开头
- 用 `pytest-mock` 做 mock，不用 `unittest.mock` 直接导入
- 核心逻辑覆盖率 ≥ 80%
