/// @description check_guess(letter) 
/// @param letter
function check_guess(argument0) {

	var newGuess;

	if(string_length(argument0) == 0)
		newGuess = "";
	else
		newGuess = string_char_at(string_upper(argument0), 1);
	
	var out = "";
	for(var i = 1; i <= string_length(global.guess); i++)
	{
		var g = string_char_at(global.guess, i);
		var s = string_char_at(global.sentence, i);
		if(s == newGuess && g == "_" )
			out += s;
		else
			out += g;		
	}

	return out;


}
