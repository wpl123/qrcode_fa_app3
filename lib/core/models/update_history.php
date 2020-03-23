<?php
require_once('db.php'); 

// https://www.geeksforgeeks.org/php-mysql-update-query/
  
 try{ 
    $scanID = $_POST["scan_id"];
    $scanUsed = $_POST["scan_used"];
    $query = "UPDATE history SET scanUsed = '$scanUsed' WHERE id = '$scanID'";
    $stm = $db->prepare($query);
    $stm->execute();
    
    echo json_encode("Updated Data");

 } catch(PDOException $e){ 
 	die("ERROR: Could not able to execute $sql. " 
 								. $e->getMessage()); 
 } 
 unset($pdo); 
 ?>
