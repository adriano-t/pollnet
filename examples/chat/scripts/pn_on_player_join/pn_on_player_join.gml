/// @description a player joined
/// @param player_id
/// @param player_name
/// @param player_ip
/// @hide
function pn_on_player_join(player_id, player_name, player_ip) {
 
	show_debug_message(player_name + " (" + player_ip + ") joined.");
		
	if(player_id == global.pn_player_id)
		room_goto(room_chat);
	else
		ds_list_add(obj_chat.messages, "*** " + player_name + "*** (" + player_ip + ") joined :)");
	
}
