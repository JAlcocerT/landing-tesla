.PHONY: help install dev build docker-dev docker-prod docker-clean

# Define variables
DOCKER_IMAGE_NAME=landing-tesla
DOCKER_PROD_IMAGE_NAME=landing-tesla-prod

# Help command to display all available commands
help:
	@echo "Available commands:"
	@echo "  make help         - Show this help message"
	@echo "  make install      - Install dependencies"
	@echo "  make dev          - Start development server"
	@echo "  make build        - Build the application"
	@echo "  make docker-dev   - Run the container in development mode"
	@echo "  make docker-prod  - Build and run the production container"
	@echo "  make docker-clean - Clean up Docker resources"

# Install dependencies
install:
	npm install

# Start development server
dev:
	npm run dev

# Build the application
build:
	npm run build

# Run the container in development mode
docker-dev:
	docker build --target=development -t $(DOCKER_IMAGE_NAME)-dev .
	docker run -it --rm \
		-v $(PWD):/app \
		-p 3000:3000 \
		$(DOCKER_IMAGE_NAME)-dev \
		npm run dev -- --host

# Build and run the production container
docker-prod:
	docker build -t $(DOCKER_IMAGE_NAME) .
	docker run -d --name $(DOCKER_IMAGE_NAME)-prod \
		-p 3000:3000 \
		$(DOCKER_IMAGE_NAME)

# Clean up Docker resources
docker-clean:
	@echo "Removing Docker containers..."
	@docker ps -a -q --filter "name=$(DOCKER_IMAGE_NAME)*" | xargs -r docker rm -f 2>/dev/null || true
	@echo "Removing Docker images..."
	@docker images -q "$(DOCKER_IMAGE_NAME)*" | xargs -r docker rmi -f 2>/dev/null || true