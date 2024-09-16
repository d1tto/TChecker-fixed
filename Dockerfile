# Use an official PHP 7.0 image as a parent image
FROM php:7.0-cli

RUN ln -s /usr/local/bin/php /usr/bin/php

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list \
    && sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN mkdir -p /usr/share/man/man1

# Install dependencies
RUN apt-get update && apt-get install -y openjdk-8-jdk \
    git \
    autoconf \
    build-essential \
    python3 \
    python3-pip \
    vim \
    nano \
    wget \
    curl \
    zip \
    unzip \
    sudo \
    graphviz \
    graphviz-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install pygraphviz

RUN pip3 install chardet

# Clone php-ast repository
RUN git clone https://github.com/nikic/php-ast /usr/src/php-ast

# Change to php-ast directory
WORKDIR /usr/src/php-ast

# Checkout specific commit
RUN git checkout 701e853

# Install php-ast
RUN phpize && \
    ./configure && \
    make && \
    make install

# Enable php-ast extension
RUN echo "extension=ast.so" > /usr/local/etc/php/conf.d/ast.ini

# Copy current directory contents into the container
COPY . /app

WORKDIR /app

RUN unzip gradle-2.0-bin.zip

RUN ./gradle-2.0/bin/gradle build -x test

# Keep the container running
CMD ["tail", "-f", "/dev/null"]