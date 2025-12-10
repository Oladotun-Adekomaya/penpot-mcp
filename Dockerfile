## ------ Build
FROM node:22.21.1 AS build

WORKDIR /app

COPY . .

RUN set -ex; \
    apt update ; \
    apt -y install python3 python3-venv pip

RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

# Development URL
# ENV PLUGIN_API_URL="https://penpot-plugins-api-doc-devel.kaleidos.workers.dev/"

# Production URL
ENV PLUGIN_API_URL="https://penpot-plugins-api-doc.pages.dev/"

RUN pip install -Ur requirements.txt

RUN set -ex; \
    cd python-scripts; \
    python prepare_api_docs.py $PLUGIN_API_URL

RUN set -ex; \
    cd mcp-server; \
    npm install --frozen-lockfile; \
    npm run build;

## ----- Runtime

FROM node:22.21.1-alpine

WORKDIR /app

COPY --from=build /app/mcp-server/data ./data
COPY --from=build /app/mcp-server/node_modules ./node_modules
COPY --from=build /app/mcp-server/dist ./dist

# MCP API Server
EXPOSE 4401

# WebSocket server
EXPOSE 4402

# Repl server
EXPOSE 4403

ENTRYPOINT node ./dist/index.js

