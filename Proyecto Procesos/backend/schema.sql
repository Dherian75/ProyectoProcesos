-- =============================================
-- SISTEMA DE GESTIÓN ECO-VIDA - BASE DE DATOS
-- =============================================

-- Crear la base de datos
CREATE DATABASE EcoVidaDB;
GO

USE EcoVidaDB;
GO

-- =============================================
-- TABLA: Usuarios del Sistema
-- =============================================
CREATE TABLE Usuarios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    rol NVARCHAR(20) NOT NULL CHECK (rol IN ('administrador', 'vendedor', 'inventario', 'cliente')),
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    fecha_actualizacion DATETIME2 DEFAULT GETDATE()
);

-- =============================================
-- TABLA: Categorías de Productos
-- =============================================
CREATE TABLE Categorias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(500),
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME2 DEFAULT GETDATE()
);

-- =============================================
-- TABLA: Productos Naturales
-- =============================================
CREATE TABLE Productos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(1000),
    categoria_id INT,
    precio DECIMAL(10,2) NOT NULL,
    stock_actual INT DEFAULT 0,
    stock_minimo INT DEFAULT 0,
    unidad_medida NVARCHAR(20) DEFAULT 'unidad',
    codigo_barras NVARCHAR(50),
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    fecha_actualizacion DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (categoria_id) REFERENCES Categorias(id)
);

-- =============================================
-- TABLA: Proveedores
-- =============================================
CREATE TABLE Proveedores (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL,
    contacto NVARCHAR(100),
    telefono NVARCHAR(20),
    email NVARCHAR(100),
    direccion NVARCHAR(300),
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    fecha_actualizacion DATETIME2 DEFAULT GETDATE()
);

-- =============================================
-- TABLA: Clientes
-- =============================================
CREATE TABLE Clientes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL,
    telefono NVARCHAR(20),
    email NVARCHAR(100),
    direccion NVARCHAR(300),
    cedula NVARCHAR(20),
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    fecha_actualizacion DATETIME2 DEFAULT GETDATE()
);

-- =============================================
-- TABLA: Ventas
-- =============================================
CREATE TABLE Ventas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT,
    usuario_id INT NOT NULL,
    fecha_venta DATETIME2 DEFAULT GETDATE(),
    subtotal DECIMAL(10,2) NOT NULL,
    impuesto DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    estado NVARCHAR(20) DEFAULT 'completada' CHECK (estado IN ('completada', 'cancelada', 'pendiente')),
    metodo_pago NVARCHAR(20) DEFAULT 'efectivo',
    notas NVARCHAR(500),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- =============================================
-- TABLA: Detalles de Venta
-- =============================================
CREATE TABLE DetallesVenta (
    id INT IDENTITY(1,1) PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES Ventas(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES Productos(id)
);

-- =============================================
-- TABLA: Movimientos de Inventario
-- =============================================
CREATE TABLE MovimientosInventario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    producto_id INT NOT NULL,
    tipo_movimiento NVARCHAR(20) NOT NULL CHECK (tipo_movimiento IN ('entrada', 'salida', 'ajuste')),
    cantidad INT NOT NULL,
    stock_anterior INT NOT NULL,
    stock_nuevo INT NOT NULL,
    motivo NVARCHAR(200),
    usuario_id INT NOT NULL,
    fecha_movimiento DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (producto_id) REFERENCES Productos(id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- =============================================
-- TABLA: Tareas (Principal del Sistema)
-- =============================================
CREATE TABLE Tareas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(1000),
    estado NVARCHAR(20) NOT NULL DEFAULT 'pendiente'
        CHECK (estado IN ('pendiente', 'en-progreso', 'completada', 'atrasada')),
    prioridad NVARCHAR(10) NOT NULL DEFAULT 'media'
        CHECK (prioridad IN ('baja', 'media', 'alta')),
    categoria NVARCHAR(20) NOT NULL DEFAULT 'general'
        CHECK (categoria IN ('productos', 'inventario', 'ventas', 'clientes', 'proveedores', 'reportes', 'sistema')),
    asignado_a NVARCHAR(20) NOT NULL DEFAULT 'administrador'
        CHECK (asignado_a IN ('administrador', 'vendedor', 'inventario', 'cliente')),
    usuario_creador_id INT,
    fecha_vencimiento DATE,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    fecha_actualizacion DATETIME2 DEFAULT GETDATE(),
    fecha_completado DATETIME2 NULL,
    FOREIGN KEY (usuario_creador_id) REFERENCES Usuarios(id)
);

-- =============================================
-- TABLA: Reportes Generados
-- =============================================
CREATE TABLE Reportes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    tipo_reporte NVARCHAR(50) NOT NULL,
    parametros NVARCHAR(1000),
    fecha_generacion DATETIME2 DEFAULT GETDATE(),
    usuario_id INT NOT NULL,
    archivo_ruta NVARCHAR(300),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- =============================================
-- TABLA: Configuraciones del Sistema
-- =============================================
CREATE TABLE Configuraciones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    clave NVARCHAR(100) NOT NULL UNIQUE,
    valor NVARCHAR(500),
    descripcion NVARCHAR(300),
    fecha_actualizacion DATETIME2 DEFAULT GETDATE()
);

