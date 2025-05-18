@echo off
echo ############################################################
echo # Maintenance Tracker - Automated Setup Script for Windows #
echo ############################################################
echo.

REM Check if Python is installed by checking for pip
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python (with pip) not found. Attempting to install Python 3 using winget...
    echo If winget is not available or fails, please install Python 3 manually
    echo from python.org and ensure "Add Python to PATH" is checked during installation.
    echo.
    winget install -e --id Python.Python.3 --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo.
        echo ERROR: Python installation via winget failed or was cancelled.
        echo Please install Python 3 manually from python.org (ensure "Add Python to PATH" is checked).
        echo Then, re-run this setup script.
        pause
        exit /b 1
    )
    echo.
    echo Python installation attempted. Please close this window and re-run setup.bat
    echo to ensure the new Python installation is recognized in the PATH.
    pause
    exit /b 0
) else (
    echo Python (with pip) is already installed.
)
echo.

REM Get the directory of the batch script
set SCRIPT_DIR=%~dp0

REM Navigate to the script's directory
cd /d "%SCRIPT_DIR%"

echo Creating Python virtual environment (venv)...
python -m venv venv
if %errorlevel% neq 0 (
    echo ERROR: Failed to create Python virtual environment.
    pause
    exit /b 1
)
echo Virtual environment created successfully in 'venv' folder.
echo.

echo Activating virtual environment and installing required packages...
call "%SCRIPT_DIR%venv\Scripts\activate.bat"
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate virtual environment. Check if venv was created correctly.
    pause
    exit /b 1
)
echo Installing packages from requirements.txt...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install packages from requirements.txt.
    pause
    exit /b 1
)
echo Packages installed successfully.
echo.

echo Initializing the database...
flask initdb
if %errorlevel% neq 0 (
    echo ERROR: Failed to initialize the database with 'flask initdb'.
    echo Make sure Flask was installed correctly.
    pause
    exit /b 1
)
echo Database initialized successfully.
echo.

echo ############################################################
echo # Setup Complete!                                          #
echo ############################################################
echo.
echo You can now run the application using the 'run_app.bat' script.
echo.
pause 