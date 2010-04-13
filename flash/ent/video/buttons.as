package ent.video{
	
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import ent.utils.loader_que;
	import ent.gui.button;
	
	public class buttons extends Sprite{
		private var _base_url:String;
		private var _buttons:Array;
		private var _que:loader_que;
		private var _objs:Array;
		
		public function buttons(base_url:String, _prefix:String){
			_base_url = base_url;
			_que = new loader_que(on_done);
			_buttons = new Array();
			_buttons['pause'] = _prefix+'_pause';
			_buttons['forward'] = _prefix+'_forward';
			_buttons['play'] = _prefix+'_play';
			_buttons['back'] = _prefix+'_back';
			_objs = new Array();
			init();
		}
		
		private function on_done():void{
			var len:Number = 0;
			var order:Array = ['back', 'pause', 'play', 'forward']
			for(var i:uint = 0; i < order.length; i++){
				var hold:button = new button(_objs[order[i]].mc, _objs[order[i]+"_down"].mc, _objs[order[i]].mc, order[i]);
				hold.x = len;
				len+=hold.width;
				addChild(hold);
			}
			addEventListener('button_click', click);
		}
		
		private function click(event:Event):void{
			dispatchEvent(new Event(_buttons[event.target.key], true));
		}
		
		private function init():void{
			for(var i:String in _buttons){
				var name:String = i;
				var a:Object = new Object();
				a.loader = new Loader();
				a.url = new URLRequest(_base_url+name+".png");
				a.mc = new Sprite();
				a.mc.addChild(a.loader);
				
				a.complete = function(event:Event):void{
					trace(this.mc.height);
				}
				
				a.progress = function(event:ProgressEvent):void{
					//trace(this.mc+" :: "+event.bytesLoaded);
				}
				
				_objs[name] = a;
				
				var bname:String = i+"_down";
				var b:Object = new Object();
				b.loader = new Loader();
				b.url = new URLRequest(_base_url+bname+".png");
				b.mc = new Sprite();
				b.mc.addChild(b.loader);
				
				b.complete = function(event:Event):void{
					trace("COMPLETE: "+this.mc.height);
				}
				
				b.progress = function(event:ProgressEvent):void{
					//trace(this.mc+" :: "+event.bytesLoaded);
				}
				
				_objs[bname] = b;
				
				_que.add_element(a);
				_que.add_element(b);
			}
		}
		
	}
}