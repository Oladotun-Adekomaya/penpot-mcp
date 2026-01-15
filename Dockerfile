FROM node:22-alpine

# Install system build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy all files
COPY . .

# 1. Install Root Dependencies
RUN npm install

# 2. Install Sub-Project Dependencies (CRITICAL FIX)
# This installs typescript, esbuild, and other tools inside the sub-folders
RUN npm run install:all

# 3. Build the project
RUN npm run build:all

# Expose the three critical ports
EXPOSE 4400 4401 4402

# Set host to 0.0.0.0 so Docker can map it
ENV PENPOT_MCP_SERVER_LISTEN_ADDRESS=0.0.0.0
ENV PENPOT_MCP_PLUGIN_SERVER_LISTEN_ADDRESS=0.0.0.0
ENV PENPOT_MCP_SERVER_ADDRESS=0.0.0.0

# Start everything
CMD ["npm", "run", "start:all"]
