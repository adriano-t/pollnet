draw_text(10, 10, "Games List");

for(var i = 0; i < ds_list_size(obj_pollnet.games_list); i++)
{
	var game = obj_pollnet.games_list[| i]; 
	
	var s = game.game_name + ": " + string(game.online_players) + "/" + string(game.max_players);
	draw_text(50, 30 + 24 * i, s);
	if(button_pressed(spr_join, 10, 30 + 24 * i))
	{
		var u = get_string("Username", "")
		if(u == "")
			exit;
		
		pn_join(game, u, function(resp){
			if(resp.success) {
				room_goto(room_chat);
			}
			else {
				show_debug_message(resp.error);
			}
		});
	}
}