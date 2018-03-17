/// @description send a message to a specific player
/// @param to
/// @param message
 
var val = "token=" + global.pn_token;
val += "&to=" + string(argument0);
val += "&message=" + string(argument1); 
var msgid = http_post_string(global.pn_post, val);

var l = ds_list_create();
ds_list_add(l, msgid);
ds_list_add(l, argument0);
ds_list_add(l, argument1);
ds_list_add(global.pn_request_send_list, l); 