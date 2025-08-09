# -------- Build stage --------
FROM node:18-bullseye AS build

ARG FLOWISE_VERSION=v3.0.4
ENV NPM_CONFIG_LOGLEVEL=warn

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone Flowise (version pinée)
RUN git clone --depth 1 --branch ${FLOWISE_VERSION} https://github.com/FlowiseAI/Flowise.git .

# Install + build
RUN npm ci --legacy-peer-deps
RUN npm run build
RUN npm prune --production

# -------- Runtime stage --------
FROM node:18-bullseye

# ⚠️ Ne PAS fixer PORT ici : Railway fournit $PORT
ENV NODE_ENV=production \
    ENABLE_UI_NODES=true \
    COMPONENTS_CUSTOM_PATH=/app/custom_components

WORKDIR /app
COPY --from=build /app /app

# Persistance locale (si volume Railway monté)
RUN mkdir -p /root/.flowise

# Expose indicatif (Railway utilise $PORT de toute façon)
EXPOSE 3000

CMD ["npm", "run", "start"]
