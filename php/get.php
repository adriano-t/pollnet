<?php

require_once "header.php";

if (!isset($_POST["token"]) || !isset($_POST["lastid"])) {
    exit("ERROR_MISSING_PARAMETERS");
}

require_once "config.php";
require_once "connection.php";

$token = $mysqli->real_escape_string($_POST["token"]);
$lastid = $mysqli->real_escape_string($_POST["lastid"]);

$query = "SELECT id, game FROM " . $prefix . "_users WHERE token = '$token'";
$result = $mysqli->query($query) or die($mysqli->error);

// Only take the first result
if ($row = $result->fetch_assoc()) {
    $id = $row["id"];
    $game = $row["game"];

    // Update user
    $query = "UPDATE " . $prefix . "_users SET date = NOW() WHERE token = '$token'";
    $result = $mysqli->query($query) or die($mysqli->error);

    // Get players list
    $query = "SELECT id, name, admin FROM " . $prefix . "_users WHERE game = '$game'";
    $result = $mysqli->query($query) or die($mysqli->error);

    while ($row = $result->fetch_assoc()) {
        echo $row["id"] . $word_sep . $row["name"] . $word_sep . $row["admin"] . $word_sep . $line_sep;
    }

    echo ($msg_sep);

    // Get messages list
    $query = "SELECT id, date, user_from, user_to, message
    FROM " . $prefix . "_messages 
    WHERE user_from <> '$id'
        AND game = '$game'  
        AND (user_to = '$id' OR user_to = 0)
        AND id > '$lastid'
    ORDER BY id ASC";
    $result = $mysqli->query($query) or die($mysqli->error);

    while ($row = $result->fetch_assoc()) {
        echo $row["id"] . $word_sep . $row["date"] . $word_sep . $row["user_from"] . $word_sep . $row["user_to"] . $word_sep . $row["message"] . $word_sep . $line_sep;
    }
} else {
    exit("ERROR_LOBBY_DESTROYED");
}
?>
