'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''

from sqlalchemy import create_engine
import pymysql
import pandas as pd

class Connect(object):
    '''
    classdocs
    '''


    def __init__(self, params):
        '''
        Constructor
        '''
        self.sqlEngine       = create_engine('mysql+pymysql://root:@127.0.0.1', pool_recycle=3600)
        self.dbConnection    = self.sqlEngine.connect()
        
        
    def closeConnect(self):
        self.dbConnection.Close()
        
    def find (self,table,params):
        paramsString = ""    
        if params != None:   
            for param in params:
                if paramsString == "" : 
                    paramsString=param[0]+" = "+param[1]
                else:
                    paramsString=paramsString+" and "+param[0]+" = "+param[1]
                 
        return pd.read_sql("select * from "+table+" where "+paramsString, self.dbConnection)
  
     
    def save (self,table,params):  
        params.to_sql(table, self.dbConnection, if_exists='fail')
