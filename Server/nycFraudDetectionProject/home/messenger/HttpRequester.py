'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''

class RequestProcessor():
    '''
    classdocs
    '''


    def __init__(self, url):
        '''
        Constructor
        '''
        self.url = url  
        
    def process(self,params):
        resp = requests.post(self.url, json=params)
        if resp.status_code != 200:
            raise ApiError('POST /tasks/ {}'.format(resp.status_code))
        