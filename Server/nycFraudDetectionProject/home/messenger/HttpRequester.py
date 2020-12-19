'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
import requests

class RequestProcessor():
    '''
    This class is responsible for sending http requests to external services
    '''


    def __init__(self, url):
        '''
        It is required to initialize an object of this class by passing the destination URL
        '''
        self.url = url  
        
    def process(self,params):
        resp = requests.post(self.url, json=params)
        if resp.status_code != 200:
            print('POST /tasks/ {}'+format(resp.status_code))
        