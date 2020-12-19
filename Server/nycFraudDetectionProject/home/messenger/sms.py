'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
from messenger import HttpRequester
class SMSMessenger():
    '''
    This class is responsible for sending sms messages when a transaction is flagged
    '''


    def __init__(self):
        '''
        It is required to initialize an object using using the destination url
        '''
        self.url = "http://fetspay.fetswallet.com/rest/sendSMS"
        
    def send(self,data,probs):
        
        request = 'The Transaction with details below was flagged with score '+str(probs) 
        request = request+" "+str(data.loc[0,])
        
        print(request)
            
        HttpRequester.RequestProcessor(self.url).process(request)