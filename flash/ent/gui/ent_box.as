package ent.gui{
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class ent_box extends Sprite{
		private var bg_color:*;
		private var bg_alpha:int;
		private var center:Boolean;
		private var wid:int;
		private var het:int;
		private var corners:int;
		private var outline_color:uint;
		private var outline_alpha:int;
		private var resizing:Boolean = false;
		private var timer:Timer;
		private var nwid:int;
		private var nhet:int;
		private var speed:int;
		private var ret_obj:Object;
		private var fill:Boolean;
		
		public function ent_box(_wid:int, _het:int, _corners:int, _outline_color:uint, _outline_alpha:int,  _bg_color:*, _bg_alpha:int, _center:Boolean=false, _fill:Boolean = true){
			bg_color = _bg_color;
			bg_alpha = _bg_alpha;
			center = _center;
			wid  = _wid;
			het = _het;
			corners = _corners;
			outline_color = _outline_color;
			outline_alpha = _outline_alpha;
			fill = _fill;
			timer = new Timer(14);
			timer.addEventListener(TimerEvent.TIMER, do_timer);
			draw_box();
		}

		public function draw_box():void{
			//trace("drawing: "+ het+":"+wid+" || "+bg_color+":"+outline_color);
			graphics.clear();
			graphics.lineStyle(1, outline_color, (outline_alpha*.01), true);
			if(fill){
				if(bg_color is Array){
					var matr:Matrix = new Matrix();
					matr.createGradientBox(wid, het, Math.PI/2);
					graphics.beginGradientFill('linear', bg_color, [1,1], [0, 200], matr);
				}else{
					graphics.beginFill(bg_color, (bg_alpha*.01));
				}
			}
			var startx:int;
			var starty:int;
			if(center){
				startx = -(wid/2);
				starty = -(het/2);
				wid = wid/2;
				het = het/2;
			}else{
				startx = 0;
				starty = 0;
			}
			graphics.moveTo(startx + corners, starty);
			graphics.lineTo(wid - corners, starty);
			graphics.curveTo(wid, starty, wid, starty + corners);
			graphics.lineTo(wid, het - corners);
			graphics.curveTo(wid, het, wid-corners, het)
			graphics.lineTo(startx + corners, het);
			graphics.curveTo(startx, het, startx, het-corners);
			graphics.lineTo(startx, starty + corners);
			graphics.curveTo(startx,starty, startx + corners, starty);
			if(fill) graphics.endFill();
		}
	
		public function resize(_nwid:int, _nhet:int, _speed:uint, _ret_obj:Object):Boolean{
			nwid = _nwid;
			nhet = _nhet;
			speed = _speed;
			ret_obj = _ret_obj;
			if(resizing){
				timer.stop();
			}
			resizing = true;
			timer.start();
			return true;
		}
		
		private function do_timer(event:TimerEvent):void{
			var difx:int = nwid - wid;
			var dify:int = nhet - het;
			var movex:*  = difx/speed; 
			var movey:*  = dify/speed;
			var mulx:Number = movex < 0 ? -1 : 1;
			var muly:Number = movey < 0 ? -1 : 1;
			var absx:* = Math.ceil(Math.abs(movex));
			var absy:* = Math.ceil(Math.abs(movey));
			wid += absx*mulx;
			het += absy*muly;
			draw_box();
			if(Math.abs(wid - nwid) <= 1 && Math.abs(het - nhet) <= 1){
				wid = nwid;
				het = nhet;
				draw_box();
				timer.stop();
				dispatchEvent(new Event('onDone'));
				resizing = false;
			}
		}
	}
}	