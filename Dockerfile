FROM node:22-alpine

# Install system build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy all files
COPY . .

# --- CRITICAL FIX ---
# This command finds the "vite" command in the plugin's package.json 
# and adds the "--host" flag to it. This forces it to listen on 0.0.0.0.
RUN sed -i 's/vite /vite --host /g' penpot-plugin/package.json

# 1. Install Root Dependencies
RUN npm install

# 2. Install Sub-Project Dependencies
RUN npm run install:all

# 3. Build the project
RUN npm run build:all

# Expose the three critical ports
EXPOSE 4400 4401 4402

# Environment Variables
ENV HOST=0.0.0.0
ENV PENPOT_MCP_SERVER_LISTEN_ADDRESS=0.0.0.0
ENV PENPOT_MCP_PLUGIN_SERVER_LISTEN_ADDRESS=0.0.0.0
ENV PENPOT_MCP_SERVER_ADDRESS=0.0.0.0

# Start everything
CMD ["npm", "run", "start:all"]
