# PostgreSQL Schema Management

This guide provides instructions for managing PostgreSQL schemas using Docker Compose and Makefile commands. It includes steps to set up the Docker Compose environment, manage schemas, and execute Makefile commands for adding new schemas to the database.

---

## Table of Contents

- [PostgreSQL Schema Management](#postgresql-schema-management)
  - [Table of Contents](#table-of-contents)
  - [Docker Compose Setup](#docker-compose-setup)
    - [Docker Compose Configuration](#docker-compose-configuration)
    - [`docker-compose.yml`](#docker-composeyml)
  - [Makefile Setup](#makefile-setup)
    - [`Makefile`](#makefile)
  - [Running the Application](#running-the-application)
  - [Managing Schemas](#managing-schemas)
    - [Adding New Schemas](#adding-new-schemas)
    - [Creating a Schema Using Make Commands](#creating-a-schema-using-make-commands)
      - [Using `sync-schema`](#using-sync-schema)
      - [Using `CS`](#using-cs)
  - [Viewing Help](#viewing-help)
    - [Notes:](#notes)

---

## Docker Compose Setup

To get started, ensure you have [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/) installed.

### Docker Compose Configuration

Below is the configuration to set up a PostgreSQL container using Docker Compose.

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  db:
    image: postgres:15.3-alpine  # Updated to the latest stable version
    container_name: postgres_db  # Optional: Assign a clear name to the container
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres  # Optional: Specify a default database
    ports:
      - '5432:5432'
    volumes:
      - postgres_data:/var/lib/postgresql/data # Named volume for data persistence
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql  # Ensure init script is used
    healthcheck:  # Add a health check for better reliability
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
    driver: local

networks:
  default:
    name: postgres
```

- The above `docker-compose.yml` configures PostgreSQL with:
  - Custom username and password (`postgres`).
  - Default database (`postgres`).
  - A named volume for persistent data storage.
  - An initial SQL script (`init.sql`), which will run when the container is first created.
  - A health check for monitoring the PostgreSQL server's readiness.

---

## Makefile Setup

The `Makefile` automates schema creation and synchronization for PostgreSQL. Below is the content of the `Makefile` to manage schemas using Docker commands.

### `Makefile`

```makefile
# Default schema name
SCHEMA_NAME ?= default_schema

# Command to sync schemas from the schemas.txt file to the database
sync-schema:
   @echo "Synchronizing schemas from schemas.txt..."
   @docker exec -it postgres_db bash -c "cat /db/schemas.txt | while read schema; do \
      if [ -n \"$$schema\" ]; then \
         docker exec -it postgres_db psql -U postgres -d postgres -c \"CREATE SCHEMA IF NOT EXISTS $$schema;\"; \
      fi \
   done"

# Command to create a single schema
CS:
   @if [ -z "$(schema)" ]; then \
      echo "Error: schema name is mandatory. Use: make CS schema=<name>"; \
      exit 1; \
   fi
   @docker exec -it postgres_db psql -U postgres -d postgres -c "CREATE SCHEMA IF NOT EXISTS $(schema);"

# Alias for CS
cs: CS

# Help target to display available commands
help:
   @echo "Available commands:"
   @echo "  make sync-schema          - Synchronize schemas from schemas.txt to the database"
   @echo "  make CS schema=<name>     - Create a schema in the database (case-sensitive)"
   @echo "  make cs schema=<name>     - Alias for 'make CS'"
   @echo "  make help                 - Show available make commands"
```

- **`sync-schema`**: Synchronizes schemas listed in `schemas.txt` with the PostgreSQL database.
- **`CS`**: Creates a schema in the database.
- **`cs`**: Alias for `make CS` to create a schema.
- **`help`**: Displays available Makefile commands.

---

## Running the Application

To start the PostgreSQL container and run your application, follow these steps:

1. Ensure Docker and Docker Compose are installed on your machine.
2. Navigate to the directory containing the `docker-compose.yml` and `Makefile`.
3. Run the following command to start the PostgreSQL container:

   ```bash
   docker-compose up -d
   ```

   This will:
   - Pull the necessary Docker image.
   - Start the PostgreSQL container in detached mode.
   - Run any initialization scripts (e.g., `init.sql`) to set up the database.

4. After the container is up and running, you can interact with the PostgreSQL database and manage schemas using the Makefile commands.

---

## Managing Schemas

### Adding New Schemas

To add new schemas, simply update the `schemas.txt` file located in the `./db/` directory.

1. Open `schemas.txt` and add the new schema name(s) you want to create, one per line. For example:

   ```plaintext
   template_repo
   demo
   new_schema
   ```

   **Note**: Schema names are case-sensitive.

2. Save the changes to `schemas.txt`.

### Creating a Schema Using Make Commands

Once the `schemas.txt` file is updated with new schema names, you can apply the changes to your database using the `sync-schema` Makefile command.

#### Using `sync-schema`

1. Run the following command to synchronize the schemas:

   ```bash
   make sync-schema
   ```

2. This command will:
   - Check if the `postgres_db` container is running.
   - Read the `schemas.txt` file.
   - Create any missing schemas in the PostgreSQL database.

3. After synchronization, verify the schemas by running:

   ```bash
   docker exec -it postgres_db psql -U postgres -d postgres -c "\dn"
   ```

   This will list all the schemas in the database.

#### Using `CS`

To create a single schema directly, use the `CS` Makefile command. For example:

1. To create a new schema:

   ```bash
   make CS schema=new_schema
   ```

   This will:
   - Create the specified schema in the database if it doesn't already exist.

2. **Alias**: You can also use the alias `make cs` as a shortcut for `make CS`:

   ```bash
   make cs schema=new_schema
   ```

---

## Viewing Help

To see a list of available make commands and their descriptions, run:

```bash
make help
```

This will display the following information:

```plaintext
Available commands:
  make sync-schema          - Synchronize schemas from schemas.txt to the database
  make CS schema=<name>     - Create a schema in the database (case-sensitive)
  make cs schema=<name>     - Alias for 'make CS'
  make help                 - Show available make commands
```

---

### Notes:

- Ensure your Docker Compose environment is up and running before executing any commands.
- `schemas.txt` should be located inside the `./db/` directory.
- Schema names in `schemas.txt` are **case-sensitive**.
- The `sync-schema` command will only create schemas that are defined in `schemas.txt`.
