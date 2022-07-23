/// @description button_pressed(sprite, x, y) 
/// @param sprite
/// @param x
/// @param y 
function button_pressed(argument0, argument1, argument2) {
	var s = argument0;
	var px = argument1;
	var py = argument2;
	var sub =  0;
	var sw = sprite_get_width(s);
	var sh = sprite_get_height(s);
	if(mouse_x > px && mouse_x < px + sw && mouse_y > py && mouse_y < py + sh)
		sub = 1;

	if(!sub)
		draw_sprite_ext(s, sub, px, py, 1, 1, 0, c_ltgray, 1);
	else
		draw_sprite_ext(s, sub, px, py, 1, 1, 0, c_white, 1);

	return sub && mouse_check_button_pressed(mb_left);


}
