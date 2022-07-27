var aid = ds_map_find_value(async_load, "id");
var status = ds_map_find_value(async_load, "status");
if (status == 1) 
{ 
	show_debug_message("WAITING: Status Receiving packets!");
	exit; 
} 
	
var r_str = ds_map_find_value(async_load, "result");



#region process messages
if (aid == self.request_messages)
{
	if(status < 0)
	{
		self.reject(events_list[pn_event.error], pn_error.empty_result, "empty receive message result"); 
		exit;
	}
	
	if(r_str == "ERROR_LOBBY_DESTROYED") {
		self.reject(events_list[pn_event.disconnect], pn_error.lobby_destroyed, "The lobby has been destroyed");
		exit;
	}
	
	var split = string_pos(self.sep_mess, r_str);
	var r_players = string_copy(r_str, 1, split - 1);
	var r_message = string_delete(r_str, 1, split);
	
	#region split players 
	
	var lines = self.string_split(r_players, self.sep_line);
	 
	for(var i = 0; i < array_length(lines); i++)
	{  
		var p_data = self.string_split(lines[i], self.sep_word);
		var player_id = real(p_data[0]);
		var player_name = p_data[1];
		var is_admin = p_data[2] == "1";
		if(is_admin) {
			self.admin_id = player_id;
		}
		
		ds_map_add(self.players_checkmap, player_id, player_name); 
		//new player joined
		if(!ds_map_exists(self.players_map, player_id))
		{
			ds_map_add(self.players_map, player_id, player_name);
			ds_list_add(self.players_list, player_id);
			
			//don't trigger the event for myself
			if(player_id != self.player_id) 
			{
				self.resolve(events_list[pn_event.player_join], {
					player_id: player_id, 
					player_name: player_name
				});
			}
		}
	}
	 
	
	//players who quit
	for(var i = 0; i < ds_list_size(self.players_list); i++)
	{
		var p = self.players_list[| i];
		if(!ds_map_exists(self.players_checkmap, p))
		{
			//if i quit, leave the lobby
			if(p == self.player_id)
			{
				self.resolve(self.callback_quit);
				reset();
				exit;
			} 
			else
			{
				self.resolve(events_list[pn_event.player_quit], {
					player_id: p, 
					player_name: self.players_map[? p]
				});
			}
			
			ds_list_delete(self.players_list, i--);
			ds_map_delete(self.players_map, p);
		}
	}
	ds_map_clear(self.players_checkmap);
	
	#endregion
	
	#region split messages 
	  
	lines = self.string_split(r_message, self.sep_line);
	
	for(var i = 0; i < array_length(lines); i++)
	{  
		var m_data = self.string_split(lines[i], self.sep_word);
		
		if(array_length(m_data) != 5) {
			self.reject(events_list[pn_event.error], pn_error.wrong_message_format, "decode: wrong message format");
			continue;
		}
		
		self.last_id = real(m_data[0]);
		self.last_date = m_data[1];
		var from = real(m_data[2]);
		var to = real(m_data[3]);
		var packet = m_data[4];
		
		//server message
		if(from == server_message_id)
		{
			if(packet == "pollnet_game_started") 
			{
				self.resolve(events_list[pn_event.game_start]);
			}
		}
		//game message, decode it
		else
		{
			var gm_data = self.string_split(packet, self.sep_packet);
			
			var msg_id = gm_data[0];
			var type = real(gm_data[1]); 
			
			var handlers = self.message_events[? msg_id];
			if(handlers != undefined)
			{
				switch(type)
				{
					case 0: //TYPE ARRAY			
						//show_debug_message("TYPE ARRAY");
					
						var len = real(gm_data[2]); 
						// fill array
						var message = array_create(len);
						var val;
						var idx = 0;
						for(var j = 0; j < len * 2; j++)
						{
							var sub_type = real(gm_data[3 + j]);
							j++; 
							
							if(sub_type == 1){
								val = base64_decode(gm_data[3 + j]); 
							}
							else if(sub_type == 2) {
								val = real(gm_data[3 + j]); 
							}
							else
							{
								for(var k = 0; k < array_length(handlers); k++)
									self.reject(handlers[k], pn_error.unkown_element_type, "decode: unknown array element type: " + string(sub_type));
								exit;
							}
					
							message[idx++] = val;
						}
					
						break;
			
					case 1: // TYPE STRING
						//show_debug_message("TYPE STRING");
						message = base64_decode(gm_data[2]);
						break;
			
					case 2: // TYPE REAL
						//show_debug_message("TYPE REAL");
						message = real(gm_data[2]);
						break;
			
					default:
						for(var j = 0; j < array_length(handlers); j++)
							self.reject(handlers[j], pn_error.unknown_packet_type, "decode: unknown packet type");
						exit;
						break;
				}
					 
				for(var j = 0; j < array_length(handlers); j++)
					self.resolve(handlers[j], {
						last_date: self.last_date,
						from: from,
						to: to,
						message_id: msg_id,
						message: message,
					});
			}
			else
			{
				self.reject(events_list[pn_event.error], pn_error.missing_message_handler, "Missing message handler for " + string(msg_id));
			}
		}
	
	}
	#endregion
	
    alarm[0] = receive_interval * game_get_speed(gamespeed_fps);
	exit;
}
#endregion
  
