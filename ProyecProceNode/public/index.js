const styleContent = `
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    color: #333;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.header {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 20px;
    padding: 30px;
    margin-bottom: 30px;
    text-align: center;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.header h1 {
    color: #2c3e50;
    font-size: 2.5em;
    margin-bottom: 10px;
    background: linear-gradient(45deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.header p {
    color: #7f8c8d;
    font-size: 1.1em;
}

.dashboard {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.stat-card {
    background: rgba(255, 255, 255, 0.9);
    border-radius: 15px;
    padding: 25px;
    text-align: center;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.stat-card h3 {
    font-size: 2em;
    margin-bottom: 10px;
    color: #2c3e50;
}

.stat-card p {
    color: #7f8c8d;
    font-weight: 500;
}

.controls {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    padding: 25px;
    margin-bottom: 30px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.controls h2 {
    color: #2c3e50;
    margin-bottom: 20px;
    font-size: 1.5em;
}

.form-group {
    margin-bottom: 20px;
}

.form-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 15px;
}

label {
    display: block;
    margin-bottom: 8px;
    color: #2c3e50;
    font-weight: 500;
}

input, select, textarea {
    width: 100%;
    padding: 12px;
    border: 2px solid #e0e0e0;
    border-radius: 10px;
    font-size: 16px;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

input:focus, select:focus, textarea:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

textarea {
    resize: vertical;
    min-height: 100px;
}

.btn {
    background: linear-gradient(45deg, #667eea, #764ba2);
    color: white;
    border: none;
    padding: 12px 25px;
    border-radius: 10px;
    font-size: 16px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-weight: 600;
}

.btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
}

.btn-secondary {
    background: linear-gradient(45deg, #95a5a6, #7f8c8d);
}

.btn-danger {
    background: linear-gradient(45deg, #e74c3c, #c0392b);
}

.btn-success {
    background: linear-gradient(45deg, #2ecc71, #27ae60);
}

.filters {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
    margin-bottom: 20px;
}

.task-list {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    padding: 25px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.task-item {
    background: #f8f9fa;
    border-left: 4px solid #667eea;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 15px;
    transition: all 0.3s ease;
}

.task-item:hover {
    transform: translateX(5px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.task-item.completed {
    border-left-color: #2ecc71;
    opacity: 0.8;
}

.task-item.overdue {
    border-left-color: #e74c3c;
    background: #fdf2f2;
}

.task-item.in-progress {
    border-left-color: #f39c12;
}

.task-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 10px;
    flex-wrap: wrap;
    gap: 10px;
}

.task-title {
    font-size: 1.3em;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 5px;
}

.task-meta {
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
    font-size: 0.9em;
    color: #7f8c8d;
}

.task-actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.task-actions .btn {
    padding: 8px 15px;
    font-size: 14px;
}

.status-badge {
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 0.85em;
    font-weight: 600;
    text-transform: uppercase;
}

.status-pending {
    background: #ffeaa7;
    color: #d63031;
}

.status-in-progress {
    background: #fab1a0;
    color: #e17055;
}

.status-completed {
    background: #00b894;
    color: white;
}

.status-overdue {
    background: #d63031;
    color: white;
}

.priority-high {
    border-left-color: #e74c3c !important;
}

.priority-medium {
    border-left-color: #f39c12 !important;
}

.priority-low {
    border-left-color: #27ae60 !important;
}

.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    backdrop-filter: blur(5px);
}

.modal-content {
    background: white;
    border-radius: 20px;
    padding: 30px;
    max-width: 600px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.close-btn {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 24px;
    cursor: pointer;
    color: #7f8c8d;
    transition: color 0.3s ease;
}

.close-btn:hover {
    color: #2c3e50;
}

.no-tasks {
    text-align: center;
    padding: 40px;
    color: #7f8c8d;
    font-size: 1.2em;
}

.loading {
    text-align: center;
    padding: 40px;
    color: #667eea;
    font-size: 1.2em;
}

.export-section {
    margin-top: 20px;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 10px;
}

.export-section h3 {
    color: #2c3e50;
    margin-bottom: 15px;
}

.export-buttons {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

@media (max-width: 768px) {
    .container {
        padding: 10px;
    }

    .header h1 {
        font-size: 2em;
    }

    .dashboard {
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 15px;
    }

    .form-row {
        grid-template-columns: 1fr;
    }

    .task-header {
        flex-direction: column;
        align-items: flex-start;
    }

    .task-actions {
        width: 100%;
        justify-content: flex-start;
    }

    .modal-content {
        width: 95%;
        padding: 20px;
    }
}

@media (max-width: 480px) {
    .header h1 {
        font-size: 1.8em;
    }

    .stat-card {
        padding: 20px;
    }

    .controls, .task-list {
        padding: 20px;
    }

    .task-item {
        padding: 15px;
    }

    .export-buttons {
        flex-direction: column;
    }
}
`;

