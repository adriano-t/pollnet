<?php

$mysqli = new mysqli($host, $dbusername, $password, $database);

// Check connection
if ($mysqli->connect_error) {
    die("Error: can't connect to the database - " . $mysqli->connect_error);
}

// Function to generate a random string
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

// Function to get user's IP address
function getUserIP()
{
    if (array_key_exists('HTTP_X_FORWARDED_FOR', $_SERVER) && !empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        if (strpos($_SERVER['HTTP_X_FORWARDED_FOR'], ',') > 0) {
            $addr = explode(",", $_SERVER['HTTP_X_FORWARDED_FOR']);
            return trim($addr[0]);
        } else {
            return $_SERVER['HTTP_X_FORWARDED_FOR'];
        }
    } else {
        return $_SERVER['REMOTE_ADDR'];
    }
}

$number = file_get_contents($prefix . "_update.txt");
if (time() - $number > $update_interval) {
    file_put_contents($prefix . "_update.txt", time());

    // Delete players
    $query = "DELETE FROM " . $prefix . "_users WHERE date < NOW() - INTERVAL $delete_interval SECOND";
    $mysqli->query($query) or die($mysqli->error);

    // Delete messages
    $query = "DELETE FROM " . $prefix . "_messages WHERE date < NOW() - INTERVAL $delete_interval SECOND";
    $mysqli->query($query) or die($mysqli->error);

    // Delete empty games
    $query = "DELETE FROM " . $prefix . "_games
    WHERE id NOT IN (
        SELECT game FROM " . $prefix . "_users 
    )";
    $mysqli->query($query) or die($mysqli->error);

    // Transfer admin to other players if needed
    $query = "SELECT id FROM " . $prefix . "_games
    WHERE id NOT IN (
        SELECT game FROM " . $prefix . "_users WHERE admin = 1
    )";
    $result = $mysqli->query($query) or die($mysqli->error);
    $games = array();
    while ($row = $result->fetch_assoc())
        array_push($games, $row["id"]);

    for ($i = 0; $i < count($games); $i++) {
        $gameid = $games[$i];
        $query = "UPDATE " . $prefix . "_users as U
        JOIN (SELECT MIN(id) AS id FROM " . $prefix . "_users) as NU ON NU.id = U.id
        SET admin=1
        WHERE U.game = $gameid";

        $mysqli->query($query) or die($mysqli->error);
    }
}

$word_sep = chr(1);
$msg_sep = chr(2);
$line_sep = chr(3);
