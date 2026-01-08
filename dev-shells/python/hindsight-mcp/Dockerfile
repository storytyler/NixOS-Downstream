FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY src/mcp_server.py /app/mcp_server.py

# Environment variables
ENV HINDSIGHT_URL=http://hindsight:8888
ENV HINDSIGHT_DEFAULT_BANK_ID=Sisyphus

# Expose MCP server port
EXPOSE 8000

# Run the MCP server
CMD ["python", "-m", "mcp_server"]
