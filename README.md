# Sprawozdanie_Lab11

# File Tree

```
project_root/
│
├── docker-compose.yml
├── init.sql
├── html/
│   ├── index.php
│   ├── db.php
│   └── style.css
│
├── nginx.conf
└── php/
    └── Dockerfile
```

# Tworzenie pliku docker-compose.yml

```
version: '3.8'

services:
  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "4001:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./html:/var/www/html
    networks:
      - frontend
      - backend
    depends_on:
      - php

  php:
    build:
      context: .
      dockerfile: ./php/Dockerfile
    container_name: php
    volumes:
      - ./html:/var/www/html
    networks:
      - backend


  mysql:
    image: mysql:5.7
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: testdb
      MYSQL_USER: testuser
      MYSQL_PASSWORD: testpassword
    volumes:
      - mysql_data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - backend

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    container_name: phpmyadmin
    environment:
      PMA_HOST: mysql
      PMA_USER: testuser
      PMA_PASSWORD: testpassword
    ports:
      - "6001:80"
    networks:
      - backend

networks:
  frontend:
  backend:

volumes:
  mysql_data:
```

# Tworzenie Dockerfile dla PHP

```
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
```

# Uruchomienie kontenerów

```
docker-compose up --build -d
```

```
[+] Building 38.3s (12/12) FINISHED                                                          docker-container:mybuilder
 => [php internal] booting buildkit                                                                                3.1s
 => => pulling image moby/buildkit:buildx-stable-1                                                                 1.6s
 => => creating container buildx_buildkit_mybuilder0                                                               1.5s
 => [php internal] load build definition from Dockerfile                                                           0.3s
 => => transferring dockerfile: 389B                                                                               0.1s
 => [php internal] load metadata for docker.io/library/php:7.4-fpm                                                 1.4s
 => [php auth] library/php:pull token for registry-1.docker.io                                                     0.0s
 => [php internal] load .dockerignore                                                                              0.0s
 => => transferring context: 2B                                                                                    0.0s
 => CACHED [php 1/4] FROM docker.io/library/php:7.4-fpm@sha256:3ac7c8c74b2b047c7cb273469d74fc0d59b857aa44043e6ea6  0.1s
 => => resolve docker.io/library/php:7.4-fpm@sha256:3ac7c8c74b2b047c7cb273469d74fc0d59b857aa44043e6ea6a0084372811  0.1s
 => [php internal] load build context                                                                              0.1s
 => => transferring context: 3.28kB                                                                                0.0s
 => [php 2/4] WORKDIR /var/www/html                                                                                0.1s
 => [php 3/4] RUN docker-php-ext-install mysqli                                                                   12.1s
 => [php 4/4] COPY . /var/www/html                                                                                 0.2s
 => [php] exporting to docker image format                                                                        18.6s
 => => exporting layers                                                                                            0.7s
 => => exporting manifest sha256:f786b30b98ca8484cec8a673e7a908e9df9f56d2d8d22f06675382f5c4e3114c                  0.0s
 => => exporting config sha256:62ebafd9eb1a074720f8bdac9254102bb857b22601d685717f7055ad6adfc112                    0.0s
 => => sending tarball                                                                                            17.8s
 => [php] importing to docker                                                                                      0.4s
 => => loading layer 5f70bf18a086 32B / 32B                                                                        0.4s
 => => loading layer 02162fe7cf0e 32.77kB / 52.67kB                                                                0.3s
 => => loading layer 9dc50365cc97 1.90kB / 1.90kB                                                                  0.2s
[+] Running 4/6
 - Network chmurylab11_backend   Created                                                                           7.2s
 - Network chmurylab11_frontend  Created                                                                           7.0s
 ✔ Container phpmyadmin          Started                                                                           4.9s
 ✔ Container php                 Started                                                                           3.9s
 ✔ Container mysql               Started                                                                           4.5s
 ✔ Container nginx               Started                                                                           4.9s
```

# Sprawdzenie statusu kontenerów

```
docker ps -a
```

```
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS                      PORTS                    NAMES
85cb77967db5   mysql:5.7                       "docker-entrypoint.s…"   12 minutes ago   Up 12 minutes               3306/tcp, 33060/tcp      mysql
71253fd27a73   nginx:latest                    "/docker-entrypoint.…"   17 minutes ago   Up 16 minutes               0.0.0.0:4001->80/tcp     nginx
98938c55b23d   phpmyadmin/phpmyadmin:latest    "/docker-entrypoint.…"   17 minutes ago   Up 17 minutes               0.0.0.0:6001->80/tcp     phpmyadmin
d2db309af74b   chmurylab11-php                 "docker-php-entrypoi…"   17 minutes ago   Up 17 minutes               9000/tcp                 php
d95ae4a9dfbd   moby/buildkit:buildx-stable-1   "buildkitd"              18 minutes ago   Up 18 minutes                                        buildx_buildkit_mybuilder0
2cfc34f02418   nginx:latest                    "/docker-entrypoint.…"   7 days ago       Exited (0) 7 days ago                                web3
8738757be1c6   nginx:latest                    "/docker-entrypoint.…"   7 days ago       Exited (0) 7 days ago                                web2
2644b7021aad   nginx:latest                    "/docker-entrypoint.…"   7 days ago       Exited (0) 7 days ago                                web1
ad59ad38e393   local/med:v0                    "docker-entrypoint.s…"   2 months ago     Exited (255) 4 weeks ago    0.0.0.0:8090->8080/tcp   medical
b3243ba3983f   local/webtest                   "docker-entrypoint.s…"   2 months ago     Exited (255) 4 weeks ago    0.0.0.0:8089->8080/tcp   test
5cb0806df9c9   web100                          "apache2ctl -D FOREG…"   2 months ago     Exited (137) 2 months ago                            objective_black
```

# Results

![image](https://github.com/mr-macintosh01/Sprawozdanie_Lab11/assets/65767905/1dea4b4c-590d-4eda-ba08-5f88d10f036c)
![image](https://github.com/mr-macintosh01/Sprawozdanie_Lab11/assets/65767905/b0a92e8d-e3fc-47b6-86e3-c950006e0a3b)
![image](https://github.com/mr-macintosh01/Sprawozdanie_Lab11/assets/65767905/92d5296e-aa03-404e-b3af-f5ad91c94c46)
![image](https://github.com/mr-macintosh01/Sprawozdanie_Lab11/assets/65767905/53a915b6-cb09-422c-981b-1f7ae5c38077)

