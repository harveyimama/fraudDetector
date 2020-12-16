'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
from services import trainService
class Tester(object):
    '''
    classdocs
    '''


    def __init__(self, params):
        '''
        Constructor
        '''
        self.model  =  trainService.Trainer().getModel() 
        
        
    def predictOutcome(self,transaction):
        
        return self.model.predict(transaction)