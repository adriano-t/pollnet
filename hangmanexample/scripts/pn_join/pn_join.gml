/// @description join a game
/// @param game
/// @param user_name


var gameid = argument0[| 0];
var admin_id = argument0[| 1];
var gamename = argument0[| 2]; 
var max_players = argument0[| 4];
	
global.pn_username = argument1;
	
var val = "mode=join";
val += "&gameid=" + string(gameid);
val += "&username=" + string(global.pn_username); 

global.pn_game_name = gamename;
global.pn_max_players = max_players;
global.pn_admin_id = admin_id;
global.pn_hosting = false;

global.pn_request_join = http_post_string(global.pn_lobby, val);