const htmlContent = `
<div class="container">
    <div class="header">
        <h1>Sistema de Gestión Eco-Vida</h1>
        <p>Gestión eficiente de tareas y procesos para productos naturales</p>
    </div>

    <div class="dashboard">
        <div class="stat-card">
            <h3 id="totalTasks">0</h3>
            <p>Total de Tareas</p>
        </div>
        <div class="stat-card">
            <h3 id="completedTasks">0</h3>
            <p>Completadas</p>
        </div>
        <div class="stat-card">
            <h3 id="pendingTasks">0</h3>
            <p>Pendientes</p>
        </div>
        <div class="stat-card">
            <h3 id="overdueTasks">0</h3>
            <p>Atrasadas</p>
        </div>
    </div>

    <div class="controls">
        <h2>Crear Nueva Tarea</h2>
        <form id="taskForm">
            <div class="form-row">
                <div class="form-group">
                    <label for="taskTitle">Título de la Tarea *</label>
                    <input type="text" id="taskTitle" required>
                </div>
                <div class="form-group">
                    <label for="taskStatus">Estado *</label>
                    <select id="taskStatus" required>
                        <option value="pendiente">Pendiente</option>
                        <option value="en-progreso">En Progreso</option>
                        <option value="completada">Completada</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="taskPriority">Prioridad</label>
                    <select id="taskPriority">
                        <option value="baja">Baja</option>
                        <option value="media">Media</option>
                        <option value="alta">Alta</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="taskCategory">Categoría</label>
                    <select id="taskCategory">
                        <option value="productos">Gestión de Productos</option>
                        <option value="inventario">Inventario</option>
                        <option value="ventas">Ventas</option>
                        <option value="clientes">Clientes</option>
                        <option value="proveedores">Proveedores</option>
                        <option value="reportes">Reportes</option>
                        <option value="sistema">Sistema</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="taskDueDate">Fecha de Vencimiento</label>
                    <input type="date" id="taskDueDate">
                </div>
                <div class="form-group">
                    <label for="taskAssignee">Asignado a</label>
                    <select id="taskAssignee">
                        <option value="administrador">Administrador</option>
                        <option value="vendedor">Vendedor</option>
                        <option value="inventario">Encargado de Inventario</option>
                        <option value="cliente">Cliente</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="taskDescription">Descripción</label>
                <textarea id="taskDescription" placeholder="Descripción detallada de la tarea..."></textarea>
            </div>
            <button type="submit" class="btn">Crear Tarea</button>
            <button type="button" class="btn btn-secondary" id="resetBtn">Limpiar</button>
        </form>
    </div>

    <div class="controls">
        <h2>Filtros Avanzados</h2>
        <div class="filters">
            <div class="form-group">
                <label for="filterStatus">Filtrar por Estado</label>
                <select id="filterStatus">
                    <option value="">Todos</option>
                    <option value="pendiente">Pendiente</option>
                    <option value="en-progreso">En Progreso</option>
                    <option value="completada">Completada</option>
                    <option value="atrasada">Atrasada</option>
                </select>
            </div>
            <div class="form-group">
                <label for="filterPriority">Filtrar por Prioridad</label>
                <select id="filterPriority">
                    <option value="">Todas</option>
                    <option value="alta">Alta</option>
                    <option value="media">Media</option>
                    <option value="baja">Baja</option>
                </select>
            </div>
            <div class="form-group">
                <label for="filterCategory">Filtrar por Categoría</label>
                <select id="filterCategory">
                    <option value="">Todas</option>
                    <option value="productos">Productos</option>
                    <option value="inventario">Inventario</option>
                    <option value="ventas">Ventas</option>
                    <option value="clientes">Clientes</option>
                    <option value="proveedores">Proveedores</option>
                    <option value="reportes">Reportes</option>
                    <option value="sistema">Sistema</option>
                </select>
            </div>
            <div class="form-group">
                <label for="searchTasks">Buscar Tareas</label>
                <input type="text" id="searchTasks" placeholder="Buscar por título o descripción...">
            </div>
        </div>
        <div class="export-section">
            <h3>Exportar Datos</h3>
            <div class="export-buttons">
                <button class="btn btn-success" id="csvBtn">Exportar CSV</button>
                <button class="btn btn-success" id="pdfBtn">Exportar PDF</button>
                <button class="btn btn-secondary" id="reportBtn">Generar Reporte</button>
            </div>
        </div>
    </div>

    <div class="task-list">
        <h2>Lista de Tareas</h2>
        <div id="taskContainer">
            <div class="loading">Cargando tareas...</div>
        </div>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" id="closeEdit">&times;</span>
        <h2>Editar Tarea</h2>
        <form id="editTaskForm">
            <div class="form-row">
                <div class="form-group">
                    <label for="editTaskTitle">Título de la Tarea *</label>
                    <input type="text" id="editTaskTitle" required>
                </div>
                <div class="form-group">
                    <label for="editTaskStatus">Estado *</label>
                    <select id="editTaskStatus" required>
                        <option value="pendiente">Pendiente</option>
                        <option value="en-progreso">En Progreso</option>
                        <option value="completada">Completada</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="editTaskPriority">Prioridad</label>
                    <select id="editTaskPriority">
                        <option value="baja">Baja</option>
                        <option value="media">Media</option>
                        <option value="alta">Alta</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="editTaskCategory">Categoría</label>
                    <select id="editTaskCategory">
                        <option value="productos">Gestión de Productos</option>
                        <option value="inventario">Inventario</option>
                        <option value="ventas">Ventas</option>
                        <option value="clientes">Clientes</option>
                        <option value="proveedores">Proveedores</option>
                        <option value="reportes">Reportes</option>
                        <option value="sistema">Sistema</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="editTaskDueDate">Fecha de Vencimiento</label>
                    <input type="date" id="editTaskDueDate">
                </div>
                <div class="form-group">
                    <label for="editTaskAssignee">Asignado a</label>
                    <select id="editTaskAssignee">
                        <option value="administrador">Administrador</option>
                        <option value="vendedor">Vendedor</option>
                        <option value="inventario">Encargado de Inventario</option>
                        <option value="cliente">Cliente</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="editTaskDescription">Descripción</label>
                <textarea id="editTaskDescription"></textarea>
            </div>
            <button type="submit" class="btn">Actualizar Tarea</button>
            <button type="button" class="btn btn-secondary" id="cancelEdit">Cancelar</button>
        </form>
    </div>
</div>
`;

