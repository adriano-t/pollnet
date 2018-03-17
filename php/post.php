<?php

require_once "config.php";

if(!isset($_POST["token"]) || !isset($_POST["message"]))
    exit;
$token = mysql_real_escape_string($_POST["token"]); 
$message = mysql_real_escape_string($_POST["message"]); 
$to = mysql_real_escape_string($_POST["to"]);

$query = "SELECT id, game FROM pollnet_users WHERE token = '$token'";
$result = mysql_query($query) or die(mysql_error());

//only take the first result
if ($row = mysql_fetch_assoc($result)) 
{
    $id = $row["id"];
    $game = $row["game"];

    //update user
    $query = "UPDATE pollnet_users SET date = NOW() WHERE token = '$token'";
    $result = mysql_query($query) or die(mysql_error());

    //send message to a specific player
    if(isset($_POST["to"])) 
        $query = "INSERT INTO pollnet_messages(message, user_from, user_to, game)
        VALUES('$message', '$id', '$to', '$game')";
    
    //send message to all the players
    else
        $query = "INSERT INTO pollnet_messages(message, user_from, game)
        VALUES('$message', '$id', '$game')";

    mysql_query($query) or die(mysql_error());
    
    echo (mysql_insert_id());
}
?>