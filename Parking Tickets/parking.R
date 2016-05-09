setwd("/Users/katerabinowitz/Documents/DataLensDC/DC-Transportation/Parking Tickets")
library(geojsonio)
library(data.table)
library(plyr)
library (dplyr)
library(rgdal)
library(reshape)

###Read in Parking Ticket Data and Create Single 2013-15 dataset###
###Read in Parking Ticket Data and Create Single 2013-15 dataset###
###Read in Parking Ticket Data and Create Single 2013-15 dataset###
readIn<-function(url) {
  dataIn<-geojson_read(url,method = "local",parse = TRUE)
  df <- data.frame(matrix(unlist(dataIn$features$properties),nrow=length(dataIn$features$properties[[1]])))
  colnames(df)<-names(dataIn$features$properties)
  dfLoc<-data.frame(t(matrix(unlist(dataIn$features$geometry$coordinates),
                             nrow=length(unlist(dataIn$features$geometry$coordinates[1])))))
  colnames(dfLoc)<-c("longitude","latitude")
  dfAll<-cbind(df,dfLoc)
}

Jan15<-readIn("http://opendata.dc.gov/datasets/6f36c3fcbcfa4f83931f524628325c9c_0.geojson")
Feb15<-readIn("http://opendata.dc.gov/datasets/aab075ac11e9415fb329fb4fab970bc3_1.geojson")
March15<-readIn("http://opendata.dc.gov/datasets/60c9c95a5fe0436caaa1f80f8b0ecad8_2.geojson")
April15<-readIn("http://opendata.dc.gov/datasets/c6037ff5ae924f8f845512d7a164abf2_2.geojson")
May15<-readIn("http://opendata.dc.gov/datasets/f3336832f98d4ccab272c2d3eb1ed3bc_4.geojson")
June15<-readIn("http://opendata.dc.gov/datasets/33a81b8818eb46b2ac4e14af3c6e56ec_5.geojson")
July15<-readIn("http://opendata.dc.gov/datasets/0d22a375d1074700b007f67d413b7ee0_6.geojson")
Aug15<-readIn("http://opendata.dc.gov/datasets/13fd2526f4da4da294e1bd1ba1b10d4f_7.geojson")
Sept15<-readIn("http://opendata.dc.gov/datasets/a0eea990ba9f4ef9a23f94bc8fdb6871_8.geojson")
Oct15<-readIn("http://opendata.dc.gov/datasets/58e41f6541bf4c10b94342ba7d7f6442_9.geojson")
Nov15<-readIn("http://opendata.dc.gov/datasets/9b040759c7264e59b8943fea0f081725_10.geojson")
Dec15<-readIn("http://opendata.dc.gov/datasets/2e967e9053144a309680fccea0f7b4e1_11.geojson")

Jan14<-readIn("http://opendata.dc.gov/datasets/93c1160a13cd49e0a411b3f8e6c3be66_0.geojson")
Feb14<-readIn("http://opendata.dc.gov/datasets/7877594f7e7a4affbd9372f65b935660_1.geojson")
March14<-readIn("http://opendata.dc.gov/datasets/863a00cfb1384e4288f3f6a53b63c5f1_2.geojson")
April14<-readIn("http://opendata.dc.gov/datasets/f01f547123844b97930de0127555ba64_3.geojson")
May14<-readIn("http://opendata.dc.gov/datasets/25d65f5cb95e492ea718e1764cf5c9a2_4.geojson")
June14<-readIn("http://opendata.dc.gov/datasets/39a65bd2f4ae43ce9dd9da7c209dbf29_5.geojson")
July14<-readIn("http://opendata.dc.gov/datasets/3f557f661e444c29b217eb63c2324d34_6.geojson")
Aug14<-readIn("http://opendata.dc.gov/datasets/dda2ff2bbcdb40a7a2044010f73f962b_7.geojson")
Sept14<-readIn("http://opendata.dc.gov/datasets/d60447c91b4649b892fc56c4b9d9ed96_8.geojson")
Oct14<-readIn("http://opendata.dc.gov/datasets/77e0b89b413d47dbab97927d5f4dcbe1_9.geojson")
Nov14<-readIn("http://opendata.dc.gov/datasets/da64c15a136b4d69ad5a5e3b7b3a8f48_10.geojson")
Dec14<-readIn("http://opendata.dc.gov/datasets/b00605a8e3e54d2ca75c525ba42966ea_11.geojson")

