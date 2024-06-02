# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory
WORKDIR /var/www/html

# Install any dependencies
RUN docker-php-ext-install mysqli

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Informacje o autorze
LABEL maintainer="Maksim Rymasheuski"
