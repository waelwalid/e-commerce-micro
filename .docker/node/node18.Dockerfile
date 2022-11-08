FROM node:18-alpine
LABEL maintainer="<wael.walid91@gmail.com>"
ENV LINUX alpine
WORKDIR /var/www/app
COPY . /var/www/app/

RUN apk add --no-cache --force-refresh \
    curl \
    wget \
    net-tools \
    lsof \
    vim \
    bash 

# Create applicatin folder and adjust persmissions
RUN mkdir -p /var/www/app && \
    chown -Rf nobody:nobody /var/www/app

# RUN yarn install 


EXPOSE 80
# EXPOSE 9229

