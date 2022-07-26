/// @description create a new game
/// @param {String} game_name
/// @param {String} user_name
/// @param {Real} max_players
/// @param {Function} callback
function pn_host(game_name, user_name, max_players, callback = undefined) {

	var val = "mode=host";
	val += "&gamename=" + string(game_name);
	val += "&gametoken=" + string(global.pn_game_token);
	val += "&username=" + string(user_name);
	val += "&maxplayers=" + string(max_players);
	global.pn_game_name = game_name;
	global.pn_player_name = user_name;
	global.pn_max_players = max_players;
	global.pn_admin_id = -1;
	global.pn_request_host = pn_http_request(global.pn_url_lobby, val); 
	global.pn_callback_host = callback;
}
