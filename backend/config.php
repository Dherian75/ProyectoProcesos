<?php
$serverName = getenv('SQLSRV_SERVER') ?: 'localhost';
$connectionOptions = [
    'Database' => getenv('SQLSRV_DB') ?: 'ecovida',
    'Uid' => getenv('SQLSRV_USER') ?: 'sa',
    'PWD' => getenv('SQLSRV_PASS') ?: 'password',
    'CharacterSet' => 'UTF-8'
];
$conn = sqlsrv_connect($serverName, $connectionOptions);
if ($conn === false) {
    http_response_code(500);
    die(json_encode(['error' => sqlsrv_errors()]));
}
?>
