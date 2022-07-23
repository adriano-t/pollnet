<?php
require_once "header.php";
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
	$ip = mysql_real_escape_string(getUserIP());
    $token = randomString(20);
    
    $query = "INSERT INTO ".$prefix."_games(name, gametoken, maxplayers) 
    VALUES('$gamename', '$gametoken', '$maxplayers')";
    mysql_query($query) or die(mysql_error());

    $gameid = mysql_insert_id();

    $query = "INSERT INTO ".$prefix."_users(ip, token, name, game, admin) 
    VALUES(INET_ATON('$ip'), '$token', '$username', '$gameid', TRUE)";
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
    $query = "SELECT id, game FROM ".$prefix."_users WHERE token = '$token' and admin = TRUE";
    $result = mysql_query($query) or die(mysql_error());
    
    //only take the first result
    if ($row = mysql_fetch_assoc($result)) 
    {
        $id = $row["id"];
        $game = $row["game"];
    
        //send start message to all the players
        $message = "pollnet_game_started";
        $query = "INSERT INTO ".$prefix."_messages(message, user_from, game)
        VALUES('$message', '$id', '$game')"; 
        mysql_query($query) or die(mysql_error());

        //block new joins
        $query = "UPDATE ".$prefix."_games SET started = '$started' WHERE id = '$game'";
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
	
    $result = mysql_query("SELECT count(*) FROM ".$prefix."_users WHERE game = '$gameid'")or die(mysql_error());
    $count = mysql_result($result, 0);

    //check max amount of players reached
    $query = "SELECT maxplayers, usr.num
    FROM ".$prefix."_games 
    JOIN (SELECT count(*) AS num FROM ".$prefix."_users WHERE game = '$gameid') AS usr
    WHERE id = '$gameid'";

    $result = mysql_query($query) or die(mysql_error());
    $max = mysql_result($result, 0, 0);
    $count = mysql_result($result, 0, 1);
    if($count < $max)
    {
		// insert the new player
		$ip = mysql_real_escape_string(getUserIP());
        $query = "INSERT INTO ".$prefix."_users(ip, token, name, game, admin) 
        VALUES(INET_ATON('$ip'), '$token', '$username', '$gameid', FALSE)";
        mysql_query($query) or die(mysql_error());
		$player_id = mysql_insert_id();
		
		//get admin ip
		$query = "SELECT INET_NTOA(ip)
        FROM ".$prefix."_users 
        WHERE admin = TRUE AND game = '$gameid';";
		$result = mysql_query($query) or die(mysql_error());

		$admin_ip = "127.0.0.1";
		if(mysql_num_rows($result) != 0) 
			$admin_ip = mysql_result($result, 0, 0);
		
		
        echo($token . $word_sep . $player_id . $word_sep . $admin_ip);
    }
}
elseif ($mode == "quit")
{
    //join lobby
    if(!isset($_POST["token"]))
        exit;

    $token = mysql_real_escape_string($_POST["token"]);
    $query = " DELETE FROM ".$prefix."_users WHERE token = '$token'";
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
    FROM ".$prefix."_games pg
    JOIN (
        SELECT game, COUNT(game) as num 
        FROM ".$prefix."_users 
        GROUP BY game
        ) usr 
    ON pg.id = usr.game
    JOIN (
        SELECT id, game
        FROM ".$prefix."_users 
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