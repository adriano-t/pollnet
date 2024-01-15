<?php
require_once "header.php";
require_once "config.php";
require_once "connection.php";

$mode = $_POST["mode"];

if ($mode == "host") {
    // Create lobby
    if (!isset($_POST["gamename"]) || !isset($_POST["gametoken"]) || !isset($_POST["username"]) || !isset($_POST["maxplayers"]) || $_POST["maxplayers"] < 1 || !isset($_POST["private"]))
        exit("ERROR_MISSING_PARAMETERS");

    $gamename = $mysqli->real_escape_string($_POST["gamename"]);
    $gametoken = $mysqli->real_escape_string($_POST["gametoken"]);
    $username = $mysqli->real_escape_string($_POST["username"]);
    $maxplayers = $mysqli->real_escape_string($_POST["maxplayers"]);
    $private = $mysqli->real_escape_string($_POST["private"]);
    $ip = $mysqli->real_escape_string(getUserIP());
    $token = randomString(20);

    $query = "INSERT INTO " . $prefix . "_games(name, gametoken, maxplayers, private) 
    VALUES('$gamename', '$gametoken', '$maxplayers', '$private')";
    $mysqli->query($query) or die($mysqli->error);

    $gameid = $mysqli->insert_id;

    $query = "INSERT INTO " . $prefix . "_users(ip, token, name, game, admin) 
    VALUES(INET_ATON('$ip'), '$token', '$username', '$gameid', TRUE)";
    $mysqli->query($query) or die($mysqli->error);

    exit($token . $word_sep . $mysqli->insert_id . $word_sep);
} elseif ($mode == "manage") {
    // Manage players
    if (!isset($_POST["token"])  || !isset($_POST["started"]))
        exit("ERROR_MISSING_PARAMETERS");

    $started = $mysqli->real_escape_string($_POST["started"]);
    $token = $mysqli->real_escape_string($_POST["token"]);

    // Verify user
    $query = "SELECT id, game FROM " . $prefix . "_users WHERE token = '$token' and admin = TRUE";
    $result = $mysqli->query($query) or die($mysqli->error);

    // Only take the first result
    if ($row = $result->fetch_assoc()) {
        $id = $row["id"];
        $game = $row["game"];

        // Send start message to all the players
        $message = "pollnet_game_started";
        $query = "INSERT INTO " . $prefix . "_messages(message, user_from, game)
        VALUES('$message', '999999999', '$game')";
        $mysqli->query($query) or die($mysqli->error);

        // Block new joins
        $query = "UPDATE " . $prefix . "_games SET started = '$started' WHERE id = '$game'";
        $mysqli->query($query) or die($mysqli->error);

        exit("0");
    } else {
        exit("ERROR_LOBBY_DESTROYED");
    }
} elseif ($mode == "join") {
    // Join lobby
    if (!isset($_POST["gameid"])  || !isset($_POST["username"]))
        exit("ERROR_MISSING_PARAMETERS");

    $gameid = $mysqli->real_escape_string($_POST["gameid"]);
    $username = $mysqli->real_escape_string($_POST["username"]);
    $token = randomString(20);

    // Get current player count
    $resultCount = $mysqli->query("SELECT count(*) FROM " . $prefix . "_users WHERE game = '$gameid'") or die($mysqli->error);
    $count = $resultCount->fetch_row()[0];

    // Check max amount of players reached
    $query = "SELECT maxplayers, started, usr.num
    FROM " . $prefix . "_games 
    JOIN (SELECT count(*) AS num FROM " . $prefix . "_users WHERE game = '$gameid') AS usr
    WHERE id = '$gameid'";

    $result = $mysqli->query($query) or die($mysqli->error);

    if ($result->num_rows <= 0) {
        exit("ERROR_LOBBY_DESTROYED");
    }

    $row = $result->fetch_assoc();
    $max = $row["maxplayers"];
    $started = $row["started"];
    $count = $row["num"];


    if ($started) {
        exit("ERROR_GAME_STARTED");
    }

    if ($count < $max) {
        // Insert the new player
        $ip = $mysqli->real_escape_string(getUserIP());
        $query = "INSERT INTO " . $prefix . "_users(ip, token, name, game, admin) 
        VALUES(INET_ATON('$ip'), '$token', '$username', '$gameid', FALSE)";
        $mysqli->query($query) or die($mysqli->error);
        $player_id = $mysqli->insert_id;

        exit($token . $word_sep . $player_id . $word_sep);
    } else {
        exit("ERROR_LOBBY_FULL");
    }
} elseif ($mode == "autojoin") {
    // Join lobby
    if (!isset($_POST["gametoken"]) || !isset($_POST["username"]))
        exit("ERROR_MISSING_PARAMETERS");

    $gametoken = $mysqli->real_escape_string($_POST["gametoken"]);

    $query = "SELECT pg.id, adm.id as admin, name, num, maxplayers
    FROM " . $prefix . "_games pg
    JOIN (
        SELECT game, COUNT(game) as num 
        FROM " . $prefix . "_users 
        GROUP BY game
        ) usr 
    ON pg.id = usr.game
    JOIN (
        SELECT id, game
        FROM " . $prefix . "_users 
        WHERE admin = TRUE
        ) adm 
    ON pg.id = adm.game
    WHERE gametoken = '$gametoken' 
        AND started = FALSE 
        AND pg.private = FALSE 
        AND num < maxplayers";

    $result = $mysqli->query($query) or die($mysqli->error);

    if ($result->num_rows == 0) {
        exit("ERROR_LOBBY_NOT_FOUND");
    }

    $row = $result->fetch_assoc();

    $gameid = $mysqli->real_escape_string($row["id"]);
    $admin = $mysqli->real_escape_string($row["admin"]);
    $game_name = $mysqli->real_escape_string($row["name"]);
    $maxplayers = $mysqli->real_escape_string($row["maxplayers"]);
    $username = $mysqli->real_escape_string($_POST["username"]);
    $token = randomString(20);

    // Insert the new player
    $ip = $mysqli->real_escape_string(getUserIP());
    $query = "INSERT INTO " . $prefix . "_users(ip, token, name, game, admin) 
    VALUES(INET_ATON('$ip'), '$token', '$username', '$gameid', FALSE)";
    $mysqli->query($query) or die($mysqli->error);
    $player_id = $mysqli->insert_id;

    exit($token . $word_sep . $player_id . $word_sep . $game_name . $word_sep . $admin . $word_sep . $maxplayers . $word_sep);

} elseif ($mode == "quit") {
    // Join lobby
    if (!isset($_POST["token"]))
        exit("ERROR_MISSING_PARAMETERS");

    // Delete player from lobby
    $token = $mysqli->real_escape_string($_POST["token"]);
    $query = " DELETE FROM " . $prefix . "_users WHERE token = '$token'";
    $result = $mysqli->query($query) or die($mysqli->error);

    // Delete empty games
    $query = "DELETE FROM " . $prefix . "_games
    WHERE id NOT IN (
        SELECT game FROM " . $prefix . "_users 
    )";
    $mysqli->query($query) or die($mysqli->error);

    exit("0");
} elseif ($mode == "gameslist") {
    // Show games list

    if (!isset($_POST["gametoken"]))
        exit("ERROR_MISSING_PARAMETERS");
    $gametoken = $mysqli->real_escape_string($_POST["gametoken"]);

    $query = "SELECT pg.id, adm.id as admin, name, num, maxplayers
    FROM " . $prefix . "_games pg
    JOIN (
        SELECT game, COUNT(game) as num 
        FROM " . $prefix . "_users 
        GROUP BY game
        ) usr 
    ON pg.id = usr.game
    JOIN (
        SELECT id, game
        FROM " . $prefix . "_users 
        WHERE admin = TRUE
        ) adm 
    ON pg.id = adm.game
    WHERE gametoken = '$gametoken' AND started = FALSE";

    $result = $mysqli->query($query) or die($mysqli->error);

    if ($result->num_rows == 0) {
        exit("0");
    }

    while ($row = $result->fetch_assoc()) {
        echo $row["id"] . $word_sep . $row["admin"] . $word_sep . $row["name"] . $word_sep . $row["num"] . $word_sep . $row["maxplayers"] . $word_sep . $line_sep;
    }
}
