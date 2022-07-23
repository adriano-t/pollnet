draw_text(10, 10, "Games List");

for(var i = 0; i < ds_list_size(global.pn_games_list); i++)
{
	var game = global.pn_games_list[| i];
	var gameid = game[| 0]; 
	var adminid = real(game[| 1]);
	var gamename = game[| 2]; 
	var online_players = real(game[| 3]); 
	var max_players = real(game[| 4]); 
	
	var s = gamename + ": " + string(online_players) + "/" + string(max_players);
	draw_text(50, 30 + 24 * i, s);
	if(button_pressed(spr_join, 10, 30 + 24 * i))
	{
		var u = get_string("Username", "")
		if(u == "")
			exit;
		
		pn_join(game, u);
	}
}