let tasks = [];
let currentEditingTask = null;

function init() {
    const style = document.createElement('style');
    style.textContent = styleContent;
    document.head.appendChild(style);
    document.body.innerHTML = htmlContent;
    attachEvents();
    loadTasksFromServer();
}

function attachEvents() {
    document.getElementById('taskForm').addEventListener('submit', createTask);
    document.getElementById('editTaskForm').addEventListener('submit', updateTask);
    document.getElementById('filterStatus').addEventListener('change', applyFilters);
    document.getElementById('filterPriority').addEventListener('change', applyFilters);
    document.getElementById('filterCategory').addEventListener('change', applyFilters);
    document.getElementById('searchTasks').addEventListener('input', applyFilters);
    document.getElementById('resetBtn').addEventListener('click', resetForm);
    document.getElementById('closeEdit').addEventListener('click', closeEditModal);
    document.getElementById('cancelEdit').addEventListener('click', closeEditModal);
    document.getElementById('csvBtn').addEventListener('click', () => exportTasks('csv'));
    document.getElementById('pdfBtn').addEventListener('click', () => exportTasks('pdf'));
    document.getElementById('reportBtn').addEventListener('click', generateReport);
}

function loadTasksFromServer() {
    fetch('/api/tareas')

        .then(response => response.json())
        .then(data => {
            tasks = data;
            updateDashboard();
            renderTasks();
        })
        .catch(() => {
            document.getElementById('taskContainer').innerHTML = '<div class="no-tasks">Error cargando tareas.</div>';
        });
}

