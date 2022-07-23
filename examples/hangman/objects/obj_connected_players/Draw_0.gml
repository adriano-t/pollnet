
//users list area
draw_set_color(c_ltgray);
draw_rectangle(0, 0, 120, room_height -1, 0);

//my name
draw_set_color(c_maroon);
draw_text(10, 4,  "Players");

draw_set_color(c_black);


//other players name
for(var i = 0; i < ds_list_size(global.pn_players_list); i++)
{
	var player_id = global.pn_players_list[| i];
	var player_name = global.pn_players_map[? player_id];
	
	if(player_id == global.pn_admin_id) 
		draw_set_color(c_blue);
	else 
		draw_set_color(c_black);
	if(global.turn == player_id) 
		draw_text(10, 32 + 16 * i,  " -> " + player_name); 
	else
		draw_text(10, 32 + 16 * i,  player_name); 
	
}
 
draw_set_color(c_black);
// x button to close the game
if(button_pressed(spr_x, room_width - 32, 0))
{
	pn_quit();
}