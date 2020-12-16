'''
Created on Dec 14, 2020

@author: Harvey.Imama
'''
import cherrypy
from webService import conf
from consumer import tc
from persistence import conn


if __name__ == '__main__':
    conf.WSProcessor()
    tc.TransactionConsumer().run()
    conn.connect() 