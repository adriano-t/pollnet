/// @description split string
/// @param string
/// @param separator

if(string_length(argument0) == 0)
	return array_create(0);
	
var s = argument0;
var sep = argument1;
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

