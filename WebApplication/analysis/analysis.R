
### READ DATA FROM DATABASE
setwd('~/BGSE/Computing Lab/data')


library(RMySQL)
db = dbConnect(MySQL(), user='root', password='root', dbname='income', host='localhost')


# Import data

query_person =dbSendQuery(db, "select * from PERSON_RECORD;")
data_person<-fetch(query_person,n=-1)
query_housing =dbSendQuery(db, "select * from HOUSING_RECORD;")
data_housing<-fetch(query_housing,n=-1)

data<-merge(data_person, data_housing,all.x=TRUE, by.x = 'SERIALNO', by.y = 'SERIALNO')


# Complete dataset
library(data.table)
data<-fread("data.csv")
data<-as.data.frame(data)
data<-data[,-c(1,2,3)]




### FILTER DATA ###

#AGE
data<-data[data$AGEP>18,]
data<-data[!data$AGEP>64,]


# WKHP
#data<-data[!is.na(data$WKHP)]
data<-data[data$WKHP>25,]

#WKW: number of weeks worked
data<-data[data$WKW!=6,]
data<-data[data$WKW!=5,]

#Wage >15000 and remove top 2%
data<-data[data$WAGP>15000,]
data<-data[data$WAGP<200000,]


# remove some observations
data<-data[!data$LAPTOP==0.000,]


### FACTOR VARIABLES ###
non.factors<-c('GASP', 'BDSP',	'FULP','NOC','WAGP','RMSP', 'PWGTP', 'AGEP', 'JWMNP','WKHP')
non.factor.position<-match(non.factors,colnames(data))



for ( i in 1:dim(data)[2]){

	if (!(i %in% non.factor.position)){
		data[,i]<-as.factor(data[,i])
	} 
}


### TRANSFORMATION OF VARIABLES ###																																																																																																																																																																																																					
																																																			
#SCHL: Educational attainment
data$SCHL<-ifelse(data$SCHL %in% seq(0,19,1),1,data$SCHL)
data$SCHL<-as.factor(data$SCHL)

#SOCP: occupation 
data$SOCP<-substr(data$SOCP,1,3)
data$SOCP<-ifelse(data$SOCP=='132','14',data$SOCP)
data$SOCP<-substr(data$SOCP,1,2)
data$SOCP<-as.factor(data$SOCP)

#JWMNP
data$JWMNP<-ifelse(is.na(data$JWMNP),1,data$JWMNP)
data$JWMNP<-as.numeric(data$JWMNP)

data<-data[,-42] # remove RESMODE




### INFERENCE


set.seed(666)
train<-sample(1:dim(data)[1],round(0.8*dim(data)[1]))


## INTERACTIONS

data$SOCP_SCHL<-with(data, interaction(data$SOCP,  data$SCHL), drop = TRUE )

# Log of wages
y<-log(data$WAGP)

# Linear regression
reg<-lm(y[train]~. , data=data[train,-13], weights=data$PWGTP[train])

#predictions
library(forecast)
pred<-predict(reg, data[-train,-13])
pred.wage<-exp(pred)

#Accuracy of predictions
res<-exp(y[-train])-pred.wage
plot(density(res))
pr<-accuracy(exp(y[-train]), pred.wage, test=NULL)




### LASSO
library(MASS)
library(glmnet)
y<-log(data$WAGP)

# create binary variables with all factors
X<-model.matrix(~.  , data)

#lasso regression
model.lasso<-glmnet(X[train,-1],y[train],family="gaussian", alpha=1, weights=data$PWGTP[train])


## Predictions

pred<-predict(model.lasso, newx=X[-train,-1], s=0.2)


#accuracy
accuracy(exp(y[-train]), exp(pred[,1]), test=NULL)


plot(model.lasso, type.coef='coef', xvar='lambda', main='Shrinkage of coeffients')
plot(model.lasso)


plot(cvob1)
coef(cvob1)

# find best lambda
cv<-cv.glmnet(X[,-1],y)



