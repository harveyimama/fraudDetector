# 1. Library
library(RMySQL)
library(ggplot2)
library(flexdashboard)
library(dplyr)
library(formattable)


# 2. Settings
db_user <- 'root'
db_password <- '1W2w1s500.'
db_name <- 'aml'
db_table <- 'transaction'
db_host <- '127.0.0.1' # for local access
db_port <- 3306

# 3. Read data from db
mydb <-  dbConnect(MySQL(), user = db_user, password = db_password,
                   dbname = db_name, host = db_host, port = db_port)
s <- paste0("select * from ", db_table)
rs <- dbSendQuery(mydb, s)
transaction.data <-  fetch(rs, n = -1)
on.exit(dbDisconnect(mydb))