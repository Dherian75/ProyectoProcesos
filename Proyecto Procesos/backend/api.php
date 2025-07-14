
# app.py - API Principal para Sistema Eco-Vida
from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_caching import Cache
import pymysql
import bcrypt
import pandas as pd
import logging
from datetime import datetime, timedelta
from functools import wraps
import json
import os
import io
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from config import get_config, EcoVidaConfig
import traceback

# Configurar logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Inicializar Flask
app = Flask(__name__)
config = get_config()
app.config.from_object(config)

# Configurar extensiones
cors = CORS(app, origins=config.CORS_ORIGINS)
jwt = JWTManager(app)
cache = Cache(app)
limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=[config.RATE_LIMIT_DEFAULT] if config.RATE_LIMIT_ENABLED else []
)

# Configuración de base de datos
def get_db_connection():
    """Obtiene conexión a la base de datos"""
    return pymysql.connect(
        host=config.DB_HOST,
        port=config.DB_PORT,
        user=config.DB_USER,
        password=config.DB_PASSWORD,
        database=config.DB_NAME,
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=True
    )

# Decoradores
def handle_db_errors(f):
    """Maneja errores de base de datos"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        try:
            return f(*args, **kwargs)
        except pymysql.Error as e:
            logger.error(f"Error de base de datos: {e}")
            return jsonify({'error': 'Error de base de datos'}), 500
        except Exception as e:
            logger.error(f"Error inesperado: {e}")
            logger.error(traceback.format_exc())
            return jsonify({'error': 'Error interno del servidor'}), 500
    return decorated_function

def validate_json(required_fields=None):
    """Valida JSON de entrada"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not request.is_json:
                return jsonify({'error': 'Content-Type debe ser application/json'}), 400
            
            data = request.get_json()
            if not data:
                return jsonify({'error': 'JSON inválido'}), 400
            
            if required_fields:
                missing_fields = [field for field in required_fields if field not in data]
                if missing_fields:
                    return jsonify({'error': f'Campos requeridos: {", ".join(missing_fields)}'}), 400
            
            return f(*args, **kwargs)
        return decorated_function
    return decorator

# Rutas de autenticación
@app.route('/api/auth/login', methods=['POST'])
@limiter.limit(config.RATE_LIMIT_LOGIN if config.RATE_LIMIT_ENABLED else "1000 per hour")
@validate_json(['username', 'password'])
@handle_db_errors
def login():
    """Autenticación de usuario"""
    data = request.get_json()
    username = data['username']
    password = data['password']
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT id, username, password, role, full_name, is_active FROM users WHERE username = %s",
                (username,)
            )
            user = cursor.fetchone()
            
            if not user or not user['is_active']:
                return jsonify({'error': 'Credenciales inválidas'}), 401
            
            if not bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
                return jsonify({'error': 'Credenciales inválidas'}), 401
            
            # Crear token JWT
            access_token = create_access_token(
                identity=user['id'],
                additional_claims={'role': user['role'], 'username': user['username']}
            )
            
            return jsonify({
                'access_token': access_token,
                'user': {
                    'id': user['id'],
                    'username': user['username'],
                    'role': user['role'],
                    'full_name': user['full_name']
                }
            })
    finally:
        conn.close()

@app.route('/api/auth/register', methods=['POST'])
@validate_json(['username', 'email', 'password', 'role', 'full_name'])
@handle_db_errors
def register():
    """Registro de nuevo usuario"""
    data = request.get_json()
    
    # Validar rol
    if data['role'] not in config.USER_ROLES:
        return jsonify({'error': 'Rol inválido'}), 400
    
    # Hash de la contraseña
    password_hash = bcrypt.hashpw(data['password'].encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                """INSERT INTO users (username, email, password, role, full_name) 
                   VALUES (%s, %s, %s, %s, %s)""",
                (data['username'], data['email'], password_hash, data['role'], data['full_name'])
            )
            user_id = cursor.lastrowid
            
            return jsonify({
                'id': user_id,
                'username': data['username'],
                'role': data['role'],
                '
