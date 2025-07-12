
<?php
header('Content-Type: application/json');
require_once __DIR__.'/config.php';
$action = $_GET['action'] ?? 'list';
if ($action === 'list') {
    $stmt = sqlsrv_query($conn, "SELECT * FROM tasks ORDER BY id DESC");
    $rows = [];
    while($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        if ($row['dueDate']) $row['dueDate'] = $row['dueDate']->format('Y-m-d');
        $rows[] = $row;
    }
    echo json_encode($rows);
} elseif ($action === 'create') {
    $data = json_decode(file_get_contents('php://input'), true);
    $sql = "INSERT INTO tasks (title, description, status, priority, category, assignee, dueDate, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE()); SELECT SCOPE_IDENTITY() AS id;";
    $params = [$data['title'], $data['description'], $data['status'], $data['priority'], $data['category'], $data['assignee'], $data['dueDate'] ?: null];
    $stmt = sqlsrv_query($conn, $sql, $params);
    if ($stmt === false) {http_response_code(500); echo json_encode(sqlsrv_errors()); exit;}
    sqlsrv_next_result($stmt); $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
    $data['id'] = (int)$row['id'];
    echo json_encode($data);
} elseif ($action === 'update') {
    $id = (int)($_GET['id'] ?? 0);
    $data = json_decode(file_get_contents('php://input'), true);
    $sql = "UPDATE tasks SET title=?, description=?, status=?, priority=?, category=?, assignee=?, dueDate=?, updatedAt=GETDATE() WHERE id=?";
    $params = [$data['title'], $data['description'], $data['status'], $data['priority'], $data['category'], $data['assignee'], $data['dueDate'] ?: null, $id];
    $stmt = sqlsrv_query($conn, $sql, $params);
    if ($stmt === false) {http_response_code(500); echo json_encode(sqlsrv_errors()); exit;}
    $data['id'] = $id;
    echo json_encode($data);
} elseif ($action === 'delete') {
    $id = (int)($_GET['id'] ?? 0);
    $stmt = sqlsrv_query($conn, "DELETE FROM tasks WHERE id=?", [$id]);
    echo json_encode(['deleted' => $id]);
}
?>
