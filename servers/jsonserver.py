from lib.event import *
import json

class jsonserver(object):
	
	policy_flag = '<policy-file-request/>'
	
	def __init__(self, server):
		self.server = server
		self.server.received_tcp+= self.got_data
		self.server.new_tcp_client+= self.log_client
		self.server.socket_closed+= self.remove_client
		
		self.got_packet = event()
		self.sent_policy_file = event()
		self.tcp_client = event()
		self.clients = []
		self.clients_ok = []
	
	def flash_policy_file(self):
		return """
          <?xml version="1.0"?>
          <cross-domain-policy>
            <allow-access-from domain="*" to-ports="*"/>
          </cross-domain-policy>\0\n"""
	
	def send_packet(self, packet):		
		try:
			jsondata = json.dumps(packet)
			for cli in self.clients_ok:
				self.server.send_data('tcp', jsondata, cli)
		except Exception as msg:
			print(msg)
	
	
	def check_for_debug(self, cli, data):
		if data.find(self.policy_flag) != -1:
			print(self.flash_policy_file())
			self.server.send_data('tcp', self.flash_policy_file(), cli)
			print("Sent policy file!")
			#fire event
			self.sent_policy_file(cli)
			return True
		return False
		
	def remove_client(self, client):
		print("removing client: ", client)
		try:
			self.clients.remove(client)
			self.clients_ok.remove(client)
		except:
			print("no client")
	
	def log_client(self, client):
		self.clients.append(client)
		
	def check_ready(self, obj, cli):
		if 'method' in obj and obj['method'] == 'ready': 
			print("APPENDING NEW OK: ", cli)
			self.clients_ok.append(cli)

	def got_data(self, data, cli):
		print("got data from flash:", data)
		data = str(data)		
		db = self.check_for_debug(cli, data)
		if db != True:
			obj = json.dumps(data)
			self.check_ready(obj, cli)
			self.got_packet(obj)
