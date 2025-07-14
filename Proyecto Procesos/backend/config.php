# config.py - Configuración para Sistema Eco-Vida
import os
from datetime import timedelta
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

class Config:
    """Configuración base"""
    
    # Configuración de base de datos
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = int(os.getenv('DB_PORT', 3306))
    DB_NAME = os.getenv('DB_NAME', 'eco_vida_db')
    DB_USER = os.getenv('DB_USER', 'ecovida_app')
    DB_PASSWORD = os.getenv('DB_PASSWORD', 'ecovida_secure_password_2025')
    
    # URL de conexión a la base de datos
    DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    
    # Configuración de la aplicación
    SECRET_KEY = os.getenv('SECRET_KEY', 'ecovida-secret-key-2025-change-in-production')
    DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'
    
    # Configuración de JWT
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'jwt-secret-key-ecovida-2025')
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=int(os.getenv('JWT_ACCESS_TOKEN_EXPIRES', 24)))
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(days=int(os.getenv('JWT_REFRESH_TOKEN_EXPIRES', 30)))
    
    # Configuración de CORS
    CORS_ORIGINS = os.getenv('CORS_ORIGINS', '*').split(',')
    
    # Configuración de la aplicación
    API_VERSION = 'v1'
    API_PREFIX = f'/api/{API_VERSION}'
    
    # Configuración de paginación
    DEFAULT_PAGE_SIZE = int(os.getenv('DEFAULT_PAGE_SIZE', 10))
    MAX_PAGE_SIZE = int(os.getenv('MAX_PAGE_SIZE', 100))
    
    # Configuración de archivos
    UPLOAD_FOLDER = os.getenv('UPLOAD_FOLDER', 'uploads')
    MAX_CONTENT_LENGTH = int(os.getenv('MAX_CONTENT_LENGTH', 16 * 1024 * 1024))  # 16MB
    
    # Configuración de logging
    LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
    LOG_FILE = os.getenv('LOG_FILE', 'ecovida.log')
    
    # Configuración de caché
    CACHE_TYPE = os.getenv('CACHE_TYPE', 'simple')
    CACHE_DEFAULT_TIMEOUT = int(os.getenv('CACHE_DEFAULT_TIMEOUT', 300))
    
    # Configuración de email (para notificaciones)
    MAIL_SERVER = os.getenv('MAIL_SERVER', 'smtp.gmail.com')
    MAIL_PORT = int(os.getenv('MAIL_PORT', 587))
    MAIL_USE_TLS = os.getenv('MAIL_USE_TLS', 'True').lower() == 'true'
    MAIL_USERNAME = os.getenv('MAIL_USERNAME')
    MAIL_PASSWORD = os.getenv('MAIL_PASSWORD')
    MAIL_DEFAULT_SENDER = os.getenv('MAIL_DEFAULT_SENDER', 'noreply@ecovida.com')
    
    # Configuración de tareas
    TASK_STATUSES = ['pendiente', 'en-progreso', 'completada', 'atrasada']
    TASK_PRIORITIES = ['baja', 'media', 'alta']
    USER_ROLES = ['administrador', 'vendedor', 'inventario', 'cliente']
    
    # Configuración de categorías
    TASK_CATEGORIES = {
        'productos': 'Gestión de Productos',
        'inventario': 'Inventario',
        'ventas': 'Ventas',
        'clientes': 'Clientes',
        'proveedores': 'Proveedores',
        'reportes': 'Reportes',
        'sistema': 'Sistema'
    }
    
    # Configuración de exportación
    EXPORT_FORMATS = ['csv', 'xlsx', 'pdf']
    EXPORT_FOLDER = os.getenv('EXPORT_FOLDER', 'exports')
    
    # Configuración de seguridad
    PASSWORD_MIN_LENGTH = int(os.getenv('PASSWORD_MIN_LENGTH', 8))
    PASSWORD_REQUIRE_UPPERCASE = os.getenv('PASSWORD_REQUIRE_UPPERCASE', 'True').lower() == 'true'
    PASSWORD_REQUIRE_LOWERCASE = os.getenv('PASSWORD_REQUIRE_LOWERCASE', 'True').lower() == 'true'
    PASSWORD_REQUIRE_DIGITS = os.getenv('PASSWORD_REQUIRE_DIGITS', 'True').lower() == 'true'
    PASSWORD_REQUIRE_SPECIAL = os.getenv('PASSWORD_REQUIRE_SPECIAL', 'True').lower() == 'true'
    
    # Configuración de rate limiting
    RATE_LIMIT_ENABLED = os.getenv('RATE_LIMIT_ENABLED', 'True').lower() == 'true'
    RATE_LIMIT_DEFAULT = os.getenv('RATE_LIMIT_DEFAULT', '100 per hour')
    RATE_LIMIT_LOGIN = os.getenv('RATE_LIMIT_LOGIN', '5 per minute')
    
    # Configuración de backup
    BACKUP_ENABLED = os.getenv('BACKUP_ENABLED', 'True').lower() == 'true'
    BACKUP_SCHEDULE = os.getenv('BACKUP_SCHEDULE', '0 2 * * *')  # Diario a las 2 AM
    BACKUP_RETENTION_DAYS = int(os.getenv('BACKUP_RETENTION_DAYS', 30))
    
    # Configuración de monitoreo
    HEALTH_CHECK_ENABLED = os.getenv('HEALTH_CHECK_ENABLED', 'True').lower() == 'true'
    METRICS_ENABLED = os.getenv('METRICS_ENABLED', 'True').lower() == 'true'
    
    @staticmethod
    def validate_config():
        """Valida la configuración y devuelve errores si los hay"""
        errors = []
        
        # Validar configuración de base de datos
        required_db_fields = ['DB_HOST', 'DB_NAME', 'DB_USER', 'DB_PASSWORD']
        for field in required_db_fields:
            if not getattr(Config, field):
                errors.append(f"Campo de base de datos requerido: {field}")
        
        # Validar configuración de seguridad
        if len(Config.SECRET_KEY) < 32:
            errors.append("SECRET_KEY debe tener al menos 32 caracteres")
        
        if len(Config.JWT_SECRET_KEY) < 32:
            errors.append("JWT_SECRET_KEY debe tener al menos 32 caracteres")
        
        # Validar configuración de archivos
        if not os.path.exists(Config.UPLOAD_FOLDER):
            try:
                os.makedirs(Config.UPLOAD_FOLDER)
            except Exception as e:
                errors.append(f"No se puede crear el directorio de uploads: {e}")
        
        if not os.path.exists(Config.EXPORT_FOLDER):
            try:
                os.makedirs(Config.EXPORT_FOLDER)
            except Exception as e:
                errors.append(f"No se puede crear el directorio de exports: {e}")
        
        return errors

