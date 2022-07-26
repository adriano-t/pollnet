var aid = ds_map_find_value(async_load, "id");
var status = ds_map_find_value(async_load, "status");
if (status == 1) 
{ 
	show_debug_message("WAITING: Status Receiving packets!");
	exit; 
} 
	
var r_str = ds_map_find_value(async_load, "result");



#region process messages
if (aid == global.pn_request_messages)
{
	if(status < 0)
	{
		pn_reject(global.pn_callback_message, pn_error.empty_result, "empty message request result"); 
		exit;
	}
	
	if(r_str == "ERROR_LOBBY_DESTROYED") {
		pn_reject(global.pn_callback_message, pn_error.lobby_destroyed, "The game does not exists anymore");
		exit;
	}
	
	var split = string_pos(sep_mess, r_str);
	var r_players = string_copy(r_str, 1, split - 1);
	var r_message = string_delete(r_str, 1, split);
	
	#region split players 
	
	var lines = pn_string_split(r_players, sep_line);
	 
	for(var i = 0; i < array_length(lines); i++)
	{  
		var p_data = pn_string_split(lines[i], sep_word);
		var player_id = real(p_data[0]);
		var player_name = p_data[1];
		var is_admin = p_data[2] == "1";
		if(is_admin) {
			global.pn_admin_id = player_id;
		}
		
		ds_map_add(global.pn_players_checkmap, player_id, player_name); 
		//new player joined
		if(!ds_map_exists(global.pn_players_map, player_id))
		{
			ds_map_add(global.pn_players_map, player_id, player_name);
			ds_list_add(global.pn_players_list, player_id);
			
			//don't trigger the event for myself
			if(player_id != global.pn_player_id) 
			{
				pn_resolve(pn_events[pn_event.player_join], {
					player_id: player_id, 
					player_name: player_name
				});
			}
		}
	}
	 
	
	//players who quit
	for(var i = 0; i < ds_list_size(global.pn_players_list); i++)
	{
		var p = global.pn_players_list[| i];
		if(!ds_map_exists(global.pn_players_checkmap, p))
		{
			//if i quit, leave the lobby
			if(p == global.pn_player_id)
			{
				pn_resolve(global.pn_callback_quit);
				reset();
				exit;
			} 
			else
			{
				pn_resolve(pn_events[pn_event.player_quit], {
					player_id: p, 
					player_name: global.pn_players_map[? p]
				});
			}
			
			ds_list_delete(global.pn_players_list, i--);
			ds_map_delete(global.pn_players_map, p);
		}
	}
	ds_map_clear(global.pn_players_checkmap);
	
	#endregion
	
	#region split messages 
	  
	lines = pn_string_split(r_message, sep_line);
	
	for(var i = 0; i < array_length(lines); i++)
	{  
		var m_data = pn_string_split(lines[i], sep_word);
		
		if(array_length(m_data) != 5) {
			pn_reject(pn_events[pn_event.receive_message], pn_error.wrong_message_format, "decode: wrong message format");
			continue;
		}
		
		global.pn_last_id = real(m_data[0]);
		global.pn_last_date = m_data[1];
		var from = real(m_data[2]);
		var to = real(m_data[3]);
		var packet = m_data[4];
		
		//server message
		if(from == pn_server_message_id)
		{
			if(packet == "pollnet_game_started") 
			{
				pn_resolve(pn_events[pn_event.game_start]);
			}
		}
		//game message, decode it
		else
		{
			var gm_data = pn_string_split(packet, sep_packet);
			
			var msg_id = gm_data[0];
			var type = real(gm_data[1]); 
			  
			switch(type)
			{
				case 0: //TYPE ARRAY				
					//show_debug_message("TYPE ARRAY");
					
					var len = real(gm_data[2]); 
					// fill array
					var message = array_create(len);
					var val;
					for(var j = 0; j < len; j++)
					{
						var sub_type = gm_data[3 + j]; 
						j++; 
						
						if(sub_type == "0"){
							val = string(gm_data[3 + j]); 
						}
						else if(sub_type == "1") {
							val = real(gm_data[3 + j]); 
						}
						else
						{ 
							pn_reject(pn_events[pn_event.receive_message], pn_error.unkown_element_type, "decode: unknown array element type");
							exit;
						}
					
						message[j] = val;
					}
					
					break;
			
				case 1: // TYPE STRING
					//show_debug_message("TYPE STRING");
					message = gm_data[2];
					break;
			
				case 2: // TYPE REAL
					//show_debug_message("TYPE REAL");
					message = real(gm_data[2]);
					break;
			
				default:
					pn_reject(pn_events[pn_event.receive_message], pn_error.unknown_packet_type, "decode: unknown packet type");
					exit;
					break;
			}
					 
			pn_resolve(pn_events[pn_event.receive_message], {
				last_date: global.pn_last_date,
				from: from,
				to: to,
				message_id: msg_id,
				message: message,
			});
		}
	
	}
	#endregion
	
    alarm[0] = receive_interval * game_get_speed(gamespeed_fps);
	exit;
}
#endregion
  