Jan13<-readIn("http://opendata.dc.gov/datasets/8e065ed29a2d43c08802385f3c9a6df4_0.geojson")
Feb13<-readIn("http://opendata.dc.gov/datasets/e541d743615d4027bf3ec00d67b7adbf_1.geojson")
March13<-readIn("http://opendata.dc.gov/datasets/08283fed77f743bab072b373eb7bd96f_2.geojson")
April13<-readIn("http://opendata.dc.gov/datasets/7906787f79ef47d6b1bc80a4d19ea567_3.geojson")
May13<-readIn("http://opendata.dc.gov/datasets/71a93c37f6c547e3b8d69cebc008493f_4.geojson")
June13<-readIn("http://opendata.dc.gov/datasets/ea6f36d302134fc899a593463fb43a83_5.geojson")
July13<-readIn("http://opendata.dc.gov/datasets/0814aef502aa49d783b5086565740524_6.geojson")
Aug13<-readIn("http://opendata.dc.gov/datasets/0b921d3eaa4b410f8d34d0677d3f7cb5_7.geojson")
Sept13<-readIn("http://opendata.dc.gov/datasets/e1261d1070e44f099e05b167866d1bab_8.geojson")
Oct13<-readIn("http://opendata.dc.gov/datasets/8f453e65e7fd445fa3bcdf8f2415241a_9.geojson")
Nov13<-readIn("http://opendata.dc.gov/datasets/f8d4f9f3956b4177948131d4f3e683d2_10.geojson")
Dec13<-readIn("http://opendata.dc.gov/datasets/5d582d5304424c9b823985c294faba66_11.geojson")

Parking<-rbind(Jan13,Feb13,March13,April13,May13,June13,July13,Aug13,Sept13,Oct13,Nov13,Dec13,
              Jan14,Feb14,March14,April14,May14,June14,July14,Aug14,Sept14,Oct14,Nov14,Dec14,
              Jan15,Feb15,March15,April15,May15,June15,July15,Aug15,Sept15,Oct15,Nov15,Dec15)
Parking<-Parking[!duplicated(Park15$OBJECTID),]

rm(Jan13,Feb13,March13,April13,May13,June13,July13,Aug13,Sept13,Oct13,Nov13,Dec13,
  Jan14,Feb14,March14,April14,May14,June14,July14,Aug14,Sept14,Oct14,Nov14,Dec14,
   Jan15, Feb15, March15, April15, May15,June15, July15, Aug15, Sept15,Oct15,Nov15,Dec15)

Parking<-subset(Parking,Parking$RP_PLATE_STATE %in% state.abb | Parking$RP_PLATE_STATE=="DC")
write.csv(Parking,"parkingTickets1315.csv")

fines<-read.csv("parkMoveFines.csv",
                        stringsAsFactors=FALSE, strip.white=TRUE)[c(2:4)]
colnames(fines)[c(1)]<-"VIOLATION_CODE"

tickets<-merge(x=fines,y=Parking,by="VIOLATION_CODE",all.y=TRUE)

matchcheck<-function(x) {
  x<-gsub("[[:space:]]","",x)
  x<-gsub("[[:punct:]]","",x)
}

tickets$descM<-matchcheck(tickets$desc)
tickets$vioM<-matchcheck(tickets$VIOLATION_DESCRIPTION)
check<-subset(tickets,tickets$descM!=tickets15$vioM)
colnames(tickets)
tickets<-tickets[-c(22:23)]
tickets$fineN<-as.numeric(gsub("\\$","",tickets$fine))
tickets$year<-substr(tickets$TICKET_ISSUE_DATE,1,4)
table(tickets$year)

