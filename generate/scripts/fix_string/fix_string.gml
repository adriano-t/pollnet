/// @description fix_string(string) 
/// @param string
var allowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";

var s = "";
argument0 = string_upper(argument0);
for(var i = 1; i <= string_length(argument0); i++)
{
	var c  = string_char_at(argument0, i);
	if (string_pos(c, allowed) > 0)
		s += c;
}

return s;