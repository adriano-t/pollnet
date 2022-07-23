draw_self();

draw_text(room_width/2, room_height/2, global.winner + " win!");

if(button_pressed(spr_x, room_width - 32, 0))
{
	pn_quit();
}