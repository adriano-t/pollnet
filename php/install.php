<?php

require_once "config.php";


mysql_query("DROP TABLE IF EXISTS pollnet_games") or die(mysql_error());
mysql_query("DROP TABLE IF EXISTS pollnet_users") or die(mysql_error());
mysql_query("DROP TABLE IF EXISTS pollnet_messages") or die(mysql_error()); 

$query = "CREATE TABLE pollnet_games(
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    maxplayers SMALLINT NOT NULL,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);";
mysql_query($query) or die(mysql_error());
echo("games table created<br/>");

$query = "CREATE TABLE pollnet_users(
    id BIGINT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
    token CHAR(20) NOT NULL ,
    name VARCHAR(50) NOT NULL,
    game BIGINT UNSIGNED  NOT NULL,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT game_fk
        FOREIGN KEY (game) REFERENCES pollnet_games(id) 
);";
mysql_query($query) or die(mysql_error());
echo("users table created<br/>");

$query = "CREATE TABLE pollnet_messages(
    id BIGINT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
    game BIGINT UNSIGNED  NOT NULL,
    user_from BIGINT UNSIGNED  NOT NULL,
    user_to BIGINT UNSIGNED ,
    message TEXT NOT NULL,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    CONSTRAINT game_fk
        FOREIGN KEY (game) REFERENCES pollnet_games(id),
    CONSTRAINT user_from_fk
        FOREIGN KEY (user_from) REFERENCES pollnet_users(id),
    CONSTRAINT user_to_fk
        FOREIGN KEY (user_to) REFERENCES pollnet_users(id)
);";
mysql_query($query) or die(mysql_error());
echo("messages table created<br/>");


echo("<h2> Installation complete! </h2><br/>");
unlink(__FILE__);
?>