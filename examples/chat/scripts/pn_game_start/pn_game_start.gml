/// @description accept new players to join the game 
function pn_game_start() {
 
	var val = "mode=manage";
	val += "&started=1";
	val += "&token=" + global.pn_token;
	global.pn_request_game_start = pn_http_request(global.pn_url_lobby, val);
	
}
