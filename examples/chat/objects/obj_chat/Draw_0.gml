

//users list area
draw_set_color(c_ltgray);
draw_rectangle(0, 0, 120, room_height -1, 0);

//other players name
for(var i = 0; i < ds_list_size(obj_pollnet.players_list); i++)
{
	var player_id = obj_pollnet.players_list[| i];
	var player_name = obj_pollnet.players_map[? player_id];
	
	if(player_id == obj_pollnet.player_id)
		draw_set_color(c_blue);
	else
		draw_set_color(c_black);
	
	draw_text(10, 32 + 16 * i,  player_name + "[" + string(player_id)+"]");
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
	if(keyboard_string != "") {
		pn_send("chat", all, keyboard_string, function(resp) {
			if(resp.success) {
				var s = "[" + string(obj_pollnet.last_date) + "] <" + string( obj_pollnet.player_name) + "> " + keyboard_string;
				ds_list_add(obj_chat.messages, s);
			} else {
				show_debug_message(resp.error);	
			}
			keyboard_string = "";
		});
	}
}
 
//draw last 28 messages
var count = ds_list_size(messages);
var max_count = 28;
var idx = max(0, count - max_count);
for(var i = idx; i < count; i++)
{
	draw_text(125, 16 + 16 * (i - idx), messages[| i]);
}

if(button_pressed(spr_x, room_width - 32, 0))
{
	pn_quit(function() {
		show_debug_message("You quit the lobby");
	});
}