class DevelopmentConfig(Config):
    """Configuración para desarrollo"""
    DEBUG = True
    
    # Base de datos de desarrollo
    DB_NAME = 'eco_vida_dev'
    DATABASE_URL = f"mysql+pymysql://{Config.DB_USER}:{Config.DB_PASSWORD}@{Config.DB_HOST}:{Config.DB_PORT}/{DB_NAME}"
    
    # Configuración de logging más detallada
    LOG_LEVEL = 'DEBUG'
    
    # Configuración de caché simple para desarrollo
    CACHE_TYPE = 'simple'
    CACHE_DEFAULT_TIMEOUT = 60
    
    # Configuración de CORS más permisiva
    CORS_ORIGINS = ['http://localhost:3000', 'http://localhost:8080', 'http://127.0.0.1:3000']

class ProductionConfig(Config):
    """Configuración para producción"""
    DEBUG = False
    
    # Configuración de seguridad más estricta
    SECRET_KEY = os.getenv('SECRET_KEY')
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')
    
    # Configuración de base de datos de producción
    DATABASE_URL = os.getenv('DATABASE_URL')
    
    # Configuración de logging para producción
    LOG_LEVEL = 'WARNING'
    
    # Configuración de caché más robusta
    CACHE_TYPE = 'redis'
    CACHE_REDIS_URL = os.getenv('REDIS_URL', 'redis://localhost:6379')
    
    # Configuración de CORS más restrictiva
    CORS_ORIGINS = os.getenv('CORS_ORIGINS', '').split(',')
    
    # Configuración de SSL
    SSL_REDIRECT = True
    SSL_DISABLE = False

