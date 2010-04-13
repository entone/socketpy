package ent.gui{
	
	import flash.display.*;
	import flash.text.*
	import ent.gui.ent_box;
	
	public class bar_gauge extends Sprite{
		
		private const MAX:uint = 1;
		private const MIN:uint = 0;
		private var _range:Array;//[min, max]
		private var _gauge:Sprite;
		private var _step:uint;
		private var _mask:ent_box;
		private var _label_holder:Sprite;
		private var _title:TextField;
		
		public function bar_gauge(range:Array, gauge:Sprite, step:uint=1):void{
			_range = range;
			_gauge = gauge;
			_step = step;
			init();
		}
		
		private function init(){
			//_wid:int, _het:int, _corners:int, _outline_color:uint, _outline_alpha:int,  _bg_color:uint, _bg_alpha:int, _center:Boolean, _fill:Boolean = true
			_mask = new ent_box(_gauge.width, _gauge.height, 0, 0x000000, 100, 0x000000, 100, false, true);
			_mask.rotation = 180;
			_mask.y = _gauge.height;
			_mask.x = _gauge.width;
			addChild(_gauge);
			addChild(_mask);
			_gauge.mask = _mask;
			create_labels();
		}
		
		private function create_labels(){
			var num_steps:int = Math.ceil((_range[MAX] - _range[MIN])/_step);
			var spacing:Number = _gauge.height/num_steps;
			_label_holder = new Sprite();
			for(var i:uint = 0; i <= num_steps; i++){
				var hold:Sprite = new Sprite();
				var disp = _range[MIN]+(_step*i);
				var dash = new ent_box(5, 1, 0, 0xFFFFFF, 0, 0xFFFFFF, 100, false);
				var txt = new TextField();
				txt.selectable = false;
				txt.autoSize = TextFieldAutoSize.RIGHT;
				txt.text = disp;
				txt.textColor = 0xFFFFFF;
				txt.x = -(txt.width+1);
				hold.addChild(txt);
				dash.y = (txt.height/2);
				dash.x = 0;
				hold.addChild(dash);
				hold.y = _gauge.height-(spacing*i);
				trace(hold.y+" :: "+_gauge.height);
				_label_holder.addChild(hold);
			}
			_label_holder.y = -9;
			addChild(_label_holder);
		}
		
		public function adjust(val:Number){
			val-=_range[MIN];
			var range:Number = _range[MAX] - _range[MIN];
			var pixel = (_gauge.height/range)*val;
			_mask.resize(_gauge.width, pixel, 1, {});
		}
	}
	
}