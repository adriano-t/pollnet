<?php

require_once "config.php"; 

$db = mysql_connect($host, $dbusername, $password) or die("Errore durante la connessione al database");
mysql_select_db($database, $db) or die("Errore durante la selezione del database");


mysql_query("DROP TABLE IF EXISTS ".$prefix."_games") or die(mysql_error());
mysql_query("DROP TABLE IF EXISTS ".$prefix."_users") or die(mysql_error());
mysql_query("DROP TABLE IF EXISTS ".$prefix."_messages") or die(mysql_error()); 

$query = "CREATE TABLE ".$prefix."_games(
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gametoken VARCHAR(50) NOT NULL,
    started BOOLEAN NOT NULL DEFAULT FALSE,
    maxplayers SMALLINT NOT NULL,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);";
mysql_query($query) or die(mysql_error());
echo("games table created<br/>");

$query = "CREATE TABLE ".$prefix."_users(
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	ip INT UNSIGNED NOT NULL,
    token CHAR(20) NOT NULL ,
    name VARCHAR(50) NOT NULL,
    admin BOOLEAN NOT NULL,
    game BIGINT UNSIGNED  NOT NULL,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT game_fk
        FOREIGN KEY (game) REFERENCES ".$prefix."_games(id) 
);";
mysql_query($query) or die(mysql_error());
echo("users table created<br/>");

$query = "CREATE TABLE ".$prefix."_messages(
    id BIGINT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
    game BIGINT UNSIGNED  NOT NULL,
    user_from BIGINT UNSIGNED  NOT NULL,
    user_to BIGINT UNSIGNED DEFAULT 0 NOT NULL ,
    message TEXT NOT NULL,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    CONSTRAINT game_fk
        FOREIGN KEY (game) REFERENCES ".$prefix."_games(id),
    CONSTRAINT user_from_fk
        FOREIGN KEY (user_from) REFERENCES ".$prefix."_users(id) ON DELETE CASCADE,
    CONSTRAINT user_to_fk
        FOREIGN KEY (user_to) REFERENCES ".$prefix."_users(id)
);";
mysql_query($query) or die(mysql_error());
echo("messages table created<br/>");


echo("<h2> Installation complete! </h2><br/>");
unlink(__FILE__);
?>