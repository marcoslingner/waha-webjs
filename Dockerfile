# ---------- Build stage ----------
FROM node:18 AS build

WORKDIR /src
COPY package*.json ./
RUN npm install

ADD . /src
RUN npm run build || true \
    && [ -d dist ] && find ./dist -name "*.d.ts" -delete || true

# ---------- Release stage ----------
FROM node:18 AS release

# Instalações necessárias para o whatsapp-web.js (chrome + fontes)
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json ./
COPY --from=build /src .       # <-- copia tudo do estágio build (código + node_modules)

EXPOSE 3000
CMD ["npm", "run", "start"]
