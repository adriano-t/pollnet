/// @description a message has been sent
/// @param to
/// @param message

var to = argument0;
var message = argument1;


var s = "<" + global.pn_username + "> " + message;

ds_list_add(obj_chat.messages, s);
 