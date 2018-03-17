/// @description join a game
/// @param game_id
/// @param user_name

var val = "mode=join";
val += "&gameid=" + string(argument0);
val += "&username=" + string(argument1);
global.pn_username = argument1;
global.pn_request_join = http_post_string(global.pn_lobby, val);