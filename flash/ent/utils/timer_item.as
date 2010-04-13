package ent.utils
{
	import flash.events.TimerEvent;
	
	public class timer_item{
		public var _obj:*;
		public var _method:String
		public var _interval:int;
		public var _repeat:int = 0;
		public var _repeated:int = 0;
		public var _count:int = 0;
		public var _run:Boolean = true;
		
		public function timer_item(obj:*, method:String, interval:int = 30, repeat:int = 0){
			_obj = obj;
			_method = method;
			_interval = interval;
			_repeat = repeat;
		}
		
		public function run_me(event:TimerEvent):void{
			_obj[_method](event);
		}
	}
}