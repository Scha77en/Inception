
### Makefile

```Makefile
DB_DATA = /home/aouhbi/data/mariadb

WP_DATA = /home/aouhbi/data/wordpress

  

all : up

  

up : build

@mkdir -p $(DB_DATA)

@mkdir -p $(WP_DATA)

docker compose -f ./srcs/docker-compose.yml up -d

  

down :

docker compose -f ./srcs/docker-compose.yml down

  

stop :

docker compose -f ./srcs/docker-compose.yml stop

  

start :

docker compose -f ./srcs/docker-compose.yml start

  

build :

docker compose -f ./srcs/docker-compose.yml build

  

fclean:

docker system prune -a --volumes -f

  

status :

docker ps

  

re: fclean all
```


#### Targets

1. **`all : up`**
    
    - The `all` target depends on the `up` target, meaning when `all` is run, it triggers the `up` command.
2. **`up : build`**
    
    - **`build`** is a prerequisite for `up`, meaning it will first build the Docker images.
    - **`mkdir -p $(DB_DATA)` & `mkdir -p $(WP_DATA)`**: Ensures the directories for MariaDB and WordPress data exist, creating them if necessary.
    - **`docker compose -f ./srcs/docker-compose.yml up -d`**: Starts the containers defined in `docker-compose.yml` in detached mode (`-d`), allowing them to run in the background.
3. **`down`**
    
    - **`docker compose -f ./srcs/docker-compose.yml down`**: Stops and removes all running containers, networks, and volumes created by the `docker-compose.yml`.
4. **`stop`**
    
    - **`docker compose -f ./srcs/docker-compose.yml stop`**: Stops all running containers without removing them.
5. **`start`**
    
    - **`docker compose -f ./srcs/docker-compose.yml start`**: Restarts stopped containers without rebuilding.
6. **`build`**
    
    - **`docker compose -f ./srcs/docker-compose.yml build`**: Builds or rebuilds the Docker images for the services defined in the `docker-compose.yml` file.
7. **`fclean`**
    
    - **`docker system prune -a --volumes -f`**: Removes all unused Docker objects (containers, images, volumes, networks) including the associated volumes (`--volumes` flag) forcefully (`-f` flag).
8. **`status`**
    
    - **`docker ps`**: Displays the currently running Docker containers.
9. **`re`**
    
    - This target is a combination of `fclean` and `all`. It forcefully cleans up all Docker objects and then rebuilds and starts the services.


### docker-compose.yml

```yml
services:

nginx:

container_name: nginx

build:

context: ./requirements/nginx

dockerfile: Dockerfile

ports:

- "443:443"

volumes:

- wordpress:/var/www/html

depends_on:

- wordpress

networks:

- inception_network

restart: always

  

mariadb:

container_name: mariadb

build:

context: ./requirements/mariadb

dockerfile: Dockerfile

volumes:

- mariadb:/var/lib/mysql

env_file:

- .env

networks:

- inception_network

restart: always

  

wordpress:

container_name: wordpress

build:

context: ./requirements/wordpress

dockerfile: Dockerfile

volumes:

- wordpress:/var/www/html

depends_on:

- mariadb

env_file:

- .env

networks:

- inception_network

restart: always

  

volumes:

wordpress:

driver: local

driver_opts:

type: none

o: bind

device: /home/aouhbi/data/wordpress

mariadb:

driver: local

driver_opts:

type: none

o: bind

device: /home/aouhbi/data/mariadb

  

networks:

inception_network:

driver: bridge
```


This `docker-compose.yml` file defines three services: **nginx**, **mariadb**, and **wordpress**, each using their own configurations. Below is a detailed explanation of each section.

### 1. **Services**

#### a. `nginx`

- **container_name**: The name assigned to the container. Here, it's `nginx`.
- **build**:
    - **context**: Specifies the directory to use as the build context. It includes the Dockerfile and other necessary files for building the image. For `nginx`, the context is `./requirements/nginx`.
    - **dockerfile**: Specifies the Dockerfile to use. The file here is `Dockerfile`, located inside `./requirements/nginx`.
