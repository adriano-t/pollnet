
if(button_pressed(spr_host, x, y))
{
	
	var u = get_string("nickname", "") 
	if(u == "")
		exit;
		
	var s = get_string("server name", u) 
	if(s == "")
		exit;


	pn_host(s, u, 4, function(resp) {
		if(resp.success) {
			room_goto(room_game);
		} else {
			show_debug_message(resp.error_id + "|" + resp.error);
		}
	});
}
