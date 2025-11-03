#!/bin/bash

# Simple AWS EC2 Deployment Script
# Use this if deploy.sh has issues

set -e

echo "========================================="
echo "Simple Deployment Script"
echo "========================================="

# Navigate to current directory (where script is run from)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "Working directory: $(pwd)"

# Check if we're in the right directory
if [ ! -f "env.example" ]; then
    echo "ERROR: env.example not found!"
    echo "Please run this script from the Disease-Prediction-main directory"
    exit 1
fi

# Create .env if needed
if [ ! -f .env ]; then
    echo "Creating .env from env.example..."
    cp env.example .env
fi

# Get public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "35.172.48.105")
echo "Detected Public IP: $PUBLIC_IP"

# Update ALLOWED_HOSTS
if grep -q "ALLOWED_HOSTS" .env; then
    sed -i "s|ALLOWED_HOSTS=.*|ALLOWED_HOSTS=$PUBLIC_IP,localhost,127.0.0.1|" .env
    echo "Updated ALLOWED_HOSTS"
fi

# Update DB_HOST to 'db' for Docker Compose
if grep -q "DB_HOST=localhost" .env; then
    sed -i "s/DB_HOST=localhost/DB_HOST=db/" .env
    echo "Updated DB_HOST to 'db'"
fi

echo ""
echo "Building Docker images..."
docker-compose build --no-cache || docker compose build --no-cache

echo ""
echo "Starting containers..."
docker-compose up -d || docker compose up -d

echo ""
echo "Waiting for database..."
sleep 15

echo ""
echo "Running migrations..."
docker-compose exec -T web python manage.py migrate --noinput || true

echo ""
echo "Collecting static files..."
docker-compose exec -T web python manage.py collectstatic --noinput || true

echo ""
echo "========================================="
echo "Deployment Complete!"
echo "========================================="
echo ""
echo "Your app is running at: http://$PUBLIC_IP:8000"
echo ""
echo "Useful commands:"
echo "  View logs:    docker-compose logs -f"
echo "  Stop:         docker-compose down"
echo "  Restart:      docker-compose restart"
echo "  Create admin: docker-compose exec web python manage.py createsuperuser"
echo ""

