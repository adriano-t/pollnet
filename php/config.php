<?php

$update_interval = 3; //seconds

$dbusername = "tizsoft";
$password = "";
$host = "localhost";
$database = "my_tizsoft";


$db = mysql_connect($host, $dbusername, $password) or die("Errore durante la connessione al database");
mysql_select_db($database, $db) or die("Errore durante la selezione del database");

function randomString($length = 10) 
{
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $s = '';
    for ($i = 0; $i < $length; $i++) {
        $s .= $characters[rand(0, $charactersLength - 1)];
    }
    return $s;
}


$number = file_get_contents('pollnet_update.txt'); 
if(time() - $number > $update_interval)
{ 
    file_put_contents('pollnet_update.txt', time()); 

    //delete players and messages
    $query = "DELETE pu, pm
    FROM pollnet_users pu
    LEFT JOIN pollnet_messages pm ON pu.id = pm.user_from
    WHERE pu.date < NOW() - INTERVAL 10 SECOND"; 
    mysql_query($query) or die(mysql_error());
 
    //delete empty games
    $query = "DELETE FROM pollnet_games
    WHERE id NOT IN (
        SELECT game FROM pollnet_users 
    )"; 
    mysql_query($query) or die(mysql_error());
}


$row_sep = chr(1);
$msg_sep = chr(2);
$line_sep = chr(3);

?>