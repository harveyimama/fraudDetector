'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
from messenger import HttpRequester
class emailMessenger():
    '''
    classdocs
    '''


    def __init__(self, params):
        '''
        Constructor
        '''
        self.url = "http://fetspay.fetswallet.com/rest/sendEmail"
        
    def send(self,data,probs):
        
        request = 'The Transaction with details below was flagged with score '+probs[0]+':'+probs[1] 
        
        for idex in data.index:
            request = request+str(data[idex])
        
        print(request)
            
        HttpRequester.RequestProcessor().process(request)