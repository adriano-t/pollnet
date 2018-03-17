/// @description create a new game
/// @param game_name
/// @param user_name
/// @param max_players

var val = "mode=host";
val += "&gamename=" + string(argument0);
val += "&username=" + string(argument1);
val += "&maxplayers=" + string(argument2);
global.pn_username = argument1;
global.pn_request_host = http_post_string(global.pn_lobby, val); 