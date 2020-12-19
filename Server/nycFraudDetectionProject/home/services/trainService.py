'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
from persistence import conn
import pandas as pd
from sklearn.tree import DecisionTreeClassifier # Import Decision Tree Classifier
from sklearn.model_selection import train_test_split # Import train_test_split function
from sklearn import metrics #Import scikit-learn metrics module for accuracy calculation


class Trainer():
    '''
    classdocs
    '''
    TRANSACTION = "Transaction"
    MAX_DEPTH = 10000
    model = None
   

    def __init__(self):
        '''
        Constructor
        '''
        global fittedModel 
        self.__doTrain__()    
        fittedModel = self.model
            
       
       
    def getModel (self):
        return self.model 
    
    
    def __doTrain__ (self):
        self.model = DecisionTreeClassifier(max_depth=self.MAX_DEPTH)  
        
        data = self.__getData__()
       
        feature_cols = ['week_of_the_month','day_of_the_week' ,'time_of_the_day','channel','total_debit_so_far' ,'total_credit_so_far' ,'customer_type','has_bvn','has_address','is_key_customer','tier','has_customer_capabilities','is_flagged','alert_type']
        X = data[feature_cols] # Features
        y = data.is_flagged # Target variable
        #X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1)
        print('Training Model............ this should take about 5 minutes')
        self.model.fit(self.__getDummified__(X),y) 
        print('Getting score............ this should take about 5 minutes')
        print('score is = ')
        print(self.model.score(self.__getDummified__(X),y))
        
        
    def __getData__ (self):
        
        connection = conn.Connect()
        print('Loading data............ this should take about 15 minutes')
        data = connection.find(self.TRANSACTION,None) 
        connection.closeConnect()
            
        return data
       
    def __getDummified__ (self,X):
        
        day_of_the_week = pd.get_dummies(X['day_of_the_week'], prefix='Day')
        time_of_the_day = pd.get_dummies(X['time_of_the_day'], prefix='Time')
        channel = pd.get_dummies(X['channel'], prefix='Channel')
        customer_type = pd.get_dummies(X['customer_type'], prefix='Type')
        has_bvn = pd.get_dummies(X['has_bvn'], prefix='BVN')
        has_address = pd.get_dummies(X['has_address'], prefix='Addy')
        is_key_customer = pd.get_dummies(X['is_key_customer'], prefix='Key')
        has_customer_capabilities = pd.get_dummies(X['has_customer_capabilities'], prefix='CC')
        tier = pd.get_dummies(X['tier'], prefix='Tier')
       
        model_data = pd.concat((day_of_the_week.drop('Day_Monday',axis=1),time_of_the_day.drop('Time_Business Hours',axis=1),channel.drop('Channel_CONSOLE',axis=1),customer_type.drop('Type_CUSTOMER',axis=1),has_bvn.drop('BVN_N',axis=1),has_address.drop('Addy_N',axis=1),is_key_customer.drop('Key_N',axis=1),has_customer_capabilities.drop('CC_N',axis=1),tier.drop('Tier_1st Tier',axis=1), X[['week_of_the_month','total_debit_so_far' ,'total_credit_so_far','alert_type']]), axis=1)
    
        return model_data