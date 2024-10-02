# Inception

Inception is a project focused on containerization and system infrastructure, developed as part of the 42 Network curriculum. The goal is to build and manage a small infrastructure using Docker Compose, while understanding and applying fundamental concepts of Docker, services, and networking.
Project Overview

This project consists of setting up multiple services within Docker containers, using Docker Compose to orchestrate them. The services include:

    NGINX: Acting as a reverse proxy with SSL/TLS encryption.
    MariaDB: A database server for handling data storage.
    WordPress: A PHP-based CMS, connecting to the database and served via NGINX.

Key Features

    Self-Signed SSL Certificate: NGINX is configured with a self-signed SSL certificate for secure communication.
    MariaDB: A relational database server running inside its own container, with a custom initialization script to set up the database and users.
    WordPress: A WordPress instance connected to the MariaDB database and served using PHP-FPM through NGINX.
    Docker Compose: The entire setup is orchestrated using Docker Compose, with a Makefile controlling key operations like building, starting, stopping, and cleaning up the environment.

Technologies Used

    Docker & Docker Compose: For containerizing and managing services.
    NGINX: Configured as a reverse proxy and handling HTTPS traffic.
    MariaDB: For database management.
    WordPress: Content management system.
    Debian: As the base image for all containers.


***More details about the project implementation and concepts inside the `Inception Doc` Folder.***