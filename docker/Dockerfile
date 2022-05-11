# stage1
FROM node:16.14.0-buster as node-builder

WORKDIR /metaverse-frontend

# Copy the package.json and install dependencies
COPY package*.json ./

## need to following line in mainland China
#RUN npm config set registry https://registry.npm.taobao.org/
#
#RUN npm config get registry

RUN npm install

# Copy rest of the files
COPY . .

# Build the project
RUN npm run build


FROM nginx:alpine as prod-nginx
COPY ./docker/nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=node-builder /metaverse-frontend/dist /usr/share/nginx/html

EXPOSE 8081
CMD ["nginx", "-g", "daemon off;"]