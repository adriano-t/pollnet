/// @description request existing games
function pn_get_lobbies(callback = undefined) {
	var val = "mode=gameslist";
	val += "&gametoken=" + string(global.pn_game_token);
	global.pn_request_lobbies = pn_http_request(global.pn_url_lobby, val);
	global.pn_callback_lobbies = callback;
}
