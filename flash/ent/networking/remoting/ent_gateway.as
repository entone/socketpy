package ent.networking.remoting
{
	import flash.net.Responder;
	import ent.networking.remoting.RemotingConnection;
	import flash.events.NetStatusEvent;
	
	public class ent_gateway{
		private var _obj:String;
		private var gatewayUrl:String;
		private var gateway:RemotingConnection;
		private var resp:Responder;
		private var _callback:Object;
		
		public function ent_gateway(url:String){
			gatewayUrl = url;
			gateway = new RemotingConnection(gatewayUrl);
			gateway.addEventListener(NetStatusEvent.NET_STATUS, handle_status);
			resp = new Responder(onResult, onFault);
			_obj = 'controller';
		}
		
		public function call(object:String, method:String, args:Array, callback:Object):Boolean{
			_callback = callback;
			trace("calling: "+object+"."+method+"("+args+")");
			gateway.call('controller.call', resp, object, method, args);
			return true;
		}
		
		private function handle_status(status:NetStatusEvent):void{
			trace(status.info.code);
		}
			
		private function onResult(result:Object):void{
			trace("got result");
			_callback['onResult'](result);
		}
		
		private function onFault(fault:Object):void{
			trace("fault");
			_callback['onFault'](fault);
		}
	}
}