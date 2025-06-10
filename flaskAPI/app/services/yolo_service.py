from ultralytics import YOLO
import cv2
from PIL import Image
import numpy as np
import os
import uuid

model = YOLO('yolomodel/best.pt')

def predict_pothole(image_path):
    results = model(image_path)  # List of results (usually 1 item)
    predictions = []

    image = cv2.imread(image_path)

    for result in results:
        boxes = result.boxes
        for i in range(len(boxes)):
            bbox = boxes.xyxy[i].tolist()
            class_id = int(boxes.cls[i].item())
            confidence = float(boxes.conf[i].item())

            predictions.append({
                "bbox": bbox,
                "class_id": class_id,
                "confidence": confidence
            })

            # Draw bounding box
            x1, y1, x2, y2 = map(int, bbox)
            label = f"pothole ({confidence:.2f})"
            cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
            cv2.putText(image, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX,
                        0.5, (255, 0, 0), 2)

    # Save annotated image
    base, ext = os.path.splitext(image_path)
    annotated_path = f"{base}_annotated{ext}"
    cv2.imwrite(annotated_path, image)

    return predictions, annotated_path