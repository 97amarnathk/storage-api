FROM node:14-alpine
RUN apk add --no-cache g++ make python3
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --production

FROM node:14-alpine
RUN apk add --no-cache g++ make python3
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

FROM node:14-alpine
WORKDIR /app
COPY migrations migrations
COPY package.json .
COPY --from=0 /app/node_modules node_modules
COPY --from=1 /app/dist dist
EXPOSE 5000
CMD ["npm", "run", "start"]
