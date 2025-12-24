# Use official Python runtime as base image
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml uv.lock ./
COPY bilibili.py ./

# Install dependencies using uv
RUN uv sync --frozen

# Set environment variables for SSE transport
ENV MCP_TRANSPORT=sse
ENV MCP_HOST=0.0.0.0
ENV MCP_PORT=8080

# Expose the port
EXPOSE 8080

# Run the application with SSE transport
CMD ["uv", "run", "bilibili.py", "--sse"]
