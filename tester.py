from servers.jsonserver import *
from servers.server import *
from datetime import datetime
import time

class tester(object):

	def __init__(self):
		print("started at "+str(datetime.today()))
		
		
		self.server = server('127.0.0.1', 6000, 8000)
		
		self.json = jsonserver(self.server)
		self.json.tcp_client+= self.got_flash
		self.json.got_packet+= self.flash_data
			
		self.server.start()
			
	def got_flash(self, client):
		print("Flash connected")
		
	def flash_data(self, data):
		try:
			self.json.send_packet(data)
		except:
			print("probably not parsable by JSON")
