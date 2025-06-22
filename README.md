# Symfony Docker Development Template

---

This repository provides a robust and easy-to-use Docker-based development environment for Symfony applications. It's designed to streamline your local setup, ensuring consistency across different development machines and making onboarding new team members a breeze.

## Features

* **Isolated Environment:** All services (Nginx, PHP-FPM, MySQL, Redis, MailHog, phpMyAdmin, Workspace) run in their own Docker containers.
* **Fast Development:** Utilizes Docker volumes for real-time code synchronization and leverages PHP-FPM for efficient PHP execution.
* **Local Domain:** Access your application via a consistent port (default `8080`).
* **Debugging Ready:** Pre-configured for Xdebug integration with your IDE (e.g., PhpStorm).
* **Database Management:** Includes MySQL with a persistent volume and phpMyAdmin for easy database access.
* **Email Testing:** MailHog for catching and viewing outgoing emails during development.
* **Composer & Symfony CLI:** A dedicated `symfony-workspace` container for running Composer commands, Symfony CLI, and other development tools.
* **Makefile Shortcuts:** Convenient `make` commands to manage your Docker services and common development tasks.

---

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

* [**Docker**](https://www.docker.com/) (Docker Engine and Docker Compose)
* [**Make**](https://www.gnu.org/software/make/) (usually pre-installed on Linux/macOS)

---

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/manzolo/symfony-docker-dev-template.git
    cd symfony-docker-dev-template
    ```

2.  **Enjoy your Symfony project:**
    You can use the `symfony-workspace` container to manage your Symfony project:
    ```bash
    make start # Start the services
    make enter # Enter the workspace container
    ```
    *Alternatively, copy your existing Symfony project files into this directory.*

3.  **Configure Environment Variables:**
    Check your `.env` and `.env.dev` respectively. Update the variables as needed, especially for your database connection (`.env`).

4.  **Build and Start Docker Containers:**
    ```bash
    make start
    ```
    This will build the custom PHP-FPM and Workspace images and then start all defined services in the background.

5.  **Access Your Application:**
    Your Symfony application should now be accessible at `http://localhost:8080`.

6.  **Run Symfony Migrations & Other Deploy Steps:**
    After starting the services and copying your Symfony project, you'll likely need to install dependencies and run database migrations.
    ```bash
    make deploy
    # If you have Doctrine Migrations, you'll want to run them:
    make enter
    php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration
    exit
    ```

---

## Makefile Commands

This template includes a `Makefile` with convenient shortcuts for managing your development environment:

* `make **build**`: Builds the Docker images. Useful after changes to Dockerfiles.
* `make **start**`: Starts all Docker services in detached mode (`-d`).
* `make **stop**`: Stops and removes all Docker containers.
* `make **status**`: Shows the status of all Docker services.
* `make **logs**`: Displays real-time logs from all services. Press `Ctrl+C` to exit.
* `make **enter**`: Enters the `symfony-workspace` container's bash shell. Use this for running Composer, Symfony Console, or other commands.
* `make **root**`: Enters the `symfony-workspace` container as the root user. Use with caution.
* `make **test-mail**`: Sends a test email via the Mailer to check MailHog setup.
* `make **backupdb**`: Creates a database backup (`.sql` file) in the `var/` directory on your host machine.
* `make **restoredb**`: Restores the database from `var/db_backup.sql`. **Make sure `var/db_backup.sql` exists and contains your desired backup!**

---

## Service Endpoints

* **Symfony Application:** `http://localhost:8080` (or `http://localhost:${SYMFONY_NGINX_PORT}` if changed in `.env`)
* **phpMyAdmin:** `http://localhost:8088` (or `http://localhost:${PHPMYADMIN_PORT}` if changed in `.env`)
* **MailHog:** `http://localhost:8025` (or `http://localhost:${MAILHOG_WEB_PORT}` if changed in `.env`)

---

## Configuration

* **`.env`:** Contains core application environment variables.
* **`.env.dev`:** Contains development-specific Docker Compose variables and Xdebug settings.
* **`docker/development/nginx/nginx.conf`:** Nginx configuration for serving your Symfony application from the `public/` directory and proxying to PHP-FPM. **Ensure this is correctly configured for Symfony.**
* **`docker/common/php-fpm/Dockerfile`:** Defines the PHP-FPM container, including PHP extensions and user permissions.
* **`docker/development/workspace/Dockerfile`:** Defines the workspace container, including development tools.

---

## Xdebug Setup

Xdebug is pre-configured to connect back to your host machine.

1.  **Ensure `XDEBUG_ENABLED=true`** in your `.env.dev` file.
2.  **`XDEBUG_HOST`:** By default, it's set to `host.docker.internal`, which works on Docker Desktop (macOS/Windows) and recent Docker versions on Linux. If you experience issues, consult Docker's networking documentation for your specific setup.
3.  **IDE Configuration:** Configure your IDE (e.g., PhpStorm) to listen for Xdebug connections on port `9003` (or the port specified in your PHP-FPM configuration, if different from default) and ensure your project's path mappings are correct (host path `.` to container path `/var/www`).

---
