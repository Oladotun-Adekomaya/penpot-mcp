FROM node:22-alpine

# Install system build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy all files
COPY . .

# 1. Install Root Dependencies
RUN npm install

# 2. Install Sub-Project Dependencies
RUN npm run install:all

# 3. Build the project
RUN npm run build:all

# Expose the three critical ports
EXPOSE 4400 4401 4402

# Start everything
CMD ["npm", "run", "start:all"]
