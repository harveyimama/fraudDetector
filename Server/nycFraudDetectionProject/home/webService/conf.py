'''
Created on Dec 12, 2020

@author: Harvey.Imama
'''
import cherrypy
from webService import ws

class WSProcessor: 
        
    def __init__ (self):        
       config = {'server.socket_host': '0.0.0.0'}
       cherrypy.config.update(config)
       cherrypy.quickstart(ws.MyWebService())  
        