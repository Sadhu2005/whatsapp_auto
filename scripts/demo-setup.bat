@echo off
REM WhatsApp Resume Processing - Windows Demo Setup Script

echo 🎬 WhatsApp Resume Processing Demo Setup
echo ========================================

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)
echo ✅ Docker is running

REM Check if .env file exists
if not exist ".env" (
    echo ⚠️  .env file not found. Creating from template...
    copy env.example .env
    echo ℹ️  Please edit .env file with your credentials before continuing
    echo ℹ️  Required: NGROK_AUTHTOKEN, TWILIO credentials, Google service account, OpenAI key
    echo.
    pause
)

REM Check if service-account.json exists
if not exist "service-account.json" (
    echo ❌ service-account.json not found!
    echo ℹ️  Please download your Google service account JSON file and place it in the project root
    echo ℹ️  File should be named: service-account.json
    pause
    exit /b 1
)
echo ✅ Google service account found

REM Create required directories
if not exist "n8n_data" mkdir n8n_data
if not exist "credentials" mkdir credentials
echo ✅ Created required directories

REM Load environment variables
if exist ".env" (
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="" if not "%%a:~0,1%"=="#" (
            set "%%a=%%b"
        )
    )
)

REM Check if NGROK_AUTHTOKEN is set
if "%NGROK_AUTHTOKEN%"=="" (
    echo ❌ NGROK_AUTHTOKEN not set in .env file
    echo ℹ️  Get your ngrok authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken
    pause
    exit /b 1
)

echo ✅ Environment variables loaded

REM Start services
echo.
echo 🚀 Starting services...

REM Stop any existing containers
docker compose down >nul 2>&1

REM Start services
docker compose up -d

REM Wait for services to start
echo ℹ️  Waiting for services to start...
timeout /t 15 /nobreak >nul

REM Check if n8n is running
curl -s http://localhost:5678 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ n8n is running at http://localhost:5678
) else (
    echo ❌ n8n failed to start
    docker compose logs n8n
    pause
    exit /b 1
)

REM Check if ngrok is running
curl -s http://localhost:4040 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ ngrok is running at http://localhost:4040
) else (
    echo ❌ ngrok failed to start
    docker compose logs ngrok
    pause
    exit /b 1
)

echo.
echo 🎯 Demo Setup Complete!
echo ======================
echo.
echo ℹ️  Next steps for demo:
echo 1. Configure Twilio webhook: Check http://localhost:4040 for your ngrok URL
echo 2. Import n8n workflow: n8n_workflow_export.json
echo 3. Configure credentials in n8n (Google, OpenAI, Twilio)
echo 4. Test with WhatsApp message
echo.
echo ℹ️  Access points:
echo • n8n: http://localhost:5678 (admin/adminpass)
echo • ngrok dashboard: http://localhost:4040
echo.
echo ℹ️  Demo script ready! 🎬
pause
