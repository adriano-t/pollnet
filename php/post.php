<?php

require_once "header.php";

if (!isset($_POST["token"]) || !isset($_POST["message"])) {
    exit("ERROR_MISSING_PARAMETERS");
}

require_once "config.php";
require_once "connection.php";

$token = $mysqli->real_escape_string($_POST["token"]);
$message = $mysqli->real_escape_string($_POST["message"]);
$to = $mysqli->real_escape_string($_POST["to"]);

$query = "SELECT id, game FROM " . $prefix . "_users WHERE token = '$token'";
$result = $mysqli->query($query) or die($mysqli->error);

// Only take the first result
if ($row = $result->fetch_assoc()) {
    $id = $row["id"];
    $game = $row["game"];

    // Update user
    $query = "UPDATE " . $prefix . "_users SET date = NOW() WHERE token = '$token'";
    $result = $mysqli->query($query) or die($mysqli->error);

    // Send message to a specific player
    if (isset($_POST["to"])) {
        $query = "INSERT INTO " . $prefix . "_messages(message, user_from, user_to, game)
        VALUES('$message', '$id', '$to', '$game')";
    }
    // Send message to all the players
    else {
        $query = "INSERT INTO " . $prefix . "_messages(message, user_from, game)
        VALUES('$message', '$id', '$game')";
    }

    $mysqli->query($query) or die($mysqli->error);

    exit("0");
} else {
    exit("ERROR_LOBBY_DESTROYED");
}
?>
