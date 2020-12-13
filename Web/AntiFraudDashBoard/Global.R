# 1. Library
library(RMySQL)

# 2. Settings
db_user <- 'root'
db_password <- 'fets123.'
db_name <- 'fddb'
db_table <- 'transactions'
db_host <- '127.0.0.1' # for local access
db_port <- 3306

# 3. Read data from db
mydb <-  dbConnect(MySQL(), user = db_user, password = db_password,
                   dbname = db_name, host = db_host, port = db_port)
s <- paste0("select * from ", db_table)
rs <- dbSendQuery(mydb, s)
transaction.data <-  fetch(rs, n = -1)
on.exit(dbDisconnect(mydb))