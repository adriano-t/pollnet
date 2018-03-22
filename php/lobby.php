<?php

require_once "config.php";
require_once "connection.php";

$mode =  $_POST["mode"];

if($mode == "host")
{
    //create lobby
    if(!isset($_POST["gamename"]) || !isset($_POST["gametoken"]) || !isset($_POST["username"]) || !isset($_POST["maxplayers"]) || $_POST["maxplayers"] < 1)
        exit;

    $gamename = mysql_real_escape_string($_POST["gamename"]);
    $gametoken = mysql_real_escape_string($_POST["gametoken"]);
    $username = mysql_real_escape_string($_POST["username"]);
    $maxplayers = mysql_real_escape_string($_POST["maxplayers"]);
    $token = randomString(20);
    
    $query = "INSERT INTO pollnet_games(name, gametoken, maxplayers) 
    VALUES('$gamename', '$gametoken', '$maxplayers')";
    mysql_query($query) or die(mysql_error());

    $gameid = mysql_insert_id();

    $query = "INSERT INTO pollnet_users(token, name, game, admin) 
    VALUES('$token', '$username', '$gameid', TRUE)";
    mysql_query($query) or die(mysql_error());

    echo($token . $word_sep . mysql_insert_id());
} 
elseif ($mode == "manage")
{
    
    //manage players
    if(!isset($_POST["token"])  || !isset($_POST["started"]))
        exit;
 
    $started = mysql_real_escape_string($_POST["started"]);
    $token = mysql_real_escape_string($_POST["token"]); 

    //verify user
    $query = "SELECT id, game FROM pollnet_users WHERE token = '$token'";
    $result = mysql_query($query) or die(mysql_error());
    
    //only take the first result
    if ($row = mysql_fetch_assoc($result)) 
    {
        $id = $row["id"];
        $game = $row["game"];
    
        //send start message to all the players
        $message = "pollnet_game_started";
        $query = "INSERT INTO pollnet_messages(message, user_from, game)
        VALUES('$message', '$id', '$game')"; 
        mysql_query($query) or die(mysql_error());

        //block new joins
        $query = "UPDATE pollnet_games SET started = '$started' WHERE id = '$game'";
        mysql_query($query) or die(mysql_error());
 
        echo("0");
    }
}
elseif ($mode == "join")
{
    //join lobby
    if(!isset($_POST["gameid"])  || !isset($_POST["username"]))
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
        $query = "INSERT INTO pollnet_users(token, name, game, admin) 
        VALUES('$token', '$username', '$gameid', FALSE)";
        mysql_query($query) or die(mysql_error());
        echo($token . $word_sep . mysql_insert_id());
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
    echo("0");
}
elseif ($mode == "gameslist")
{
    // show games list  

    if(!isset($_POST["gametoken"]))
        exit;
    $gametoken = mysql_real_escape_string($_POST["gametoken"]);

    $query = "SELECT pg.id, adm.id as admin, name, num, maxplayers
    FROM pollnet_games pg
    JOIN (
        SELECT game, COUNT(game) as num 
        FROM pollnet_users 
        GROUP BY game
        ) usr 
    ON pg.id = usr.game
    JOIN (
        SELECT id, game
        FROM pollnet_users 
        WHERE admin = TRUE
        ) adm 
    ON pg.id = adm.game
    WHERE gametoken = '$gametoken' AND started = FALSE";
    
    $result = mysql_query($query) or die(mysql_error());

    if(mysql_num_rows($result) == 0) 
        echo("0");
        
    while ($row = mysql_fetch_assoc($result)) 
    {
        echo $row["id"] . $word_sep . $row["admin"] . $word_sep . $row["name"] . $word_sep . $row["num"] . $word_sep . $row["maxplayers"] . $word_sep . $line_sep;
    }
}