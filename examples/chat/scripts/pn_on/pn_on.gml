///@param {Enum.pn_event} event
///@param {Function} callback
function pn_on(event, callback){
	if(real(event) < pn_event.COUNT && is_method(callback))
		obj_pollnet.pn_events[event] = callback;
	else
		show_debug_message("Pollnet Error: Impossible to register event " + string(callback));
}