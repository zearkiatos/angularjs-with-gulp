FROM node:8-alpine as build-stage

RUN apk update
RUN apk upgrade
RUN mkdir -p dist && apk --no-cache --virtual .build-deps add \
	python \
	libsass \
	make \
	g++ \
	git \
	ncftp \
	curl \
	zip

# COPY FILES
WORKDIR /workspace
COPY . /workspace

RUN npm install -g gulp
RUN npm install

RUN gulp build

FROM nginx:1.11.4-alpine

COPY ./docker/default.conf /etc/nginx/conf.d/
COPY ./package.json /usr/share/nginx/
COPY ./docker /usr/share/nginx/docker


# COPY FILES
RUN mkdir -p /usr/share/nginx/html
COPY --from=build-stage /workspace/dist/index.html /usr/share/nginx/html
COPY --from=build-stage /workspace/dist/ /usr/share/nginx/html/

WORKDIR /usr/share/nginx/

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]