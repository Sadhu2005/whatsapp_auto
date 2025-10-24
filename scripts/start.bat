@echo off
REM WhatsApp Resume Processing - Windows Startup Script

echo 🚀 Starting WhatsApp Resume Processing System...

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

REM Check if ngrok is installed
where ngrok >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ngrok is not installed. Please install ngrok first:
    echo    Download from: https://ngrok.com/download
    pause
    exit /b 1
)

REM Check if service-account.json exists
if not exist "service-account.json" (
    echo ❌ service-account.json not found. Please add your Google service account JSON file.
    pause
    exit /b 1
)

REM Create required directories
if not exist "n8n_data" mkdir n8n_data
if not exist "credentials" mkdir credentials

echo 📦 Starting n8n with Docker Compose...
docker compose up -d

REM Wait for n8n to start
echo ⏳ Waiting for n8n to start...
timeout /t 10 /nobreak >nul

REM Check if n8n is running
curl -s http://localhost:5678 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ n8n is running at http://localhost:5678
    echo    Login: admin / adminpass
) else (
    echo ❌ n8n failed to start. Check logs with: docker compose logs n8n
    pause
    exit /b 1
)

echo 🌐 Starting ngrok tunnel...
REM Start ngrok in background
start /b ngrok http 5678 --log=stdout > ngrok.log 2>&1

REM Wait for ngrok to start
timeout /t 5 /nobreak >nul

REM Get ngrok URL (simplified for Windows)
echo ✅ ngrok tunnel should be active
echo 🔗 Check ngrok dashboard at http://localhost:4040 for your public URL
echo ""
echo 📋 Next steps:
echo 1. Copy your ngrok URL from http://localhost:4040
echo 2. Configure Twilio webhook URL: [your-ngrok-url]/webhook/whatsapp
echo 3. Import workflow in n8n: n8n_workflow_export.json
echo 4. Configure credentials in n8n
echo 5. Test by sending a message to your Twilio sandbox number
echo ""
echo 🛑 Press any key to stop...
pause >nul

REM Cleanup
taskkill /f /im ngrok.exe >nul 2>&1
docker compose down
