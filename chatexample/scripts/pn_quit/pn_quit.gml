/// @description disconnect from the game 

var val = "mode=quit";
val += "&token=" + global.pn_token;
global.pn_request_quit = http_post_string(global.pn_lobby, val);