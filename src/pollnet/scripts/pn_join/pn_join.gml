/// @description join a game
/// @param game
/// @param user_name
function pn_join(game, user_name) {
	var gameid = game[| 0];
	var admin_id = game[| 1];
	var gamename = game[| 2]; 
	var max_players = game[| 4];
	
	global.pn_username = user_name;
	
	var val = "mode=join";
	val += "&gameid=" + string(gameid);
	val += "&username=" + string(global.pn_username); 

	global.pn_game_name = gamename;
	global.pn_max_players = max_players;
	global.pn_admin_id = admin_id;

	global.pn_request_join = pn_http_request(global.pn_url_lobby, val);
	
}
