
if(instance_number(object_index) > 1)
{
	instance_destroy();
	exit;
}

enum pn_error {
	data_type,
	empty_message_result,
	empty_join_result,
	empty_host_result,
	empty_start_request_result,
	empty_send_request_result,
	empty_games_list_result,
	empty_quit_result,
	empty_root_url,
	wrong_message_format,
	unknown_packet_type,
	unkown_element_type,
	cant_send,
}

reset = function() {
	for(var i = 0; i < ds_list_size(global.pn_request_send_list); i++)
		ds_list_destroy(global.pn_request_send_list[| i]);
	ds_list_clear(global.pn_request_send_list);
	ds_map_clear(global.pn_players_checkmap);
	ds_map_clear(global.pn_players_map);
	ds_list_clear(global.pn_players_list);
	global.pn_request_host = -1;
	global.pn_request_join = -1;
	global.pn_request_game_start = -1;
	global.pn_request_quit = -1;
	global.pn_request_games = -1; 
	global.pn_request_message = -1;
	alarm[0] = -1;
}

pn_config();
var len = string_length(global.pn_url_root);
if(len == 0) {
	pn_on_error(pn_error.empty_root_url, "global.pn_url_root url should not be empty");
}
if(string_char_at(global.pn_url_root, len) != "/")
	global.pn_url_root += "/";
	
global.pn_url_get = global.pn_url_root + "get.php";
global.pn_url_post = global.pn_url_root + "post.php";
global.pn_url_lobby = global.pn_url_root + "lobby.php";

global.pn_last_date = "1912-06-23 00:00:00";
global.pn_last_id = 0;
global.pn_token = "";
global.pn_request_send_list = ds_list_create();
global.pn_players_checkmap = ds_map_create();
global.pn_players_map = ds_map_create();
global.pn_players_list = ds_list_create();
global.pn_games_list = ds_list_create();
global.pn_request_host = -1;
global.pn_request_join = -1;
global.pn_request_game_start = -1;
global.pn_request_quit = -1;
global.pn_request_games = -1;
global.pn_request_message = -1;
global.pn_admin_id = -1;
global.pn_player_id = -1;
sep_word = chr(1);
sep_mess = chr(2);
sep_line = chr(3);
sep_packet = chr(4);
token_size = 20;
