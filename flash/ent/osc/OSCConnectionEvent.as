package ent.osc {
	import flash.events.Event;
	 
	/**
	 * @author adam
	 *  
	 * (c) 2007 Fwiidom.org
	 * 
	 */
	public class OSCConnectionEvent extends Event {
		
		public static var ON_CONNECT:String 		= "onConnect";
		public static var ON_CONNECT_ERROR:String 	= "onConnectError";
		public static var ON_CLOSE:String 			= "onClose";
		public static var ON_PACKET_IN:String 		= "onPacketIn";
		public static var ON_PACKET_OUT:String 		= "onPacketOut";
		
		public var data:Object;
		
		public function OSCConnectionEvent(inType:String,inData:Object=null) {
			super(inType);
			data = inData;
		}	
	}
}