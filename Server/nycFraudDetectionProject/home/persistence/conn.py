'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''

from sqlalchemy import create_engine
import pymysql
import pandas as pd

class Connect():
    '''
    This class is responsible for all interactions with the mysql database
    '''


    def __init__(self):
        '''
        All connection parameters are loaded on Initialization 
        '''
        self.sqlEngine  = create_engine('mysql+pymysql://root:1W2w1s500.@127.0.0.1/aml', pool_recycle=3600)
        self.dbConnection = self.sqlEngine.connect()
        
        
    def closeConnect(self):
        self.dbConnection.close()
        
    def find (self,table,params):
        paramsString = ""    
        if params != None:   
            for param in params:
                if paramsString == "" : 
                    paramsString=param[0]+" = "+param[1]
                else:
                    paramsString=paramsString+" and "+param[0]+" = "+param[1]
        if params != None:         
            return pd.read_sql("select * from "+table+" where "+paramsString, self.dbConnection)
        else:
            return pd.read_sql("select * from "+table+" ", self.dbConnection) 
     
    def save (self,table,params):  
        params.to_sql(table, self.dbConnection, if_exists='append')
