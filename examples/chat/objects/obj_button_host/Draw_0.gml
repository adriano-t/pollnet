
if(button_pressed(spr_host, x, y))
{
	var s = get_string("server name", "") 
	if(s == "")
		exit;

	var u = get_string("nickname", "") 
	if(u == "")
		exit;

	var p = get_integer("max players", 2) 
	if(p < 2)
		exit;

	pn_host(s, u, p);
}
