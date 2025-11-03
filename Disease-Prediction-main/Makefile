.PHONY: help build up down restart logs shell migrate createsuperuser collectstatic backup clean test

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build Docker images
	docker-compose build

up: ## Start all containers
	docker-compose up -d

down: ## Stop all containers
	docker-compose down

restart: ## Restart all containers
	docker-compose restart

logs: ## View logs
	docker-compose logs -f

shell: ## Open shell in web container
	docker-compose exec web bash

migrate: ## Run database migrations
	docker-compose exec web python manage.py migrate

createsuperuser: ## Create Django superuser
	docker-compose exec web python manage.py createsuperuser

collectstatic: ## Collect static files
	docker-compose exec web python manage.py collectstatic --noinput

backup: ## Backup database
	./backup.sh

clean: ## Clean up containers, volumes, and images
	docker-compose down -v
	docker system prune -f

test: ## Run tests
	docker-compose exec web python manage.py test

prod-up: ## Start production deployment with Nginx
	docker-compose -f docker-compose.nginx.yml up -d --build

prod-down: ## Stop production deployment
	docker-compose -f docker-compose.nginx.yml down

deploy: ## Run deployment script
	chmod +x deploy.sh && ./deploy.sh

quick-start: ## Quick start for local development
	chmod +x quick-start.sh && ./quick-start.sh

