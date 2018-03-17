

//users list area
draw_set_color(c_ltgray);
draw_rectangle(0, 0, 120, room_height -1, 0);

//my name
draw_set_color(c_blue);
draw_text(10, 16,  global.pn_username);

//other players name
draw_set_color(c_black);
for(var i = 0; i < ds_list_size(global.pn_players_list); i++)
{
	var player_id = global.pn_players_list[| i];
	var player_name = global.pn_players_map[? player_id];
	
	draw_text(10, 32 + 16 * i,  player_name + "_" + string(player_id));
}


//input area
draw_set_color(c_orange);
draw_rectangle(0, room_height - 30, room_width - 1, room_height -1, 0);
draw_set_color(c_black);
draw_rectangle(0, room_height - 30, room_width - 1, room_height -1, 1); 
draw_set_color(c_black);
draw_text(6, room_height - 25, keyboard_string + caret); 

if(keyboard_check_pressed(vk_enter))
{
	pn_send_all(keyboard_string);
	keyboard_string = "";
}
 
//draw last 20 messages
var count = ds_list_size(messages);
var max_count = 20;
var idx = max(0, count - max_count);
for(var i = idx; i < count; i++)
{
	draw_text(125, 16 + 16 * i, messages[| i]);
}

if(button_pressed(spr_x, room_width - 32, 0))
{
	pn_quit();
}