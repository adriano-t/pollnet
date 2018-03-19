/// @description process a received message
/// @param date
/// @param from
/// @param is_private
/// @param message_id
/// @param message

var date = argument0;
var sender_id = argument1;
var sender_name = global.pn_players_map[? sender_id];
var is_private = argument2;
var message_id = argument3;
var message = argument4;
 
 
 switch(message_id)
 {
	 case "chat":
 
		var s = "[" + date + "] <" + sender_name + "> " + message;
		if(is_private)
			s = "PRIVATE | " + s;
		ds_list_add(obj_chat.messages, s);
		
		break;
		
	// you can add more message types
	//case "reaction" 
	//	break;
} 
	
 