function createTask(e) {
    e.preventDefault();
    const payload = {
        title: document.getElementById('taskTitle').value,
        status: document.getElementById('taskStatus').value,
        priority: document.getElementById('taskPriority').value,
        category: document.getElementById('taskCategory').value,
        dueDate: document.getElementById('taskDueDate').value,
        assignee: document.getElementById('taskAssignee').value,
        description: document.getElementById('taskDescription').value
    };
    fetch('/api/tareas', {

        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
    .then(r => r.json())
    .then(data => {
        tasks.push(data);
        resetForm();
        updateDashboard();
        renderTasks();
        showNotification('Tarea creada exitosamente');
    });
}

function updateTask(e) {
    e.preventDefault();
    if (!currentEditingTask) return;
    const payload = {
        title: document.getElementById('editTaskTitle').value,
        status: document.getElementById('editTaskStatus').value,
        priority: document.getElementById('editTaskPriority').value,
        category: document.getElementById('editTaskCategory').value,
        dueDate: document.getElementById('editTaskDueDate').value,
        assignee: document.getElementById('editTaskAssignee').value,
        description: document.getElementById('editTaskDescription').value
    };
    fetch('/api/tareas/' + currentEditingTask.id, {

        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
    .then(r => r.json())
    .then(data => {
        const index = tasks.findIndex(t => t.id === currentEditingTask.id);
        tasks[index] = data;
        closeEditModal();
        updateDashboard();
        renderTasks();
        showNotification('Tarea actualizada');
    });
}

function deleteTask(id) {
    if (!confirm('¿Estás seguro de que quieres eliminar esta tarea?')) return;
   fetch('/api/tareas/' + id, {
    method: 'DELETE'
})

}

function editTask(id) {
    const task = tasks.find(t => t.id === id);
    if (!task) return;
    currentEditingTask = task;
    document.getElementById('editTaskTitle').value = task.title;
    document.getElementById('editTaskStatus').value = task.status;
    document.getElementById('editTaskPriority').value = task.priority;
    document.getElementById('editTaskCategory').value = task.category;
    document.getElementById('editTaskDueDate').value = task.dueDate;
    document.getElementById('editTaskAssignee').value = task.assignee;
    document.getElementById('editTaskDescription').value = task.description;
    document.getElementById('editModal').style.display = 'block';
}

function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
    currentEditingTask = null;
}

function updateDashboard() {
    const total = tasks.length;
    const completed = tasks.filter(t => t.status === 'completada').length;
    const pending = tasks.filter(t => t.status === 'pendiente').length;
    const overdue = tasks.filter(t => t.status === 'atrasada').length;
    document.getElementById('totalTasks').textContent = total;
    document.getElementById('completedTasks').textContent = completed;
    document.getElementById('pendingTasks').textContent = pending;
    document.getElementById('overdueTasks').textContent = overdue;
}

function renderTasks() {
    const container = document.getElementById('taskContainer');
    const filtered = getFilteredTasks();
    if (filtered.length === 0) {
        container.innerHTML = '<div class="no-tasks">No hay tareas que mostrar.</div>';
        return;
    }
    container.innerHTML = filtered.map(task => `
        <div class="task-item ${task.status} priority-${task.priority}">
            <div class="task-header">
                <div>
                    <div class="task-title">${task.title}</div>
                    <div class="task-meta">
                        <span><strong>ID:</strong> ${task.id}</span>
                        <span><strong>Categoría:</strong> ${getCategoryName(task.category)}</span>
                        <span><strong>Asignado:</strong> ${getAssigneeName(task.assignee)}</span>
                        <span><strong>Prioridad:</strong> ${task.priority}</span>
                        ${task.dueDate ? `<span><strong>Vence:</strong> ${task.dueDate}</span>` : ''}
                    </div>
                </div>
                <div class="task-actions">
                    <span class="status-badge status-${task.status}">${getStatusName(task.status)}</span>
                    <button class="btn btn-secondary" onclick="editTask(${task.id})">Editar</button>
                    <button class="btn btn-danger" onclick="deleteTask(${task.id})">Eliminar</button>
                </div>
            </div>
            <p>${task.description || ''}</p>
        </div>
    `).join('');
}

function getFilteredTasks() {
    const status = document.getElementById('filterStatus').value;
    const priority = document.getElementById('filterPriority').value;
    const category = document.getElementById('filterCategory').value;
    const search = document.getElementById('searchTasks').value.toLowerCase();
    return tasks.filter(task => {
        const matchesStatus = status ? task.status === status : true;
        const matchesPriority = priority ? task.priority === priority : true;
        const matchesCategory = category ? task.category === category : true;
        const matchesSearch = task.title.toLowerCase().includes(search) || (task.description || '').toLowerCase().includes(search);
        return matchesStatus && matchesPriority && matchesCategory && matchesSearch;
    });
}

function resetForm() {
    document.getElementById('taskForm').reset();
}

function getCategoryName(key) {
    const map = {
        productos: 'Productos', inventario: 'Inventario', ventas: 'Ventas',
        clientes: 'Clientes', proveedores: 'Proveedores', reportes: 'Reportes', sistema: 'Sistema'
    };
    return map[key] || key;
}

function getAssigneeName(key) {
    const map = {
        administrador: 'Administrador', vendedor: 'Vendedor', inventario: 'Encargado de Inventario', cliente: 'Cliente'
    };
    return map[key] || key;
}

function getStatusName(key) {
    const map = { 'pendiente': 'Pendiente', 'en-progreso': 'En Progreso', 'completada': 'Completada', 'atrasada': 'Atrasada' };
    return map[key] || key;
}

function applyFilters() {
    renderTasks();
}

function showNotification(msg) {
    alert(msg);
}

function exportTasks(type) {
    showNotification('Exportar ' + type.toUpperCase() + ' no implementado');
}

function generateReport() {
    showNotification('Generar reporte no implementado');
}

window.addEventListener('load', init);  