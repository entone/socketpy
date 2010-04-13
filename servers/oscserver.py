from lib.event import *
from lib.oscAPI import *
from lib.OSC import *

class oscserver(object):

	def __init__(self, server):
		self.server = server
		self.server.received_udp+= self.got_data
		self.got_packet = event()
	
	def send_packet(self, packet):
		osc = self.create_osc(packet)
		self.server.send_data('udp', osc, self.address)
		
	def create_packet(self, address, arguments):
		if not isinstance(arguments, list): arguments = [arguments]
		return {'address':address, 'arguments':arguments}
	
	def got_data(self, data):
		objs = self.osc_list(data)
		for ob in objs:
			self.got_packet(ob)
					
	def create_osc(self, packet):
		if isinstance(packet, list):
			bundle = createBundle()
			for msg in packet:
				appendToBundle(bundle, msg['address'], msg['arguments'])
			ret = bundle.message
		else:
			ret = createBinaryMsg(packet['address'], packet['arguments'])
		
		return ret
	
	def osc_list(self, data):
		message = decodeOSC(data)
		messes = [];
		if isinstance(message[0], list):
			for mess in message:
				a = {}
				a['address'] = mess[0]
				a['typetags'] = mess[1]
				a['arguments'] = mess[2:]
				messes.append(a)
		else:
			a = {}
			a['address'] = message[0]
			a['typetags'] = message[1]
			a['arguments'] = message[2:]
			messes.append(a)
			
		return messes
	