---
name: frontend-conventions
description: 前端开发编码规范，涵盖命名、代码风格、React/Vue、TypeScript、性能和安全
paths: ["**/*.js", "**/*.jsx", "**/*.ts", "**/*.tsx", "**/*.vue", "**/*.css", "**/*.scss"]
---

# 前端开发编码规范

## 命名规范

### 文件命名
- 组件文件使用 PascalCase：`UserProfile.tsx`
- 工具函数文件使用 camelCase：`formatDate.ts`
- 样式文件使用 kebab-case：`user-profile.css`

### 变量命名
- 变量和函数使用 camelCase：`userName`, `getUserData()`
- 常量使用 UPPER_SNAKE_CASE：`API_BASE_URL`, `MAX_RETRY_COUNT`
- 类名使用 PascalCase：`UserService`, `HttpClient`

### CSS 类名
- 使用 BEM 命名法：`.block__element--modifier`
- 或使用 kebab-case：`.user-profile-card`

## 代码风格

- 使用 2 空格缩进（不使用 Tab）
- 每行不超过 100 字符
- 文件末尾保留一个空行
- 使用单引号或反引号，语句末尾加分号
- 单个函数不超过 50 行
- 函数参数超过 3 个时使用对象传参

## React/Vue 规范

- 组件文件只导出一个组件
- Props 必须定义类型
- React 优先使用函数组件
- useEffect 依赖数组必须完整
- 自定义 Hook 必须以 `use` 开头

## TypeScript 规范

- 优先使用 `interface` 定义对象类型
- 避免使用 `any`，必要时使用 `unknown`
- 导出的函数和组件必须有类型定义

## 性能优化

- 避免在循环中创建函数
- 大列表使用虚拟滚动
- 合理使用 memo/useMemo/useCallback
- 图片使用懒加载

## 安全规范

- 永远不要在前端存储敏感信息
- 用户输入必须验证和转义
- 避免使用 `eval()` 和 `innerHTML`
