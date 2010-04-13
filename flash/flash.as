package{

	import flash.display.*;
	import ent.networking.socket.jsonserver;
	import flash.utils.*;
	import flash.events.*;
	import ent.utils.ent_event;
	import flash.text.*;
	import ent.gui.ent_box;
	import ent.gui.bar_gauge;
	import ent.gui.active_line;

	[SWF(frameRate='31', backgroundColor='#000000')]		

	public class flash extends Sprite{
		public var js:jsonserver;
		private var _txt:TextField;
		private var _gauge:bar_gauge;
		private var _line:active_line;
		private var _data:Timer;
		
		public function flash(){
			init_display();
			js = new jsonserver('127.0.0.1', 6000);
			_data = new Timer(300);
			_data.addEventListener(TimerEvent.TIMER, do_stuff);
			configure_listeners();
			
		}
		
		private function configure_listeners():void {
            js.addEventListener(Event.CLOSE, closeHandler);
            js.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            js.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            js.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			js.addEventListener('json_connected', connected);
			js.addEventListener('json_data', data);
        }
		
		private function do_stuff(e:TimerEvent){
			var obj:Object = {type:'fake_data', value:Math.random()*1023}
			js.sendJson(obj);
		}
		
		private function init_display(){
			set_stage();
			create_text_field();
			write_text("INIT!");
			create_guage();
			create_line();
		}
		
		private function create_guage(){
			var gauge:ent_box = new ent_box(30, stage.stageHeight-60, 0, 0x000000, 100, [0xFF0000, 0x76ACFF], 100, false);
			_gauge = new bar_gauge([0, 1023], gauge, 200);
			_gauge.x = stage.stageWidth - (gauge.width+5);
			_gauge.y = 30;
			addChild(_gauge);
			_gauge.adjust(650);
		}
		
		private function create_line(){
			_line = new active_line([0xFF0000], 600, 300, 40, 50, [0, 1023]);
			_line.y = 30;
			_line.x = 30;
			addChild(_line)
		}
		
		private function create_text_field(){
			_txt = new TextField();
			_txt.multiline = true;
			_txt.width = stage.stageWidth;
			_txt.height = stage.stageHeight;
			_txt.textColor = 0xDDDDDD;
			_txt.selectable = false;
			addChild(_txt);
		}
		
		function connected(ev){
			trace(ev);
			write_text("Connected");			
			start()
		}
		
		function start(){
			var t:Timer = new Timer(1000, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
				js.sendJson({method:'ready'});
				_data.start();
			}, false, 0, true);
			t.start();
			_line.start();
			write_text("Starting");
		}
		
		function write_text(tex:String){
			var d:Date = new Date();
			var mins = d.getMinutes() < 10 ? "0"+String(d.getMinutes()) : d.getMinutes();
			var secs = d.getSeconds() < 10 ? "0"+String(d.getSeconds()) : d.getSeconds();
			_txt.text+=d.getHours()+":"+mins+":"+secs+"."+d.getMilliseconds()+" "+tex+"\n";
			_txt.scrollV = _txt.numLines;
		}
		
		function data(ev:ent_event){
			var obj:Object = ev.get_data();
			trace("DATA: "+obj.type+ " = "+obj.value);
			_gauge.adjust(obj.value);
			_line.add([obj.value]);
			write_text(obj.type+" = "+obj.value);
		}
		
		private function closeHandler(event:Event):void {
           write_text("closeHandler: " + event);
        }


        private function ioErrorHandler(event:IOErrorEvent):void {
            write_text("ioErrorHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            write_text("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
           write_text("securityErrorHandler: " + event);
        }

		
		private function set_stage(){
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;			
		}
		
	}
}