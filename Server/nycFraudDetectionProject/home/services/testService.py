'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
from services import trainService
import pandas as pd


class Tester():
    '''
    The tester is responsible for providing predictions by passing transaction data to the predict function of the Model
    '''


    def __init__(self):
        '''
        It is required to get the current working model
        The object would train again if it finds no available fitted models
        '''
        if trainService.fittedModel is None:  
            trainService.fittedModel =  trainService.Trainer().getModel() 
        
        self.model = trainService.fittedModel
        
        
    def predictOutcome(self,transaction):
        return self.model.predict(self.__dummify__(transaction))
    
    def getProbablity(self,transaction):
        
        return  self.model.predict_proba(self.__dummify__(transaction))
    
    '''
    Dummification is required because of all the categorical features in dataset
    '''
    def __dummify__(self,t):
         
         model_data = pd.concat((self.__getDayDum__(t['day_of_the_week']),self.__getBHDum__(t['time_of_the_day']),self.__getCHDum__(t['channel']),self.__getCustDum__(t['customer_type']),self.__getYNDum__(t['has_bvn'], 'BVN'),self.__getYNDum__(t['has_address'], 'Addy'),self.__getYNDum__(t['is_key_customer'], 'Key'),self.__getYNDum__(t['has_customer_capabilities'], 'CC'),self.__getTierDum__(t['tier']) ,t[['week_of_the_month','total_debit_so_far' ,'total_credit_so_far','alert_type']]), axis=1)
         for col in model_data.columns: 
            print(col) 
            print('==')
            print(model_data[col])
         return model_data
     
    def __getYNDum__(self,item,pref):
        
         Item = {'item' : [item.iloc[0],'Y','N']}
         Itemp = pd.DataFrame(data=Item)
         Item_dummies = pd.get_dummies(Itemp, prefix=pref)
         df = Item_dummies.drop(pref+'_N',axis=1)
         return df[df.index==0]   
         
    def __getDayDum__(self,item):
        
         Item = {'item' : [item.iloc[0],'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']}
         df = self.__doDummifyProcess__(Item,'Day','Day_Monday')
         return df[df.index==0]
     
    def __getBHDum__(self,item):
        
         Item = {'item' : [item.iloc[0],'Business Hours','off peak']}
         df = self.__doDummifyProcess__(Item,'Time','Time_Business Hours')
         return df[df.index==0]
     
    def __getCHDum__(self,item):
        
         Item = {'item' : [item.iloc[0],'CONSOLE','BETTING USSD','FETS MOBILE APP','FETS WEB','FETS USSD','IBEDC','fets POS','WEB','USSD','SCHEDULED','ATM','BANK TELLER','MOBILE BANKING','OTHERS','WEBSERVICE','mCash']}
         df = self.__doDummifyProcess__(Item,'Channel','Channel_CONSOLE')
         return df[df.index==0]
    
    def __getTierDum__(self,item):
        
         Item = {'item' : [item.iloc[0],'1st Tier','2nd Tier','3rd Tier']}
         df = self.__doDummifyProcess__(Item,'Tier','Tier_1st Tier')
         return df[df.index==0]
     
    def __getCustDum__(self,item):
        
         Item = {'item' : [item.iloc[0],'MERCHANT','CUSTOMER','AGENTCM','AGENT','DEALER']}
         df = self.__doDummifyProcess__(Item,'Type','Type_CUSTOMER')
         return df[df.index==0]
     
    def  __doDummifyProcess__(self,Item,pref,header):
         Itemp = pd.DataFrame(data=Item)
         Item_dummies = pd.get_dummies(Itemp, prefix=pref)
         df = Item_dummies.drop(header,axis=1)
         return df
         