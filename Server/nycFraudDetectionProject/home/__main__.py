'''
Created on Dec 14, 2020

@author: Harvey.Imama
'''
import cherrypy
from webService import conf
from consumer import tc
from persistence import conn
from services import trainService
from scheduler import sh


if __name__ == '__main__':
    conn.Connect()
    trainService.Trainer()
    sh.Schedule()
    conf.WSProcessor()
    tc.TransactionConsumer().run()
    
   
    