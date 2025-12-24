# Bilibili API MCP Server

用于哔哩哔哩 API 的 MCP（模型上下文协议）服务器，支持多种操作。

## 环境要求

- [uv](https://docs.astral.sh/uv/) - 一个项目管理工具，可以很方便管理依赖。
- Docker (可选) - 用于容器化部署

## 使用方法

### 方法 1: 使用 Docker (推荐)

使用 Docker 运行服务器，支持 SSE（Server-Sent Events）传输：

#### 使用 Docker Compose

```bash
# 克隆项目
git clone https://github.com/r-earth-or/bilibili-mcp-server.git
cd bilibili-mcp-server

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

服务将在 `http://localhost:8080` 上运行。

#### 使用 Docker 命令

```bash
# 构建镜像
docker build -t bilibili-mcp-server .

# 运行容器
docker run -d -p 8080:8080 --name bilibili-mcp-server bilibili-mcp-server

# 查看日志
docker logs -f bilibili-mcp-server
```

#### 使用预构建的 Docker 镜像

```bash
# 从 GitHub Container Registry 拉取镜像
docker pull ghcr.io/r-earth-or/bilibili-mcp-server:latest

# 运行容器
docker run -d -p 8080:8080 --name bilibili-mcp-server ghcr.io/r-earth-or/bilibili-mcp-server:latest
```

### 方法 2: 使用 SSE 传输（网络模式）

直接运行服务器使用 SSE 传输：

```bash
# 安装依赖
uv sync

# 运行服务器 (SSE 模式)
uv run bilibili.py --sse

# 或者使用环境变量
MCP_TRANSPORT=sse MCP_HOST=0.0.0.0 MCP_PORT=8080 uv run bilibili.py
```

配置 MCP 客户端连接到 SSE 服务器：

```json
{
  "mcpServers": {
    "bilibili": {
      "url": "http://localhost:8080/sse"
    }
  }
}
```

### 方法 3: 使用 stdio 传输（本地模式）

适用于本地开发和测试：

1. clone 本项目

2. 使用 uv 安装依赖

```bash
uv sync
```

3. 在任意 mcp client 中配置本 Server

```json
{
  "mcpServers": {
    "bilibili": {
      "command": "uv",
      "args": [
        "--directory",
        "/your-project-path/bilibili-mcp-server",
        "run",
        "bilibili.py"
      ]
    }
  }
}
```

4. 在 client 中使用

## 环境变量配置

- `MCP_TRANSPORT`: 传输模式，可选 `sse` 或 `stdio` (默认: `stdio`)
- `MCP_HOST`: SSE 服务器绑定的主机地址 (默认: `0.0.0.0`)
- `MCP_PORT`: SSE 服务器监听的端口 (默认: `8080`)

## 支持的操作

支持以下操作：

1. `general_search`: 基础搜索功能，使用关键词在哔哩哔哩进行搜索。
2. `search_user`: 专门用于搜索哔哩哔哩用户的功能，可以按照粉丝数排序。
3. `get_precise_results`: 精确搜索功能，可以过滤掉不必要的信息，支持多种搜索类型：
   - 用户搜索 (`user`)：精确匹配用户名，只返回完全匹配的结果。例如搜索"双雷"只会返回用户名为"双雷"的账号信息，不会返回其他相关用户
   - 视频搜索 (`video`)
   - 直播搜索 (`live`)
   - 专栏搜索 (`article`)
返回结果包含 `exact_match` 字段，标识是否找到精确匹配的结果。
4. `get_video_danmaku·`: 获取视频弹幕信息。

## Docker 镜像

Docker 镜像通过 GitHub Actions 自动构建和发布到 GitHub Container Registry (ghcr.io)。

支持的标签：
- `latest`: 最新的主分支构建
- `vX.Y.Z`: 语义化版本标签
- `main`: 主分支的最新构建
- `<branch>-<sha>`: 特定分支和提交的构建

## 如何为本项目做贡献

1. Fork 本项目
2. 新建分支，并在新的分支上做改动
3. 提交 PR

## License

MIT
