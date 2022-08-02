
################################################################################
### Community Level Maps for NC - Grad Rates by Community Area
### Source: https://toandthrough.uchicago.edu/tool/cps/
################################################################################

### Set wd
setwd("Path/to/Files")

### Load Libraries
library(dplyr)
library(data.table)
library(ggplot2)
library(tmap)
library(leaflet)
library(rgeos)
library(rgdal)
library(sp)
library(raster)
library(stringr)
library(sf)
library(cmapgeo)

### Load Data
data<-fread("data.csv")

################################################################################
### Community Level Edu Outcomes - Attempting to use CMAP
################################################################################

### Create community area
community<-cca_sf
community<-community %>%
  mutate(community=toupper(cca_name))

### Merge in CPS data
community<-community %>%
  left_join(data)

### HS Graduation Map
tm_shape(community) +
  tm_fill("hs_graduation_spr2020",style="jenks",n=5,title = "HS Graduation Rate (Spring 2020)",palette = "Greens") + 
  tm_borders() +
  tm_text("hs_graduation_spr2020",size=.7) +
  tm_credits("Data from To&Through") +
  tm_layout(frame=F)


### Add in a test point
test_point <- as.data.frame(cbind("lon" = -87.621951, "lat" = 41.881722)) %>% # Millenium Park
  st_as_sf(coords = c("lon", "lat"), crs = st_crs(4326)) %>%
  st_transform(st_crs(community))

### HS Graduation Map with test point
tm_shape(community) +
  tm_fill("hs_graduation_spr2020",style="jenks",n=5,title = "HS Graduation Rate (Spring 2020)",palette = "Greens") + 
  tm_borders() +
  tm_text("hs_graduation_spr2020",size=.7) +
  tm_credits("Data from To&Through") +
  
  tm_shape(test_point) +
  tm_dots(col="black",size=1) +
  tm_layout(frame=F)




