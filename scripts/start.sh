#!/bin/bash

# WhatsApp Resume Processing - Startup Script

echo "🚀 Starting WhatsApp Resume Processing System..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok is not installed. Please install ngrok first:"
    echo "   Windows: choco install ngrok"
    echo "   Mac: brew install ngrok"
    echo "   Linux: Download from https://ngrok.com/download"
    exit 1
fi

# Check if service-account.json exists
if [ ! -f "service-account.json" ]; then
    echo "❌ service-account.json not found. Please add your Google service account JSON file."
    exit 1
fi

# Create required directories
mkdir -p n8n_data credentials

echo "📦 Starting n8n with Docker Compose..."
docker compose up -d

# Wait for n8n to start
echo "⏳ Waiting for n8n to start..."
sleep 10

# Check if n8n is running
if curl -s http://localhost:5678 > /dev/null; then
    echo "✅ n8n is running at http://localhost:5678"
    echo "   Login: admin / adminpass"
else
    echo "❌ n8n failed to start. Check logs with: docker compose logs n8n"
    exit 1
fi

echo "🌐 Starting ngrok tunnel..."
# Start ngrok in background
ngrok http 5678 --log=stdout > ngrok.log 2>&1 &
NGROK_PID=$!

# Wait for ngrok to start
sleep 5

# Get ngrok URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | grep -o 'https://[^"]*' | head -1)

if [ -n "$NGROK_URL" ]; then
    echo "✅ ngrok tunnel active: $NGROK_URL"
    echo "🔗 Webhook URL: $NGROK_URL/webhook/whatsapp"
    echo ""
    echo "📋 Next steps:"
    echo "1. Configure Twilio webhook URL: $NGROK_URL/webhook/whatsapp"
    echo "2. Import workflow in n8n: n8n_workflow_export.json"
    echo "3. Configure credentials in n8n"
    echo "4. Test by sending a message to your Twilio sandbox number"
    echo ""
    echo "🛑 To stop: Press Ctrl+C"
    
    # Keep script running
    wait $NGROK_PID
else
    echo "❌ Failed to get ngrok URL. Check ngrok.log for details."
    kill $NGROK_PID 2>/dev/null
    exit 1
fi
