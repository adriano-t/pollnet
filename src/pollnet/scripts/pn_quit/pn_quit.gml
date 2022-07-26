/// @description disconnect from the game 
/// @param {Function} callback
function pn_quit(callback = undefined) {
	var val = "mode=quit";
	val += "&token=" + global.pn_token;
	global.pn_request_quit = pn_http_request(global.pn_url_lobby, val);
	global.pn_callback_quit = callback;
}
