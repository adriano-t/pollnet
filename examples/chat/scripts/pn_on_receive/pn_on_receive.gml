/// @description process a received message
/// @param date
/// @param sender_id
/// @param is_private
/// @param message_id
/// @param message
/// @hide
function pn_on_receive(date, sender_id, is_private, message_id, message) {

	var sender_name = global.pn_players_map[? sender_id];
 
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
	
}
