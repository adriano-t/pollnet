/// @description join a game
/// @param {Struct} game
/// @param {String} user_name
/// @param {Function} callback
function pn_join(game, user_name, callback = undefined) {
	
	obj_pollnet.player_name = user_name;
	
	var val = "mode=join";
	val += "&gameid=" + string(game.game_id);
	val += "&username=" + string(obj_pollnet.player_name); 

	obj_pollnet.game_name = game.game_name;
	obj_pollnet.max_players = game.max_players;
	obj_pollnet.admin_id = game.admin_id;

	obj_pollnet.request_join = obj_pollnet.pn_http_request(obj_pollnet.url_lobby, val);
	obj_pollnet.callback_join = callback;
	
}
