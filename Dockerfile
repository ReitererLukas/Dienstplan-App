# STAGE 1 - translate ts to js
FROM node:16 AS builder
WORKDIR /app
COPY NotificationServerDienstplan/package*.json ./

ENV NODE_ENV_STAGE="DEV"
ENV TZ="Europe/Vienna"

RUN npm config set unsafe-perm true
RUN npm install typescript --location=global
RUN npm install ts-node --location=global
RUN npm install

COPY NotificationServerDienstplan/. .

RUN npm run build

# STAGE 2 - deploy js
FROM node:16 AS deployment
WORKDIR /app
COPY NotificationServerDienstplan/package*.json ./
COPY NotificationServerDienstplan/tsconfig.json ./

ENV NODE_ENV_STAGE="PROD"
ENV TZ="Europe/Vienna"

RUN npm install --omit=dev
COPY --from=builder /app/dist ./dist

CMD [ "npm", "run", "prod"]