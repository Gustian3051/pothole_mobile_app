from flask import Blueprint
from app.controllers.detection_controller import detection_pothole

detection_bp = Blueprint('detection_bp', __name__)

# Hubungkan fungsi controller ke endpoint /pothole
detection_bp.route('/pothole', methods=['POST'])(detection_pothole)
