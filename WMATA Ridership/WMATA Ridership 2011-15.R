library(dplyr)
library(reshape)
library(tidyr)
setwd ("/Users/katerabinowitz/Documents/DataLensDC/DC-Transportation/WMATA Ridership")
#read in data
ride<-read.csv("WMATA Ridership.csv",stringsAsFactors=FALSE, strip.white=TRUE)[c(1:3)]
Time<-read.csv("WMATA Ridership by Period.csv",stringsAsFactors=FALSE, strip.white=TRUE)[c(1:4)]
Locs<-read.csv("Metro_Stations_Regional.csv",
               stringsAsFactors=FALSE, strip.white=TRUE)[c(1,2,5)]

#Decline in ridership by station
str(ride)
ride$year<-substr(ride$DATEMONTHINT,1,4)
ride$month<-substr(ride$DATEMONTHINT,5,6)
ride<-subset(ride,ride$year %in% c("2011","2012","2013","2014","2015"))

rideYr<-ride %>% 
  group_by(STATION,year) %>% 
  summarise(Riders= mean(RIDERS_PER_WEEKDAY))
yrRide<-t(rideYr)

yrRide <- spread(rideYr, year, Riders)
colnames(yrRide)<-c("Station","Yr11","Yr12","Yr13","Yr14","Yr15")
yrRide$Change1115<-((yrRide$Yr15-yrRide$Yr11)/yrRide$Yr11)*100
yrRide$ChangeGroup<-ifelse(is.na(yrRide$Change1115),"N/A",
                      ifelse(yrRide$Change1115 < -18,"More than 18% decline",
                       ifelse(yrRide$Change1115 < -14 & yrRide$Change1115 >= -18,"14%-18% decline",
                        ifelse(yrRide$Change1115 < -10 & yrRide$Change1115 >= -14,"10%-14% decline",
                          ifelse(yrRide$Change1115 < -6 & yrRide$Change1115 >= -10,"6%-10% decline",
                            ifelse(yrRide$Change1115 < 0 & yrRide$Change1115 >= -6,"0-6% decline",
                           "Increased ridership"))))))
table(yrRide$ChangeGroup)
yrRide$Change1115<-round(yrRide$Change1115,2)
yrRide$Yr15<-round(yrRide$Yr15,2)
yrRide<-yrRide[order(yrRide$Change1115),]
yrRide<-yrRide[order(yrRide$Station),]

Locs$NAME<-ifelse(Locs$NAME=="Ronald Reagan Washington National Airport","Reagan Washington National Airport",
                  Locs$NAME)
Locs<-Locs[order(Locs$NAME),]
RidebyStation<-cbind(yrRide,Locs)[-c(11)]
write.csv(RidebyStation,"StationAnnualRidership.csv")
RidebyStation<-RidebyStation[order(RidebyStation$Change1115),]

# Overall decline
ride1115<-subset(ride,ride$year %in% c("2011","2015"))
ride1115$MY<-paste(ride1115$month,ride1115$year)

monthSystem<-overall<-ride1115 %>% 
  group_by(MY) %>% 
  summarise(Riders= sum(RIDERS_PER_WEEKDAY))

monthSystem$year<-substr(monthSystem$MY,4,7)

avgRiders<-monthSystem %>% 
  group_by(year) %>% 
  summarise(Riders= mean(Riders))

#time patterns by station
Time$year<-substr(Time$DATEMONTHINT,1,4)
Time$month<-substr(Time$DATEMONTHINT,5,6)
lastYr<-subset(Time,Time$DATEMONTHINT>201501)

timeTrend<-lastYr %>% 
  group_by(STATION,PERIOD) %>% 
  summarise(Riders= mean(RIDERS_PER_WEEKDAY))
period <- spread(timeTrend, PERIOD, Riders)
colnames(period)<-c("Station","AMPeak","Evening","LateNightPeak","Midday","PMPeak")

prop <- function (y) {
  (y / (period$AMPeak+period$Evening+period$LateNightPeak+period$Midday+period$PMPeak))*100
}
period$AMPeakProp<-prop(period$AMPeak)
period$EveningProp<-prop(period$Evening)
period$LateNightProp<-prop(period$LateNightPeak)
period$MiddayProp<-prop(period$Midday)
period$PMPeakProp<-prop(period$PMPeak)

period<-period[order(period),]

#2011-15 decline by periods
Time1115<-subset(Time,Time$year %in% c("2011","2015"))

Time1115$MY<-paste(Time1115$month,Time1115$year)

timeSystem<-overall<-Time1115 %>% 
  group_by(MY,PERIOD) %>% 
  summarise(Riders= sum(RIDERS_PER_WEEKDAY))

timeSystem$year<-substr(timeSystem$MY,4,7)

avgTimeRiders<-timeSystem %>% 
  group_by(year,PERIOD) %>% 
  summarise(Riders= mean(Riders))

perTrend <- spread(avgTimeRiders, year, Riders)
colnames(perTrend)<-c("Period","Yr11","Yr15")
perTrend$Change1115<-((perTrend$Yr15-perTrend$Yr11)/perTrend$Yr11)*100
perTrend<-perTrend[order(perTrend$Change1115),]
perTrend$Change1115<-round(perTrend$Change1115,2)
perTrend$Yr15<-round(perTrend$Yr15,2)
perTrend<-perTrend[c(5,3,4,2,1),]
write.csv(perTrend,"RidebyPeriod.csv")
