#!/usr/bin/env python3

import os
import sqlite3
from flask import Flask, render_template, request, redirect, url_for, jsonify, g
from PIL import Image
import base64
from io import BytesIO
# from pyzbar.pyzbar import decode # For QR code scanning - install if needed

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
app.config['DATABASE'] = 'maintenance.db'

# SSL Configuration - Replace with your actual cert and key paths or environment variables
SSL_CERT_PATH = os.environ.get('LOCALHOST_SSL_CRT') # Example: 'path/to/your/cert.pem'
SSL_KEY_PATH = os.environ.get('LOCALHOST_SSL_KEY')   # Example: 'path/to/your/key.pem'


def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(app.config['DATABASE'])
        db.row_factory = sqlite3.Row # Allows accessing columns by name
    return db

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()
    print("Initialized the database.")

@app.cli.command('initdb')
def initdb_command():
    """Initializes the database."""
    init_db()

# --- Routes ---

@app.route('/')
def index():
    """Dashboard view."""
    # Fetch deficiencies from DB
    # Add sorting/filtering logic later
    db = get_db()
    cur = db.execute("SELECT id, description, category, location, severity, reported_at, image_filename FROM deficiencies ORDER BY reported_at DESC")
    deficiencies = cur.fetchall()
    return render_template('dashboard.html', deficiencies=deficiencies)

@app.route('/submit', methods=['GET', 'POST'])
def submit_deficiency():
    """Deficiency submission form."""
    if request.method == 'POST':
        description = request.form['description']
        category = request.form['category']
        location = request.form['location']
        severity = request.form['severity']
        image_file = request.files.get('image')
        image_filename = None

        if image_file:
            # Option 1: Save image to a folder
            if not os.path.exists(app.config['UPLOAD_FOLDER']):
                os.makedirs(app.config['UPLOAD_FOLDER'])
            image_filename = image_file.filename # Consider more robust filename generation
            image_path = os.path.join(app.config['UPLOAD_FOLDER'], image_filename)
            
            # Compress and save image
            try:
                img = Image.open(image_file.stream)
                # Resize for web, adjust as needed
                img.thumbnail((800, 800)) 
                img.save(image_path, optimize=True, quality=85)
            except Exception as e:
                print(f"Error processing image: {e}")
                # Handle error, maybe return a message to the user

            # Option 2: Store as base64 in DB (not recommended for many/large images)
            # image_data = image_file.read()
            # compressed_image = compress_image_to_base64(image_data)


        db = get_db()
        db.execute(
            'INSERT INTO deficiencies (description, category, location, severity, image_filename) VALUES (?, ?, ?, ?, ?)',
            (description, category, location, severity, image_filename)
        )
        db.commit()
        return redirect(url_for('index')) # Or a 'success' page

    return render_template('submit_form.html')

# Helper function for image compression to base64 (if you choose that route)
# def compress_image_to_base64(image_data, max_size=(800, 800), quality=85):
#     img = Image.open(BytesIO(image_data))
#     img.thumbnail(max_size)
#     buffered = BytesIO()
#     img.save(buffered, format="JPEG", quality=quality, optimize=True)
#     img_str = base64.b64encode(buffered.getvalue()).decode('utf-8')
#     return img_str


if __name__ == '__main__':
    context = None
    if SSL_CERT_PATH and SSL_KEY_PATH and os.path.exists(SSL_CERT_PATH) and os.path.exists(SSL_KEY_PATH):
        context = (SSL_CERT_PATH, SSL_KEY_PATH)
        print(f"Attempting to start Flask with SSL using cert: {SSL_CERT_PATH} and key: {SSL_KEY_PATH}")
    else:
        print("SSL certificate or key not found or not configured. Running without SSL.")
        print(f"SSL_CERT_PATH: {SSL_CERT_PATH} (exists: {os.path.exists(SSL_CERT_PATH) if SSL_CERT_PATH else 'N/A'})")
        print(f"SSL_KEY_PATH: {SSL_KEY_PATH} (exists: {os.path.exists(SSL_KEY_PATH) if SSL_KEY_PATH else 'N/A'})")


    # Make sure to run `flask initdb` once to create the database schema
    if not os.path.exists(app.config['DATABASE']):
        print(f"Database not found at {app.config['DATABASE']}. Initializing it now.")
        # You might want to automatically call init_db() here for simplicity in development
        init_db() # Uncomment to auto-create DB if it doesn't exist on first run
    
    app.run(debug=True, host='0.0.0.0', port=5050, ssl_context=context) 