/// @description request existing games
function pn_get_lobbies(callback = undefined) {
	var val = "mode=gameslist";
	val += "&gametoken=" + string(obj_pollnet.game_token);
	obj_pollnet.request_lobbies = obj_pollnet.pn_http_request(obj_pollnet.url_lobby, val);
	obj_pollnet.callback_lobbies = callback;
}
