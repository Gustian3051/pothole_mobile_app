CREATE TABLE potholes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    num_potholes INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pothole_detections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pothole_id INT,  
    x_min FLOAT,
    y_min FLOAT,
    x_max FLOAT,
    y_max FLOAT,
    class_id INT,
    confidence FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);