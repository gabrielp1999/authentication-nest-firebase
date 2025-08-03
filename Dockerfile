# Etapa 1: Build da aplicação
FROM node:18-alpine AS builder

WORKDIR /app

# Copia os arquivos do projeto
COPY package*.json ./
RUN npm install

COPY . .

# Compila o código TypeScript
RUN npm run build

# Etapa 2: Imagem final para produção
FROM node:18-alpine

WORKDIR /app

# Copia apenas o necessário da etapa anterior
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

RUN npm install --only=production

# Define a variável de ambiente padrão
ENV NODE_ENV=production

# Porta padrão do Nest (ajuste se for diferente)
EXPOSE 3000

# Comando de inicialização
CMD ["node", "dist/main"]
