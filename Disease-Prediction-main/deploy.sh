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

# Create project directory if it doesn't exist
PROJECT_DIR="/home/ubuntu/disease-prediction"
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}Creating project directory...${NC}"
    sudo mkdir -p $PROJECT_DIR
    sudo chown -R $USER:$USER $PROJECT_DIR
fi

# Navigate to project directory
cd $PROJECT_DIR

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file...${NC}"
    cp env.example .env
    echo -e "${RED}IMPORTANT: Please edit .env file with your configuration before proceeding!${NC}"
    echo "Press Enter to continue after editing .env file..."
    read
fi

# Get EC2 instance private IP
EC2_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo -e "${GREEN}EC2 Instance Private IP: $EC2_IP${NC}"

# Update ALLOWED_HOSTS in .env
if grep -q "ALLOWED_HOSTS" .env; then
    sed -i "s/ALLOWED_HOSTS=.*/ALLOWED_HOSTS=${EC2_IP},localhost,127.0.0.1/" .env
fi

# Update DB_HOST in .env (use private IP for database)
if grep -q "DB_HOST" .env; then
    sed -i "s/DB_HOST=.*/DB_HOST=${EC2_IP}/" .env
fi

echo -e "${GREEN}Environment configuration updated with EC2 IP: $EC2_IP${NC}"

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
echo "Your application is running at: http://$EC2_IP:8000"
echo "To view logs: docker-compose logs -f"
echo "To stop: docker-compose down"
echo "To restart: docker-compose restart"

