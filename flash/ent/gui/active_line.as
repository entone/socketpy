package ent.gui{
	
	import flash.display.*;
	import ent.gui.ent_box;
	import flash.utils.*;
	import flash.events.*;
	import flash.text.*;
	
	public class active_line extends Sprite{
		
		private const MAX:uint = 1;
		private const MIN:uint = 0;
		private var _lines:Array;
		private var _time:Number;
		private var _height:uint;
		private var _range:Array;
		private var _width:uint;
		private var _seconds:uint;
		private var _disp_seconds:uint;
		private var _pps:Number;
		private var _border:ent_box;
		private var _grid:Sprite;
		private var _step:uint;
		private var _timer:Timer;
		
		public function active_line(lines:Array, wid:uint, het:uint, secs:uint, step:uint, range:Array):void{
			_lines = new Array();			
			_width = wid;
			_height = het;
			_seconds = secs;
			_pps = _width/_seconds;
			_disp_seconds = _seconds*.65;
			_range = range;
			_step = step;
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, update)
			create_display(lines);
		}
		
		private function create_grid(){
			_grid = new Sprite();
			_grid.graphics.clear();
			_grid.graphics.lineStyle(1, 0x666666, 100, true);
			_grid.graphics.moveTo(0, 0);
			var _x:uint = 0;
			while(_x <= _width){
				_grid.graphics.moveTo(_x, 0);
				_grid.graphics.lineTo(_x, _height);
				_x+=_pps;
			}
			_grid.graphics.moveTo(0, 0);
			var num_steps:int = Math.ceil((_range[MAX] - _range[MIN])/_step);
			var spacing:Number = _height/num_steps;
			var _y:uint = 0;
			var i:uint = 0;
			while(_y <= _height){
				_grid.graphics.moveTo(0, _y);
				_grid.graphics.lineTo(_width, _y);
				var a:TextField = new TextField();
				a.text = String(_range[MAX]-(_step*i));
				a.height = 12;
				a.width = 60;
				a.y = _y-(a.height/2);
				a.selectable = false;
				a.autoSize = TextFieldAutoSize.LEFT;
				a.x = -(a.width);
				a.textColor = 0xFFFFFF;
				_grid.addChild(a);
				_y+=spacing;
				i++;
			}
			addChild(_grid);
		}
		
		public function start(){
			_timer.start();
		}
		
		private function create_border(){
			_border = new ent_box(_width, _height, 0, 0xFFFFFF, 100, 0xFFFFFF, 0, false, false);
			addChild(_border);
		}
		
		private function create_display(lines){			
			create_grid();
			for(var i = 0; i < lines.length; i++){
				var a:Sprite = new Sprite();
				_lines.push({disp:a, color:lines[i], items:[]});
				addChild(a);
			}
			create_border();
		}
		
		private function update(e:TimerEvent){
			var ar:Array = []
			for(var i:uint = 0; i < _lines.length; i++){
				if(_lines[i].items.length){
					ar[i] = _lines[i].items[_lines[i].items.length-1].value;
				}
			}
			add(ar);
			draw();
		}
		
		private function populate_array(line:Object, val:Number){
			var d:Date = new Date();
			var now:uint = d.getTime();
			var obj:Object = {value:val, time:now};
			if(line.items.length){
				for(var i in line.items){
					var st:uint = line.items[i].time;
					if(((now - st)/1000) > _disp_seconds) line.items.splice(i, 1);
				}
				line.items.push(obj);
			}else{
				line.items.push(obj);
			}
			//trace(line.items.length);
		}
		
		public function add(ar:Array){
			//trace(ar);
			for(var i:uint = 0; i < _lines.length; i++){
				if(ar[i] != -1){
					populate_array(_lines[i], ar[i]);
				}
			}
		}
		
		private function draw(){
			for(var i:uint = 0; i < _lines.length; i++){
				if(_lines[i].items.length){
					var _last:uint = _lines[i].items[0].time;
					_lines[i].disp.graphics.clear();
					_lines[i].disp.graphics.lineStyle(3, _lines[i].color, 100, true);
					var val:Number = _lines[i].items[0].value-_range[MIN];
					var range:Number = _range[MAX] - _range[MIN];
					var _y:Number = _height - ((_height/range)*val);
					_lines[i].disp.graphics.moveTo(0, _y);
					for(var t:uint = 0; t < _lines[i].items.length; t++){
						//trace(_pps+" || "+_lines[i].items[t].time+" - "+_last+" = "+(_lines[i].items[t].time-_last))
						var _x:Number = ((_lines[i].items[t].time-_last)/1000)*_pps;
						var val:Number = _lines[i].items[t].value-_range[MIN];
						var range:Number = _range[MAX] - _range[MIN];
						var _y:Number = _height - ((_height/range)*val);
						//trace(_x+" | "+_y);
						_lines[i].disp.graphics.lineTo(_x, _y);
						//_last = _lines[i].items[t].time;
					}
				}
			}
		}
		
	}
	
}