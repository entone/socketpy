package ent.networking.socket{

	import flash.events.*;
	import flash.net.Socket;
    import flash.system.Security;
	import ent.utils.ent_event;
	import com.json.JSON;
	
	public class jsonserver extends Socket{
		private var _hostname:String;
        private var _port:uint;
		
		public function jsonserver(host:String, eport:uint):void {
			super(host, eport);
			Security.allowDomain("*");
			//Security.loadPolicyFile("xmlsocket://"+host+":"+eport);
			_hostname = host;
			_port = eport;
			configure_listeners();			
			connect(host, eport);
        }
		
		private function configure_listeners():void {
            addEventListener(Event.CLOSE, closeHandler);
            addEventListener(Event.CONNECT, connectHandler);
            addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
            addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            addEventListener(ProgressEvent.PROGRESS, progressHandler);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }

        private function closeHandler(event:Event):void {
            trace("closeHandler: " + event);
        }

        private function connectHandler(event:Event):void {
			dispatchEvent(new ent_event('json_connected'));
            trace("connectHandler: " + event);
        }

        private function dataHandler(event:ProgressEvent):void {
			var json:* = JSON.deserialize(readUTFBytes(bytesAvailable));
			dispatchEvent(new ent_event('json_data', json));
        }
		
		public function sendJson(obj:*):void{
			var str:String = JSON.serialize(obj);
			trace("sending: "+str);
			writeUTFBytes(str);
			flush();
		}

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
		
	}
	
}