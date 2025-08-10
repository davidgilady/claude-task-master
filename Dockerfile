# Use the official Node.js runtime as the base image
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /app

# Create a non-root user for security
RUN addgroup -g 1001 -S nodejs && \
  adduser -S taskmaster -u 1001

# Copy package files first for better caching
COPY package*.json ./

# Copy the application code (needed for prepare script)
COPY . .

RUN chown -R taskmaster:nodejs /app

# Switch to non-root user
USER taskmaster

# Install dependencies (omit dev dependencies)
RUN npm ci --omit=dev && \
  npm cache clean --force

# Expose port for MCP server (if needed)
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production
ENV PATH="/app/bin:$PATH"

# Default command - run as MCP server
CMD ["node", "mcp-server/server.js"]
