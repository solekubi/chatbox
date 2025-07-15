FROM node:18.20.8 AS builder

WORKDIR /app

COPY . .

RUN npm install --legacy-peer-deps && \
    npm run build

FROM nginx:stable-alpine as stage

RUN apk add --no-cache tzdata \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone

COPY --from=build-stage /app/release/app/dist/renderer /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]