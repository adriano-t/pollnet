if(instance_number(object_index) > 1)
{
	instance_destroy();
	exit;
}
pn_config();
global.pn_last_date = "1912-06-23 00:00:00";
global.pn_token = "";
global.pn_request_send_list = ds_list_create();
global.pn_players_checkmap = ds_map_create();
global.pn_players_map = ds_map_create();
global.pn_players_list = ds_list_create();
global.pn_games_list = ds_list_create();
global.pn_request_host = -1;
global.pn_request_join = -1;
global.pn_request_quit = -1;
global.pn_request_games = -1;
global.pn_request_message = -1;
sep_word = chr(1);
sep_mess = chr(2);
sep_line = chr(3)
token_size = 20;