draw_text(10, 10, "Games List");

for(var i = 0; i < ds_list_size(obj_pollnet.games_list); i++)
{
	var game = obj_pollnet.games_list[| i];
	
	// get game info
	var gameid = game.game_id;
	var admin_id = game.admin_id;
	var gamename = game.game_name;
	var online_players = game.online_players;
	var max_players = game.max_players;
	
	//draw game info
	var s = gamename + ": " + string(online_players) + "/" + string(max_players);
	draw_text(50, 30 + 24 * i, s);
	
	// draw join button
	if(button_pressed(spr_join, 10, 35 + 24 * i))
	{
		var u = get_string("Username", "")
		if(u == "")
			exit;
		
		pn_join(game, u, function(resp) {
			if(resp.success) {
				room_goto(room_game);
			} else {
				show_debug_message(resp.error_id + "|" + resp.error);
			}
		});
	}
}