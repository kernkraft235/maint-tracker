# Maintenance Tracker Web App - Setup Guide for Windows

This guide will help you set up and run the Maintenance Tracker web application on your Windows computer. No prior technical experience is needed, just follow these steps carefully!

## Option 1: Quick Setup (Recommended - Using Batch Scripts)

This is the easiest way to get started. You'll use two script files: `setup.bat` (run once) and `run_app.bat` (run each time you want to use the app).

**If you don't have `setup.bat` and `run_app.bat` files:**
*   You can create them yourself. Open Notepad, copy the content for each script (provided by your developer or in the sections below if this README is part of the source code), paste it into Notepad, and save the files as `setup.bat` and `run_app.bat` respectively. Make sure when you save, the "Save as type" is set to "All Files (*.*)" so it doesn't save as `setup.bat.txt`.
*   Place these two `.bat` files in the main `maint-tracker` project folder (the same folder that contains `app.py` and `requirements.txt`).

### 1. Run the Setup Script (Run this only ONCE)

   The `setup.bat` script will:
   *   Check if Python 3 is installed and attempt to install it using `winget` if it's missing (this requires an internet connection and may need administrator approval).
   *   Create an isolated Python environment for the application.
   *   Install all the necessary application dependencies.
   *   Initialize the application's database.

   **To run `setup.bat`:**
   1.  Navigate to your `maint-tracker` project folder in File Explorer.
   2.  Double-click the `setup.bat` file.
   3.  A command prompt window will open and show the progress. Read any messages carefully.
   4.  If Python needs to be installed via `winget`, the script might instruct you to re-run `setup.bat` after the Python installer closes. Please follow those instructions.
   5.  Wait for the script to finish. It will say "Setup Complete!" and pause. You can then press any key to close the window.

### 2. Run the Application Script (Run this EACH TIME you use the app)

   The `run_app.bat` script will:
   *   Activate the Python environment.
   *   Allow you to (optionally) specify paths to SSL certificate files if you want to use a secure HTTPS connection.
   *   Start the Maintenance Tracker web application.

   **To run `run_app.bat`:**
   1.  Navigate to your `maint-tracker` project folder.
   2.  Double-click the `run_app.bat` file.
   3.  A command prompt window will open.
       *   **SSL Configuration (Optional):** The script will pause and show instructions if you want to set paths for SSL certificate and key files. If you have these files and want to use them:
           *   Edit the `run_app.bat` file itself (right-click -> Edit or Open with Notepad).
           *   Find the lines:
             ```batch
             set "LOCALHOST_SSL_CRT="
             set "LOCALHOST_SSL_KEY="
             ```
           *   Change them to the full paths of your certificate and key files, for example:
             ```batch
             set "LOCALHOST_SSL_CRT=C:\MyCerts\localhost.crt"
             set "LOCALHOST_SSL_KEY=C:\MyCerts\localhost.key"
             ```
           *   Save the `run_app.bat` file and then run it again.
       *   If you don't set SSL paths, the application will run using HTTP, which is fine for local use.
   4.  The script will then start the application. You will see output in the command prompt, including a line like:
       `* Running on https://localhost:5050/` (if SSL is used) or `* Running on http://localhost:5050/`.

   5.  **Open the Application in your Web Browser**:
       *   Open your web browser (Chrome, Edge, Firefox).
       *   If SSL is active, go to: `https://localhost:5050` (or `https://127.0.0.1:5050`)
       *   If SSL is not active, go to: `http://localhost:5050` (or `http://127.0.0.1:5050`)
       *   Your browser might show a warning if you are using self-signed SSL certificates (e.g., "Your connection is not private"). You usually need to click "Advanced" and then "Proceed to localhost (unsafe)".

   You should now see the Maintenance Tracker application!

### Stopping the Application
*   Go back to the command prompt window where the application is running (the one opened by `run_app.bat`).
*   Press `Ctrl + C` (hold down the Ctrl key and press C). You might need to press it a couple of times.
*   The script will say "Application stopped." and pause. Press any key to close it.

---

## Option 2: Manual Setup Steps

If you prefer to run commands manually or if the batch scripts don't work for some reason, follow these detailed steps.

### Step 1: Install Python (if not already installed)

Python is the programming language this application is built with.

1.  **Check if Python is installed & Install using winget (Recommended for newer Windows)**:
    *   Open Command Prompt (Start menu, type `cmd`, press Enter).
    *   Type `python --version`. If you see a version like `Python 3.x.x`, you have Python.
    *   If not, you can try installing with `winget` (a Windows package manager). Type:
        ```bash
        winget install -e --id Python.Python.3 --accept-package-agreements --accept-source-agreements
        ```
    *   If `winget` installation fails or you don't have `winget`, proceed to manual download.

2.  **Manual Download & Install**:
    *   Open your web browser and go to: [python.org](https://www.python.org/)
    *   Hover over "Downloads" and click the button for the latest Python for Windows.
    *   Run the downloaded installer.
    *   **VERY IMPORTANT**: On the first screen, check the box **"Add Python 3.x to PATH"**.
    *   Click "Install Now".

### Step 2: Get the Application Files

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

### Step 3: Install Application Dependencies (Manual)

1.  **Open Command Prompt in the Project Folder**:
    *   Go to the `maint-tracker` folder.
    *   In File Explorer's address bar, type `cmd` and press Enter.

2.  **Create and Activate Virtual Environment**:
    *   In Command Prompt, type these commands one by one, pressing Enter after each:
        ```bash
        python -m venv venv
        venv\Scripts\activate
        ```
    *   You should see `(venv)` at the start of your prompt.

3.  **Install Packages**:
    *   With `(venv)` active, type and run:
        ```bash
        pip install -r requirements.txt
        ```

### Step 4: SSL Certificates (Manual - Optional)

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

### Step 5: Initialize the Database (Manual)

1.  With `(venv)` active in Command Prompt (in project folder):
    ```bash
    flask initdb
    ```
    You should see "Initialized the database."

### Step 6: Run the Application (Manual)

1.  With `(venv)` active in Command Prompt (in project folder):
    ```bash
    python app.py
    ```
2.  Look for `* Running on ...` and open the URL (`http://localhost:5050` or `https://localhost:5050`) in your browser.

### Using and Stopping the Application (Manual)

*   **Submit Deficiency**: Click "Submit Deficiency" in the navigation bar to report a new issue.
    *   Your browser will ask for permission to use your camera if you try the "Scan QR Code" or "Use Camera" buttons. You need to allow this for those features to work.
*   **Dashboard**: The main page shows a list of all reported deficiencies.

**Stopping the Application**:

*   Go back to the Command Prompt window where the application is running.
*   Press `Ctrl + C` (hold down the Ctrl key and press C).
*   You might need to press it a couple of times.

**Running the Application Again Later (Manual)**:

1.  Open Command Prompt.
2.  Navigate to your project folder (e.g., `cd Desktop\maint-tracker`).
3.  Activate the virtual environment: `venv\Scripts\activate`
4.  If using SSL, set the environment variables again (see Step 4).
5.  Run the app: `python app.py`

That's it! If you encounter any problems, carefully re-read the steps or ask for help, providing any error messages you see. 