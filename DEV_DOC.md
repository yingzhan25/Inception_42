# Inception - Developer Documentation

This document outlines the setup, build process, and technical details for developers working on the Inception project.

## Setting Up the Environment from Scratch

### Prerequisites

1.  **Docker**: You must have Docker Engine installed.
2.  **Docker Compose**: You must have Docker Compose installed (often included with Docker Desktop).
3.  **Root/Sudo Access**: Required for managing Docker and potentially creating host directories.
4.  **Git**: For cloning the repository.

### Configuration Files

1.  **Clone the Repository**:
    ```bash
    git clone <repository_url>
    cd inception
    ```

2.  **Host Data Directories**:
    The project is configured to store persistent data in `/home/yingzhan/data/`. If your local username is different, you must update the paths in two files:
    -   `Makefile`: Update the `mkdir` and `rm` commands.
    -   `srcs/docker-compose.yml`: Update the `device` path for the `mariadb_data` and `wordpress_data` volumes.

3.  **Secrets (Environment Variables)**:
    Create a subdirectory named `secrets` inside the `srcs/` directory. This folder will hold the password txt file for the services.
	Create a file named `.env` inside the `srcs/` directory. This file will hold configuration variables for the services. Populate it with the following keys:

    ```env
    # MariaDB Settings
    DB_NAME=your_database_name
    DB_USER=your_database_user
    DB_ROOT_PASSWORD=your_root_password

    # WordPress Settings (can be anything, WordPress uses them for setup)
    WP_USER=your_wordpress_admin_user
    WP_EMAIL=your_email@example.com

    # FTP Server Settings
    FTP_USER=your_ftp_user
    ```

## Building and Launching the Project

The `Makefile` at the root of the repository is the main entry point for managing the project.

-   **To Build and Launch**:
    This command builds all Docker images from their respective `Dockerfiles` and starts the services in detached mode as defined in `srcs/docker-compose.yml`.
    ```bash
    make all
    # or
    make up
    ```

-   **To Force a Rebuild**:
    If you make changes to a `Dockerfile` or a configuration file, you may need to force a rebuild of the images. The `up` command with the `--build` flag is already included in the default `make all` command. For a clean start, it's best to use `make re`.
    ```bash
    make re
    ```

## Managing Containers and Volumes

The `Makefile` provides convenient shortcuts, but you can also use `docker-compose` commands directly. Remember to specify the compose file path.

-   **List Running Services**:
    ```bash
    docker-compose -f srcs/docker-compose.yml ps
    ```

-   **View Logs**:
    ```bash
    make logs
    # or
    docker-compose -f srcs/docker-compose.yml logs -f
    ```

-   **Stop and Remove Containers**:
    ```bash
    make down
    # or
    docker-compose -f srcs/docker-compose.yml down
    ```

-   **Manage Volumes**:
    The `make down` command does **not** remove the named volumes, preserving your data. To completely remove everything, including the data:
    1.  Bring down the stack: `make down`
    2.  Remove the volumes: `docker volume rm srcs_mariadb_data srcs_wordpress_data`

    The `make fclean` command automates this process and also clears the data from the host directories.

## Data Persistence

-   **Where Data is Stored**:
    Persistent data for the two main services is stored on the host machine at the following locations:
    -   **MariaDB**: `/home/yingzhan/data/mariadb/`
    -   **WordPress**: `/home/yingzhan/data/wordpress/`

-   **How Data Persists**:
    Persistence is achieved using Docker **Named Volumes** that are configured to use a local `bind` mount. This is a specific technique to satisfy the project's requirements.

    In `srcs/docker-compose.yml`, we define named volumes like this:
    ```yaml
    volumes:
      mariadb_data:
        driver: local
        driver_opts:
          type: none
          o: bind
          device: /home/yingzhan/data/mariadb
    ```
    -   This creates a Docker-managed volume named `srcs_mariadb_data`.
    -   However, instead of letting Docker manage the storage location, we instruct it to bind the volume directly to the host path specified in `device`.
    -   The service then mounts this named volume (e.g., `mariadb_data:/var/lib/mysql`).

    This ensures that even if the containers and volumes are removed (`docker-compose down` and `docker volume rm`), the data remains in the host directories until manually deleted.
