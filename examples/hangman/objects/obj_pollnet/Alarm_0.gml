var val = "lastid=" + string(self.last_id);
val += "&token=" + string(self.token);
self.request_messages = obj_pollnet.pn_http_request(self.url_get, val);