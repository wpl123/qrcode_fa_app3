<?php
require_once('db.php');
$query = 'SELECT * FROM history';
$stm = $db->prepare($query);
$stm->execute();
$row = $stm->fetch(PDO::FETCH_ASSOC);
echo $row;