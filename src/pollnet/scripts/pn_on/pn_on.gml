///@param {Real} event
///@param {Function} callback
function pn_on_event(event, callback){
	if(event < pn_event.COUNT && is_method(callback))
		obj_pollnet.events_list[event] = callback;
	else
		show_debug_message("Pollnet Error: Impossible to register event " + string(callback));
}