- **ports**: Exposes port `443` on the container to port `443` on the host machine, used for HTTPS connections. (`"443:443"`).
- **volumes**: Mounts the `wordpress` volume to `/var/www/html` inside the `nginx` container. This allows the `nginx` service to serve the WordPress files.
- **depends_on**: Specifies a dependency on the `wordpress` service. Docker Compose ensures that the `wordpress` container starts before `nginx`.
- **networks**: Defines the network `nginx` will be connected to, in this case, `inception_network`.
- **restart**: Sets the container to always restart if it crashes or stops for any reason.

#### b. `mariadb`

- **container_name**: The container will be named `mariadb`.
- **build**:
    - **context**: The build context is `./requirements/mariadb`, where the Dockerfile for MariaDB is located.
    - **dockerfile**: The Dockerfile used for this service is named `Dockerfile` in the `mariadb` directory.
- **volumes**: Mounts the `mariadb` volume to `/var/lib/mysql` inside the container, persisting the MariaDB database data.
- **env_file**: Specifies an environment file, `.env`, which contains environment variables like database credentials.
- **networks**: Connects the `mariadb` container to the `inception_network`.
- **restart**: Always restart the container in case it stops.

#### c. `wordpress`

- **container_name**: The container is named `wordpress`.
- **build**:
    - **context**: The build context is `./requirements/wordpress`, which contains the Dockerfile and related files.
    - **dockerfile**: Uses the `Dockerfile` in the `wordpress` directory.
- **volumes**: Mounts the `wordpress` volume to `/var/www/html` inside the container, which contains the WordPress website files.
- **depends_on**: Specifies that the `wordpress` container must wait for the `mariadb` container to start before it is launched.
- **env_file**: Uses the `.env` file for environment variables like database connection details.
- **networks**: Connects the `wordpress` container to `inception_network`.
- **restart**: Always restarts the container if it crashes or stops.

### 2. **Volumes**

This section defines two named volumes, `wordpress` and `mariadb`. These are used for persisting data.

- **wordpress**:
    - **driver**: `local`, meaning the volume will be stored on the local disk.
    - **driver_opts**:
        - **type**: `none`, specifies a bind mount (binds a directory on the host machine to a directory inside the container).
        - **o**: `bind`, indicating that it's a bind mount.
        - **device**: The path on the host machine where WordPress data is stored, `/home/aouhbi/data/wordpress`.
- **mariadb**:
    - **driver**: `local`, storing MariaDB's data on the local disk.
    - **driver_opts**:
        - **type**: `none`, specifies a bind mount.
        - **o**: `bind`, used for a bind mount.
        - **device**: The path on the host machine for MariaDB data storage, `/home/aouhbi/data/mariadb`.

### 3. **Networks**

Defines the network `inception_network`, which allows the services to communicate with each other.

- **driver**: `bridge` specifies that the Docker Bridge network is used. This allows the containers to communicate internally while isolating them from the host network.

---

### Summary

- **nginx** serves the WordPress files over HTTPS (port 443) and depends on the WordPress service.
- **mariadb** is the database service that stores the data for WordPress.
- **wordpress** runs the WordPress application and depends on MariaDB for the database.
- Volumes are used to persist data for both WordPress and MariaDB.
- All containers are part of the `inception_network` and will restart automatically if they stop.


#### Volumes in Docker Compose:

[Bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)
[tmpfs mounts](https://docs.docker.com/engine/storage/tmpfs/)
[driver_opts](https://docs.docker.com/reference/compose-file/volumes/#driver_opts)

- **driver**: `local` is the default driver for Docker volumes. It stores data on the host filesystem, allowing the container to access it.
    
- **driver_opts**: Custom options for the driver to specify how the volume behaves.
    
    - **type**: `none` here means no filesystem type is specified. This is used when you're binding a host directory to the container.
        
    - **o**: Specifies mount options. `bind` allows mounting a directory from the host filesystem into the container.
        
    - **device**: The path on the host filesystem where the data is stored. For example, `/home/aouhbi/data/wordpress` on the host system is mounted to the container.


