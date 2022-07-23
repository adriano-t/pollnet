draw_self();

//change level if dead
if(image_index == image_number -1) 
	room_goto(room_lose);	 

// real sentence
draw_set_halign(fa_center);
draw_text(room_width/2, 40, global.sentence);


// guessing sentence
var s = "";
for(var i = 1; i <= string_length(global.guess); i++)
{
	s += string_char_at(global.guess, i) + " ";
} 
draw_text(room_width/2, 10, s);	
	
draw_text(room_width/3, room_height - 50, "Chosen letters: " + global.letters);	
draw_set_halign(fa_left);
	
	

