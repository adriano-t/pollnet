/// @description a player quit
/// @param player_id
/// @param player_name
/// @hide
function pn_on_player_quit(player_id, player_name) {

	if(player_id == global.pn_player_id)
	{
		room_goto(room_start);
		return;
	}


	var online_players = ds_list_size(global.pn_players_list) ;
	//if you are alone, quit
	if(online_players == 0)
	{
		//pn_quit();
	}

}
