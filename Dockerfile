ARG NODE_VERSION="22.15.0"

# --- Stage 1: Build ---
FROM node:${NODE_VERSION}-slim AS build

# Install pnpm globally
RUN corepack enable && corepack prepare pnpm@latest --activate

# Set working directory
WORKDIR /app

# Copy only package files first for caching
# Install dependencies (only prod deps later)
COPY pnpm-lock.yaml ./
COPY package.json ./
RUN pnpm install --frozen-lockfile

# Copy the rest of the source
COPY tsconfig.json ./
COPY src ./src

# Build the TypeScript project
RUN pnpm run build

# --- Stage 2: Production ---
FROM node:${NODE_VERSION}-slim AS production

# Set working directory
WORKDIR /app

# Copy only built files and minimal deps
COPY --from=build /app/pnpm-lock.yaml /app/package.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

# Set environment variables (optional defaults)
ENV NODE_ENV=production
ENV TZ=UTC
ENV PORT=8080

# Expose the port your app uses
EXPOSE $PORT

# Start the app
CMD ["node", "dist/index.js"]
