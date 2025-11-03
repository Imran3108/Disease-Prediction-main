#!/bin/bash

# AWS EC2 Security Group and Instance Setup Script

set -e

echo "========================================="
echo "AWS EC2 Setup for Disease Prediction"
echo "========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}This script will help you set up AWS EC2 security groups.${NC}"
echo ""
echo "Please make sure you have AWS CLI installed and configured."
echo "If not, install it using: sudo apt-get install awscli -y"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

echo -e "${YELLOW}Creating security group rules...${NC}"

# Note: These commands need to be run manually or with proper AWS credentials
# Uncomment and modify based on your needs

# For PostgreSQL database (internal only)
# aws ec2 authorize-security-group-ingress \
#     --group-id YOUR_SG_ID \
#     --protocol tcp \
#     --port 5432 \
#     --cidr 10.0.0.0/16  # Adjust CIDR based on your VPC

# For Django application
# aws ec2 authorize-security-group-ingress \
#     --group-id YOUR_SG_ID \
#     --protocol tcp \
#     --port 8000 \
#     --cidr 0.0.0.0/0

# For Nginx
# aws ec2 authorize-security-group-ingress \
#     --group-id YOUR_SG_ID \
#     --protocol tcp \
#     --port 80 \
#     --cidr 0.0.0.0/0

# aws ec2 authorize-security-group-ingress \
#     --group-id YOUR_SG_ID \
#     --protocol tcp \
#     --port 443 \
#     --cidr 0.0.0.0/0

# For SSH access
# aws ec2 authorize-security-group-ingress \
#     --group-id YOUR_SG_ID \
#     --protocol tcp \
#     --port 22 \
#     --cidr YOUR_IP/32

echo -e "${GREEN}========================================="
echo "Manual Configuration Required:"
echo "=========================================${NC}"
echo ""
echo "1. SSH into your EC2 instance"
echo "2. Configure security groups to allow:"
echo "   - Port 22 (SSH) - from your IP"
echo "   - Port 80 (HTTP) - from anywhere (0.0.0.0/0)"
echo "   - Port 443 (HTTPS) - from anywhere (optional)"
echo "   - Port 8000 (Django) - from anywhere"
echo "   - Port 5432 (PostgreSQL) - only from your VPC"
echo ""
echo "3. Upload your project files to EC2"
echo "4. Run the deploy.sh script"
echo ""