-- =============================================
-- ÍNDICES PARA OPTIMIZAR CONSULTAS
-- =============================================

-- Índices para la tabla Tareas
CREATE INDEX IX_Tareas_Estado ON Tareas(estado);
CREATE INDEX IX_Tareas_Prioridad ON Tareas(prioridad);
CREATE INDEX IX_Tareas_Categoria ON Tareas(categoria);
CREATE INDEX IX_Tareas_AsignadoA ON Tareas(asignado_a);
CREATE INDEX IX_Tareas_FechaVencimiento ON Tareas(fecha_vencimiento);

-- Índices para la tabla Productos
CREATE INDEX IX_Productos_Categoria ON Productos(categoria_id);
CREATE INDEX IX_Productos_Activo ON Productos(activo);

-- Índices para la tabla Ventas
CREATE INDEX IX_Ventas_Cliente ON Ventas(cliente_id);
CREATE INDEX IX_Ventas_Usuario ON Ventas(usuario_id);
CREATE INDEX IX_Ventas_Fecha ON Ventas(fecha_venta);

-- Índices para la tabla MovimientosInventario
CREATE INDEX IX_MovimientosInventario_Producto ON MovimientosInventario(producto_id);
CREATE INDEX IX_MovimientosInventario_Fecha ON MovimientosInventario(fecha_movimiento);

-- =============================================
-- TRIGGERS PARA AUDITORÍA Y LÓGICA DE NEGOCIO
-- =============================================

-- Trigger para actualizar fecha_actualizacion en Tareas
GO  -- Aquí termina el lote anterior

CREATE TRIGGER TR_Tareas_UpdateTimestamp
ON Tareas
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Tareas 
    SET fecha_actualizacion = GETDATE(),
        fecha_completado = CASE 
            WHEN i.estado = 'completada' AND d.estado != 'completada' THEN GETDATE()
            WHEN i.estado != 'completada' THEN NULL
            ELSE fecha_completado
        END
    FROM Tareas t
    INNER JOIN inserted i ON t.id = i.id
    INNER JOIN deleted d ON t.id = d.id;
END;
GO


-- Trigger para actualizar stock en movimientos de inventario
CREATE TRIGGER TR_MovimientosInventario_UpdateStock
ON MovimientosInventario
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE p
    SET stock_actual = i.stock_nuevo,
        fecha_actualizacion = GETDATE()
    FROM Productos p
    INNER JOIN inserted i ON p.id = i.producto_id;
END;
GO

-- Trigger para crear movimientos de inventario en ventas
CREATE TRIGGER TR_DetallesVenta_CreateMovimiento
ON DetallesVenta
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO MovimientosInventario (producto_id, tipo_movimiento, cantidad, stock_anterior, stock_nuevo, motivo, usuario_id)
    SELECT 
        i.producto_id,
        'salida',
        i.cantidad,
        p.stock_actual,
        p.stock_actual - i.cantidad,
        'Venta ID: ' + CAST(i.venta_id AS NVARCHAR(10)),
        v.usuario_id
    FROM inserted i
    INNER JOIN Productos p ON i.producto_id = p.id
    INNER JOIN Ventas v ON i.venta_id = v.id;
END;
GO

-- =============================================
-- INSERTAR DATOS INICIALES
-- =============================================

-- Usuarios iniciales
INSERT INTO Usuarios (nombre, email, password_hash, rol) VALUES
('Administrador Sistema', 'admin@ecovida.com', 'hashed_password_admin', 'administrador'),
('Vendedor Principal', 'vendedor@ecovida.com', 'hashed_password_vendedor', 'vendedor'),
('Encargado Inventario', 'inventario@ecovida.com', 'hashed_password_inventario', 'inventario');

-- Categorías de productos
INSERT INTO Categorias (nombre, descripcion) VALUES
('Hierbas Medicinales', 'Plantas y hierbas con propiedades medicinales'),
('Aceites Esenciales', 'Aceites naturales extraídos de plantas'),
('Suplementos Naturales', 'Suplementos alimenticios naturales'),
('Cosméticos Naturales', 'Productos de belleza con ingredientes naturales'),
('Tés e Infusiones', 'Mezclas de hierbas para infusiones'),
('Productos Orgánicos', 'Productos certificados como orgánicos');

-- Productos ejemplo
INSERT INTO Productos (nombre, descripcion, categoria_id, precio, stock_actual, stock_minimo, unidad_medida) VALUES
('Manzanilla', 'Flores de manzanilla para infusiones', 5, 5.50, 100, 20, 'gramos'),
('Aceite de Lavanda', 'Aceite esencial de lavanda puro', 2, 15.00, 50, 10, 'ml'),
('Aloe Vera Gel', 'Gel natural de aloe vera', 4, 8.75, 75, 15, 'ml'),
('Moringa en Polvo', 'Polvo de moringa orgánica', 3, 12.00, 60, 12, 'gramos');

