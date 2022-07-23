/// @description process a received message
/// @param date
/// @param sender_id
/// @param is_private
/// @param message_id
/// @param {Any} message
/// @hide
function pn_on_receive(date, sender_id, is_private, message_id, message) {

	var sender_name = global.pn_players_map[? sender_id];
 
	switch(message_id)
	{
		case "turn":
			global.turn = message;
			break;
		
		case "letter": 
			var newguess = check_guess(message);
			// no letters found
			if(newguess == global.guess)
			{
				obj_hangman.image_index++;
				pn_send("hang", all, message);
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
				pn_send("win", all, sender_id);
			}
		
			//find the player
			var index = ds_list_find_index(global.pn_players_list, sender_id);
			var next_index = (index + 1) mod ds_list_size(global.pn_players_list);
			while(next_index == ds_list_find_index(global.pn_players_list, global.pn_player_id))
				next_index = (next_index + 1) mod ds_list_size(global.pn_players_list);
			
			//send next turn
			global.turn = global.pn_players_list[| next_index];
			pn_send("turn", all, global.turn);
		
			break;
		
		case "guess":
			global.guess = message;
			break;
		
		case "hang":
			obj_hangman.image_index++;
			global.letters += message;
			break;
	
		case "win":
			if(message == global.pn_player_id)
				global.winner = "You";
			else
				global.winner = global.pn_players_map[? message];
			room_goto(room_win);
			break;
		
		case "lose":
			if(message == global.pn_player_id) 
				room_goto(room_lose); 
			else
				show_message_async(global.pn_players_map[? message] + " tried a solution and lose");
			break;
		
		case "solution": 
			if(string_upper(message) == global.sentence)
			{
				pn_send("win", all, sender_id);
				global.winner = global.pn_players_map[? sender_id];
				room_goto(room_win);
			}
			else 
				pn_send("lose", all, sender_id);
		 
			break;
	} 
	
}
