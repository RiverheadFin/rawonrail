FROM ghcr.io/hazmi35/node:22-dev-alpine as build-stage

# Prepare pnpm with corepack (experimental feature)
RUN corepack enable && corepack prepare pnpm@latest

# Copy package.json, lockfile and npm config files
COPY package.json pnpm-lock.yaml *.npmrc  ./

# Fetch dependencies to virtual store
RUN pnpm fetch

# Install dependencies
RUN pnpm install --offline --frozen-lockfile

# Copy Project files
COPY . .

# Build TypeScript Project
RUN pnpm run build

# Prune devDependencies
RUN pnpm prune --production

# Get ready for production
FROM ghcr.io/hazmi35/node:22-alpine

LABEL name "rawon"
LABEL maintainer "Stegripe Development <support@stegripe.org>"

# Install ffmpeg
RUN apk add --no-cache ffmpeg python3 && ln -sf python3 /usr/bin/python

# Copy needed files
COPY --from=build-stage /tmp/build/package.json .
COPY --from=build-stage /tmp/build/node_modules ./node_modules
COPY --from=build-stage /tmp/build/dist ./dist
COPY --from=build-stage /tmp/build/yt-dlp-utils ./yt-dlp-utils
COPY --from=build-stage /tmp/build/lang ./lang
COPY --from=build-stage /tmp/build/index.js ./index.js

# Additional Environment Variables
ENV NODE_ENV production

# Create the startup script directly in the Dockerfile
RUN echo '#!/bin/sh' > start.sh && \
    echo 'mkdir -p "${DATA_DIRECTORY:-./src/data}"' >> start.sh && \
    echo 'mkdir -p "${APP_DIRECTORY:-./src/data/app}"' >> start.sh && \
    echo 'node --es-module-specifier-resolution=node index.js' >> start.sh && \
    chmod +x start.sh

# Start the app with our startup script
CMD ["./start.sh"]