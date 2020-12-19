'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
from messenger import HttpRequester
class emailMessenger():
    '''
    The email messenger is responsible for sending email messages when a transaction  is flagged
    '''


    def __init__(self):
        '''
        Declare external email gateway service
        '''
        self.url = "http://fetspay.fetswallet.com/rest/sendEmail"
        
    def send(self,data,probs):
        
        request = 'The Transaction with details below was flagged with score '+str(probs) 
        request = request+" "+str(data.loc[0,])
        
        print(request)
            
        HttpRequester.RequestProcessor(self.url).process(request)