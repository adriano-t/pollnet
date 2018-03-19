/// @description send a message to a specific player
/// @param message_id
/// @param to
/// @param message

var packet = string(argument0) + chr(10);

if(is_array(argument2))
{
	packet += "0";
	var len = array_length_1d(argument2);
	packet += string(len) + chr(10);
	for(var i = 0; i < len; i++)
	{
		var val = argument2[i];
		
		if(is_string(val)) 
			packet += "1" + val + chr(10);
		
		else if(is_real(val)) 
			packet += "2" + string(val) + chr(10); 
			
		else
		{
			show_debug_message("ERROR!!! : Can't send this data type");	
			return;
		}
	}
}

else if(is_string(argument2)) 
	packet += "1" + argument2; 
	
else if(is_real(argument2)) 
	packet += "2" + string(argument2); 
	
else
{
	show_debug_message("ERROR!!! : Can't send this data type");	
	return;
}

var val = "token=" + global.pn_token;
if(argument1 > 0)
	val += "&to=" + string(argument1);
val += "&message=" + packet; 
var msgid = http_post_string(global.pn_post, val);
 
var l = ds_list_create();
ds_list_add(l, msgid);
ds_list_add(l, argument0);
ds_list_add(l, argument1);
ds_list_add(l, argument2);
ds_list_add(global.pn_request_send_list, l); 