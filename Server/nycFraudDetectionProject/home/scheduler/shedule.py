'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
import schedule
import time
from services import trainService
class Scheduler(object):
    '''
    classdocs
    '''


    def __init__(self, params):
        '''
        Constructor
        '''
        schedule.every(1).week.do(self.__doRun__)
     
        
    def __doRun__(self):   
        trainService.Trainer()