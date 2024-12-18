# https://v2.vuejs.org/v2/cookbook/dockerize-vuejs-app.html?redirect=true

# build stage
FROM node:lts-alpine as build-stage
RUN mkdir /wol-frontend
WORKDIR /wol-frontend
COPY . .
WORKDIR /wol-frontend/app
RUN npm install

RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /wol-frontend/app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]