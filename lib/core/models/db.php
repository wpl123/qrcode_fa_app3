<?php

$dns = 'mysql:host=https://progressprogrammingsolutions.com.au;dbname=fa_qrcode_server';
$user = 'root';
$pass = 'WeRcoNTYPIN';
try{
    $db = new PDO ($dns, $user, $pass);
    echo 'Connected';
} catch(PDOException $e){
    $error = $e->getMessage();
    echo $error;
}