# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm install --production

# Copy built files from builder
COPY --from=builder /app/dist ./dist

# Expose port 3000
EXPOSE 3000

# Install serve to run the production build
RUN npm install -g serve

# Start production server
CMD ["serve", "-s", "dist", "-l", "3000"]
