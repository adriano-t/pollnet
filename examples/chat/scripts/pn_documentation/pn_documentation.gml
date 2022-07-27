/*

===========================
= REGISTER EVENTS
===========================

pn_on(pn_event.game_start, function(resp) {
	if(resp.success) 
	{
		//the game has started
	} 
	else 
	{
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on(pn_event.player_join, function(resp) {
	if(resp.success) 
	{
		show_debug_message("Player joined: " + string(resp.data.player_id) + " | " + string(resp.data.player_name));
	} 
	else 
	{
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on(pn_event.player_quit, function(resp) {
	if(resp.success) 
	{
		show_debug_message("Player quit: " + string(resp.data.player_id) + " | " + string(resp.data.player_name));
	} 
	else 
	{
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on(pn_event.receive_message, function(resp) {
	if(resp.success) 
	{
		var data = resp.data;
		//data.last_date
		//data.from
		//data.to
		//data.message_id
		//data.message
		show_debug_message(string(data.from) + ": " + string(data.message_id) + " | " +  string(data.message));
	} 
	else 
	{
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on(pn_event.error, function(resp) {
	show_debug_message(string(resp.error_id) + " | " + string(resp.error));
});

*/