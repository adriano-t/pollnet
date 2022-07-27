


obj_pollnet.set_config({
	url_root: "https://tizsoft.altervista.org/pollnet/",  //link to the folder containing php files
	game_token: "test", //game token (change this for each game or gamemode you create)
	receive_interval: 2, // receive interval in seconds
});

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
	show_debug_message("POLLNET ERROR: " + string(resp.error_id) + " | " + string(resp.error));
});

pn_on(pn_event.disconnect, function(resp) {
	pn_quit();
	show_debug_message("DISCONNECTED: " + string(resp.error_id) + " | " + string(resp.error));
	
	self.status = "DISCONNECTED: " + string(resp.error_id) + " | " + string(resp.error);
});


enum test_status {
	running,
	passed,
	failed,
}
status_names = [
	"running",
	"passed",
	"failed"
]

tests = {
	join: test_status.running,
	host: test_status.running,
	send_real: test_status.running,
	send_string: test_status.running,
	send_array: test_status.running,
	recv_real: test_status.running,
	recv_string: test_status.running,
	recv_array: test_status.running,
}

self.status = "searching for a game";
current_y = 10;
increment_y = 14;
draw_text_aligned = function(text, x = 10) {
	draw_text(x, current_y, string(text));
	current_y += increment_y;
}

handle_lobbies = function(resp){
	if(resp.success) 
	{
		show_debug_message("received lobbies");
		if(obj_pollnet.player_id == -1)
			self.alarm[1] = game_get_speed(gamespeed_fps) * 3;
	} 
	else 
	{
		show_debug_message(resp.message);	
	}
}
pn_get_lobbies(handle_lobbies);

search_times = 0;
alarm[0] = game_get_speed(gamespeed_fps) * 3;