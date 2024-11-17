#!/bin/bash

# Paths
SCHEMAS_FILE="/docker-entrypoint-initdb.d/schemas.txt"
STATE_FILE="/var/lib/postgresql/processed_schemas.txt"

# Database connection variables
DB_USER=${POSTGRES_USER:-postgres}
DB_PASSWORD=${POSTGRES_PASSWORD:-postgres}
DB_NAME=${POSTGRES_DB:-postgres}

# Ensure the state file exists
touch "$STATE_FILE"

# Create schemas from the file
if [ -f "$SCHEMAS_FILE" ]; then
    echo "Reading schemas from $SCHEMAS_FILE..."
    while IFS= read -r schema || [ -n "$schema" ]; do
        if [ -n "$schema" ]; then
            # Check if the schema is already processed
            if grep -Fxq "$schema" "$STATE_FILE"; then
                echo "Schema '$schema' already exists. Skipping..."
            else
                echo "Creating schema: $schema"
                PGPASSWORD="$DB_PASSWORD" psql -U "$DB_USER" -d "$DB_NAME" -c "CREATE SCHEMA IF NOT EXISTS \"$schema\";"
                if [ $? -eq 0 ]; then
                    # Mark schema as processed
                    echo "$schema" >> "$STATE_FILE"
                else
                    echo "Failed to create schema: $schema"
                fi
            fi
        fi
    done < "$SCHEMAS_FILE"
else
    echo "Schemas file not found at $SCHEMAS_FILE. No schemas will be created."
fi
