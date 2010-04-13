import socket
import select
from lib.event import event

class server(object):

	def __init__(self, host, tcp_port, udp_port):
		self.types = {'tcp':self.enable_tcp, 'udp':self.enable_udp}
		self.type_accept = {'tcp':self.accept_tcp, 'udp':self.accept_udp}
		self.type_send = {'tcp':self.send_tcp, 'udp':self.send_udp}
		
		self.buffer = ""
		#events
		
		self.started = event()
		self.received_tcp = event()
		self.received_udp = event()
		self.stop = event()
		self.new_udp_client = event()
		self.new_tcp_client = event()
		self.error = event()
		self.socket_closed = event()
		
		self.ip = socket.gethostbyname(socket.gethostname())
		self.tcp_port = tcp_port
		self.udp_port = udp_port
		self.host = host
		self.type = type
		self.tcp = self.setup_socket('tcp')
		self.udp = self.setup_socket('udp')
		self.inputs = [self.udp, self.tcp]
		self.outputs = []
		self.connections = []
		self.running = False
		
	def setup_socket(self, type):
		try:
			return self.types.get(type)()
		except socket.error, err:
			print "Couldn't be a server on port %d : %s" % (self.tcp_port, err)
	
	def enable_tcp(self):
		soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		soc.bind((self.host, self.tcp_port))
		soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 0)
		soc.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
		soc.listen(1)
		return soc
	
	def enable_udp(self):
		soc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
		soc.bind((self.host, self.udp_port))
		soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 0)
		soc.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
		return soc
		
	def accept_type(self):
		data = self.type_accept.get(self.type)()
		return data
		
			
	def accept_udp(self):
		data, address = self.udp.recvfrom(512)
		address = (address[0], self.udp_port)
		try:
			self.connections.index(address)
		except ValueError:
			self.connections.append(address)
			self.new_udp_client(address)
			
		return data
		
	
	def accept_tcp(self):
		client, addr = self.tcp.accept()
		self.inputs.append(client)
		self.new_tcp_client(client)
		return False
		
	def send_data(self, type, data, cli_add):
		try:
			self.type_send.get(type)(data, cli_add)
		except socket.error, msg:
			print msg
			pass
	
	def send_udp(self, data, add):
		self.udp.sendto(data, add)
		
	def send_tcp(self, data, client):
		client.sendall(data)
		

	def start(self):
		self.running = True		
		while self.running:
			try:
				inputs, output, exc = select.select(self.inputs, self.outputs, [])
			except socket.error, msg:
				print msg
				break
			data = False
			if(self.udp in inputs): data = self.accept_udp()
			if(self.tcp in inputs): self.accept_tcp()
			for sock in inputs:
				tcp = False
				if(sock == self.tcp): continue
				if(data == False):
					tcp = True
					try:
						data = sock.recv(512)
					except:
						#self.socket_closed(sock)
						print "socket is gone"
				if data:
					if(sock == self.udp): 
						self.received_udp(data)
					elif(tcp):
						self.received_tcp(data, sock)
				elif data == False or data =='':
					print "no data"
					self.socket_closed(sock)
					self.inputs.remove(sock)
					sock.close()
					
	
	def __del__(self):
		self.close()
	
	def close(self):
		#self.sock.close()
		print "Server closed"
						
	
	
	