# ==========================================
# Stage 1: Dependencies & Build Stage
# ==========================================
FROM node:24.21.0-alpine AS build

WORKDIR /app

# Install dependencies needed for native modules / build
RUN apk add --no-cache libc6-compat

# Install npm dependencies cleanly (with fallback if package-lock.json is missing or desynced)
RUN if [ -f package-lock.json ]; then npm ci || npm install; else npm install; fi

# Copy full application source code
COPY . ./

# Build Nuxt production output (.output)
RUN npm run build

# ==========================================
# Stage 2: Production Runtime Stage
# ==========================================
FROM node:24.21.0-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

# Run container as non-root user for security
USER node

# Copy only the compiled standalone Nitro server output from build stage
COPY --chown=node:node --from=build /app/.output ./

EXPOSE 3000

CMD ["node", "server/index.mjs"]