###Aggregate by State ###
###Aggregate by State ###
###Aggregate by State ###
countByState<-ddply(tickets, c("year","RP_PLATE_STATE"), nrow)
colnames(countByState)<-c("Year","State","Tickets")
fineByState<-aggregate(tickets$fineN, by=list(Category=tickets$year,tickets$RP_PLATE_STATE), FUN=sum,na.rm=TRUE)
colnames(fineByState)<-c("Year","State","Fines")
ticketsByState<-merge(countByState,fineByState,by=c("Year","State"))
write.csv(ticketsByState,"parkingTicketsSummary.csv",row.names=FALSE)

###Bring in Population###
###Bring in Population###
###Bring in Population###
VApop<-read.csv("VA County Populations.csv",
                stringsAsFactors=FALSE, strip.white=TRUE,header=FALSE)
VApop<-subset(VApop,VApop$V3=="Arlington County, Virginia" | VApop$V3=="Fairfax County, Virginia" | 
                VApop$V3=="Alexandria city, Virginia"| VApop$V3=="Fairfax city, Virginia"| 
                VApop$V3=="Falls Church city, Virginia")[c(9:11)]
cols = c(1:3);    
VApop[,cols] = apply(VApop[,cols], 2, function(x) as.numeric(x));
VAtotal<-colSums(VApop)

MDpop<-read.csv("MD County Populations.csv",
                stringsAsFactors=FALSE, strip.white=TRUE,header=FALSE)
MDpop<-subset(MDpop,MDpop$V3=="Montgomery County, Maryland" | MDpop$V3=="Prince George's County, Maryland")[c(9:11)]  
MDpop[,cols] = apply(MDpop[,cols], 2, function(x) as.numeric(x));
MDtotal<-colSums(MDpop)

DCpop<-read.csv("DC Population.csv",
                stringsAsFactors=FALSE, strip.white=TRUE,header=FALSE)[3,c(9:11)]
areaPop<-as.data.frame(rbind(MDtotal,VAtotal,DCpop))
colnames(areaPop)<-c("pop2013","pop2014","pop2015")
areaPop$State<-c("MD","VA","DC")
areaT<-melt(areaPop, id=c("State"))
colnames(areaT)<-c("State","Year","Pop")
areaT$Year<-gsub("pop","",areaT$Year)

###Create mini datasets for viz###
###Create mini datasets for viz###
###Create mini datasets for viz###
Graph1<-subset(ticketsByState,ticketsByState$State=="DC" | ticketsByState$State=="VA" | ticketsByState$State=="MD")[c(3,4,7)]
Graph1<-melt(Graph1,id.vars=c("state.name","Year"))
Graph1<- cast(Graph1,Year~state.name)
colnames(Graph1)[2]<-"DC"

Graph2<-subset(ticketsByState,ticketsByState$State=="DC" | ticketsByState$State=="VA" | ticketsByState$State=="MD")[c(2,3:4,7)]
Graph2Pop<-merge(Graph2,areaT,by=c("State","Year"))
Graph2Pop$ticketPerCapita<-round(Graph2Pop$Tickets/(as.numeric(as.character(Graph2Pop$Pop))),2)
Graph2Pop<-Graph2Pop[c(2,4,6)]
Graph2<-melt(Graph2Pop,id.vars=c("state.name","Year"))
Graph2<-cast(Graph2,Year~state.name)
colnames(Graph2)[2]<-"DC"

write.csv(Graph1,"Graph1.csv",row.names=FALSE)
write.csv(Graph2,"Graph2.csv",row.names=FALSE)

map<-aggregate(list(Tickets=ticketsByState$Tickets,Fines=ticketsByState$Fines),
               by=list(State=ticketsByState$state.name), FUN=mean)
map$Tickets<-round(map$Tickets,0)
map$Fines<-round(map$Fines,2)
stateMap<-readOGR("http://eric.clst.org/wupl/Stuff/gz_2010_us_040_00_5m.json", "OGRGeoJSON")
colnames(map)[c(1)]<-"NAME"
StatePTMap<-merge(stateMap,map,by="NAME",all.y=TRUE)
writeOGR(StatePTMap,'StatePTMap.geojson','statePTMap', driver='GeoJSON',check_exists = FALSE)
