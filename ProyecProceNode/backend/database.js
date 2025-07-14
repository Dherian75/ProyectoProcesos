// backend/database.js
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./tareas.db');

// Crear tabla si no existe
db.serialize(() => {
  db.run(`CREATE TABLE IF NOT EXISTS tareas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    status TEXT,
    priority TEXT,
    category TEXT,
    dueDate TEXT,
    assignee TEXT,
    description TEXT
  )`);
});

module.exports = db;
