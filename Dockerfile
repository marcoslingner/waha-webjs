# ---------- Runtime + build ----------
FROM node:18

# Instala Google Chrome headless
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
      > /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable fonts-ipafont-gothic \
                       fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst \
                       fonts-freefont-ttf && \
    rm -rf /var/lib/apt/lists/*

# Pasta da app
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Porta que o WAHA usa
ENV PORT=3000
EXPOSE 3000

# Arranca o servidor
CMD ["node", "index.js"]
