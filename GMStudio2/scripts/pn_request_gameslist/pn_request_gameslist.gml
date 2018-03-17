/// @description request existing games

var val = "mode=games";
global.pn_request_games = http_post_string(global.pn_lobby, val);