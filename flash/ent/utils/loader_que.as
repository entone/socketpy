package ent.utils{
	
	import flash.events.*;
	import flash.display.Loader;
	
	public class loader_que{
		
		private var _elements:Array;
		private var _current_loader:uint = 0;
		private var _running:Boolean = false;
		private var _ondone:Function;
		
		public function loader_que(on_done:Function):void{
			_ondone = on_done;
			_elements = new Array();
		}
		
		public function add_element(el:Object):int{
			var a:int = _elements.push(el);
			run();
			return a;
		}
		
		private function run_next():void{
			_current_loader++;
			if(_current_loader < _elements.length){
				run();
			}else if(_current_loader == _elements.length){
				_ondone();
				clear_que();
			}
		}
		
		private function clear_que():void{
			_elements.length = 0;
			_current_loader = 0;
			_running = false;
		}
		
		
		private function run():void{
			if(!_running){
				_running = true;
				assign_callbacks(_elements[_current_loader].loader);
				_elements[_current_loader].loader.load(_elements[_current_loader].url);
			}
		}
		
		private function assign_callbacks(_loader:Loader):void{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
            _loader.contentLoaderInfo.addEventListener(Event.OPEN, open);
            _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
            _loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, security);
            _loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatus);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, io);	
		}
		
		private function complete(event:Event):void{
			_running = false;
			trace('complete: '+ _current_loader);
			if(_elements[_current_loader].complete) _elements[_current_loader].complete(event);
			run_next();
		}
		
		private function open(event:Event):void{
			trace('open: '+ event.type);
			if(_elements[_current_loader].open) _elements[_current_loader].open(event);
		}
		
		private function progress(event:ProgressEvent):void{
			trace('progress: '+event.bytesLoaded, event.bytesTotal);
			if(_elements[_current_loader].progress) _elements[_current_loader].progress(event);
		}
		
		private function security(event:SecurityErrorEvent):void{
			trace('security: '+event.text);
			if(_elements[_current_loader].security) _elements[_current_loader].security(event);
			run_next();
		}
		
		private function httpstatus(event:HTTPStatusEvent):void{
			trace('security: '+event.status);
			if(_elements[_current_loader].httpstatus) _elements[_current_loader].httpstatus(event);
		}
		
		private function io(event:IOErrorEvent):void{
			trace('security: '+event.text);
			if(_elements[_current_loader].io) _elements[_current_loader].io(event);
			run_next();
		}
	
	}
}