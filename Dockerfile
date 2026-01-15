# Use Node 22 as specified in prerequisites
FROM node:22-alpine

# Install build dependencies for native modules if needed
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy all files
COPY . .

# Install dependencies
RUN npm install

# Build the project (Typescript compilation)
RUN npm run build:all

# Expose the three critical ports
# 4400: Plugin Web Server (manifest.json)
# 4401: MCP HTTP/SSE Server (for Claude/LLM)
# 4402: WebSocket Server (for Penpot Plugin)
EXPOSE 4400 4401 4402

# Set host to 0.0.0.0 so Docker can map it
ENV PENPOT_MCP_SERVER_LISTEN_ADDRESS=0.0.0.0
ENV PENPOT_MCP_PLUGIN_SERVER_LISTEN_ADDRESS=0.0.0.0
ENV PENPOT_MCP_SERVER_ADDRESS=0.0.0.0

# Start everything
CMD ["npm", "run", "start:all"]
