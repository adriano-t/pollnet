draw_text(10, 10, "Into our town the Hangman came,\nSmelling of gold and blood and flame.\nAnd he paced our bricks with a diffident air,\n And built his frame on the courthouse square.");
draw_self();

if(button_pressed(spr_x, room_width - 32, 0))
{
	pn_quit();
}