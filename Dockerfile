# Estágio 1: Construção das dependências
FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production

# Estágio 2: Construção do aplicativo
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Estágio 3: Execução do aplicativo
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV production
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=deps /app/node_modules ./node_modules
EXPOSE 3000
CMD ["npm", "start"]