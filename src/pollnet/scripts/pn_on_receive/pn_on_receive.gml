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
		// you can add more message types
		//case "my-message-id" 
		//	break;
	} 
	
}
