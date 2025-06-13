# ---------- Runtime + build ----------
FROM node:18

# Cria pasta da aplicação
WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia todo o restante do código
COPY . .

# Porta usada pelo WAHA (mantenha 3000 para combinar com CMD)
EXPOSE 3000

# Comando de inicialização
CMD ["node", "index.js"]
