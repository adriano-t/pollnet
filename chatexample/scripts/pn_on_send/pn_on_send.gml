/// @description called when a message has been sent
/// @param message_id
/// @param to
/// @param message

var message_id = argument0;
var to = argument1;
var message = argument2;


var s = "<" + global.pn_username + "> " + message;

ds_list_add(obj_chat.messages, s);
 