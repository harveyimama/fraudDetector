'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
import schedule
import time
from services import trainService
class Schedule(object):
    '''
    This class is responsible for scheduling model training 
    '''


    def __init__(self):
        '''
        Default training frequency is set at once a week
        '''
        schedule.every(1).week.do(self.__doRun__)
     
        
    def __doRun__(self):   
        trainService.Trainer()