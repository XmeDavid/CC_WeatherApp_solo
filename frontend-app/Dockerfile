
FROM --platform=linux/amd64 node:14-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production
RUN npm install express serve-static

COPY server.js .
COPY dist ./dist

EXPOSE 3000

CMD ["node", "server.js"]
