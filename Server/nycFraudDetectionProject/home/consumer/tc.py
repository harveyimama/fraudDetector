'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''

from kafka import KafkaConsumer
import sys
import pandas as pd
from services  import testService
from persistence  import conn
from messenger  import sms
from messenger  import email
import logging
import threading

class TransactionConsumer:
    '''
    classdocs
    '''
    TRANSACTION = "transaction"

    def __init__(self):
        '''
        Constructor
        '''
        self.bootstrap_servers = ['localhost:9092']
        self.topicName = 'transaction-fraud-check'
        self.consumer = KafkaConsumer (self.topicName, group_id = 'group1',bootstrap_servers = self.bootstrap_servers,auto_offset_reset = 'earliest')
        
        
    
    def run(self):
        try:
            for message in self.consumer:
                print ("%s:%d:%d: key=%s value=%s" % (message.topic, message.partition,message.offset, message.key,message.value))
                data = pd.read_json(message.value) 
                outcome = testService.Tester().predictOutcome(data) 
                
                if outcome == True:
                    x = threading.Thread(target=self.__sendMessage__, args=(data,)) 
                    x.start()
                    logging.info("Thread %s: starting", "heyyyyyy")        
                self. __saveOutcome_(data,outcome)
                
                
        except KeyboardInterrupt:
            sys.exit()
            
            
    def __saveOutcome_(self,data,outcome):
        data.isflagged = outcome
        conn.Connect().save(self.TRANSACTION,data)
        
    def __sendMessage__(self,data):
        email.emailMessenger().send(data)
        sms.SMSMessenger().send(data)