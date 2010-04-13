package ent.gui{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.*;
	
	public class button extends Sprite{
		private var _up:Sprite;
		private var _hover:Sprite;
		private var _hitarea:Sprite;
		public var key:String;
		
		public function button(reg:Sprite, hover:Sprite, hitarea:Sprite, _key:String):void{
			_up = reg;
			_hover = hover;
			_hitarea = hitarea;
			key = _key;
			init();
		}
		
		private function init():void{
			addChild(_hover);
			addChild(_up);
			addChild(_hitarea);
			_hitarea.alpha = 0;
			_hover.alpha = 0;
			_up.alpha = 1;
			rollout(new MouseEvent('test'));
			_hitarea.useHandCursor = true;
			_hitarea.addEventListener(MouseEvent.CLICK, click);
			_hitarea.addEventListener(MouseEvent.ROLL_OVER, rollover);
			_hitarea.addEventListener(MouseEvent.ROLL_OUT, rollout);
		}
		
		private function click(event:MouseEvent) :void{
			dispatchEvent(new Event('button_click', true));
		}
		
		private function rollover(event:MouseEvent) :void{
			dispatchEvent(new Event('button_over', true));
			_hover.alpha = 1;
			_up.alpha = 0;
		}
		
		private function rollout(event:MouseEvent) :void{
			dispatchEvent(new Event('button_out', true));
			_up.alpha = 1;
			_hover.alpha = 0;
		}
	}
}