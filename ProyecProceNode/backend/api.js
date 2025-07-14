// backend/api.js
const express = require('express');
const fs = require('fs');
const router = express.Router();

const dataPath = __dirname + '/tareas.json';

// Obtener todas las tareas
router.get('/tareas', (req, res) => {
  const tareas = JSON.parse(fs.readFileSync(dataPath));
  res.json(tareas);
});

// Crear tarea
router.post('/tareas', (req, res) => {
  const tareas = JSON.parse(fs.readFileSync(dataPath));
  const nuevaTarea = { id: Date.now(), ...req.body };
  tareas.push(nuevaTarea);
  fs.writeFileSync(dataPath, JSON.stringify(tareas, null, 2));
  res.json(nuevaTarea);
});

// Actualizar tarea
router.post('/tareas/:id', (req, res) => {
  const tareas = JSON.parse(fs.readFileSync(dataPath));
  const index = tareas.findIndex(t => t.id == req.params.id);
  if (index !== -1) {
    tareas[index] = { id: tareas[index].id, ...req.body };
    fs.writeFileSync(dataPath, JSON.stringify(tareas, null, 2));
    res.json(tareas[index]);
  } else {
    res.status(404).send('Tarea no encontrada');
  }
});

// Eliminar tarea
router.delete('/tareas/:id', (req, res) => {
  let tareas = JSON.parse(fs.readFileSync(dataPath));
  tareas = tareas.filter(t => t.id != req.params.id);
  fs.writeFileSync(dataPath, JSON.stringify(tareas, null, 2));
  res.json({ success: true });
});

module.exports = router;
