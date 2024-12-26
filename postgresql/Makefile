# Create a schema with input
CS:
	@if [ -z "$(schema)" ]; then \
		echo "Error: schema name is mandatory. Use: make CS schema=<name>"; \
		exit 1; \
	fi
	@docker exec -it postgres_db psql -U postgres -d postgres -c "CREATE SCHEMA IF NOT EXISTS $(schema);"

cs: CS  # Alias for CS target

# Delete a schema with input
DS:
	@if [ -z "$(schema)" ]; then \
		echo "Error: schema name is mandatory. Use: make DS schema=<name>"; \
		exit 1; \
	fi
	@docker exec -it postgres_db psql -U postgres -d postgres -c "DROP SCHEMA IF EXISTS $(schema) CASCADE;"
	@echo "Schema '$(schema)' deleted successfully."

ds: DS  # Alias for DS target

# Synchronize schemas from schemas.txt
sync-schema:
	@if [ "$(shell docker ps -q -f name=postgres_db)" = "" ]; then \
		echo "Error: postgres_db container is not running. Start it with 'docker-compose up -d'."; \
		exit 1; \
	fi
	@echo "Synchronizing schemas from schemas.txt..."
	@docker exec -it postgres_db /docker-entrypoint-initdb.d/create_schema.sh
	@echo "Schema synchronization complete."

# Display help information
help:
	@echo "Available commands:"
	@echo "  make CS schema=<name>     - Create a schema in the database (case-sensitive)"
	@echo "  make cs schema=<name>     - Alias for 'make CS'"
	@echo "  make DS schema=<name>     - Delete a schema in the database (case-sensitive)"
	@echo "  make ds schema=<name>     - Alias for 'make DS'"
	@echo "  make sync-schema          - Synchronize schemas from schemas.txt to the database"
