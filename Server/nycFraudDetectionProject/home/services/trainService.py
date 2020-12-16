'''
Created on Dec 15, 2020

@author: Harvey.Imama
'''
from persistence import conn
import pandas as pd
from sklearn.tree import DecisionTreeClassifier # Import Decision Tree Classifier
from sklearn.model_selection import train_test_split # Import train_test_split function
from sklearn import metrics #Import scikit-learn metrics module for accuracy calculation

class Trainer(object):
    '''
    classdocs
    '''
    TRANSACTION = "Transaction"
    MAX_DEPTH = 3

    def __init__(self, params):
        '''
        Constructor
        '''
        if self.model is None:
            self.__doTrain__()    
            
       
       
    def getModel (self):
        return self.model 
    
    
    def __doTrain__ (self):
        self.model = DecisionTreeClassifier(max_depth=self.MAX_DEPTH)  
        
        data = self.__getData__()
       
        feature_cols = ['amount', 'insulin', 'bmi', 'age','glucose','bp','pedigree']
        X = data[feature_cols] # Features
        y = data.isflagged # Target variable
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1)
        self.model = self.model.fit(X_train,y_train)
        
        
    def __getData__ (self):
        
        connection = conn.Connect()
        data = connection.find(self.TRANSACTION,None) 
        connection.closeConnect()
        return data
       
        
        