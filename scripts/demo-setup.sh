#!/bin/bash

# WhatsApp Resume Processing - Demo Setup Script
# This script sets up everything needed for the demo

echo "🎬 WhatsApp Resume Processing Demo Setup"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check prerequisites
echo "🔍 Checking prerequisites..."

# Check Docker
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker Desktop first."
    exit 1
fi
print_status "Docker is running"

# Check if .env file exists
if [ ! -f ".env" ]; then
    print_warning ".env file not found. Creating from template..."
    cp env.example .env
    print_info "Please edit .env file with your credentials before continuing"
    print_info "Required: NGROK_AUTHTOKEN, TWILIO credentials, Google service account, OpenAI key"
    echo ""
    read -p "Press Enter after updating .env file..."
fi

# Check if service-account.json exists
if [ ! -f "service-account.json" ]; then
    print_error "service-account.json not found!"
    print_info "Please download your Google service account JSON file and place it in the project root"
    print_info "File should be named: service-account.json"
    exit 1
fi
print_status "Google service account found"

# Create required directories
mkdir -p n8n_data credentials
print_status "Created required directories"

# Load environment variables
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check if NGROK_AUTHTOKEN is set
if [ -z "$NGROK_AUTHTOKEN" ]; then
    print_error "NGROK_AUTHTOKEN not set in .env file"
    print_info "Get your ngrok authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken"
    exit 1
fi

print_status "Environment variables loaded"

# Start services
echo ""
echo "🚀 Starting services..."

# Stop any existing containers
docker compose down > /dev/null 2>&1

# Start services
docker compose up -d

# Wait for services to start
print_info "Waiting for services to start..."
sleep 15

# Check if n8n is running
if curl -s http://localhost:5678 > /dev/null; then
    print_status "n8n is running at http://localhost:5678"
else
    print_error "n8n failed to start"
    docker compose logs n8n
    exit 1
fi

# Check if ngrok is running
if curl -s http://localhost:4040 > /dev/null; then
    print_status "ngrok is running at http://localhost:4040"
else
    print_error "ngrok failed to start"
    docker compose logs ngrok
    exit 1
fi

# Get ngrok URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | grep -o 'https://[^"]*' | head -1)

if [ -n "$NGROK_URL" ]; then
    print_status "ngrok tunnel active: $NGROK_URL"
    WEBHOOK_URL="$NGROK_URL/webhook/whatsapp"
    print_info "Webhook URL: $WEBHOOK_URL"
else
    print_warning "Could not get ngrok URL automatically"
    print_info "Check ngrok dashboard at http://localhost:4040"
fi

echo ""
echo "🎯 Demo Setup Complete!"
echo "======================"
echo ""
print_info "Next steps for demo:"
echo "1. Configure Twilio webhook: $WEBHOOK_URL"
echo "2. Import n8n workflow: n8n_workflow_export.json"
echo "3. Configure credentials in n8n (Google, OpenAI, Twilio)"
echo "4. Test with WhatsApp message"
echo ""
print_info "Access points:"
echo "• n8n: http://localhost:5678 (admin/adminpass)"
echo "• ngrok dashboard: http://localhost:4040"
echo ""
print_info "Demo script ready! 🎬"
