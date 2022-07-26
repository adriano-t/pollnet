/// @description join a game
/// @param {Struct} game
/// @param {String} user_name
/// @param {Function} callback
function pn_join(game, user_name, callback = undefined) {
	
	global.pn_player_name = user_name;
	
	var val = "mode=join";
	val += "&gameid=" + string(game.gameid);
	val += "&username=" + string(global.pn_player_name); 

	global.pn_game_name = game.game_name;
	global.pn_max_players = game.max_players;
	global.pn_admin_id = game.admin_id;

	global.pn_request_join = pn_http_request(global.pn_url_lobby, val);
	global.pn_callback_join = callback;
	
}
