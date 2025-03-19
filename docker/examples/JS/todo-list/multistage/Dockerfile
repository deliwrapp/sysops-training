# Stage 1: Install dependencies and copy source code
FROM node:alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --production

# Stage 2: Create production image with minimal dependencies
FROM node:alpine AS production

WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Run your application
CMD ["npm", "run", "dev"]

