/// @description join a random game
/// @param {String} user_name
/// @param {Function} callback
function pn_join_auto(user_name, callback = undefined) {
	
	obj_pollnet.player_name = user_name;
	
	var val = "mode=autojoin";
	val += "&gametoken=" + string(obj_pollnet.game_token);
	val += "&username=" + string(obj_pollnet.player_name); 

	obj_pollnet.request_join_auto = obj_pollnet.pn_http_request(obj_pollnet.url_lobby, val);
	obj_pollnet.callback_join_auto = callback;
	
}