-- Configuraciones iniciales
INSERT INTO Configuraciones (clave, valor, descripcion) VALUES
('empresa_nombre', 'Eco-Vida Productos Naturales', 'Nombre de la empresa'),
('empresa_direccion', 'Quito, Ecuador', 'Dirección de la empresa'),
('iva_porcentaje', '12', 'Porcentaje de IVA aplicado'),
('moneda', 'USD', 'Moneda utilizada en el sistema');

-- Tareas iniciales (como en el JavaScript original)
INSERT INTO Tareas (titulo, descripcion, estado, prioridad, categoria, asignado_a, fecha_vencimiento) VALUES
('Configurar sistema de autenticación', 'Implementar sistema de login con roles para administrador, vendedor y encargado de inventario', 'en-progreso', 'alta', 'sistema', 'administrador', '2025-07-15'),
('Registrar productos naturales', 'Añadir nuevos productos naturales al inventario con categorías y precios', 'pendiente', 'media', 'productos', 'inventario', '2025-07-12'),
('Generar reporte mensual de ventas', 'Crear reporte detallado de ventas del mes anterior', 'completada', 'alta', 'reportes', 'administrador', '2025-07-08'),
('Actualizar información de proveedores', 'Revisar y actualizar datos de contacto de proveedores', 'pendiente', 'baja', 'proveedores', 'administrador', '2025-07-05');

-- =============================================
-- VISTAS ÚTILES PARA REPORTES
-- =============================================

-- Vista para estadísticas de tareas
GO
CREATE VIEW vw_EstadisticasTareas AS
SELECT
    COUNT(*) AS total_tareas,
    SUM(CASE WHEN estado = 'completada' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN estado = 'pendiente' THEN 1 ELSE 0 END) AS pendientes,
    SUM(CASE WHEN estado = 'en-progreso' THEN 1 ELSE 0 END) AS en_progreso,
    SUM(
        CASE
            WHEN estado = 'atrasada'
                 OR (fecha_vencimiento < CAST(GETDATE() AS DATE)
                     AND estado != 'completada')
            THEN 1
            ELSE 0
        END
    ) AS atrasadas
FROM dbo.Tareas;
GO

-- Vista para productos con stock bajo
CREATE VIEW vw_ProductosStockBajo AS
SELECT 
    p.id,
    p.nombre,
    p.stock_actual,
    p.stock_minimo,
    c.nombre as categoria
FROM Productos p
LEFT JOIN Categorias c ON p.categoria_id = c.id
WHERE p.stock_actual <= p.stock_minimo
AND p.activo = 1;
GO

-- Vista para resumen de ventas
CREATE VIEW vw_ResumenVentas AS
SELECT 
    v.id,
    v.fecha_venta,
    c.nombre as cliente,
    u.nombre as vendedor,
    v.total,
    v.estado
FROM Ventas v
LEFT JOIN Clientes c ON v.cliente_id = c.id
INNER JOIN Usuarios u ON v.usuario_id = u.id;
GO

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS ÚTILES
-- =============================================

-- Procedimiento para actualizar estado de tareas atrasadas
CREATE PROCEDURE sp_ActualizarTareasAtrasadas
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Tareas 
    SET estado = 'atrasada',
        fecha_actualizacion = GETDATE()
    WHERE fecha_vencimiento < CAST(GETDATE() AS DATE)
    AND estado NOT IN ('completada', 'atrasada');
    
    SELECT @@ROWCOUNT as tareas_actualizadas;
END;
GO

-- Procedimiento para generar reporte de tareas
CREATE PROCEDURE sp_ReporteTareas
    @estado NVARCHAR(20) = NULL,
    @categoria NVARCHAR(20) = NULL,
    @fecha_inicio DATE = NULL,
    @fecha_fin DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        t.id,
        t.titulo,
        t.descripcion,
        t.estado,
        t.prioridad,
        t.categoria,
        t.asignado_a,
        t.fecha_vencimiento,
        t.fecha_creacion,
        t.fecha_actualizacion,
        u.nombre as creado_por
    FROM Tareas t
    LEFT JOIN Usuarios u ON t.usuario_creador_id = u.id
    WHERE (@estado IS NULL OR t.estado = @estado)
    AND (@categoria IS NULL OR t.categoria = @categoria)
    AND (@fecha_inicio IS NULL OR t.fecha_creacion >= @fecha_inicio)
    AND (@fecha_fin IS NULL OR t.fecha_creacion <= @fecha_fin)
    ORDER BY t.fecha_creacion DESC;
END;
GO

-- =============================================
-- FUNCIÓN PARA CALCULAR DÍAS HASTA VENCIMIENTO
-- =============================================
CREATE FUNCTION fn_DiasHastaVencimiento(@fecha_vencimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @dias INT;
    SET @dias = DATEDIFF(DAY, GETDATE(), @fecha_vencimiento);
    RETURN @dias;
END;
GO
PRINT 'Base de datos EcoVidaDB creada exitosamente con todas las tablas, índices, triggers y procedimientos.';