package ent.gui
{
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	
	public class fisheye extends Sprite{
	
		private var _elements:Array;
		private var _height:Number;
		private var _orig_height:Number;
		private var _len:int;
		private var _spacing:int;
		private var _element_holder:Sprite;
		private var _mask:Sprite;
		private var _cover_top:Sprite;
		private var _width:Number;
		private var _focus_height:int;
		private var _focus_y:Number;
		private var _speed:int=20;
		private var _last:Number=0;
		private var _timer:Timer;
		
		public function fisheye(elements:Array, height:Number, width:Number= 200, spacing:int = 0):void{
			_timer = new Timer(14);
			_elements = elements;
			_height = height;
			_width = width;
			_orig_height = height;
			_spacing = spacing;
			_element_holder = new Sprite();
			_mask = new Sprite();
			_cover_top = new Sprite();
			_focus_height = _elements[0].mc.height;
			_mask.graphics.beginFill(0xffffff, 1);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
			
			_cover_top.graphics.beginFill(0xffffff, 0);
			_cover_top.graphics.drawRect(0, 0, _width, _height);
			_cover_top.graphics.endFill();
			addChild(_cover_top);
			addChild(_element_holder);
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
				var per:Number = dif/_focus_height > 1 ? 1 : dif/_focus_height;
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
			addEventListener(MouseEvent.MOUSE_MOVE, watch_mouse);
			//_timer.addEventListener(TimerEvent.TIMER, watch_mouse);
			//_timer.addEventListener(TimerEvent.TIMER, follow_mouse);
			//_timer.start();
		}
		
		private function follow_mouse(event:TimerEvent = null):void{
			var dif:Number = this.mouseY - _last;
			trace("DIF:" + dif);
			var move:Number = dif/_speed;
			_focus_y = _last+move;
			_last = _focus_y;
		}
		
		private function watch_mouse(event:MouseEvent = null):void{
			var move:Number = 0;
			var het:Number;
			var dif:Number;
			/*
			_cover_top.graphics.clear();
			_cover_top.graphics.beginFill(0xffffff, .7);
			_cover_top.graphics.lineStyle(1, 0xffffff, 1, true);
			_cover_top.graphics.drawRect(0, 0, 200, this.mouseY - _focus_height/2);
			_cover_top.graphics.endFill();
			
			_cover_bottom.graphics.clear();
			_cover_bottom.graphics.beginFill(0xffffff, .7);
			_cover_bottom.graphics.lineStyle(1, 0xffffff, 1, true);
			_cover_bottom.graphics.drawRect(0, (this.mouseY + (_focus_height/2)), 200, (_orig_height - (this.mouseY + (_focus_height/2))));
			_cover_bottom.graphics.endFill();
			*/
			
			for(var i:int = 0; i < _elements.length; i++){
				_focus_y = this.mouseY;
				_elements[i].mc.y += move;
				het = _elements[i].mc.height;
				dif = Math.abs((_elements[i].mc.y + (_elements[i].mc.height/2)) - _focus_y);
				var scale:Number = (1-(dif/100)) > 1 ? 1 : (1-(dif/100)) < _elements[i].scale ? _elements[i].scale : (1-(dif/100));
				_elements[i].mc.scaleX = scale; 
				_elements[i].mc.scaleY = scale; 
				if((_focus_y > _elements[i].mc.y) && (_focus_y < (_elements[i].mc.y+_elements[i].mc.height))){
					if(!_elements[i].mc.is_focused()){
						_elements[i].mc.set_focus(true);
						_elements[i].focus();
					}
				}else if(_elements[i].mc.is_focused()){
					_elements[i].unfocus();
					_elements[i].mc.set_focus(false);
				}
				move += _elements[i].mc.height - het;
			}
		}
	}
}