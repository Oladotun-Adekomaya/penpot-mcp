FROM node:22-alpine

# Install system build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy all files
COPY . .

# --- SOURCE CODE PATCH (The Fix) ---
# This command finds "defineConfig({" in the plugin configuration
# and injects the "host: 0.0.0.0" setting directly into the file.
# This forces Vite to listen on all interfaces.
RUN sed -i "s/defineConfig({/defineConfig({ server: { host: '0.0.0.0' }, preview: { host: '0.0.0.0', port: 4400 },/g" penpot-plugin/vite.config.ts

# 1. Install Root Dependencies
RUN npm install

# 2. Install Sub-Project Dependencies
RUN npm run install:all

# 3. Build the project
RUN npm run build:all

# Expose the three critical ports
EXPOSE 4400 4401 4402

# Environment Variables (Keep these as backup)
ENV HOST=0.0.0.0
ENV PENPOT_MCP_SERVER_LISTEN_ADDRESS=0.0.0.0
ENV PENPOT_MCP_PLUGIN_SERVER_LISTEN_ADDRESS=0.0.0.0
ENV PENPOT_MCP_SERVER_ADDRESS=0.0.0.0

# Start everything
CMD ["npm", "run", "start:all"]
