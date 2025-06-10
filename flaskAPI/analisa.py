from ultralytics import YOLO

# Load model
model = YOLO("yolomodel/best.pt")

# Tampilkan ringkasan performa model
metrics = model.val(data='dataset-pothole-4/data.yaml')  # Akan menghasilkan mAP, precision, recall, dll.

# Print hasil utama
print(metrics)
