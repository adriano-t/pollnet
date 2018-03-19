/// @description send a message to all the players
/// @param message_id
/// @param message 

var packet = string(argument0) + chr(10);

if(is_array(argument1))
{
	packet += "0";
	var len = array_length_1d(argument1);
	packet += string(len) + chr(10);
	for(var i = 0; i < len; i++)
	{
		var val = argument1[i];
		
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

else if(is_string(argument1)) 
	packet += "1" + argument1; 
	
else if(is_real(argument1)) 
	packet += "2" + string(argument1); 
	
else
{
	show_debug_message("ERROR!!! : Can't send this data type");	
	return;
}

var val = "token=" + global.pn_token;
val += "&message=" + packet; 
var msgid = http_post_string(global.pn_post, val);
 
var l = ds_list_create();
ds_list_add(l, msgid);
ds_list_add(l, argument0);
ds_list_add(l, -1);
ds_list_add(l, argument1);
ds_list_add(global.pn_request_send_list, l); 