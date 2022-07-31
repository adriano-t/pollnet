/// @description create a new game
/// @param {String} game_name
/// @param {String} user_name
/// @param {Real} max_players
/// @param {Bool} private
/// @param {Function} callback
function pn_host(game_name, user_name, max_players, private, callback = undefined) {

	var val = "mode=host";
	val += "&gamename=" + string(game_name);
	val += "&gametoken=" + string(obj_pollnet.game_token);
	val += "&username=" + string(user_name);
	val += "&maxplayers=" + string(max_players);
	val += "&private=" + string(private ? 1 : 0);
	obj_pollnet.game_name = game_name;
	obj_pollnet.player_name = user_name;
	obj_pollnet.max_players = max_players;
	obj_pollnet.admin_id = -1;
	obj_pollnet.request_host = obj_pollnet.pn_http_request(obj_pollnet.url_lobby, val); 
	obj_pollnet.callback_host = callback;
}
