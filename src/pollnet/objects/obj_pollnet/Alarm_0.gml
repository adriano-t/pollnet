var val = "lastid=" + string(global.pn_last_id);
val += "&token=" + string(global.pn_token);
global.pn_request_messages = pn_http_request(global.pn_url_get, val);