class TestingConfig(Config):
    """Configuración para testing"""
    TESTING = True
    DEBUG = True
    
    # Base de datos de testing
    DB_NAME = 'eco_vida_test'
    DATABASE_URL = f"mysql+pymysql://{Config.DB_USER}:{Config.DB_PASSWORD}@{Config.DB_HOST}:{Config.DB_PORT}/{DB_NAME}"
    
    # Configuración de JWT para testing
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(minutes=15)
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(hours=1)
    
    # Desactivar rate limiting para testing
    RATE_LIMIT_ENABLED = False
    
    # Configuración de caché en memoria para testing
    CACHE_TYPE = 'null'

# Configuración por defecto basada en el entorno
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}

def get_config():
    """Obtiene la configuración basada en la variable de entorno"""
    env = os.getenv('FLASK_ENV', 'development')
    return config.get(env, config['default'])

# Configuración específica para Eco-Vida
class EcoVidaConfig:
    """Configuración específica del dominio de Eco-Vida"""
    
    # Configuración de productos naturales
    PRODUCT_CATEGORIES = [
        'aceites_esenciales',
        'suplementos_naturales',
        'cosmeticos_naturales',
        'alimentos_organicos',
        'plantas_medicinales',
        'productos_apicolas',
        'productos_herbales'
    ]
    
    # Configuración de inventario
    INVENTORY_THRESHOLDS = {
        'critico': 5,
        'bajo': 20,
        'medio': 50,
        'alto': 100
    }
    
    # Configuración de notificaciones
    NOTIFICATION_TYPES = [
        'tarea_creada',
        'tarea_asignada',
        'tarea_completada',
        'tarea_atrasada',
        'inventario_bajo',
        'nuevo_pedido',
        'pago_recibido'
    ]
    
    # Configuración de reportes
    REPORT_TYPES = [
        'ventas_mensuales',
        'inventario_actual',
        'tareas_pendientes',
        'rendimiento_empleados',
        'productos_populares',
        'clientes_activos'
    ]
    
    # Configuración de integración
    INTEGRATION_APIS = {
        'payment_gateway': os.getenv('PAYMENT_GATEWAY_URL'),
        'shipping_service': os.getenv('SHIPPING_SERVICE_URL'),
        'accounting_system': os.getenv('ACCOUNTING_SYSTEM_URL')
    }
    
    # Configuración de WhatsApp/SMS
    WHATSAPP_API_KEY = os.getenv('WHATSAPP_API_KEY')
    SMS_API_KEY = os.getenv('SMS_API_KEY')
    
    # Configuración de horarios de negocio
    BUSINESS_HOURS = {
        'monday': {'start': '08:00', 'end': '18:00'},
        'tuesday': {'start': '08:00', 'end': '18:00'},
        'wednesday': {'start': '08:00', 'end': '18:00'},
        'thursday': {'start': '08:00', 'end': '18:00'},
        'friday': {'start': '08:00', 'end': '18:00'},
        'saturday': {'start': '09:00', 'end': '16:00'},
        'sunday': {'start': '10:00', 'end': '14:00'}
    }
    
    # Configuración de zonas horarias
    TIMEZONE = os.getenv('TIMEZONE', 'America/Guayaquil')  # Ecuador
    
    # Configuración de monedas
    DEFAULT_CURRENCY = 'USD'
    SUPPORTED_CURRENCIES = ['USD', 'EUR', 'COP', 'PEN']
    
    # Configuración de idiomas
    DEFAULT_LANGUAGE = 'es'
    SUPPORTED_LANGUAGES = ['es', 'en']

# Validar configuración al importar
if __name__ == '__main__':
    config_errors = Config.validate_config()
    if config_errors:
        print("Errores de configuración:")
        for error in config_errors:
            print(f"- {error}")
    else:
        print("Configuración válida")