/// @description a player joined
/// @param player_id
/// @param player_name

var player_id = argument0;
var player_name = argument1; 

show_debug_message(string(player_id) + ": " + player_name + " ONJOIN");


ds_list_add(obj_chat.messages, "*** " + player_name + " joined :)");
 