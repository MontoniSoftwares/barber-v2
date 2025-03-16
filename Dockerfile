# Estágio 1: Construção das dependências
FROM node:18 AS deps
WORKDIR /app
RUN echo "Conteúdo da pasta antes de copiar package.json:"
RUN dir /app # Comando Windows
COPY package*.json ./
RUN echo "Conteúdo da pasta depois de copiar package.json:"
RUN dir /app # Comando Windows
RUN npm install --only=production

# Estágio 2: Construção do aplicativo
FROM node:18 AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npx prisma generate
RUN npm run build

# Estágio 3: Execução do aplicativo
FROM node:18 AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=deps /app/node_modules ./node_modules
EXPOSE 3000
CMD ["npm", "start"]