<?php

require_once "config.php";
require_once "connection.php";

$mode =  $_POST["mode"];

if($mode == "host")
{
    //create lobby
    if(!isset($_POST["gamename"]) || !isset($_POST["username"]) || !isset($_POST["maxplayers"]) || $_POST["maxplayers"] < 1)
        exit;

    $gamename = mysql_real_escape_string($_POST["gamename"]);
    $username = mysql_real_escape_string($_POST["username"]);
    $maxplayers = mysql_real_escape_string($_POST["maxplayers"]);
    $token = randomString(20);
    
    $query = "INSERT INTO pollnet_games(name, maxplayers) 
    VALUES('$gamename', '$maxplayers')";
    mysql_query($query) or die(mysql_error());

    $gameid = mysql_insert_id();

    $query = "INSERT INTO pollnet_users(token, name, game) 
    VALUES('$token', '$username', '$gameid')";
    mysql_query($query) or die(mysql_error());

    echo($token);
}
elseif ($mode == "join")
{
    //join lobby
    if(!isset($_POST["gameid"]) || !isset($_POST["username"]))
        exit;

    $gameid = mysql_real_escape_string($_POST["gameid"]);
    $username = mysql_real_escape_string($_POST["username"]);
    $token = randomString(20);

    $result = mysql_query("SELECT count(*) FROM pollnet_users WHERE game = '$gameid'")or die(mysql_error());
    $count = mysql_result($result, 0);

    //single line
    $query = " SELECT maxplayers, usr.num
    FROM pollnet_games 
    JOIN (SELECT count(*) as num from pollnet_users WHERE game = '$gameid') as usr
    WHERE id = '$gameid'";

    $result = mysql_query($query) or die(mysql_error());
    $max = mysql_result($result, 0, 0);
    $count = mysql_result($result, 0, 1);
    if($count < $max)
    {
        $query = "INSERT INTO pollnet_users(token, name, game) 
        VALUES('$token', '$username', '$gameid')";
        mysql_query($query) or die(mysql_error());
        echo($token);
    }
}
elseif ($mode == "quit")
{
    //join lobby
    if(!isset($_POST["token"]))
        exit;

    $token = mysql_real_escape_string($_POST["token"]);
    $query = " DELETE FROM pollnet_users WHERE token = '$token'";
    $result = mysql_query($query) or die(mysql_error());
    echo("1");
}
else
{
    // show games list
    $query = "SELECT pg.id, name,  num, maxplayers
    FROM pollnet_games pg
    JOIN (
        SELECT id, game, COUNT(game) as num 
        FROM pollnet_users 
        GROUP BY game
        ) usr 
     ON pg.id = usr.game";
    $result = mysql_query($query) or die(mysql_error());

    while ($row = mysql_fetch_assoc($result)) 
    {
        echo $row["id"] . $row_sep . $row["name"] . $row_sep . $row["num"] . $row_sep . $row["maxplayers"] . $row_sep . $line_sep;
    }
}