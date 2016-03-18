library(ggmap)
library(rgdal)
library(plyr)
### Upload Data ###
### Data was collected from the Uber API by Jennifer A. Stark and Nick Diakopoulos via the Uber API ###
### You can download this data, learn more about it and their findings here: ###
### https://github.com/comp-journalism/2016-03-wapo-uber ###
uberFeb<-read.csv("/Users/katerabinowitz/Documents/DataLensDC Org/Drafts/TractsSurgeDC2_Feb4_Mar2.csv",
                  stringsAsFactors=FALSE,strip.white=TRUE)
str(uberFeb)
colnames(uberFeb)[c(7)]<-"location_id"
uberXFeb<-subset(uberFeb,uberFeb$product_type=="uberX")

uberLoc<-read.csv("/Users/katerabinowitz/Documents/DataLensDC Org/Drafts/UberLoc.csv",
                  stringsAsFactors=FALSE,strip.white=TRUE)[c(7,5,8)]
str(uberLoc)

zipMap = readOGR("http://opendata.dc.gov/datasets/5637d4bb43a34668b19fe630120d2b70_4.geojson", "OGRGeoJSON")

### Tie Uber Locations to Zip Code ###
LatLong<-uberLoc[c(3:2)]
colnames(LatLong)<-c("lon","lat")
addAll<-SpatialPoints(LatLong, proj4string=CRS(as.character("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")))
ZipID <- over(addAll, zipMap)
uberZip<-cbind(uberLoc,ZipID)[c(1,5)]

uberFebZip<-join(uberXFeb,uberZip,by="location_id")

uberFebZip$TimeDate<-strptime(uberFebZip$timestamp, "%Y-%m-%d %H:%M:%S")
uberFebZip$Weekday<-weekdays(uberFebZip$TimeDate)
uberFebZip$Hour<-substr(uberFebZip$timestamp,12,13)

surgeSum<-aggregate(uberFebZip$surge_multiplier, list(uberFebZip$ZIPCODE,uberFebZip$Weekday,uberFebZip$Hour), mean)

write.csv(surgeSum,
          "/Users/katerabinowitz/Documents/DataLensDC Org/Drafts/uberSurgeSum.csv",
          row.names=FALSE)


