<?php
require_once('db.php');
$query = 'SELECT * FROM history';
$stm = $db->prepare($query);
$stm->execute();
$row = $stm->fetchAll(PDO::FETCH_ASSOC);
echo '{"history":';
echo json_encode($row);
echo '}';
#echo json_encode("history ["$row "]");
