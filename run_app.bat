@echo off
echo ########################################################
echo # Maintenance Tracker - Run Application Script         #
echo ########################################################
echo.

REM Get the directory of the batch script
set SCRIPT_DIR=%~dp0

REM Navigate to the script's directory
cd /d "%SCRIPT_DIR%"

echo Activating virtual environment...
call "%SCRIPT_DIR%venv\Scripts\activate.bat"
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate virtual environment.
    echo Make sure you have run 'setup.bat' successfully first.
    pause
    exit /b 1
)

echo.
echo ########################################################
echo # SSL Configuration (Optional)                       #
echo ########################################################
echo If you have SSL certificate (.crt) and key (.key) files for localhost,
necho you can set their paths here. Otherwise, leave them blank 
necho and the application will run using HTTP.
echo.

REM --- USER: CONFIGURE YOUR SSL CERTIFICATE PATHS BELOW (IF ANY) ---
set "LOCALHOST_SSL_CRT="
set "LOCALHOST_SSL_KEY="

REM Example: 
REM set "LOCALHOST_SSL_CRT=C:\path\to\your\cert.pem"
REM set "LOCALHOST_SSL_KEY=C:\path\to\your\key.pem"
REM ---------------------------------------------------------------------
echo.

if defined LOCALHOST_SSL_CRT (
    if defined LOCALHOST_SSL_KEY (
        echo SSL Certificate Path: %LOCALHOST_SSL_CRT%
        echo SSL Key Path:         %LOCALHOST_SSL_KEY%
        echo Attempting to use SSL (HTTPS).
    ) else (
        echo SSL Certificate path is set, but Key path is missing. Running without SSL.
        set "LOCALHOST_SSL_CRT="
        set "LOCALHOST_SSL_KEY="
    )
) else (
    echo SSL paths not set by user. Running without SSL (HTTP).
    set "LOCALHOST_SSL_CRT="
    set "LOCALHOST_SSL_KEY="
)

echo.
echo Starting the Maintenance Tracker application...
echo (Press CTRL+C in this window to stop the application)
echo.

python app.py

echo.
echo Application stopped.
pause 