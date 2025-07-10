# Eco-Vida Task System

Este proyecto muestra un ejemplo básico de integración de un frontend HTML con un backend PHP que utiliza SQL Server.

## Estructura
- **frontend**: Contiene la página `index.html` con la interfaz de usuario.
- **backend**: Incluye `api.php` para las operaciones CRUD, `config.php` para la conexión y `schema.sql` para crear la tabla `tasks`.
- **main**: Documentación o archivos de arranque.

## Uso
1. Cree una base de datos en SQL Server y ejecute `backend/schema.sql`.
2. Ajuste las variables de conexión en `backend/config.php` o mediante variables de entorno `SQLSRV_SERVER`, `SQLSRV_DB`, `SQLSRV_USER` y `SQLSRV_PASS`.
3. Sirva los archivos con un servidor que soporte PHP (por ejemplo, `php -S localhost:8000` en la carpeta raíz).

Al abrir `frontend/index.html` en el navegador se cargarán las tareas almacenadas y se podrán crear, editar y eliminar.
