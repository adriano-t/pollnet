var aid = ds_map_find_value(async_load, "id");
var status = ds_map_find_value(async_load, "status");
if (status == 1) 
{ 
	show_debug_message("WAITING: Status Receiving packets!");
	exit; 
} 
	
var r_str = ds_map_find_value(async_load, "result");

#region process messages
if (aid == global.pn_request_message)
{
	if(status < 0)
	{
		pn_on_error(1, "empty result from message request"); 
		exit;
	}
	
	
	var split = string_pos(sep_mess, r_str);
	var r_players = string_copy(r_str, 1, split - 1);
	var r_message = string_delete(r_str, 1, split);
	
	#region split players 
	
	var lines = pn_string_split(r_players, sep_line);
	 
	for(var i = 0; i < array_length_1d(lines); i++)
	{  
		var p_data = pn_string_split(lines[i], sep_word);
		var player_id = real(p_data[0]);
		var player_ip = p_data[1];
		var player_name = p_data[2];
		
		ds_map_add(global.pn_players_checkmap, player_id, player_name); 
		//new player joined
		if(!ds_map_exists(global.pn_players_map, player_id))
		{
			ds_map_add(global.pn_players_map, player_id, player_name);
			ds_list_add(global.pn_players_list, player_id);
			pn_on_player_join(player_id, player_name, player_ip);
		}
	}
	 
	
	//players who quit
	for(var i = 0; i < ds_list_size(global.pn_players_list); i++)
	{
		var p = global.pn_players_list[| i];
		if(!ds_map_exists(global.pn_players_checkmap, p))
		{
			pn_on_player_quit(p, global.pn_players_map[? p]);
			ds_list_delete(global.pn_players_list, i--);
			ds_map_delete(global.pn_players_map, p);
		}
	}
	ds_map_clear(global.pn_players_checkmap);
	
	#endregion
	
	#region split messages 
	 
	
	lines = pn_string_split(r_message, sep_line);
	
	for(var i = 0; i < array_length_1d(lines); i++)
	{  
		var m_data = pn_string_split(lines[i], sep_word);
		
		global.pn_last_date = m_data[0];
		var from = real(m_data[1]);
		var to = real(m_data[2]);
		var packet = m_data[3];
		
		//server message
		if(packet == "pollnet_game_started")
		{
			pn_on_game_start();	
		}
		//game message, decode it
		else
		{
			show_debug_message("packet:" + packet);
			var gm_data = pn_string_split(packet, sep_packet);
			
			var msg_id = gm_data[0];
			var type = real(gm_data[1]); 
			  
			switch(type)
			{
				case 0: 
				
					show_debug_message("TYPE ARRAY");
					
					var len = real(gm_data[2]); 
					// fill array
					var message = array_create(len);
					var val;
					for(var j = 0; j < len; j++)
					{
						var sub_type = gm_data[3 + j]; 
						j++; 
						
						if(type == "0") 
							val = string(gm_data[3 + j]); 
						
						else if(type == "1") 
							val = real(gm_data[3 + j]); 
						
						else
						{ 
							pn_on_error(2, "decode: unknown packet type");
							exit;
						}
					
						message[j] = val;
					}
					
					break;
			
				case 1:
					show_debug_message("TYPE STRING");
					message = gm_data[2];
					break;
			
				case 2:
					show_debug_message("TYPE REAL");
					message = real(gm_data[2]);
					break;
			
				default:
					pn_on_error(3, "decode: unknown packet type (2)"); 
					exit;
					break;
			}
			
			pn_on_receive(global.pn_last_date, from, to, msg_id, message);
		}
	
	}
	#endregion
	
    alarm[0] = receive_interval * room_speed;
} 
#endregion
  
