# Maintenance Tracker Web App - Setup Guide for Windows

This guide will help you set up and run the Maintenance Tracker web application on your Windows computer. No prior technical experience is needed, just follow these steps carefully!

## Step 1: Install Python

Python is the programming language this application is built with.

1.  **Download Python**:
    *   Open your web browser (like Chrome, Edge, or Firefox) and go to the official Python website: [python.org](https://www.python.org/)
    *   Hover over "Downloads" in the menu. You should see a button like "Download for Windows" with the latest Python version (e.g., Python 3.1x.x). Click it.
    *   An installer file (e.g., `python-3.1x.x-amd64.exe`) will download.

2.  **Run the Python Installer**:
    *   Once downloaded, open the installer file.
    *   **VERY IMPORTANT**: On the first screen of the installer, check the box at the bottom that says **"Add Python 3.x to PATH"** or **"Add python.exe to PATH"**. This will make it much easier to run Python later.
    *   Click "Install Now".
    *   Wait for the installation to complete. You might see a "Setup was successful" message. You can close the installer.

3.  **Verify Python Installation (Optional)**:
    *   Click the Start menu, type `cmd`, and open "Command Prompt".
    *   In the black window that appears, type `python --version` and press Enter.
    *   If Python is installed correctly, you should see something like `Python 3.1x.x`.
    *   You can close the Command Prompt window.

## Step 2: Get the Application Files

If you received the application files as a ZIP folder:
1.  Locate the ZIP file (e.g., `maint-tracker.zip`).
2.  Right-click on the ZIP file and select "Extract All...".
3.  Choose a location to save the extracted folder (e.g., your Desktop or Documents folder) and click "Extract".
4.  You will now have a folder named something like `maint-tracker`. This is your project folder.

If you need to download it from a place like GitHub:
1.  **Install Git (Optional, but good for updates)**:
    *   Go to [git-scm.com/download/win](https://git-scm.com/download/win).
    *   Download the Git for Windows installer.
    *   Run the installer, accepting the default options is usually fine.
2.  **Clone the Repository**:
    *   Open Command Prompt (Start menu, type `cmd`).
    *   Navigate to where you want to save the project (e.g., `cd Desktop`).
    *   If the project is on GitHub, get the repository URL (it looks like `https://github.com/username/projectname.git`).
    *   Type `git clone https://github.com/username/projectname.git` (replace with the actual URL) and press Enter.
    *   This will create a folder with the project files.

## Step 3: Install Application Dependencies

The application needs some extra Python packages to work.

1.  **Open Command Prompt in the Project Folder**:
    *   Go to the `maint-tracker` folder that you extracted or cloned.
    *   In the address bar of File Explorer (where it shows the folder path), type `cmd` and press Enter. This will open Command Prompt directly in that folder.

2.  **Create a Virtual Environment (Recommended)**:
    This creates an isolated space for this project's packages.
    *   In Command Prompt, type: `python -m venv venv` and press Enter.
    *   Wait a moment for it to create a folder named `venv`.
    *   Now, activate the virtual environment by typing: `venv\Scripts\activate` and press Enter.
    *   You should see `(venv)` at the beginning of your command prompt line, like `(venv) C:\Users\YourName\Desktop\maint-tracker>`.

3.  **Install Packages**:
    *   With the virtual environment active (you see `(venv)`), type the following command in Command Prompt and press Enter:
        `pip install -r requirements.txt`
    *   This will download and install all the necessary packages listed in the `requirements.txt` file. Wait for it to finish. You might see a lot of text scrolling.

## Step 4: SSL Certificates (For Secure Connection - HTTPS)

This application can run with a secure (HTTPS) connection if you have SSL certificates. If you don't have these or don't know what they are, the app will still work using a regular (HTTP) connection.

*   **If you have SSL certificate files (`.crt` and `.key` files for `localhost` or your hostname)**:
    1.  You need to tell the application where these files are. The application looks for environment variables named `LOCALHOST_SSL_CRT` (for the public certificate) and `LOCALHOST_SSL_KEY` (for the private key).
    2.  **Setting Environment Variables (Temporary for this session)**:
        *   In the *same Command Prompt window* where you have `(venv)` active, type the following commands, replacing `path\to\your\cert.pem` and `path\to\your\key.pem` with the actual full paths to your files:
            ```bash
            set LOCALHOST_SSL_CRT=C:\path\to\your\cert.pem
            set LOCALHOST_SSL_KEY=C:\path\to\your\key.pem
            ```
            For example:
            ```bash
            set LOCALHOST_SSL_CRT=C:\Users\YourName\certs\mycert.crt
            set LOCALHOST_SSL_KEY=C:\Users\YourName\certs\mykey.key
            ```
        *   Press Enter after each `set` command.
    *   **Note**: These environment variables will only be set for the current Command Prompt session. If you close it and reopen, you'll need to set them again to use SSL. For permanent setup, search "edit environment variables for your account" in Windows.

*   **If you DO NOT have SSL certificates**:
    Don't worry! The application will automatically run using HTTP. You'll see a message in the console saying "SSL certificate or key not found... Running without SSL."

## Step 5: Initialize the Database

The application uses a database to store information. You need to create it the first time.

1.  **Make sure you are in the project folder in Command Prompt** and your virtual environment is active (`(venv)` is visible).
2.  The application is now set up to automatically create the database if it doesn't exist when you run it. So, this step might be handled automatically when you run the app.
3.  However, if you encounter errors about "no such table", you can explicitly create the database by typing:
    `flask initdb`
    And press Enter. You should see a message "Initialized the database."

## Step 6: Run the Application

You're ready to start the web application!

1.  **Make sure you are in the project folder in Command Prompt** and your virtual environment is active (`(venv)` is visible).
2.  Type the following command and press Enter:
    `python app.py`
3.  You will see some output in the Command Prompt. Look for lines like:
    *   `Attempting to start Flask with SSL...` (if you set up SSL) OR `SSL certificate or key not found... Running without SSL.`
    *   `* Running on https://0.0.0.0:5050/` (if SSL) OR `* Running on http://0.0.0.0:5050/` (if no SSL)
    *   `(Press CTRL+C to quit)`

4.  **Open the Application in your Web Browser**:
    *   Open your web browser (Chrome, Edge, Firefox).
    *   If SSL is active, go to: `https://localhost:5050` or `https://127.0.0.1:5050`
    *   If SSL is not active, go to: `http://localhost:5050` or `http://127.0.0.1:5050`
    *   Your browser might show a warning if you are using self-signed SSL certificates for HTTPS (e.g., "Your connection is not private"). You usually need to click "Advanced" and then "Proceed to localhost (unsafe)" or a similar option. This is okay for local development.

You should now see the Maintenance Tracker application!

## Step 7: Using the Application

*   **Submit Deficiency**: Click "Submit Deficiency" in the navigation bar to report a new issue.
    *   Your browser will ask for permission to use your camera if you try the "Scan QR Code" or "Use Camera" buttons. You need to allow this for those features to work.
*   **Dashboard**: The main page shows a list of all reported deficiencies.

## Stopping the Application

*   Go back to the Command Prompt window where the application is running.
*   Press `Ctrl + C` (hold down the Ctrl key and press C).
*   You might need to press it a couple of times.

## Running the Application Again Later

1.  Open Command Prompt.
2.  Navigate to your project folder (e.g., `cd Desktop\maint-tracker`).
3.  Activate the virtual environment: `venv\Scripts\activate`
4.  If using SSL, set the environment variables again (see Step 4).
5.  Run the app: `python app.py`

That's it! If you encounter any problems, carefully re-read the steps or ask for help, providing any error messages you see. 