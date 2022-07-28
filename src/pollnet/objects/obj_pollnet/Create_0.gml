
if(instance_number(object_index) > 1)
{
	show_debug_message("POLLNET ERROR: do not instantiate more than 1 obj_pollnet");
	instance_destroy();
	exit;
}

enum pn_event {
	error,
	game_start,
	player_join,
	player_quit,
	disconnect,
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
	lobby_not_found,
	missing_message_handler,
}

self.request_send_list = ds_list_create();
self.players_checkmap = ds_map_create();
self.players_map = ds_map_create();
self.players_list = ds_list_create();
self.games_list = ds_list_create();
self.message_events = ds_map_create();
self.events_list = array_create(pn_event.COUNT);
self.receive_interval = 2;

self.init_variables = function() {
	self.last_date = "1912-06-23 00:00:00";
	self.last_id = 0;
	self.token = "";
	self.admin_id = -1;
	self.player_id = -1;
	self.player_name = "";
	self.game_name = "";
	self.max_players = 0;

	self.request_game_start = -1;
	self.request_lobbies = -1; 
	self.request_host = -1;
	self.request_join = -1;
	self.request_join_auto = -1;
	self.request_quit = -1;
	self.request_messages = -1;
	self.request_clear_data = -1;
		
	self.callback_game_start = undefined;
	self.callback_lobbies = undefined;
	self.callback_host = undefined;
	self.callback_join = undefined;
	self.callback_join_auto = undefined;
	self.callback_quit = undefined;
}

self.init_variables();

self.reset = function() {
	self.alarm[0] = -1;
	
	ds_list_clear(self.request_send_list);
	ds_map_clear(self.players_checkmap);
	ds_map_clear(self.players_map);
	ds_list_clear(self.players_list);
	ds_list_clear(self.games_list);
	
	self.init_variables();
	
	for(var i = 0; i < array_length(self.events_list); i++)
		self.events_list[i] = undefined;
}

/// @param {Function} callback
/// @param {Any} data
/// @hide
self.resolve = function(callback, data = undefined) {
	if(is_method(callback))
		callback({success: true, data: data});
}


/// @param {Function} callback
/// @param {Real} error_id
/// @param {String} error
/// @hide
self.reject = function(callback, error_id, error) {
	if(is_method(callback))
		callback({success: false, error_id: error_id, error: error});
	else if(is_method(self.events_list[pn_event.error]))
		self.events_list[pn_event.error](error_id, error);
}


/// @description creates an http request
/// @param {String} url
/// @param {String} str
/// @returns {Real}
/// @hide
self.pn_http_request = function(url, str){
	var map = ds_map_create();
	//ds_map_add(map, "Connection", "keep-alive");
	//ds_map_add(map, "Cache-Control", "max-age=0");
	ds_map_add(map, "Content-Type", "application/x-www-form-urlencoded");
	return http_request(url, "POST", map, str);
}


/// @description split string
/// @param {String} str
/// @param {String} separator
/// @returns {Array<String>}
/// @hide
self.string_split = function(str, separator) {

	if(string_length(str) == 0)
		return [];
	
	var s = str;
	var sep = separator;
	var count = string_count(sep, s);
	var result = array_create(count);
	if(count == 0)
	{
		result[0] = s;
		return result;
	}

	var p, i;

	for(i = 0; i < count; i++)
	{
		p = string_pos(sep, s);
		result[i] = string_copy(s, 1, p - 1);
		s = string_delete(s, 1, p);	
	}
	if(string_length(s) > 0)
		result[i] = s;
	
	return result;
}

///@param {Struct}
self.set_config = function(config){
	var url = config.url_root;
	var len = string_length(url);
	if(string_char_at(url, len) != "/")
		url += "/";
	
	self.url_get = url + "get.php";
	self.url_post = url + "post.php";
	self.url_lobby = url + "lobby.php";
	self.game_token = config.game_token;
	self.receive_interval = config.receive_interval;
	
	ini_open(working_directory + "pollnet.ini");
	var saved_token = ini_read_string("user", "token", "");
	ini_close();
	if (string_length(saved_token) == self.token_size) 
	{
		self.clear_data(saved_token);
	}
}

self.save_token = function() {
	ini_open(working_directory + "pollnet.ini");
	ini_write_string("user", "token", self.token);
	ini_close();
}

self.clear_data = function(saved_token) {
	var val = "mode=quit";
	val += "&token=" + string(saved_token);
	self.request_clear_data = obj_pollnet.pn_http_request(obj_pollnet.url_lobby, val);
}

///@returns {bool}
self.is_admin = function() {
	return self.player_id == self.admin_id && self.admin_id != -1;
}

self.sep_word = chr(1);
self.sep_mess = chr(2);
self.sep_line = chr(3);
self.sep_packet = chr(4);
self.token_size = 20;
self.server_message_id = 999999999;