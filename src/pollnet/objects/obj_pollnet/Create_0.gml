
if(instance_number(object_index) > 1)
{
	instance_destroy();
	exit;
}


enum pn_event {
	error,
	game_start,
	player_join,
	player_quit,
	receive_message,
	COUNT
}

enum pn_error {
	empty_result,
	empty_root_url,
	wrong_message_format,
	unknown_packet_type,
	unkown_element_type,
	cant_send,
	lobby_full,
	lobby_destroyed,
	game_started,
	invalid_token,
}



pn_events = array_create(pn_event.COUNT);



pn_config();
var len = string_length(global.pn_url_root);
if(len == 0) {
	pn_reject(pn_events[pn_event.error], pn_error.empty_root_url, "global.pn_url_root url should not be empty");
}
if(string_char_at(global.pn_url_root, len) != "/")
	global.pn_url_root += "/";
	
global.pn_url_get = global.pn_url_root + "get.php";
global.pn_url_post = global.pn_url_root + "post.php";
global.pn_url_lobby = global.pn_url_root + "lobby.php";

global.pn_last_date = "1912-06-23 00:00:00";
global.pn_last_id = 0;
global.pn_token = "";
global.pn_admin_id = -1;
global.pn_player_id = -1;
global.pn_request_send_list = ds_list_create();
global.pn_players_checkmap = ds_map_create();
global.pn_players_map = ds_map_create();
global.pn_players_list = ds_list_create();
global.pn_games_list = ds_list_create();
global.pn_request_game_start = -1;
global.pn_request_lobbies = -1; 
global.pn_request_host = -1;
global.pn_request_join = -1;
global.pn_request_quit = -1;
global.pn_request_messages = -1;

global.pn_callback_game_start = undefined;
global.pn_callback_lobbies = undefined;
global.pn_callback_host = undefined;
global.pn_callback_join = undefined;
global.pn_callback_quit = undefined;


reset = function() {
	
	self.alarm[0] = -1;
	
	ds_list_clear(global.pn_request_send_list);
	ds_map_clear(global.pn_players_checkmap);
	ds_map_clear(global.pn_players_map);
	ds_list_clear(global.pn_players_list);
	ds_list_clear(global.pn_games_list);
	
	global.pn_request_game_start = -1;
	global.pn_request_lobbies = -1; 
	global.pn_request_host = -1;
	global.pn_request_join = -1;
	global.pn_request_quit = -1;
	global.pn_request_messages = -1;
	
	global.pn_callback_game_start = undefined;
	global.pn_callback_lobbies = undefined;
	global.pn_callback_host = undefined;
	global.pn_callback_join = undefined;
	global.pn_callback_quit = undefined;
	for(var i = 0; i < array_length(pn_events); i++)
		self.pn_events[i] = undefined;
		
}

sep_word = chr(1)
sep_mess = chr(2)
sep_line = chr(3)
sep_packet = chr(4)
token_size = 20
pn_server_message_id = 999999999