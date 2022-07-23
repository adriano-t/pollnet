
/// @description creates an http request
/// @param url
/// @param str
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
/// @param str
/// @param separator
/// @return {Array<String>}
/// @hide
function pn_string_split(str, separator) {

	if(string_length(str) == 0)
		return [];
	
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
