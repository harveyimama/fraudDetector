'''
Created on Dec 15, 2020

@author: Harvey.Imama
Testing out the model on Python
'''
from sqlalchemy import create_engine
import pymysql
import numpy as np
from sklearn.metrics import classification_report
from sklearn.model_selection import cross_val_score 
import pandas as pd
from sklearn.tree import DecisionTreeClassifier # Import Decision Tree Classifier
from sklearn.model_selection import train_test_split # Import train_test_split function
from sklearn import metrics #Import scikit-learn metrics module for accuracy calculation

def   getData(X): 
       
    day_of_the_week = pd.get_dummies(X['day_of_the_week'], prefix='Day')
    time_of_the_day = pd.get_dummies(X['time_of_the_day'], prefix='Time')
    channel = pd.get_dummies(X['channel'], prefix='Channel')
    customer_type = pd.get_dummies(X['customer_type'], prefix='Type')
    has_bvn = pd.get_dummies(X['has_bvn'], prefix='BVN')
    has_address = pd.get_dummies(X['has_address'], prefix='Addy')
    is_key_customer = pd.get_dummies(X['is_key_customer'], prefix='Key')
    has_customer_capabilities = pd.get_dummies(X['has_customer_capabilities'], prefix='CC')
    tier = pd.get_dummies(X['tier'], prefix='Tier')
       
    return pd.concat((day_of_the_week.drop('Day_Monday',axis=1),time_of_the_day.drop('Time_Business Hours',axis=1),channel.drop('Channel_CONSOLE',axis=1),customer_type.drop('Type_CUSTOMER',axis=1),has_bvn.drop('BVN_N',axis=1),has_address.drop('Addy_N',axis=1),is_key_customer.drop('Key_N',axis=1),has_customer_capabilities.drop('CC_N',axis=1),tier.drop('Tier_1st Tier',axis=1), X[['week_of_the_month','total_debit_so_far' ,'total_credit_so_far','alert_type']]), axis=1)

def dummify(t):
         
         model_data = pd.concat((getDayDum(t['day_of_the_week']),getBHDum(t['time_of_the_day']),getCHDum(t['channel']),getCustDum(t['customer_type']),getYNDum(t['has_bvn'], 'BVN'),getYNDum(t['has_address'], 'Addy'),getYNDum(t['is_key_customer'], 'Key'),getYNDum(t['has_customer_capabilities'], 'CC'),getTierDum(t['tier']) ,t[['week_of_the_month','total_debit_so_far' ,'total_credit_so_far','alert_type']]), axis=1)
         return model_data
     
def getYNDum(item,pref):
        
         Item = {'item' : [item.iloc[0],'Y','N']}
         Itemp = pd.DataFrame(data=Item)
         Item_dummies = pd.get_dummies(Itemp, prefix=pref)
         df = Item_dummies.drop(pref+'_N',axis=1)
         return df[df.index==0]   
         
def getDayDum(item):
        
         Item = {'item' : [item.iloc[0],'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']}
         df = doDummifyProcess(Item,'Day','Day_Monday')
         return df[df.index==0]
     
def getBHDum(item):
        
         Item = {'item' : [item.iloc[0],'Business Hours','off peak']}
         df = doDummifyProcess(Item,'Time','Time_Business Hours')
         return df[df.index==0]
     
def getCHDum(item):
        
         Item = {'item' : [item.iloc[0],'CONSOLE','BETTING USSD','FETS MOBILE APP','FETS WEB','FETS USSD','IBEDC','fets POS','WEB','USSD','SCHEDULED','ATM','BANK TELLER','MOBILE BANKING','OTHERS','WEBSERVICE','mCash']}
         df = doDummifyProcess(Item,'Channel','Channel_CONSOLE')
         return df[df.index==0]
    
def getTierDum(item):
        
         Item = {'item' : [item.iloc[0],'1st Tier','2nd Tier','3rd Tier']}
         df = doDummifyProcess(Item,'Tier','Tier_1st Tier')
         return df[df.index==0]
     
def getCustDum(item):
        
         Item = {'item' : [item.iloc[0],'MERCHANT','CUSTOMER','AGENTCM','AGENT','DEALER']}
         df = doDummifyProcess(Item,'Type','Type_CUSTOMER')
         return df[df.index==0]
     
def  doDummifyProcess(Item,pref,header):
         Itemp = pd.DataFrame(data=Item)
         Item_dummies = pd.get_dummies(Itemp, prefix=pref)
         df = Item_dummies.drop(header,axis=1)
         return df
 
json = '[{"amount": 0.01,"week_of_the_month": 1,"day_of_the_week":"Sunday" ,"time_of_the_day":"Business Hours","channel":"fets POS","transaction_type":"BILLS-PAYMENT","total_debit_so_far": 985500,"total_credit_so_far": 550,"balance": 1500,"customer_type":"AGENT","has_bvn":"N","has_address":"N","is_key_customer":"Y","tier":"2nd Tier","has_customer_capabilities":"N","is_flagged": "T","alert_type": 2,"alert_count": 670}]'
 
test_data = pd.read_json(json)    
sqlEngine  = create_engine('mysql+pymysql://root:1W2w1s500.@127.0.0.1/aml', pool_recycle=3600)
dbConnection = sqlEngine.connect()
data = pd.read_sql('select * from transaction',dbConnection)
dbConnection.close()
        
model = DecisionTreeClassifier()    
feature_cols = ['week_of_the_month','day_of_the_week' ,'time_of_the_day','channel','total_debit_so_far' ,'total_credit_so_far' ,'customer_type','has_bvn','has_address','is_key_customer','tier','has_customer_capabilities','is_flagged','alert_type']
X = data[feature_cols] # Features
y = data.is_flagged # Target variable
#X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.5, random_state=1)
model.fit(getData(X),y) 
score = model.score(getData(X),y)
print(score)
       
y_pred = model.predict(dummify(test_data))
#accuracy = np.mean(cross_val_score(model, getData(X), dummify(test_data), scoring='accuracy')) * 100
#print("Accuracy: {}%".format(accuracy))
#print('confusion matrix {}'.format(pd.DataFrame(
#            confusion_matrix(dummify(test_data), y_pred),
#            columns=['Predicted Loss', 'Predicted Win'],
#            index=['True Loss', 'True Win']
#        )))        
y_pred_p = model.predict_proba(dummify(test_data))
print(y_pred_p)
print(y_pred)

json = '[{"amount": 10000,"week_of_the_month": 2,"day_of_the_week":"Monday" ,"time_of_the_day":"Business Hours","channel":"CONSOLE","transaction_type":"BILLS-PAYMENT","total_debit_so_far": 5500,"total_credit_so_far": 1550,"balance": 1500,"customer_type":"AGENTCM","has_bvn":"N","has_address":"N","is_key_customer":"Y","tier":"1st Tier","has_customer_capabilities":"N","is_flagged": "T","alert_type": 2,"alert_count": 670}]'
test_data2 = pd.read_json(json)  

y_pred2 = model.predict(dummify(test_data2))      
y_pred_p2 = model.predict_proba(dummify(test_data2))
print(y_pred_p2)
print(y_pred2)

  
       