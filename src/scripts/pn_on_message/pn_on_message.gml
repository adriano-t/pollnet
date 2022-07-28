///@param {String} message_id
///@param {Function} callback
function pn_on_message(message_id, callback){
	if(is_method(callback)) 
	{
		var arr = obj_pollnet.message_events[? message_id];
		if(is_undefined(arr)) {
			arr = [];
			obj_pollnet.message_events[? message_id] = arr;
		}
		array_push(arr, callback);
	}
	else
		show_debug_message("Pollnet Error: Impossible to register event " + string(callback));
}