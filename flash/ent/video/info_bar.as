package ent.video{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.net.NetStream;
	import flash.events.*
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import com.boostworthy.animation.rendering.RenderMethod;
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.management.types.abstract.Animation;
	import com.boostworthy.animation.management.AnimationManager;
	import ent.gui.ent_box;
	import ent.utils.numbers;
	import ent.utils.timer_que;
	import flash.geom.Point;
		
	public class info_bar extends Sprite{
		private var _vp:*;
		private var status_bar:ent_box;
		private var seek_bar:ent_box;
		private var _scrubbing:Boolean = false;
		private var _focused:Boolean = true;
		private var _focus_counter:int = 0;
		private var _move_me:AnimationManager;
		public var background:ent_box;
		private var timeline:ent_box;
		private var time_position:ent_box;
		private var tex:TextField;
		private var timeline_holder:Sprite;
		private var mouser:Sprite;
		
		public function info_bar(vp:ent_vidplayer){
			_vp = vp;
			create_box();
		}
		
		private function create_box():void{
			x+= 10;
			y = _vp.height - 5;
			mouser = new Sprite();
			mouser.graphics.beginFill(0xffffff, 0);
			var c:Point = globalToLocal(new Point(0, 0));
			mouser.graphics.drawRect(c.x, c.y, _vp.width, _vp.height);
			background = new ent_box((_vp.width-20), 30, 5, 0xFFFFFF, 100,  0xFFFFFF, 70, false);
			timeline_holder = new Sprite();
			timeline = new ent_box((background.width-50), 10, 5, 0xFFFFFF, 100,  0x333333, 30, false);
			time_position = new ent_box((background.width-58), 2, 2, 0xFFFFFF, 0,  0xFF0000, 100, false);
			status_bar = new ent_box((background.width-58), 9, 5, 0xFFFFFF, 0,  0x333333, 100, false);
			seek_bar = new ent_box(20, 30, 3, 0xFFFFFF, 100, 0x333333, 100, false);
			tex = new TextField();
			tex.autoSize = TextFieldAutoSize.LEFT;
			tex.selectable = false;
			
			addChild(mouser);
			addChild(background);
			addChild(timeline_holder);
			timeline_holder.addChild(timeline);
			timeline_holder.addChild(status_bar);
			timeline_holder.addChild(time_position);
			timeline_holder.addChild(seek_bar);
			addChild(tex);
			
			status_bar.y = 1;
			status_bar.x = 1;
			
			timeline_holder.x = 5;
			timeline_holder.y = 15;

			time_position.x = 4;
			time_position.y = 4;
	
			seek_bar.addEventListener(MouseEvent.MOUSE_DOWN, start_seek);
			seek_bar.addEventListener(MouseEvent.MOUSE_UP, stop_seek);
			//seek_bar.addEventListener(MouseEvent.ROLL_OUT, stop_seek);
			seek_bar.y = -15;
			
			_move_me = new AnimationManager();
			
			var a:Object = new Object();
			a.move_bar = move_bar;
			a.update_loading = update_loading;
			a.monitor_focus = monitor_focus;
			a.update_time = update_time; 

			timer_que.add_item(a, "move_bar", 1);
			timer_que.add_item(a, "update_loading", 1);
			timer_que.add_item(a, "monitor_focus", 1);
			timer_que.add_item(a, "update_time", 1);
		}
		
		public function nada(event:MouseEvent):void{
			
		}
		
		public function onDone():void{
			trace("Done with background");
		}
		
		private function start_seek(event:MouseEvent):void{
			_scrubbing = true;
			_vp._video_stream.pause();
			seek_bar.startDrag(false, new Rectangle(0, seek_bar.y, ((status_bar.width+2)-(seek_bar.width)), 0));
			seek_bar.addEventListener(MouseEvent.MOUSE_MOVE, seek_to);
			addEventListener(MouseEvent.MOUSE_UP, stop_seek);
		}
		
		private function seek_to(event:MouseEvent):void{
			//trace("("+seek_bar.x+"/("+_vp.width+"-"+seek_bar.width+"))*"+_vp._duration +"="+ (seek_bar.x/(_vp.width-seek_bar.width))*_vp._duration);
			var seek:* = (seek_bar.x/(status_bar.width-seek_bar.width))*_vp._duration;
			if(seek < _vp._duration){
				_vp._video_stream.seek(seek);
				_vp._video_stream.pause();
			}
		}
		
		private function stop_seek(event:MouseEvent):void{
			_scrubbing = false;
			seek_bar.removeEventListener(MouseEvent.MOUSE_MOVE, seek_to);
			removeEventListener(MouseEvent.MOUSE_UP, stop_seek);
			seek_bar.stopDrag();
			_vp._video_stream.resume();
		}
		
		private function move_bar(event:TimerEvent):void{
			if(!_scrubbing && (_vp._video_stream.time < _vp._duration)){
				//trace("("+_vp._video_stream.time+"/"+_vp._duration+")*("+_vp.width+"-"+seek_bar.width+")"+"="+(_vp._video_stream.time/_vp._duration)*(_vp.width-seek_bar.width));
				seek_bar.x = (_vp._video_stream.time/_vp._duration)*(((status_bar.width))-seek_bar.width)+4;
				time_position.resize((seek_bar.x+(time_position.x+(seek_bar.width/2))), 2, 2, this);
			}
		}
		
		private function update_loading(event:TimerEvent):void{
			if(_vp._video_stream.bytesLoaded < _vp._video_stream.bytesTotal){
				status_bar.resize((_vp._video_stream.bytesLoaded / _vp._video_stream.bytesTotal)*(timeline.width-2), 9, 2, this);
			}else if(status_bar.width < (timeline.width-2)){
				status_bar.resize(timeline.width-2, 9, 1, this);
			}
		}

		
		private function monitor_focus(event:TimerEvent):void{
			var a:Point = localToGlobal(new Point(mouseX, mouseY));
			if((a.y < _vp.height && a.y > (_vp._video.height-background.height)) && !_focused){
				_focus_counter++
				if(_focus_counter > 10){
					_focus_counter = 0;
					_focused = true;
					focus();
				}
			}else if(a.y < (_vp.height-background.height) && _focused && !_scrubbing){
				_focus_counter++;
				if(_focus_counter > 20){
					_focus_counter = 0;
					_focused = false;
					unfocus();
				}
			}
		}
		
		private function update_time(event:TimerEvent):void{
			tex.text = numbers.parse_seconds(_vp._duration)+" / "+numbers.parse_seconds(_vp._video_stream.time);
		}
		
		private function focus():void{
			_move_me.move(this, 10, (_vp._video.height-background.height)-5, 200, Transitions.CUBIC_OUT, RenderMethod.TIMER);
		}
		
		private function unfocus():void{
			_move_me.move(this, 10, (_vp._video.height), 200, Transitions.CUBIC_OUT, RenderMethod.TIMER);
		}
	}
}