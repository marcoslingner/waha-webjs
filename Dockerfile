###############################
#  Runtime + build stage      #
###############################
FROM node:18

# --- Instala Google Chrome headless (para whatsapp-web.js) -------------
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable \
                       fonts-ipafont-gothic fonts-wqy-zenhei \
                       fonts-thai-tlwg fonts-kacst fonts-freefont-ttf && \
    rm -rf /var/lib/apt/lists/*

# --- Instala dependências e compila ------------------------------------
WORKDIR /app
COPY package*.json ./
RUN npm install

# copia configs TS + código-fonte
COPY tsconfig*.json nest-cli.json ./
COPY src ./src
RUN npm run build        # cria ./dist/main.js

# --- Runtime -----------------------------------------------------------
ENV PORT=3000
EXPOSE 3000
CMD ["node", "dist/main.js"]
