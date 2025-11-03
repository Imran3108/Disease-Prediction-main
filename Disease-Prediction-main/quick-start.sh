#!/bin/bash

# Quick Start Script for Local Development

set -e

echo "========================================="
echo "Quick Start - Disease Prediction App"
echo "========================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "ERROR: Docker Compose is not installed. Please install it first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file from example..."
    cp env.example .env
    echo "Please edit .env file with your settings if needed."
fi

# Build and start containers
echo "Building and starting containers..."
docker-compose up -d --build

# Wait for database to be ready
echo "Waiting for database to start..."
sleep 10

# Run migrations
echo "Running database migrations..."
docker-compose exec -T web python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
docker-compose exec -T web python manage.py collectstatic --noinput || true

echo ""
echo "========================================="
echo "Application is ready!"
echo "========================================="
echo ""
echo "Access the application at: http://localhost:8000"
echo ""
echo "Useful commands:"
echo "  View logs:       docker-compose logs -f"
echo "  Stop app:        docker-compose down"
echo "  Restart:         docker-compose restart"
echo "  Create admin:    docker-compose exec web python manage.py createsuperuser"
echo ""

