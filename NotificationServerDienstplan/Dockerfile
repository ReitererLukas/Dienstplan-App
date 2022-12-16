# STAGE 1 - translate ts to js
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./

ENV NODE_ENV_STAGE="DEV"

RUN npm config set unsafe-perm true
RUN npm install typescript --location=global
RUN npm install ts-node --location=global
RUN npm install

COPY . .

RUN npm run build

# STAGE 2 - deploy js
FROM node:16 AS deployment
WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./

ENV NODE_ENV_STAGE="PROD"

RUN npm install --omit=dev
COPY --from=builder /app/dist ./dist

CMD [ "npm", "run", "prod"]