#!/bin/bash

# AWS EC2 Deployment Script for Disease Prediction Application

set -e

echo "========================================="
echo "Deploying Disease Prediction Application"
echo "========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Update system packages
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt-get update -y

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

# Install Docker Compose if not installed (standalone)
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Add current user to docker group
sudo usermod -aG docker $USER

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Try different project directory locations
if [ -f "$SCRIPT_DIR/env.example" ]; then
    # Script is in the project directory
    PROJECT_DIR="$SCRIPT_DIR"
elif [ -f "/home/ubuntu/Disease-Prediction-main/env.example" ]; then
    PROJECT_DIR="/home/ubuntu/Disease-Prediction-main"
elif [ -f "/home/ubuntu/disease-prediction/env.example" ]; then
    PROJECT_DIR="/home/ubuntu/disease-prediction"
elif [ -f "$HOME/Disease-Prediction-main/env.example" ]; then
    PROJECT_DIR="$HOME/Disease-Prediction-main"
elif [ -f "$HOME/disease-prediction/env.example" ]; then
    PROJECT_DIR="$HOME/disease-prediction"
else
    echo -e "${RED}ERROR: Could not find project directory with env.example!${NC}"
    echo "Please run this script from the Disease-Prediction-main directory"
    echo "Current directory: $(pwd)"
    exit 1
fi

echo -e "${GREEN}Found project directory: $PROJECT_DIR${NC}"

# Navigate to project directory
cd "$PROJECT_DIR"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    if [ -f env.example ]; then
        echo -e "${YELLOW}Creating .env file from env.example...${NC}"
        cp env.example .env
    else
        echo -e "${RED}ERROR: env.example file not found!${NC}"
        echo "Please ensure all project files are uploaded correctly."
        exit 1
    fi
fi

# Get EC2 instance public IP for ALLOWED_HOSTS (IMDSv2 with fallback)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" || true)
if [ -n "$TOKEN" ]; then
  EC2_PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 || true)
else
  EC2_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || true)
fi
if [ -z "$EC2_PUBLIC_IP" ]; then
  EC2_PUBLIC_IP=$(curl -s ifconfig.me || hostname -I 2>/dev/null | awk '{print $1}')
fi
echo -e "${GREEN}EC2 Instance Public IP: ${EC2_PUBLIC_IP}${NC}"

# Get EC2 instance private IP for reference
EC2_PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo -e "${GREEN}EC2 Instance Private IP: $EC2_PRIVATE_IP${NC}"

# Update ALLOWED_HOSTS in .env with public IP
if grep -q "ALLOWED_HOSTS" .env; then
    sed -i "s|ALLOWED_HOSTS=.*|ALLOWED_HOSTS=$EC2_PUBLIC_IP,localhost,127.0.0.1|" .env
fi

# For Docker Compose, DB_HOST should be 'db' not the EC2 IP
# Only update if it's still localhost
if grep -q "DB_HOST=localhost" .env; then
    sed -i "s/DB_HOST=localhost/DB_HOST=db/" .env
fi

echo -e "${GREEN}Environment configuration updated with EC2 Public IP: ${EC2_PUBLIC_IP}${NC}"

# Build and start containers
echo -e "${YELLOW}Building Docker images...${NC}"
docker-compose build --no-cache

echo -e "${YELLOW}Starting containers...${NC}"
docker-compose up -d

# Wait for database to be ready
echo -e "${YELLOW}Waiting for database to be ready...${NC}"
sleep 10

# Run migrations
echo -e "${YELLOW}Running database migrations...${NC}"
docker-compose exec -T web python manage.py migrate --noinput || true

# Create superuser (optional, uncomment if needed)
# echo -e "${YELLOW}Creating superuser...${NC}"
# docker-compose exec -T web python manage.py createsuperuser

# Collect static files
echo -e "${YELLOW}Collecting static files...${NC}"
docker-compose exec -T web python manage.py collectstatic --noinput || true

echo -e "${GREEN}========================================="
echo "Deployment completed successfully!"
echo "=========================================${NC}"
echo ""
echo "Your application is running at: http://${EC2_PUBLIC_IP}:8000"
echo "To view logs: docker-compose logs -f"
echo "To stop: docker-compose down"
echo "To restart: docker-compose restart"

