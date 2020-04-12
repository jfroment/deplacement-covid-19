FROM node:current-alpine as builder

WORKDIR /usr/src/app

COPY . ./

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PUBLIC_URL=/

# Installs latest Chromium (80) package.
RUN apk update && apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@edge \
      nss@edge

RUN npm install
RUN npm run build

# Final image
FROM nginx:mainline-alpine as serve

WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
