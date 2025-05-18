DROP TABLE IF EXISTS deficiencies;

CREATE TABLE deficiencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL,
    category TEXT NOT NULL, -- e.g., Plumbing, Electrical, HVAC, Structural, Safety
    location TEXT NOT NULL, -- e.g., Room 101, North Wing, Main Hallway
    severity TEXT NOT NULL, -- e.g., Low, Medium, High, Critical
    reported_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL DEFAULT 'Open', -- e.g., Open, In Progress, Resolved, Closed
    image_filename TEXT, -- Filename if image is stored in a folder
    -- image_data TEXT, -- Uncomment if storing base64 encoded image directly in DB
    notes TEXT -- For additional notes or updates
); 