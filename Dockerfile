FROM node:latest AS builder
ENV HUGO_VERSION 0.64.0
RUN apt-get install wget

# Install Hugo.
RUN wget --quiet https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    tar -xf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv hugo /usr/local/bin/hugo && \
    rm -rf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    npm install -g autoprefixer && npm install -g postcss-cli

COPY . /hugo-site

# Use Hugo to build the static site files.
RUN hugo -v --source=/hugo-site --destination=/hugo-site/public

FROM nginx:stable-alpine
COPY --from=builder /hugo-site/public/ /usr/share/nginx/html/
EXPOSE 80