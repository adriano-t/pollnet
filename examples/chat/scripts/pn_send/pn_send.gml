/// @description send a message to a specific player or all players
/// @param message_id
/// @param to
/// @param message
function pn_send(message_id, to, message) {
 
	var packet = string(message_id) + obj_pollnet.sep_packet;

	if(is_array(message))
	{
		packet += "0" + obj_pollnet.sep_packet;
		var len = array_length(message);
		packet += string(len) + obj_pollnet.sep_packet;
		for(var i = 0; i < len; i++)
		{
			var val = message[i];
		
			if(is_string(val)) 
				packet += "1" + obj_pollnet.sep_packet +  val + obj_pollnet.sep_packet;
		
			else if(is_real(val)) 
				packet += "2" + obj_pollnet.sep_packet + string(val) + obj_pollnet.sep_packet; 
			
			else
			{
				pn_on_error(pn_error.data_type, "Can't send this data type");
				return;
			}
		}
	}

	else if(is_string(message)) 
		packet += "1" + obj_pollnet.sep_packet +  message; 
	
	else if(is_real(message)) 
		packet += "2" + obj_pollnet.sep_packet + string(message); 
	
	else
	{
		pn_on_error(pn_error.data_type, "Can't send this data type");
		return;
	}

	var val = "token=" + global.pn_token;
	if(to > 0)
		val += "&to=" + string(to);
	val += "&message=" + packet; 
	var msgid = pn_http_request(global.pn_url_post, val);
 
	var l = ds_list_create();
	ds_list_add(l, msgid);
	ds_list_add(l, message_id);
	ds_list_add(l, to);
	ds_list_add(l, message);
	ds_list_add(global.pn_request_send_list, l); 

}
