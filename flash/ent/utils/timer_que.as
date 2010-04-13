package ent.utils
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class timer_que{
		private static var _timer:Timer;
		private static var _que:Array = new Array();
		private static var _running:Boolean = false;

		public static function add_item(obj:*, method:String, interval:int, repeat:int = 0):void{
			_que.push(new timer_item(obj, method, interval, repeat));
			if(!_running){
				_running = true;
				_timer = new Timer(14);
				_timer.addEventListener(TimerEvent.TIMER, check_que);
				_timer.start();
			}
		}
		
		private static function check_que(event:TimerEvent):void{
			for(var i:int = 0; i < _que.length; i++){
				var h:timer_item = _que[i];
				if(h._run){
					if(h._count == h._interval){
						h.run_me(event);
						h._count = 0;
						h._repeated++;
						if(h._repeated == h._repeat && h._repeat > 0) h._run = false;
					}else{
						h._count++;	
					}
				}
			}
		}
		
	}
}