/// @description process a received message
/// @param date
/// @param from
/// @param is_private
/// @param message

var date = argument0;
var from = argument1;
var is_private = argument2;
var message = argument3;

var player = global.pn_players_map[? from];
var s = "[" + date + "] <" + player + "> " + message;
if(is_private)
	s = "PRIVATE | " + s;
	
ds_list_add(obj_chat.messages, s);
 