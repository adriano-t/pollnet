/// @description send a message to a specific player or all players
/// @param {Any} message_id
/// @param {Real} to
/// @param {Any} message
/// @param {Function} callback
function pn_send(message_id, to, message, callback = undefined) {

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
				packet += "1" + obj_pollnet.sep_packet + val + obj_pollnet.sep_packet ;
		
			else if(is_real(val)) 
				packet += "2" + obj_pollnet.sep_packet + string(val) + obj_pollnet.sep_packet; 
			
			else
			{
				pn_reject(callback, pn_error.unkown_element_type, "encode: unknown array element type");
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
		pn_reject(callback, pn_error.unknown_packet_type, "encode: unknown array element type");
		return;
	}

	var val = "token=" + global.pn_token;
	if(to > 0)
		val += "&to=" + string(to);
	val += "&message=" + packet; 
	var msgid = pn_http_request(global.pn_url_post, val);
 
	ds_list_add(global.pn_request_send_list, {
		request_id: msgid,
		callback: callback,
	}); 
}