package ent.utils{
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.*;
	
	public class unlocker extends Sprite{
		
		private var _phrase:Array = [];
		private var _buffer:Array = [];
		private var _timer:Timer;
		
		public function unlocker(phrase:String):void{
			for(var i:uint=0; i < phrase.length; i++) _phrase.push(phrase.charCodeAt(i));
			trace(_phrase);
			addEventListener(KeyboardEvent.KEY_DOWN, check);
			_timer = new Timer(3000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, do_reset);
		}
		
		private function check(e:KeyboardEvent){
			if(!_timer.running) _timer.start();
			trace(e.charCode)
			_buffer.push(e.charCode);
			analyze();
		}
		
		private function do_reset(e:TimerEvent){
			reset();
		}
		
		private function reset(){
			_buffer = [];
			_timer.stop();
		}
		
		private function analyze(){
			trace(_phrase);
			trace(_buffer);
			for(var i:uint = 0; i < _phrase.length; i++){
				if(_buffer[i] == -1 || _phrase[i] != _buffer[i]) return false;
			}
			removeEventListener(KeyboardEvent.KEY_DOWN, check);
			trace("UNLOCKED");
			dispatchEvent(new Event('unlocked'));
			reset();
		}
		
	}
	
}