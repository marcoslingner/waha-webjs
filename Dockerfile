FROM node:18

# Chrome p/ whats­app-web.js
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
RUN npm install

# copia configs + código e compila
COPY tsconfig*.json nest-cli.json ./
COPY src ./src
RUN npm run build              # <- gera dist/

ENV PORT=3000
EXPOSE 3000
CMD ["node", "dist/main.js"]
