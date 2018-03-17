/// @description send a message to all the players
/// @param message
  
var val = "token=" + global.pn_token; 
val += "&message=" + string(argument0); 
var msgid = http_post_string(global.pn_post, val);

var l = ds_list_create();
ds_list_add(l, msgid);
ds_list_add(l, -1);
ds_list_add(l, argument0);
ds_list_add(global.pn_request_send_list, l); 