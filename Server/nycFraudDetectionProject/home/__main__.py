'''
Created on Dec 14, 2020

@author: Harvey.Imama
'''
import cherrypy
from webService import conf
from consumer import tc
from persistence import conn
from services import trainService


if __name__ == '__main__':
    conn.Connect()
    trainService.Trainer()
    conf.WSProcessor()
    tc.TransactionConsumer().run()
    
   
    