#region join
if (aid == global.pn_request_join)
{
	
	if(status < 0)
	{
		pn_reject(global.pn_callback_join, pn_error.empty_result, "empty join result, check php installation");  
		exit;
	}
	
	if(r_str == "ERROR_LOBBY_FULL") {
		pn_reject(global.pn_callback_join, pn_error.lobby_full, "the lobby is full");
		exit;
	}
	
	if(r_str == "ERROR_GAME_STARTED") {
		pn_reject(global.pn_callback_join, pn_error.lobby_destroyed, "The game does not exits");
		exit;
	}
	
	if(r_str == "ERROR_GAME_STARTED") {
		pn_reject(global.pn_callback_join, pn_error.game_started, "The game already started");
		exit;
	}
	
	var data = pn_string_split(r_str, sep_word);
	var token = data[0];
	var player_id = real(data[1]);
	 
	if(string_length(token) == token_size)
	{
		global.pn_token = token;
		//show_debug_message("join token: " + string(token));
		global.pn_last_id = 0;
		global.pn_last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		global.pn_player_id = real(player_id);
		pn_resolve(global.pn_callback_join, {
			player_id: global.pn_player_id, 
			player_name: global.pn_player_name
		});
		alarm[0] = 1;
	} 
	else
	{
		pn_reject(global.pn_callback_join, pn_error.invalid_token, "Invalid token on join");	
	}
	exit;
} 
#endregion
 
#region host
if (aid == global.pn_request_host)
{
	if(status < 0)
	{ 
		pn_reject(global.pn_callback_host, pn_error.empty_result, "empty host result, check php installation"); 
		exit;
	} 
	
	var data = pn_string_split(r_str, sep_word);
	var token = data[0];
	var player_id = data[1]; 
	
	if(string_length(token) == token_size)
	{
		global.pn_token = token;
		//show_debug_message("host token: " + string(token));
		
		global.pn_last_id = 0;
		global.pn_last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		
		global.pn_player_id = real(player_id);
		global.pn_admin_id = global.pn_player_id;
		
		pn_resolve(global.pn_callback_host, {
			player_id: global.pn_player_id,
			player_name: global.pn_player_name
		});
		alarm[0] = 1;
	}
	else
	{
		pn_reject(global.pn_callback_host, pn_error.invalid_token, "Invalid token on join");	
	}
	exit;
}
#endregion

#region game start

if (aid == global.pn_request_game_start)
{
	if(status < 0)
	{
		pn_reject(global.pn_callback_game_start, pn_error.empty_result, "empty start request result, check php installation"); 
		exit;
	}
	pn_resolve(global.pn_callback_game_start);
	exit;
}

#endregion

#region quit
if (aid == global.pn_request_quit)
{
	if(status < 0)
	{ 
		pn_reject(global.pn_callback_quit, pn_error.empty_result, "empty quit request result, check php installation"); 
		exit;
	}
	pn_resolve(global.pn_callback_quit);
	reset();
	exit;
}
#endregion

#region send
for(var i = 0; i < ds_list_size(global.pn_request_send_list); i++)
{
	var msg = global.pn_request_send_list[| i]
	if (aid == msg.request_id)
	{ 
		if(status < 0)
		{ 
			pn_reject(msg.callback, pn_error.empty_result, "empty send request result, check php installation");
			exit;
		}

		if(r_str == "ERROR_LOBBY_DESTROYED") {
			pn_reject(msg.callback, pn_error.lobby_destroyed, "The game does not exists");
			exit;
		}
		
		pn_resolve(msg.callback);
		exit;
	}
}
#endregion

#region games
if (aid == global.pn_request_lobbies)
{
	//free games list
	ds_list_clear(global.pn_games_list); 
	
	if(status < 0)
	{ 
		pn_reject(global.pn_callback_lobbies, pn_error.empty_result, "empty games list result, check php installation");
		exit;
	}
	
	if(r_str != "0")
	{ 
		var lines = pn_string_split(r_str, sep_line); 
		for(var i = 0; i < array_length(lines); i++)
		{
			var game = ds_list_create();
			var g_data = pn_string_split(lines[i], sep_word);
			
			ds_list_add(global.pn_games_list, {
				game_id: real(g_data[0]),
				admin_id: real(g_data[1]),
				game_name: g_data[2],
				online_players: real(g_data[3]),
				max_players: real(g_data[4])
			});
		}
	}
	
	pn_resolve(global.pn_callback_lobbies, global.pn_games_list);
	exit;
}
#endregion



