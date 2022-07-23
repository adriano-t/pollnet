/// @description request existing games
function pn_request_games_list() {

	var val = "mode=gameslist";
	val += "&gametoken=" + string(global.pn_game_token);
	global.pn_request_games = pn_http_request(global.pn_url_lobby, val);
	
}
