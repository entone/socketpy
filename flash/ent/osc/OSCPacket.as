package ent.osc { 
	/**
	 * @author adam
	 * 
	 * OSC packet object
	 * 
	 * (c) 2007 Fwiidom.org
	 * 
	 */
	public class OSCPacket {
	
		public var address 	: String;
		public var port 	: Number;
		public var time 	: Number;
		
		public var name		: String;
		public var data 	: Array;	
		
		public function OSCPacket(inName:String, inData:Array, inAddress:String, inPort:Number) {
			address = inAddress;
			port = inPort;
			
			name = inName;	//e.g - "/foo/bar"
			data = inData;  //e.g - ["moo"]
			
			time = 0;
		}
		
	}
}