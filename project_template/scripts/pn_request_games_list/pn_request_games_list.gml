/// @description request existing games

var val = "mode=gameslist";
val += "&gametoken=" + string(global.pn_game_token);
global.pn_request_games = http_post_string(global.pn_lobby, val);
