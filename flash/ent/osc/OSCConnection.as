package ent.osc { 
	/**
	 * @author adam
	 *(based originally on demo code included with Flosc)
	 * 
	 * (c) 2007 Fwiidom.org
	 */
	 
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.XMLSocket;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	public class OSCConnection extends EventDispatcher {		
		
		protected var mSocket:XMLSocket;
		protected var mPort:Number;
		protected var mIp:String;
		
		protected var mDefaultSendPort:Number;
		protected var mDefaultSendIp:Number;
		
		protected var mConnected:Boolean;
		
		public function OSCConnection(inIp:String, inPort:Number) {
			super();
			mIp = inIp;
			mPort = inPort;			
		}
		
		public function connect () : void {
			mSocket = new XMLSocket();
			mSocket.addEventListener(Event.CONNECT,onConnect);
			mSocket.addEventListener(Event.CLOSE,onClose);
			mSocket.addEventListener(DataEvent.DATA,onXml);
			mSocket.connect(mIp,mPort);
		}
		
		public function disconnect () : void {
			mSocket.close();
			mConnected = false;
		}
		
		
		// *** event handler for incoming XMLDocument-encoded OSC packets
		protected function onXml (e:DataEvent) : void {
			var inXml:XMLDocument = new XMLDocument(e.data);
			//trace("OSCConnection.onXml---"+inXml);
			// parse out the packet information
			var n:XMLNode = inXml.firstChild;
			if (n != null && n.nodeName == "OSCPACKET") {
				parseXml(n);
			}	
		}
	
	
		// *** event handler to respond to successful connection attempt
		protected function onConnect (succeeded:Boolean) : void {
			//trace("OSCConnection.onConnect(succeeded)");
			if(succeeded) {
				//trace ("success");
				dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_CONNECT,null));
				mConnected = true;
			} else {
				//trace ("fail");
				onConnectError();
			}		
		}
	
	
		// *** event handler called when server kills the connection
		protected function onClose (e:Event) : void {
			//trace("OSCConnection.onClose()");
			mConnected = false;
			dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_CLOSE));
		}
	
	
		protected function onConnectError() : void {
			//trace("OSCConnection.onConnectError()");
			mConnected = false;		
			dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_CONNECT_ERROR));
		}
		
		// *** parse the messages from some XMLDocument-encoded OSC packet	
		protected function parseXml(node:XMLNode) : void {
			//trace("OSCConnection.parseXml(node)");
			//trace (node);
			if (node.firstChild.nodeName == "MESSAGE") {
				var message:XMLNode = node.firstChild;
							
				var name:String = message.attributes.NAME;			
				var data:Array = [];
				for (var child:XMLNode = message.firstChild; child != null; child=child.nextSibling) {
					if (child.nodeName == "ARGUMENT") {
						var type:String = child.attributes.TYPE;
						//boolean
						if (type=="T" || type=="F") {
							data.push((type=="T")?true:false);	
						} else
						//float
						if (type=="f") {
							data.push(parseFloat(child.attributes.VALUE));
						} 
						//Added by Barton (http://phy5ics.com/blog) for Make Controller compatibility
						else if (type=="i") {
							data.push(parseFloat(child.attributes.VALUE));
						} else 
						//string
						if (type=="s") {
							data.push(child.attributes.VALUE);
						}	
					}
				}
	
				var packet:OSCPacket = new OSCPacket(name, data, node.attributes.address, node.attributes.port);
				packet.time = node.attributes.time; 	
				dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_PACKET_IN,packet));					
			}
			else { 
				// look recursively for a message node
				for (var subchild:XMLNode = node.firstChild; subchild != null; subchild=subchild.nextSibling) {
					parseXml(subchild);
				}
			}
		}
	
	
	
		// *** build and send XMLDocument-encoded OSC
		
		public function sendOSCPacket(outPacket:OSCPacket) : void {
			var xmlOut:XMLDocument = new XMLDocument();
				
			var osc:XMLNode = xmlOut.createElement("OSCPACKET");
			osc.attributes.TIME = 0;
			osc.attributes.PORT = outPacket.port;
			osc.attributes.ADDRESS = outPacket.address;
		
			var message:XMLNode = xmlOut.createElement("MESSAGE");
			message.attributes.NAME = outPacket.name;
		
			for (var i:Number=0;i<outPacket.data.length; i++) {
				// send everything as a string
				// NOTE : the server expects all strings to be encoded
				// with the escape function.
				var argument:XMLNode = xmlOut.createElement("ARGUMENT");			
				argument.attributes.TYPE = "s";
				argument.attributes.VALUE = escape(outPacket.data[i]);
				message.appendChild(argument);
			}
						
			osc.appendChild(message);
			xmlOut.appendChild(osc);
			
			//trace ("XMLDocument SEND - ");
			trace (xmlOut);
		
			if (mSocket && mConnected) {
				mSocket.send(xmlOut);
				dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_PACKET_OUT,outPacket));
			}
		}
	}
}