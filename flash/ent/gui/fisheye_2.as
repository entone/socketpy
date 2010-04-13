package ent.gui{
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Timer;
	import com.boostworthy.animation.rendering.RenderMethod;
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.management.types.abstract.Animation;
	import com.boostworthy.animation.management.AnimationManager;
	import ent.gui.ent_box;
	
	public class fisheye_2 extends Sprite{
	
		private var _elements:Array;
		private var _height:Number;
		private var _orig_height:Number;
		private var _len:int;
		private var _spacing:int;
		private var _element_holder:Sprite;
		private var _mask:Sprite;
		private var _width:Number;
		private var _focus_height:int;
		private var _focus_y:int;
		private var _speed:int=2;
		private var _last:Number=0;
		private var _timer:Timer;
		private var _min_per:Number = .1;
		private var _center_cursor:Boolean = false;
		private var _move_me:AnimationManager;
		private var do_move:Boolean = false;
		private var scroll_bar:ent_box;
		private var _overscroll:Boolean = false;
		private var _background:ent_box;
		private var _last_mouse_y:int = 0;
		private var _focus_obj:Shape;
		
		public function fisheye_2(elements:Array, height:Number, width:Number=200, spacing:int=0, curs:Boolean=false, min_per:Number=.1):void{
			_min_per = min_per;
			_move_me = new AnimationManager();
			_center_cursor = curs;
			_timer = new Timer(14);
			_elements = elements;
			_focus_obj = new Shape();
			_focus_obj.graphics.beginFill(0xffffff, .3);
			_focus_obj.graphics.drawRect(0,0,width, _elements[0].mc.height);
			_focus_obj.graphics.endFill();
			_focus_obj.y = (height/2) - (_focus_obj.height/2);
			_height = height;
			_width = width;
			_orig_height = height;
			_spacing = spacing;
			_element_holder = new Sprite();
			_element_holder.x = 10;
			_background = new ent_box(_width, _height, 0, 0xFFFFFF, 100, 0xFFFFFF, 70, false, true);
			_mask = new Sprite();
			_focus_height = _elements[0].mc.height;
			
			_mask.graphics.beginFill(0xffffff, 1);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
	
			scroll_bar = new ent_box(60, _height, 0, 0x666666, 0, 0xCCCCCC, 90, false);
			scroll_bar.x = _width - scroll_bar.width;
			addChild(_background);
			addChild(_focus_obj);
			addChild(_element_holder);
			addChild(scroll_bar);
			addChild(_mask);
			mask = _mask;
			build_elements();
		}
		
		private function build_elements():void{
			for(var c:int = 0; c < _elements.length; c++){
				_elements[c].orig_width = _elements[c].mc.width;
				_elements[c].orig_height = _elements[c].mc.height;
				_len+= _elements[c].mc.height + _spacing;
			}
			_len-= _spacing;
			
			trace("LENGTH:" +_len);
			trace("First Height: "+ _height);
			
			var boom:Number = _len < _height ? 0 : _elements[1].mc.height*2;
			trace("BOOM: "+boom);
			_height-= boom;
			trace("New HEIGHT: " + _height);
			var dif:Number = Math.floor(_height/_elements.length) <= 0 ? 1: Math.floor(_height/_elements.length);
			trace("new item height: "+dif);
			for(var i:int = 0; i < _elements.length; i++){
				var per:Number = dif/_focus_height > 1 ? 1 : dif/_focus_height < _min_per ? _min_per : dif/_focus_height;
				_elements[i].scale = per;		
				_elements[i].mc.scaleX = per;
				_elements[i].mc.scaleY = per;
				_elements[i].mc.y = (_elements[i].mc.height + _spacing)*i;
				//trace(i + " :: "+_elements[i].mc.y + " :: " +_elements[i].mc.height);
				_element_holder.addChild(_elements[i].mc);
			}
			trace("HEIZZZZGHT: "+_elements[0].mc.scaleY);
			trace("PER: "+per);
			if(_element_holder.height > _height){
				trace("there are elements that are below teh fold, try increasing your height for te fisheye");
			}
			//addEventListener(MouseEvent.MOUSE_MOVE, watch_mouse);
			scroll_bar.addEventListener(MouseEvent.MOUSE_OVER, set_on);
			scroll_bar.addEventListener(MouseEvent.MOUSE_OUT, set_out);
			
			_timer.addEventListener(TimerEvent.TIMER, watch_mouse);
			_timer.addEventListener(TimerEvent.TIMER, follow_mouse);
			_timer.start();
		}
		
		private function set_out(event:MouseEvent):void{
			_overscroll = false;
			do_move = false;
		}
		
		private function set_on(event:MouseEvent):void{
			var a:Timer = new Timer(500, 1);
			_overscroll = true;
			a.addEventListener(TimerEvent.TIMER_COMPLETE, check_over);
			a.start();
		}
		
		private function check_over(event:TimerEvent):void{
			if(_overscroll){
				do_move = true;
			}
		}
		
		private function follow_mouse(event:TimerEvent = null):void{
			var mouse:int = Math.ceil(scroll_bar.mouseY);
			if(do_move && (Math.abs(_last_mouse_y - mouse) >= 1)){
				var zero:uint = (_height/2)+(_elements[0].mc.height);
				var y_diff:int = (_element_holder.height*1.05);
				var y_per:Number = y_diff/(scroll_bar.height);
				var new_pos:int = -((mouse)*y_per) + zero;
				trace(new_pos);
				var dif:int = new_pos - _element_holder.y;
				var move:Number = dif/_speed;
				_element_holder.y+=move;
				_last_mouse_y = mouse;
			}
		}
		
		public function set_min_per(per:Number):void{
			_min_per = per;
		}
		
		private function watch_mouse(event:TimerEvent = null):void{
			var move:Number=0;
			var het:Number;
			var dif:int;
			var foc:Boolean;
			for(var i:int = 0; i < _elements.length; i++){
				if(do_move){
					_focus_y = (_focus_obj.y) - _element_holder.y;
					_elements[i].mc.y += move;
					het = _elements[i].mc.height;
					var offset:int = _center_cursor ? _elements[i].mc.height/2 : 0;
					dif = Math.abs((_elements[i].mc.y + (offset)) - _focus_y);
					var scale:Number = (1-(dif/100)) > .7 ? 1 : (1-(dif/100)) < _min_per ? _min_per : (1-(dif/100));
					_elements[i].mc.scaleX = scale; 
					_elements[i].mc.scaleY = scale;
					move += _elements[i].mc.height - het;
				}
				foc =_elements[i].mc.is_focused(); 
				if(_elements[i].mc.scaleX >= 1 && !foc){
					if(_elements[i].mc.focus) _elements[i].mc.focus();
				}else if(_elements[i].mc.scaleX < 1){
					if(_elements[i].mc.unfocus) _elements[i].mc.unfocus();
				}
					
				
			}
		}
	}
}