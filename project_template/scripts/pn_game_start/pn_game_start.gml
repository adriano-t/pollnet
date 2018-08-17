/// @description accept new players to join the game 
 
var val = "mode=manage";
val += "&started=1";
val += "&token=" + global.pn_token;
global.pn_request_game_start = http_post_string(global.pn_lobby, val);
