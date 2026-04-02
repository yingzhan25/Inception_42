# Inception - User Documentation

This document provides instructions for end-users and administrators on how to run and manage the Inception project stack.

## Provided Services

The project launches a suite of services that work together to deliver a complete web application environment:

-   **Nginx**: A high-performance web server that acts as a reverse proxy and handles SSL/TLS encryption for the WordPress site.
-   **WordPress**: A popular content management system (CMS) for creating and managing websites. This is the main application.
-   **MariaDB**: A robust and reliable database server that stores all of the WordPress site's data (posts, users, settings, etc.).
-   **Adminer**: A lightweight database management tool, accessible via a web browser, for managing the MariaDB database.
-   **Redis**: An in-memory data store, used here as a cache to improve the performance of WordPress.
-   **FTP Server**: Allows file transfer to and from the WordPress volume, useful for manually managing themes and plugins.
-   **cAdvisor**: A monitoring tool from Google that provides real-time resource usage and performance characteristics of the running containers.
-   **Static Website**: A simple static HTML page served by a Lighttpd web server on a separate port, included as a bonus.

## Starting and Stopping the Project

All project management is handled via the `Makefile` in the root directory.

-   **To Start the Project**:
    Open a terminal in the project root and run the following command. This will build the necessary Docker images and start all services.
    ```bash
    make up
    ```

-   **To Stop the Project**:
    To stop all running services and remove the containers, run:
    ```bash
    make down
    ```
    If you only want to temporarily stop the services without removing them, you can use:
    ```bash
    make stop
    ```

## Accessing the Services

Once the project is running, you can access the different services via your web browser:

-   **WordPress Website**: [https://localhost](https://localhost)
-   **Adminer (Database Admin)**: [http://localhost:8080](http://localhost:8080)
-   **cAdvisor (Monitoring)**: [http://localhost:8082](http://localhost:8082)
-   **Static Bonus Page**: [http://localhost:8081](http://localhost:8081)

## Managing Credentials

All credentials and sensitive configuration details for the project are stored in two files:

-   **Location**: `srcs/.env` `srcs/secrets/my_password.txt`

This files contain the passwords for the MariaDB root user, the database user, and the FTP user, as well as the database name. You can edit the files to change the credentials, but you will need to restart the project for the changes to take effect (using `make re` is recommended).

**Warning**: Treat the `.env` file and `secret/` folder as sensitive. Do not share or commit to a public repository.

## Checking Service Status

There are two primary ways to check that the services are running correctly:

1.  **List Running Containers**:
    To see a list of all active Docker containers, you can run:
    ```bash
    docker ps
    ```
    You should see an entry for each service (mariadb, wordpress, nginx, etc.) with a status of `Up`.

2.  **View Service Logs**:
    To view the real-time logs from all running services, which is useful for troubleshooting, use the following Makefile command:
    ```bash
    make logs
    ```
    This will show the output of each container, helping you confirm they started without errors. Press `Ctrl+C` to stop viewing the logs.
