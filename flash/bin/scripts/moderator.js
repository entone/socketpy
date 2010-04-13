var moderator = function(gid, swf_file, chat_server, port, page_id, swf_id, swf_version, callbacks){
	this.gid = gid;
	this.port = port;
	this.swf_file = swf_file;
	this.random_id = Math.round(10000000000 * Math.random());
	this.swf_version = swf_version;
	this.swf_id = swf_id;
	this.chat_server = chat_server;
	this.page_id = page_id;
	this.uid = new Date().getTime();
	this.proxy = 0;
	this.callbacks = callbacks;
	this.inter = 0;
	this.init();
}

moderator.prototype.flash_version = function(){
	return deconcept.SWFObjectUtil.getPlayerVersion();
}

moderator.prototype.check_flash = function(){
	var a = this.flash_version();
	if(a['major'] <= 0){
		if(this.callbacks['no_flash'])  this.callbacks['no_flash']();
		return false;
	}
	return true;
}

moderator.prototype.init = function(){
	this.proxy = new ext_int(this.swf_id, this);
	this.create_tag();
}

moderator.prototype.create_tag = function(){
	this.swfo = new SWFObject(this.swf_file, this.swf_id, 1, 1, this.swf_version, "FFFFFF");
	this.swfo.addVariable('ext_id', this.swf_id);
	this.swfo.addVariable('chat_server', this.chat_server);
	this.swfo.addVariable('port', this.port);
	this.swfo.addVariable('uuid', this.random_id);
	this.swfo.addVariable('debug', true);
	this.swfo.addVariable('gid', this.gid);
	//this.swfo.useExpressInstall('swf/expressinstall.swf');
    this.swfo.write(this.page_id);
    this.obj = document.getElementById(this.swf_id);
    this.check_flash();
}


moderator.prototype.send_message = function(obj){
	this.obj.send_message(obj);
}

moderator.prototype.receive_message = function(obj){
	if(this.callbacks['receive_message']) this.callbacks['receive_message'](obj);
}

moderator.prototype.cancel = function(){
	this.obj.cancel_upload();
}

moderator.prototype.get_bytes = function(){
	return this.obj.get_bytes();
}

moderator.prototype.is_uploading = function(){
	return this.obj.is_uploading();
}

moderator.prototype.on_flash_load = function(){
	if(this.callbacks['on_flash_load'])  this.callbacks['on_flash_load']();
}

moderator.prototype.on_progress = function(obj){
	if(this.callbacks['on_progress'])  this.callbacks['on_progress'](obj);
}

moderator.prototype.on_upload = function(){
	this.start_bytes();
	if(this.callbacks['on_upload'])  this.callbacks['on_upload']();
}

moderator.prototype.on_cancel = function(file_ref){
	this.stop_bytes();
	if(this.callbacks['on_cancel'])  this.callbacks['on_cancel'](file_ref);
}

moderator.prototype.upload_done = function(obj){
	this.stop_bytes();
	if(this.callbacks['upload_done'])  this.callbacks['upload_done'](obj);
}
	
moderator.prototype.file_selected = function(obj){
	if(this.callbacks['file_selected']) this.callbacks['file_selected'](obj);
}
	
moderator.prototype.io_error = function(obj){
	if(this.callbacks['io_error']) this.callbacks['io_error'](obj);
}
	
moderator.prototype.http_error = function(obj, error){
	if(this.callbacks['http_error']) this.callbacks['http_error'](obj, error);
}
	
moderator.prototype.security_error = function(obj, error){
	if(this.callbacks['security_error']) this.callbacks['security_error'](obj);
}

moderator.prototype.transfer_done = function(obj){
	if(this.callbacks['transfer_done']) this.callbacks['transfer_done'](obj);
}
