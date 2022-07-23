/// @description disconnect from the game 
function pn_quit() {

	var val = "mode=quit";
	val += "&token=" + global.pn_token;
	global.pn_request_quit = pn_http_request(global.pn_url_lobby, val);
	
}