#region join
if (aid == global.pn_request_join)
{
	
	if(status < 0)
	{
		pn_on_error(4, "empty join result, check php installation");  
		exit;
	}
	
	var data = pn_string_split(r_str, sep_word);
	var token = data[0];
	var player_id = real(data[1]);
	var admin_ip = data[2];
	 
	  
	if(string_length(token) == token_size)
	{
		global.pn_token = token;
		show_debug_message("join token: " + token);
		global.pn_last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		global.pn_player_id = real(player_id);
		pn_on_join(admin_ip);
		alarm[0] = 1;
	}
	
} 
#endregion
 
#region host
if (aid == global.pn_request_host)
{
	if(status < 0)
	{ 
		pn_on_error(5, "empty host result, check php installation"); 
		exit;
	} 
	var data = pn_string_split(r_str, sep_word);
	var token = data[0];
	var player_id = data[1]; 
	
	if(string_length(token) == token_size)
	{
		global.pn_token = token;
		show_debug_message("host token: " + token);
		
		global.pn_last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		
		global.pn_player_id = real(player_id);
		global.pn_admin_id = global.pn_player_id;
		
		pn_on_host();
		alarm[0] = 1;
	}
	
}
#endregion

#region game start

if (aid == global.pn_request_game_start)
{
	if(status < 0)
	{
		pn_on_error(6, "empty start request result, check php installation"); 
		exit;
	}
	
	pn_on_game_start();
}

#endregion

#region quit
if (aid == global.pn_request_quit)
{
	if(status < 0)
	{ 
		pn_on_error(7, "empty quit request result, check php installation"); 
		exit;
	}
	pn_on_quit();
	 
	for(var i = 0; i < ds_list_size(global.pn_request_send_list); i++)
		ds_list_destroy(global.pn_request_send_list[| i]);
	ds_list_clear(global.pn_request_send_list);
	ds_map_clear(global.pn_players_checkmap);
	ds_map_clear(global.pn_players_map);
	ds_list_clear(global.pn_players_list);
	global.pn_request_create = -1;
	global.pn_request_host = -1;
	global.pn_request_join = -1;
	global.pn_request_game_start = -1;
	global.pn_request_quit = -1;
	global.pn_request_games = -1; 
	global.pn_request_message = -1;
}
#endregion

#region send
for(var i = 0; i < ds_list_size(global.pn_request_send_list); i++)
{
	var msg = global.pn_request_send_list[| i]
	if (aid == msg[| 0])
	{ 
		if(status < 0)
		{ 
			pn_on_error(8, "empty send request result, check php installation");
			exit;
		}
	
		if(string_length(r_str) > 0) 
			pn_on_send(msg[| 1], msg[| 2], msg[| 3]); 
		else
			show_debug_message("error, can't send message: " + string(aid));
		ds_list_destroy(msg);
		ds_list_delete(global.pn_request_send_list, i--);
	}
}
#endregion

#region games
if (aid == global.pn_request_games)
{
	//free games list
	for(var i = 0; i < ds_list_size(global.pn_games_list); i++) 
		ds_list_destroy(global.pn_games_list[| i]); 
	ds_list_clear(global.pn_games_list); 
	
	if(status < 0)
	{ 
		pn_on_error(9, "empty games list result, check php installation");
		exit;
	}
	
	if(r_str != "0")
	{ 
		var lines = pn_string_split(r_str, sep_line); 
		for(var i = 0; i < array_length_1d(lines); i++)
		{
			var game = ds_list_create();
			var g_data = pn_string_split(lines[i], sep_word);
			
			var gameid = real(g_data[0]);
			ds_list_add(game, gameid); 
		
			var admin_id = real(g_data[1]);
			ds_list_add(game, admin_id); 
		
			var game_name = g_data[2];
			ds_list_add(game, game_name); 
		
			var online_players = real(g_data[3]);
			ds_list_add(game, online_players); 
		
			var max_players = real(g_data[4]);
			ds_list_add(game, max_players); 
		
			ds_list_add(global.pn_games_list, game);
		}
	}
	
	pn_on_games_list(global.pn_games_list);
}
#endregion



