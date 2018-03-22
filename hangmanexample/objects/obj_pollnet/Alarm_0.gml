/// @description request messages 

var val = "date=" + global.pn_last_date;
val += "&token=" + global.pn_token;
global.pn_request_message = http_post_string(global.pn_get, val);