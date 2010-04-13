function ext_int(ext_id, callback){
	this.callback = callback;
	ext_int.scopes[ext_id] = this;
}

ext_int.call_js = function(method, ext_id, args){
	var obj = ext_int.scopes[ext_id].callback;
	var meth = obj[method];
	meth.apply(obj, args);
}

ext_int.scopes = {};