
//it's my turn
if(global.turn == global.pn_player_id)
{
	
	draw_text(x, y, "Your turn!");
	 
	// send the letter to the host
	if(button_pressed(spr_letter, x, y + 64))
	{
		var s = get_string("Type 1 letter", "");
		if(string_length(s) == 1)
		{
			var letter = string_upper(string_letters(s));
			pn_send("letter", global.pn_admin_id, letter);
			global.turn = noone;
		}
	}
		
	// send the solution to the host
	if(button_pressed(spr_solution, x + 128 + 16, y + 64))
	{
		var s = get_string("Solution (1 attempt remaining)","");
		if(s != "")
		{
			pn_send("solution", global.pn_admin_id, s);
			global.turn = noone;
		}
	}
		 
}
// not my turn
else
{	
	draw_text(x, y, "Waiting for my turn");
}