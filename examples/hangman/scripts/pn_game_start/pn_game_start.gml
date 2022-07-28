/// @description accept new players to join the game
/// @param {Function} callback
function pn_game_start(callback = undefined) {
 
	var val = "mode=manage";
	val += "&started=1";
	val += "&token=" + obj_pollnet.token;
	obj_pollnet.request_game_start = obj_pollnet.pn_http_request(obj_pollnet.url_lobby, val);
	obj_pollnet.callback_game_start = callback;
}
