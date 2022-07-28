

if(button_pressed(spr_sentence, x, y))
{
	var s = string_upper(get_string("Type the sentence to guess:", sentence));
	if(s == fix_string(s) && string_length(s) > 3)
	{
		global.sentence = s;

		// generate guess 
		global.guess = "";
		for(var i = 1; i <= string_length(global.sentence); i++)
		{
			var c = string_char_at(global.sentence, i);
			if(c != " ")
				global.guess += "_";
			else
				global.guess += c;
		}
		
		//send the guess to other players 
		pn_send("guess", all, global.guess);

		// it's the turn of the first joined player
		global.turn = obj_pollnet.players_list[| 1];

		// send the turn to all the players
		pn_send("turn", all, global.turn);
	
		instance_destroy();
	}
	else 
	{
		sentence = fix_string(s);
		show_message("Invalid string");
	}
}
	 