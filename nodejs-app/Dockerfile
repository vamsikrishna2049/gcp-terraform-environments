FROM node:20.15-alpine AS builder

WORKDIR /build

COPY package*.json ./
RUN npm ci --omit=dev && npm audit --omit=dev --audit-level=high && npm cache clean --force

COPY src ./src

FROM gcr.io/distroless/nodejs20-debian11

WORKDIR /app

COPY --from=builder /build/node_modules ./node_modules
COPY --from=builder /build/src ./src

USER nobody
EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
  CMD ["/nodejs/bin/node", "-e", "require('http').get('http://localhost:3000/health', (r) => { if (r.statusCode !== 200) process.exit(1) })"]

CMD ["src/app.js"]
