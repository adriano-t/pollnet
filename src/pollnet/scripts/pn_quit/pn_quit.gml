/// @description disconnect from the game 
/// @param {Function} callback
function pn_quit(callback = undefined) {
	var val = "mode=quit";
	val += "&token=" + obj_pollnet.token;
	obj_pollnet.request_quit = obj_pollnet.pn_http_request(obj_pollnet.url_lobby, val);
	obj_pollnet.callback_quit = callback;
}
