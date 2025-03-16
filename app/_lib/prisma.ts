import { PrismaClient } from "@prisma/client"

declare global {
  // eslint-disable-next-line no-unused-vars
  var cachedPrisma: PrismaClient
}

let prisma: PrismaClient
if (process.env.NODE_ENV === "production") {
  console.log("Inicializando Prisma Client em produção...")
  prisma = new PrismaClient()
  console.log("Prisma Client inicializado em produção.")
} else {
  if (!global.cachedPrisma) {
    console.log("Inicializando Prisma Client em desenvolvimento...")
    global.cachedPrisma = new PrismaClient()
    console.log("Prisma Client inicializado em desenvolvimento.")
  }
  prisma = global.cachedPrisma
}

export const db = prisma
