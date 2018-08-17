/// @description a player quit
/// @param player id
/// @param player name

var player_id = argument0;
var player_name = argument1; 


//if the host quits, return to the lobby
if(player_id == global.pn_admin_id)
{
	//pn_quit();
}


var online_players = ds_list_size(global.pn_players_list) ;
//if you are alone, quit
if(online_players == 0)
{
	//pn_quit();
}