#region join
if (aid == self.request_join)
{
	
	if(status < 0)
	{
		self.reject(self.callback_join, pn_error.empty_result, "empty join result, check php installation");  
		exit;
	}
	
	if(r_str == "ERROR_LOBBY_FULL") {
		self.reject(self.callback_join, pn_error.lobby_full, "the lobby is full");
		exit;
	}
	
	if(r_str == "ERROR_LOBBY_DESTROYED") {
		self.reject(self.callback_join, pn_error.lobby_full, "the lobby is full");
		self.reject(events_list[pn_event.disconnect], pn_error.lobby_destroyed, "The lobby has been destroyed");
		exit;
	}
	
	if(r_str == "ERROR_GAME_STARTED") {
		self.reject(self.callback_join, pn_error.game_started, "The game already started");
		exit;
	}

	
	var data = self.string_split(r_str, self.sep_word);
	var token = data[0];
	var player_id = real(data[1]);
	 
	if(string_length(token) == token_size)
	{
		self.token = token;
		self.save_token();

		//show_debug_message("join token: " + string(token));
		self.last_id = 0;
		self.last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		self.player_id = real(player_id);
		self.resolve(self.callback_join, {
			player_id: self.player_id, 
			player_name: self.player_name
		});
		alarm[0] = 1;
	} 
	else
	{
		self.reject(self.callback_join, pn_error.invalid_token, "Invalid token on join");	
	}
	exit;
} 
#endregion
 

#region join auto
if (aid == self.request_join_auto)
{
	
	if(status < 0)
	{
		self.reject(self.callback_join_auto, pn_error.empty_result, "empty auto join result, check php installation");  
		exit;
	}
	
	if(r_str == "ERROR_LOBBY_NOT_FOUND") {
		self.reject(self.callback_join_auto, pn_error.lobby_not_found, "There are no open lobbies");
		exit;
	}
		
	var data = self.string_split(r_str, self.sep_word);
	var token = data[0];
	var player_id = real(data[1]);	
    var game_name = data[2];
	var admin_id = data[3] 
	var max_players = real(data[4]);
	 
	if(string_length(token) == token_size)
	{
		self.token = token;
		self.save_token();
		//show_debug_message("join token: " + string(token));
		self.last_id = 0;
		self.last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		self.player_id = real(player_id);
		self.game_name = game_name;
		self.admin_id = admin_id;
		self.max_players = max_players;
		self.resolve(self.callback_join_auto, {
			player_id: self.player_id, 
			player_name: self.player_name
		});
		alarm[0] = 1;
	} 
	else
	{
		self.reject(self.callback_join_auto, pn_error.invalid_token, "Invalid token on join");	
	}
	exit;
} 
#endregion

#region host
if (aid == self.request_host)
{
	if(status < 0)
	{ 
		self.reject(self.callback_host, pn_error.empty_result, "empty host result, check php installation"); 
		exit;
	} 
	
	var data = self.string_split(r_str, self.sep_word);
	var token = data[0];
	var player_id = data[1]; 
	
	if(string_length(token) == token_size)
	{
		self.token = token;
		self.save_token();
		//show_debug_message("host token: " + string(token));
		
		self.last_id = 0;
		self.last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		
		self.player_id = real(player_id);
		self.admin_id = self.player_id;
		
		self.resolve(self.callback_host, {
			player_id: self.player_id,
			player_name: self.player_name
		});
		alarm[0] = 1;
	}
	else
	{
		self.reject(self.callback_host, pn_error.invalid_token, "Invalid token on join");	
	}
	exit;
}
#endregion

#region game start

if (aid == self.request_game_start)
{
	if(status < 0)
	{
		self.reject(self.callback_game_start, pn_error.empty_result, "empty game start request result, check php installation"); 
		exit;
	}
	self.resolve(self.callback_game_start);
	exit;
}

#endregion

#region quit
if (aid == self.request_quit)
{
	if(status < 0)
	{ 
		self.reject(self.callback_quit, pn_error.empty_result, "empty quit request result, check php installation"); 
		exit;
	}
	self.resolve(self.callback_quit);
	reset();
	exit;
}
#endregion

#region send
for(var i = 0; i < ds_list_size(self.request_send_list); i++)
{
	var msg = self.request_send_list[| i]
	if (aid == msg.request_id)
	{ 
		if(status < 0)
		{ 
			self.reject(msg.callback, pn_error.empty_result, "empty send request result, check php installation");
			exit;
		}

		if(r_str == "ERROR_LOBBY_DESTROYED") {
			self.reject(msg.callback, pn_error.lobby_destroyed, "The lobby has been destroyed");
			self.reject(events_list[pn_event.disconnect], pn_error.lobby_destroyed, "The lobby has been destroyed");
			exit;
		}
		
		self.resolve(msg.callback);
		exit;
	}
}
#endregion

#region games
if (aid == self.request_lobbies)
{
	//free games list
	ds_list_clear(self.games_list); 
	
	if(status < 0)
	{ 
		self.reject(self.callback_lobbies, pn_error.empty_result, "empty games list result, check php installation");
		exit;
	}
	
	if(r_str != "0")
	{ 
		var lines = self.string_split(r_str, self.sep_line); 
		for(var i = 0; i < array_length(lines); i++)
		{
			var game = ds_list_create();
			var g_data = self.string_split(lines[i], self.sep_word);
			
			ds_list_add(self.games_list, {
				game_id: real(g_data[0]),
				admin_id: real(g_data[1]),
				game_name: g_data[2],
				online_players: real(g_data[3]),
				max_players: real(g_data[4])
			});
		}
	}
	
	self.resolve(self.callback_lobbies, self.games_list);
	exit;
}
#endregion


#region clear
if (aid == self.request_clear_data)
{
	if(status < 0)
	{ 
		self.reject(self.callback_lobbies, pn_error.empty_result, "empty clear request result, check php installation");
		exit;
	}
	
	exit;
}
#endregion



