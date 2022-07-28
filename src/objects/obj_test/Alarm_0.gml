/// @description auto join


pn_join_auto(string(current_time), function(resp) {
	if(resp.success) 
	{
		tests.join = test_status.passed;
		tests.host = test_status.passed;
		tests.recv_game = test_status.running;
		self.status = "joined a lobby"	
	} 
	else
	{
		show_debug_message(resp.error);
		if(resp.error_id == pn_error.lobby_not_found) 
		{			
			tests.join = test_status.passed;
			pn_host("lobby " + string(current_time), "user" + string(current_time), 2, function(resp) {
				if(resp.success) 
				{
					tests.host = test_status.passed;
					self.status = "created a lobby, sending start game";
					tests.send_game = test_status.running;
				} 
				else
				{
					self.status = "failed to host: " + string(resp.error);
				}
			})	
		}
		else 
		{
			tests.join = test_status.failed;				
			self.status = "failed to join: " + string(resp.error);
		}
	}
});
self.status = "trying to join";
	
	//search_times++;
	//if(search_times < 2) {
	//	alarm[0] = game_get_speed(gamespeed_fps);	
	//	self.status = "searching for a game";
	//}
