#!/bin/bash

# Configuration Update Script for AWS EC2 IP Addresses

set -e

echo "========================================="
echo "Configuration Updater"
echo "========================================="

# Get EC2 instance private IP (for database)
EC2_PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Get EC2 instance public IP (for ALLOWED_HOSTS)
EC2_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

echo "Detected EC2 Private IP: $EC2_PRIVATE_IP"
echo "Detected EC2 Public IP: $EC2_PUBLIC_IP"

# Check if .env file exists
if [ ! -f .env ]; then
    echo "ERROR: .env file not found!"
    echo "Please create .env file from env.example first:"
    echo "  cp env.example .env"
    exit 1
fi

# Update .env file
echo ""
echo "Updating .env file..."

# Update ALLOWED_HOSTS
if grep -q "ALLOWED_HOSTS" .env; then
    sed -i "s|ALLOWED_HOSTS=.*|ALLOWED_HOSTS=$EC2_PUBLIC_IP,localhost,127.0.0.1|" .env
    echo "✓ Updated ALLOWED_HOSTS"
else
    echo "ALLOWED_HOSTS=$EC2_PUBLIC_IP,localhost,127.0.0.1" >> .env
    echo "✓ Added ALLOWED_HOSTS"
fi

# For Docker Compose, keep DB_HOST as 'db'
# If using external database on EC2, uncomment below:
# if grep -q "DB_HOST" .env; then
#     sed -i "s|DB_HOST=.*|DB_HOST=$EC2_PRIVATE_IP|" .env
#     echo "✓ Updated DB_HOST"
# fi

echo ""
echo "========================================="
echo "Configuration updated successfully!"
echo "========================================="
echo ""
echo "Your application will be accessible at:"
echo "  http://$EC2_PUBLIC_IP:8000"
echo ""
echo "To apply changes, restart containers:"
echo "  docker-compose restart"
echo ""

