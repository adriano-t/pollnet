


obj_pollnet.set_config({
	url_root: "https://tizsoft.altervista.org/pollnet/",  //link to the folder containing php files
	game_token: "test", //game token (change this for each game or gamemode you create)
	receive_interval: 2, // receive interval in seconds
});

pn_on_event(pn_event.game_start, function(resp) {
	if(obj_pollnet.is_admin())
		return;
	if(resp.success) {
		tests.recv_game = test_status.passed;
		self.status = "client: game started";
		
		tests.recv_array = test_status.running;
		tests.recv_real = test_status.running;
		tests.recv_string = test_status.running;
	} else {
		self.status = "failed to start game: " + string(resp.error);
		tests.recv_game = test_status.passed;	
	}
});

pn_on_event(pn_event.player_join, function(resp) {
	if(!obj_pollnet.is_admin())
		return;
	if(resp.success) 
	{
		show_debug_message("Player joined: " + string(resp.data.player_id) + " | " + string(resp.data.player_name));
		pn_game_start(function(resp) {
			if(resp.success) {
				tests.send_game = test_status.passed;
				self.status = "host: game started";
				
				tests.send_array = test_status.running;
				tests.send_real = test_status.running;
				tests.send_string = test_status.running;
				
				pn_send("real", all, 3.141500001, function(resp) {
					show_debug_message("send real" + string(resp));
					if(resp.success) {
						tests.send_real = test_status.passed;
					} else {
						tests.send_real = test_status.failed;						
					}
				});
				
				var s = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
				pn_send("string", all, s, function(resp) {
					show_debug_message("send string" + string(resp));
					if(resp.success) {
						tests.send_string = test_status.passed;
					} else {
						tests.send_string = test_status.failed;						
					}
				});
				
				var a = [9876543210.0123456789, "QWERTYUIOPqwertyuiop"];
				pn_send("array", all, a, function(resp) {
					show_debug_message("send array" + string(resp));
					if(resp.success) {
						tests.send_array = test_status.passed;
					} else {
						tests.send_array = test_status.failed;						
					}
				});
				
			} else {
				self.status = "failed to start game: " + string(resp.error);
				tests.send_game = test_status.passed;	
			}
		});
	}
	else 
	{
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_event(pn_event.player_quit, function(resp) {
	if(resp.success) 
	{
		show_debug_message("Player quit: " + string(resp.data.player_id) + " | " + string(resp.data.player_name));
	} 
	else 
	{
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_message("real", function(resp) {
	
	if(resp.success) {
		var data = resp.data; //data = {last_date, from, to, message_id, message}
		if(data.message == 3.141500001)
			tests.recv_real = test_status.passed;
		else
			tests.recv_real = test_status.failed;
		
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
		tests.recv_real = test_status.failed;
	}
});


pn_on_message("string", function(resp) {
	if(resp.success) {					
		if(resp.data.message == " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")
			tests.recv_string = test_status.passed;
		else
			tests.recv_string = test_status.failed; 
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
		tests.recv_string = test_status.failed; 
	}
});


pn_on_message("array", function(resp) {
	if(resp.success) {				
		var arr = resp.data.message;
		if(arr[0] == 9876543210.0123456789 && arr[1] == "QWERTYUIOPqwertyuiop")
			tests.recv_array = test_status.passed;
		else {
			tests.recv_array = test_status.failed;
			show_debug_message(arr)
		}
	} else {
			tests.recv_array = test_status.failed;
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_event(pn_event.error, function(resp) {
	show_debug_message("POLLNET ERROR: " + string(resp.error_id) + " | " + string(resp.error));
});

pn_on_event(pn_event.disconnect, function(resp) {
	pn_quit();
	show_debug_message("DISCONNECTED: " + string(resp.error_id) + " | " + string(resp.error));
	
	self.status = "DISCONNECTED: " + string(resp.error_id) + " | " + string(resp.error);
});


enum test_status {
	waiting,
	running,
	passed,
	failed,
}
status_names = [
	"",
	"running",
	"passed",
	"failed"
]

tests = {
	join: test_status.running,
	host: test_status.running,
	send_real: test_status.waiting,
	send_string: test_status.waiting,
	send_array: test_status.waiting,
	send_game: test_status.waiting,
	recv_real: test_status.waiting,
	recv_string: test_status.waiting,
	recv_array: test_status.waiting,
	recv_game: test_status.waiting,
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