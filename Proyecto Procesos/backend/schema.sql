-- Base de datos para Sistema de Gestión Eco-Vida
-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS eco_vida_db;
USE eco_vida_db;

-- Tabla de usuarios/asignados
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('administrador', 'vendedor', 'inventario', 'cliente') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tabla de categorías
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de tareas
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status ENUM('pendiente', 'en-progreso', 'completada', 'atrasada') NOT NULL DEFAULT 'pendiente',
    priority ENUM('baja', 'media', 'alta') NOT NULL DEFAULT 'media',
    category_id INT,
    assignee_id INT,
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    created_by INT,
    
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (assignee_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_due_date (due_date),
    INDEX idx_assignee (assignee_id),
    INDEX idx_category (category_id)
);

-- Tabla de comentarios/notas de tareas
CREATE TABLE task_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabla de historial de cambios
CREATE TABLE task_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    field_name VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insertar categorías predefinidas
INSERT INTO categories (name, description) VALUES
('productos', 'Gestión de productos naturales'),
('inventario', 'Control de inventario y stock'),
('ventas', 'Procesos de venta y comercialización'),
('clientes', 'Gestión de clientes y relaciones'),
('proveedores', 'Gestión de proveedores y suministros'),
('reportes', 'Generación de reportes y análisis'),
('sistema', 'Mantenimiento y configuración del sistema');

-- Insertar usuarios predefinidos
INSERT INTO users (username, email, password, role, full_name) VALUES
('admin', 'admin@ecovida.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBdXzogFiqxHWW', 'administrador', 'Administrador Principal'),
('vendedor1', 'vendedor1@ecovida.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBdXzogFiqxHWW', 'vendedor', 'Vendedor Principal'),
('inventario1', 'inventario1@ecovida.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBdXzogFiqxHWW', 'inventario', 'Encargado de Inventario'),
('cliente1', 'cliente1@ecovida.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBdXzogFiqxHWW', 'cliente', 'Cliente VIP');

-- Insertar tareas de ejemplo
INSERT INTO tasks (title, description, status, priority, category_id, assignee_id, due_date, created_by) VALUES
('Revisar inventario de productos orgánicos', 'Verificar stock de productos orgánicos y actualizar sistema', 'pendiente', 'alta', 2, 3, '2025-07-20', 1),
('Contactar proveedor de aceites esenciales', 'Negociar precios y disponibilidad para próximo pedido', 'en-progreso', 'media', 5, 2, '2025-07-18', 1),
('Preparar reporte mensual de ventas', 'Generar reporte completo de ventas del mes anterior', 'pendiente', 'alta', 6, 1, '2025-07-15', 1),
('Actualizar catálogo de productos', 'Añadir nuevos productos naturales al catálogo', 'completada', 'media', 1, 2, '2025-07-10', 1);

-- Crear vista para tareas con información completa
CREATE VIEW task_details AS
SELECT 
    t.id,
    t.title,
    t.description,
    t.status,
    t.priority,
    c.name AS category_name,
    u.full_name AS assignee_name,
    u.role AS assignee_role,
    t.due_date,
    t.created_at,
    t.updated_at,
    t.completed_at,
    creator.full_name AS created_by_name,
    CASE 
        WHEN t.due_date < CURDATE() AND t.status != 'completada' THEN 'atrasada'
        ELSE t.status
    END AS effective_status
FROM tasks t
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN users u ON t.assignee_id = u.id
LEFT JOIN users creator ON t.created_by = creator.id;

-- Procedimiento para actualizar estado de tareas atrasadas
DELIMITER //
CREATE PROCEDURE UpdateOverdueTasks()
BEGIN
    UPDATE tasks 
    SET status = 'atrasada' 
    WHERE due_date < CURDATE() 
    AND status != 'completada';
END//
DELIMITER ;

-- Función para obtener estadísticas de tareas
DELIMITER //
CREATE FUNCTION GetTaskStats(stat_type VARCHAR(20)) RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE result INT DEFAULT 0;
    
    CASE stat_type
        WHEN 'total' THEN
            SELECT COUNT(*) INTO result FROM tasks;
        WHEN 'completed' THEN
            SELECT COUNT(*) INTO result FROM tasks WHERE status = 'completada';
        WHEN 'pending' THEN
            SELECT COUNT(*) INTO result FROM tasks WHERE status = 'pendiente';
        WHEN 'overdue' THEN
            SELECT COUNT(*) INTO result FROM tasks WHERE due_date < CURDATE() AND status != 'completada';
        WHEN 'in_progress' THEN
            SELECT COUNT(*) INTO result FROM tasks WHERE status = 'en-progreso';
    END CASE;
    
    RETURN result;
END//
DELIMITER ;

-- Trigger para registrar cambios en el historial
DELIMITER //
CREATE TRIGGER task_history_trigger
AFTER UPDATE ON tasks
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO task_history (task_id, user_id, field_name, old_value, new_value)
        VALUES (NEW.id, NEW.created_by, 'status', OLD.status, NEW.status);
    END IF;
    
    IF OLD.priority != NEW.priority THEN
        INSERT INTO task_history (task_id, user_id, field_name, old_value, new_value)
        VALUES (NEW.id, NEW.created_by, 'priority', OLD.priority, NEW.priority);
    END IF;
    
    IF NEW.status = 'completada' AND OLD.status != 'completada' THEN
        UPDATE tasks SET completed_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END IF;
END//
DELIMITER ;

-- Índices adicionales para mejorar el rendimiento
CREATE INDEX idx_tasks_created_at ON tasks(created_at);
CREATE INDEX idx_tasks_updated_at ON tasks(updated_at);
CREATE INDEX idx_effective_status ON tasks(status, due_date);

-- Crear usuario para la aplicación
CREATE USER 'ecovida_app'@'localhost' IDENTIFIED BY 'ecovida_secure_password_2025';
GRANT SELECT, INSERT, UPDATE, DELETE ON eco_vida_db.* TO 'ecovida_app'@'localhost';
FLUSH PRIVILEGES;