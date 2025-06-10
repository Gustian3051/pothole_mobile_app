import os 
import uuid
from flask import request, jsonify, current_app
from app.services.yolo_service import predict_pothole
from app.models.database import mysql

def detection_pothole():
    if 'image' not in request.files:
        return jsonify({'message': 'No image uploaded'}), 400

    image = request.files['image']
    filename = f"{uuid.uuid4().hex}.jpg"
    path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    image.save(path)

    predictions, annotated_path = predict_pothole(path)

    # Jika tidak ada deteksi, langsung kembalikan tanpa menyimpan
    # if not predictions:
    #     return jsonify({
    #         'filename': filename,
    #         'detection': [],
    #         'message': 'No pothole detected. Image not saved to database.'
    #     }), 200

    # Simpan ke database karena ada deteksi
    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO potholes (filename, num_potholes) VALUES (%s, %s)", (filename, len(predictions)))
    pothole_id = cur.lastrowid

    for pred in predictions:
        bbox = pred['bbox']
        class_id = pred['class_id']
        confidence = pred['confidence']
        cur.execute("""
            INSERT INTO pothole_detections 
            (pothole_id, x_min, y_min, x_max, y_max, class_id, confidence) 
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (pothole_id, bbox[0], bbox[1], bbox[2], bbox[3], class_id, confidence))

    mysql.connection.commit()

    return jsonify({
        'filename': filename,
        'annotated_filename': os.path.basename(annotated_path),
        'detection': predictions
    }), 200
