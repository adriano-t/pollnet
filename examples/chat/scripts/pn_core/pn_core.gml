
/// @description creates an http request
/// @param {String} url
/// @param {String} str
/// @returns {Real}
/// @hide
function pn_http_request(url, str){
	var map = ds_map_create();
	//ds_map_add(map, "Connection", "keep-alive");
	//ds_map_add(map, "Cache-Control", "max-age=0");
	ds_map_add(map, "Content-Type", "application/x-www-form-urlencoded");
	return http_request(url, "POST", map, str);
}


/// @description split string
/// @param {String} str
/// @param {String} separator
/// @return {Array<String>}
/// @hide
function pn_string_split(str, separator) {

	if(string_length(str) == 0)
		return [""];
	
	var s = str;
	var sep = separator;
	var count = string_count(sep, s);
	var result = array_create(count);
	if(count == 0)
	{
		result[0] = s;
		return result;
	}

	var p, i;

	for(i = 0; i < count; i++)
	{
		p = string_pos(sep, s);
		result[i] = string_copy(s, 1, p - 1);
		s = string_delete(s, 1, p);	
	}
	if(string_length(s) > 0)
		result[i] = s;
	
	return result;
}


/// @param {Function} callback
/// @param {Any} data
/// @hide
function pn_resolve(callback, data = undefined) {
	if(is_method(callback))
		callback({success: true, data: data});
}

/// @param {Function} callback
/// @param {Real} error_id
/// @param {String} error
/// @hide
function pn_reject(callback, error_id, error) {
	if(is_method(callback))
		callback({success: false, error_id: error_id, error: error});
	else if(is_method(obj_pollnet.pn_events[pn_event.error]))
		obj_pollnet.pn_events[pn_event.error](error_id, error);
}