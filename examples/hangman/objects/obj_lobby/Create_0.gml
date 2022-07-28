draw_set_color(c_black);
draw_set_font(font0);
alarm[0] = game_get_speed(gamespeed_fps) * 3;

 

obj_pollnet.set_config({
	url_root: "https://tizsoft.altervista.org/pollnet/",  //link to the folder containing php files
	game_token: "hangman", //game token (change this for each game or gamemode you create)
	receive_interval: 2, // receive interval in seconds
});

pn_on_event(pn_event.game_start, function(resp) {
	if(resp.success) {
		if(obj_pollnet.is_admin()) {
			instance_create_depth(500, 60, depth, obj_choose_sentence);
		} else {
			with(obj_wait) 
				instance_destroy();
		
			instance_create_depth(500, 60, depth, obj_player);
		}
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_event(pn_event.player_join, function(resp) {
	if(resp.success) {
		show_debug_message("Player joined: " + string(resp.data.player_id) + " | " + string(resp.data.player_name));
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_event(pn_event.player_quit, function(resp) {
	if(resp.success) {
		show_debug_message("Player quit: " + string(resp.data.player_id) + " | " + string(resp.data.player_name));
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});


pn_on_event(pn_event.error, function(resp) {
	show_debug_message(string(resp.error_id) + " | " + string(resp.error));
});

pn_on_event(pn_event.disconnect, function(resp) {
	pn_quit();
});


//game messages

 
pn_on_message("turn", function(resp) {
	if(resp.success) {					
		//resp.data -> {last_date, from, to, message_id, resp.data.message}
		global.turn = resp.data.message;
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_message("letter", function(resp) {
	if(resp.success) {					
		var newguess = check_guess(resp.data.message);
			// no letters found
			if(newguess == global.guess)
			{
				obj_hangman.image_index++;
				pn_send("hang", all, resp.data.message);
			}
		
			// at least 1 letter found
			else
			{ 
				global.guess = newguess;
				pn_send("guess", all, newguess);
			}
		
			// check if he win
			if (global.guess == global.sentence)
			{
				pn_send("win", all, resp.data.from);
			}
		
			//find the player
			var index = ds_list_find_index(obj_pollnet.players_list, resp.data.from);
			var next_index = (index + 1) mod ds_list_size(obj_pollnet.players_list);
			while(next_index == ds_list_find_index(obj_pollnet.players_list, obj_pollnet.player_id))
				next_index = (next_index + 1) mod ds_list_size(obj_pollnet.players_list);
			
			//send next turn
			global.turn = obj_pollnet.players_list[| next_index];
			pn_send("turn", all, global.turn);
		
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_message("guess", function(resp) {
	if(resp.success) {					
		global.guess = resp.data.message;
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_message("hang", function(resp) {
	if(resp.success) {					
		obj_hangman.image_index++;
		global.letters += string(resp.data.message);
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_message("win", function(resp) {
	if(resp.success) {					
		if(resp.data.message == obj_pollnet.player_id)
			global.winner = "You";
		else
			global.winner = obj_pollnet.players_map[? resp.data.message];
		room_goto(room_win);
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_message("lose", function(resp) {
	if(resp.success) {					
		if(resp.data.message == obj_pollnet.player_id) 
			room_goto(room_lose); 
		else
			show_message_async(obj_pollnet.players_map[? resp.data.message] + " tried a solution and lose");
			
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});

pn_on_message("solution", function(resp) {
	if(resp.success) {					
		if(string_upper(resp.data.message) == global.sentence)
		{
			pn_send("win", all, resp.data.from);
			global.winner = obj_pollnet.players_map[? resp.data.from];
			room_goto(room_win);
		}
		else 
			pn_send("lose", all, resp.data.from);
	} else {
		show_debug_message(string(resp.error_id) + " | " + string(resp.error));
	}
});