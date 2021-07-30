#!/usr/bin/env python
import SimpleHTTPServer
import SocketServer
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer

class myHandler(BaseHTTPRequestHandler):
	
	#Handler for the GET requests
	def do_GET(self):
		self.send_response(200)
		self.send_header('Content-type','text/html')
		self.end_headers()
		# Send the html message
		self.wfile.write("OK")
		return

	def do_POST(self):
		print("Serving Post Request to "+self.path)
		self.send_response(200)
		self.end_headers()
		self.wfile.write("OK")
		return	

PORT = 22022

httpd = SocketServer.TCPServer(("", PORT), myHandler)

print "serving at port", PORT
httpd.serve_forever()
