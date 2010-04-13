package ent.utils{
	
	import flash.events.Event;
	
	public class ent_event extends Event{
		private var _data:*;
		function ent_event(_type:String, mess:Object=false){
			_data = mess;
			super(_type);
		}
		
		public function get_data():*{
			return _data;
		}
	}
}