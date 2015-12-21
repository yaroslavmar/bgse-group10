library(readr)
library(dplyr)
library(maptools)
library(rgdal)
library(gpclib)
library(ggplot2)
library(maps)
library(ggmap)

#######Person map
data<-fread("datacombedited.csv")
#########yaroslav filter code below
#filter Age
data<-data[data$AGEP>18,]
data<-data[!data$AGEP>64,]
#fiter class of worker: remove people not in labor force
data<-data[!is.na(data$COW),]
# WKHP
data<-data[!is.na(data$WKHP)]
data<-data[data$WKHP>25,]
#WKW: number of weeks worked
data<-data[data$WKW!=6,]
data<-data[data$WKW!=5,]
#Wage >15000 and remove top 2%
data<-data[data$WAGP>15000,]
data<-data[data$WAGP<200000,]
########################################yaroslav clean above

statesMap <- map_data("state")
#person <- read_csv("PR.csv")
person <- as.data.frame(data)
pr1 <- person[,c("ST.x","WAGP")]
pr <- subset(pr1,complete.cases(WAGP))
UST <- unique(pr$ST.x)
wagp_df <- as.data.frame(tapply(pr$WAGP,pr$ST.x,median))
colnames(wagp_df) <- c("Avg_income")
df <- as.data.frame(cbind(ST=UST,Avg_income=wagp_df$Avg_income))
ST<-c(1,2,4,5,6,8,9,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,44,45,46,47,48,49,50,51,53,54,55,56,72)
region<-c('alabama','alaska','arizona','arkansas','california','colorado','connecticut','delaware','district of columbia','florida','georgia','hawaii','idaho','illinois','indiana','iowa','kansas','kentucky','louisiana','maine','maryland','massachusetts','michigan','minnesota','mississippi','missouri','montana','nebraska','nevada','new hampshire','new jersey','new mexico','new york','north carolina','north dakota','ohio','oklahoma','oregon','pennsylvania','rhode island','south carolina','south dakota','tennessee','texas','utah','vermont','virginia','washington','west virginia','wisconsin','wyoming','puerto rico')
hstates<-data.frame(ST,region)
hstates$ST=as.factor(as.character(hstates$ST))
df$ST=as.factor(as.character(df$ST))
mdf = merge(df,hstates,by="ST")
rm(df,hstates)
hsMap = merge(statesMap, mdf, by="region")
rm(statesMap)
print("Map Plotting started")
p = ggplot(hsMap, aes(x = long, y = lat, group = group, fill = Avg_income)) + 
  coord_map("gilbert") +
  theme_light() +
  scale_fill_continuous(low="pink",high="red",limits=c(min(hsMap$Avg_income), max(hsMap$Avg_income))) +
  labs(title = "Median Yearly Personal Wage By State in USA",fill="Median\nYearly Personal\n Wage($)") 
p = p+ geom_polygon(colour = "black")
p = p + theme(strip.background = element_blank(), strip.text.x = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.ticks  = element_blank(), axis.line   = element_blank(), panel.border= element_blank(), panel.grid  = element_blank(), legend.position = "right") + xlab("") + ylab("")
ggsave("Map_Median_Personal_Income_By_State2teeeeeeeeest.png", p, height=6, width=10, units="in")
