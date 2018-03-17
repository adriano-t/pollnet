var aid = ds_map_find_value(async_load, "id");
var status = ds_map_find_value(async_load, "status");
if (status == 1) 
{ 
	show_debug_message("WAITING: Status Receiving packets!");
	exit; 
} 
	
var r_str = ds_map_find_value(async_load, "result");
show_debug_message("received" + string(aid));
#region process messages
if (aid == global.pn_request_message)
{
	if(status < 0)
	{ 
		show_debug_message("NO MESSAGES AND NO PLAYERS CONNECTED"); 
		exit;
	}
	
	
	var line, wd, ld; 
	
	var split = string_pos(sep_mess, r_str);
	var r_players = string_copy(r_str, 1, split - 1);
	var r_message = string_delete(r_str, 1, split);
	
	#region split players 
	
	var player_id, player_name;
	
	ld = string_pos(sep_line, r_players);  
	while(ld)
	{
		line = string_copy(r_players, 1, ld - 1);
		r_players = string_delete(r_players, 1, ld);
		ld = string_pos(sep_line, r_players);  
		// id
		wd = string_pos(sep_word, line);
		player_id = real(string_copy(line, 1, wd - 1));
		line = string_delete(line, 1, wd);
	  
		// name
		wd = string_pos(sep_word, line);
		player_name = string_copy(line, 1, wd - 1); 
		line = string_delete(line, 1, wd);
		
		ds_map_add(global.pn_players_checkmap, player_id, player_name); 
		//new player joined
		if(!ds_map_exists(global.pn_players_map, player_id))
		{
			ds_map_add(global.pn_players_map, player_id, player_name);
			ds_list_add(global.pn_players_list, player_id);
			pn_on_player_join(player_id, player_name);
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
	
	var from, to, message;
	
	ld = string_pos(sep_line, r_message); 
	while(ld)
	{
		line = string_copy(r_message, 1, ld - 1);
		r_message = string_delete(r_message, 1, ld);
		ld = string_pos(sep_line, r_message); 
	
		// date
		wd = string_pos(sep_word, line);
		global.pn_last_date = string_copy(line, 1, wd - 1);
		line = string_delete(line, 1, wd);
	  
		// from
		wd = string_pos(sep_word, line);
		from = real(string_copy(line, 1, wd - 1)); 
		line = string_delete(line, 1, wd);
	 
		// to
		wd = string_pos(sep_word, line);
		to = string_length(string_copy(line, 1, wd - 1)) > 0; 
		line = string_delete(line, 1, wd);
	 
		// message
		wd = string_pos(sep_word, line);
		message = string_copy(line, 1, wd - 1); 
		line = string_delete(line, 1, wd);
	
		pn_on_receive(global.pn_last_date, from, to, message); 
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
		show_debug_message("EMPTY JOIN RESULT"); 
		exit;
	}
	
	if(string_length(r_str) == token_size)
	{
		global.pn_token = r_str;
		show_debug_message("join token: " + r_str);
		global.pn_last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		pn_on_join();
		alarm[0] = 1;
	}
} 
#endregion
 

#region host
if (aid == global.pn_request_host)
{
	if(status < 0)
	{ 
		show_debug_message("EMPTY HOST RESULT "); 
		exit;
	}
	
	if(string_length(r_str) == token_size)
	{
		global.pn_token = r_str;
		show_debug_message("host token: " + r_str);
		
		global.pn_last_date = string(current_year) + "-" + string(current_month) + "-" + string(current_day) + " " +
		string(current_hour) + "-" + string(current_minute) + "-" + string(current_second);
		
		pn_on_host();
		alarm[0] = 1;
	}
}
#endregion

#region quit
if (aid == global.pn_request_quit)
{
	if(status < 0)
	{ 
		show_debug_message("EMPTY QUIT RESULT"); 
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
	global.pn_request_join = -1;
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
			show_debug_message("EMPTY SEND RESULT"); 
			exit;
		}
	
		if(string_length(r_str) > 0) 
			pn_on_send(msg[| 1], msg[| 2]); 
		else
			show_debug_message("error, can't send message: " + string(id));
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
		show_debug_message("EMPTY GAMES LIST"); 
		exit;
	}
	
	var game, gameid, gamename, online_players, max_players;
	
	ld = string_pos(sep_line, r_str); 
	while(ld)
	{ 
		game = ds_list_create();
		line = string_copy(r_str, 1, ld - 1); 
		r_str = string_delete(r_str, 1, ld);
		ld = string_pos(sep_line, r_str);  
	
		// game id
		wd = string_pos(sep_word, line);
		gameid = real(string_copy(line, 1, wd - 1));
		line = string_delete(line, 1, wd);
		ds_list_add(game, gameid);
		
		// game name
		wd = string_pos(sep_word, line);
		gamename = string_copy(line, 1, wd - 1);
		line = string_delete(line, 1, wd);
		ds_list_add(game, gamename);
		
		// online players
		wd = string_pos(sep_word, line);
		online_players = real(string_copy(line, 1, wd - 1));
		line = string_delete(line, 1, wd);
		ds_list_add(game, online_players);
		
		// max players
		wd = string_pos(sep_word, line);
		max_players = real(string_copy(line, 1, wd - 1));
		line = string_delete(line, 1, wd);
		ds_list_add(game, max_players);
		
		ds_list_add(global.pn_games_list, game);
	}
	pn_on_gameslist(global.pn_games_list);
}
#endregion


