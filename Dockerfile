FROM node:18.20.8-bullseye AS builder

WORKDIR /app

COPY . .

RUN npm install --legacy-peer-deps && \
    npm run build

FROM nginx:alpine3.22 AS stage

RUN apk add --no-cache tzdata \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone

COPY --from=builder /app/release/app/dist/renderer /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]