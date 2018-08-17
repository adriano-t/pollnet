/// @description split string
/// @param string
/// @param separator

var s = argument0;
var sep = argument1;
var count = string_count(sep, s);
var result = array_create(count);

var p;
for(var i = 0; i < count; i++)
{
	p = string_pos(sep, s);
	result[i] = string_copy(s, 1, p - 1);
	s = string_delete(s, 1, p);	
}

return result;
