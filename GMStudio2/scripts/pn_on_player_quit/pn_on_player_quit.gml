/// @description a player quit
/// @param player id
/// @param player name

var player_id = argument0;
var player_name = argument1; 

ds_list_add(obj_chat.messages, "*** " + player_name + " quit :(");