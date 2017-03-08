library(rgdal)
library(dplyr)
library(ggmap)
library(RColorBrewer)
library(plotly)

crash = readOGR("http://opendata.dc.gov/datasets/95254fae17bc4792bd47b53f71c2e503_19.geojson", "OGRGeoJSON")

pedCrash <- crash %>%
  subset(!(is.na(crash@data$PEDESTRIANSINVOLVED)))

pedCrash <- data.frame(pedCrash@coords)
colnames(pedCrash)<-c("lon","lat")
write.csv(pedCrash,"pedCrash.csv")

