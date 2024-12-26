.PHONY: start-postgresql

start-postgresql:
	@echo "Starting PostgreSQL using Docker Compose..."
	cd postgresql && docker compose up -d