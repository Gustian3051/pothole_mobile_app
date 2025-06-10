from flask import Flask
from flask_cors import CORS
from app.models.database import mysql
from app.routes.detection_routes import detection_bp

def create_app():
    app = Flask(__name__)
    app.config['UPLOAD_FOLDER'] = 'static/uploads'
    
    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'root'
    app.config['MYSQL_PASSWORD'] = 'waradul123'
    app.config['MYSQL_DB'] = 'pothole_db'

    mysql.init_app(app)
    CORS(app)
    
    app.register_blueprint(detection_bp, url_prefix='/api') 
    
    return app