<?php
require_once('db.php');

$scanDate = $_POST["scan_date"];
$scanTime = $_POST["scan_time"];
$scanQRCode = $_POST["scan_qrcode"];
$scanUsed = $_POST["scan_used"];

$query = "INSERT INTO history (scanDate,scanTime,scanQRCode,scanUsed) VALUES('$scanDate','$scanTime','$scanQRCode','$scanUsed')";
$stm = $db->prepare($query);
$stm->execute();
$id = $db->lastInsertId();

echo json_encode($id);

?>
