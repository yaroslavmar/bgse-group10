

setwd('~/BGSE/Computing Lab/data')
#person_record<-read.csv('person_record.csv')
#housing_record<-read.csv('housing_record.csv')

### 	DATABASE CONNECTION & CREATE TABLES

library(RMySQL)
db = dbConnect(MySQL(), user='root', password='root', dbname='income', host='localhost')

dbWriteTable(conn = db,name="HOUSING_RECORD", value='housing_record.csv', row.names=FALSE, append=TRUE)
dbWriteTable(conn = db,name="PERSON_RECORD", value='person_record.csv', row.names=FALSE, append=TRUE)
