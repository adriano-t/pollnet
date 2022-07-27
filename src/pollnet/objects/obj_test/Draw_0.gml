current_y = 20;
draw_text(2, 2, self.status);
if(instance_number(obj_pollnet) == 0)
	return;

draw_text_aligned("admin id: " + string(obj_pollnet.admin_id));
if(obj_pollnet.is_admin())
	draw_set_color(c_orange);
draw_text_aligned("player: " + string(obj_pollnet.player_id) + " | " + string(obj_pollnet.player_name));
draw_set_color(c_white);
draw_text_aligned(string(obj_pollnet.game_name) + " (" + string(ds_list_size(obj_pollnet.players_list)) +"/"+string(obj_pollnet.max_players) +")");

for(var i = 0; i < ds_list_size(obj_pollnet.games_list); i++) {
	var game = obj_pollnet.games_list[| i];
	draw_text_aligned(string(game));
}

var names = variable_struct_get_names(tests);
for(var i = 0; i < array_length(names); i++) {
	var name = names[i];
	var status = variable_struct_get(tests, name);
	var status_name = status_names[status];
	if(status_name == "passed")
		draw_set_color(c_green);
	else if(status_name == "failed")
		draw_set_color(c_red);
	else
		draw_set_color(c_white);
	draw_text_aligned(string(name) + ": " + string(status_name));
	
	draw_set_color(c_white);
}