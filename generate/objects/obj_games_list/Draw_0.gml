draw_text(10, 10, "Games List");

for(var i = 0; i < ds_list_size(global.pn_games_list); i++)
{
	var game = global.pn_games_list[| i];
	
	// get game info
	var gameid = game[| 0];
	var admin_id = game[| 1];
	var gamename = game[| 2];
	var online_players = game[| 3];
	var max_players = game[| 4];
	
	//draw game info
	var s = gamename + ": " + string(online_players) + "/" + string(max_players);
	draw_text(50, 30 + 24 * i, s);
	
	// draw join button
	if(button_pressed(spr_join, 10, 35 + 24 * i))
	{
		var u = get_string("Username", "")
		if(u == "")
			exit;
		
		pn_join(game, u);
	}
}