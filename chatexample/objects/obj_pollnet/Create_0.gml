
if(instance_number(object_index) > 1)
{
	instance_destroy();
	exit;
}
pn_config();
if(string_char_at(global.pn_website, string_length(global.pn_website)) != "/")
	global.pn_website += "/";
global.pn_get = global.pn_website + "get.php";
global.pn_post = global.pn_website + "post.php";
global.pn_lobby = global.pn_website + "lobby.php";

global.pn_last_date = "1912-06-23 00:00:00";
global.pn_token = "";
global.pn_request_send_list = ds_list_create();
global.pn_players_checkmap = ds_map_create();
global.pn_players_map = ds_map_create();
global.pn_players_list = ds_list_create();
global.pn_games_list = ds_list_create();
global.pn_request_host = -1;
global.pn_request_join = -1;
global.pn_request_game_start = -1;
global.pn_request_quit = -1;
global.pn_request_games = -1;
global.pn_request_message = -1;
global.pn_admin_id = -1;
sep_word = chr(1);
sep_mess = chr(2);
sep_line = chr(3);
sep_packet = chr(4);
token_size = 20;
