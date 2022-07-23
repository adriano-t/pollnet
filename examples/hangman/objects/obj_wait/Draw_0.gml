var online_players = ds_list_size(global.pn_players_list) + 1;

draw_text(x, y,"Waiting for players");	


// admin can start a game if there are at least 2 players
if(global.pn_player_id == global.pn_admin_id && online_players >= 2)
{
	if(button_pressed(spr_start, x, y + 64))
	{
		pn_game_start();
		instance_destroy();
	}
}