function setup_events(){
	
	obj_pollnet.set_config({
		url_root: "https://tizsoft.altervista.org/pollnet",  //link to the folder containing php files
		game_token: "chat", //game token (change this for each game or gamemode you create)
		receive_interval: 2, // receive interval in seconds
	});
	
	pn_on_event(pn_event.game_start, function(resp) {
		
		if(resp.success) 
		{
			//the game has started
		} 
		else 
		{
			show_debug_message(string(resp.error_id) + " | " + string(resp.error));
		}
	});

	pn_on_event(pn_event.player_join, function(resp) {
		if(resp.success) 
		{
			show_debug_message("Player joined: " + string(resp.data.player_id) + " | " + string(resp.data.player_name));
			ds_list_add(obj_chat.messages, "*** " + string(resp.data.player_id) + "*** (" +  string(resp.data.player_name) + ") joined :)");
		
		} 
		else 
		{
			show_debug_message(string(resp.error_id) + " | " + string(resp.error));
		}
	});

	pn_on_event(pn_event.player_quit, function(resp) {
		if(resp.success) 
		{
			ds_list_add(obj_chat.messages, "*** " + string(resp.data.player_id) + "*** (" +  string(resp.data.player_name) + ") left :)");
		
			show_debug_message("Player quit: " + string(resp.data.player_id) + " | " + string(resp.data.player_name));
		} 
		else 
		{
			show_debug_message(string(resp.error_id) + " | " + string(resp.error));
		}
	});

	pn_on_message("chat", function(resp) {
		show_debug_message(resp);
		if(resp.success) 
		{
			var data = resp.data;
			var sender_name = obj_pollnet.players_map[? data.from];
			var s = "[" + string(data.last_date) + "] <" + string(sender_name) + "> " + string(data.message);
			ds_list_add(obj_chat.messages, s);
		 
			show_debug_message(string(data.from) + ": " + string(data.message_id) + " | " +  string(data.message));
		} 
		else 
		{
			show_debug_message(string(resp.error_id) + " | " + string(resp.error));
		}
	});

	pn_on_event(pn_event.error, function(resp) {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	});
	
	
	pn_on_event(pn_event.disconnect, function(resp) {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	});
}