# ---- Base image -------------------------------------------------------------
FROM node:18-bullseye AS build

# évite d’installer des packages inutiles
ENV NPM_CONFIG_LOGLEVEL=warn

# Clone Flowise source
RUN git clone --depth 1 https://github.com/FlowiseAI/Flowise.git /app
WORKDIR /app

# Installe en ignorant les peer-deps stricts
RUN npm ci --legacy-peer-deps

# Build Flowise
RUN npm run build

# ---- Runtime image ----------------------------------------------------------
FROM node:18-bullseye

# Copie les fichiers buildés
COPY --from=build /app /app
WORKDIR /app

# Port d’écoute
ENV PORT=3000
EXPOSE 3000

# Lance le serveur
CMD ["npm", "run", "start"]
