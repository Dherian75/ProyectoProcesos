const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;
const tareasPath = path.join(__dirname, 'tareas.json');


app.use(cors());
app.use(bodyParser.json());

// Servir archivos estáticos desde carpeta 'public'
app.use(express.static(path.join(__dirname, '../public')));


// API: obtener tareas
app.get('/api/tareas', (req, res) => {
    const tareas = JSON.parse(fs.readFileSync(tareasPath));
    res.json(tareas);
});

// API: crear tarea
app.post('/api/tareas', (req, res) => {
    const tareas = JSON.parse(fs.readFileSync(tareasPath));
    const nueva = { id: Date.now(), ...req.body };
    tareas.push(nueva);
    fs.writeFileSync(tareasPath, JSON.stringify(tareas, null, 2));
    res.json(nueva);
});

// API: actualizar tarea
app.post('/api/tareas/:id', (req, res) => {
    let tareas = JSON.parse(fs.readFileSync(tareasPath));
    const index = tareas.findIndex(t => t.id == req.params.id);
    if (index !== -1) {
        tareas[index] = { id: tareas[index].id, ...req.body };
        fs.writeFileSync(tareasPath, JSON.stringify(tareas, null, 2));
        res.json(tareas[index]);
    } else {
        res.status(404).send('No encontrada');
    }
});

// API: eliminar tarea
app.post('/api/tareas/:id', (req, res) => {
  const { title, status, priority, category, dueDate, assignee, description } = req.body;
  const id = req.params.id;

  db.run(`UPDATE tareas SET 
    title = ?, status = ?, priority = ?, category = ?, dueDate = ?, assignee = ?, description = ?
    WHERE id = ?`,
    [title, status, priority, category, dueDate, assignee, description, id],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ id: Number(id), ...req.body });
    }
  );
});


// Iniciar servidor
app.listen(PORT, () => {
    console.log(`✅ Servidor corriendo en http://localhost:${PORT}`);
});
