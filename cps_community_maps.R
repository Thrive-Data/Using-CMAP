
################################################################################
### Community Level Maps for NC - Grad Rates by Community Area
### Source: https://toandthrough.uchicago.edu/tool/cps/
################################################################################

### Set wd
setwd("C:/Users/David/Documents/Thrive Work Stuff/Quick Data Requests/Community Level CPS Data")

### Load Libraries
library(dplyr)
library(data.table)
library(ggplot2)
library(tmap)
library(leaflet)
library(rgeos)
library(rgdal)
library(stringr)
library(readxl)
library(sp)
library(raster)
library(stringr)
library(googlesheets4)

library(sf)
library(ggplot2)
library(tidycensus)
library(stringr)

library(tidyverse)
library(reshape2)

library(survey)
library(srvyr)

### Load Community Shapefile
community<-readOGR(dsn=".",layer="community")

### Import CPS Data (copied to a google sheet)
data<-read_sheet("https://docs.google.com/spreadsheets/d/1cioyQs6o3Dh1wAu7KOcYw6tVDrUenEq5t8p2oDe_Dp4/edit#gid=0",sheet=1)

################################
### Clean Data and Merge to Communities
################################

### Clean
data<-data %>%
  rename(
    community=`Community Area Name`,
    freshman_enrollment_sy2020_2021=`Freshman Enrollment`,
    hs_graduation_spr2020=`High School Graduation`,
    college_enrollment_fall2020=`College Enrollment`,
    college_persistence_spr_2020=`College Persistence`,
    college_completion_spr2020=`College Completion`,
    postsec_attainment_index=`2021 Postsecondary Attainment Index`
    ) %>%
  mutate(
    community=toupper(community),
    freshman_enrollment_sy2020_2021=as.numeric(freshman_enrollment_sy2020_2021),
    hs_graduation_spr2020=as.numeric(hs_graduation_spr2020)*100,
    college_enrollment_fall2020=as.numeric(college_enrollment_fall2020)*100,
    college_persistence_spr_2020=as.numeric(college_persistence_spr_2020)*100,
    college_completion_spr2020=as.numeric(college_completion_spr2020)*100,
    postsec_attainment_index=as.numeric(postsec_attainment_index)*100
  )

### Merge to community
community<-merge(community,data,by="community")


################################
### Create Maps
################################

### HS Graduation
tm<-tm_shape(community) +
  tm_fill("hs_graduation_spr2020",style="jenks",n=5,title = "HS Graduation Rate (Spring 2020)",palette = "Greens") + 
  tm_borders() +
  tm_text("hs_graduation_spr2020",size=.7) +
  tm_credits("Data from To&Through") +
  tm_layout(frame=F)
tmap_save(tm,"hs_graduation_community.pdf")

### HS Graduation
tm<-tm_shape(community) +
  tm_fill("college_enrollment_fall2020",style="jenks",n=5,title = "College Enrollment Rate (Fall 2020)",palette = "Greens",textNA = "> 10 Students") + 
  tm_borders() +
  tm_text("college_enrollment_fall2020",size=.7) +
  tm_credits("Data from To&Through") +
  tm_layout(frame=F)
tmap_save(tm,"enrollment_community.pdf")

### College Persistence
tm<-tm_shape(community) +
  tm_fill("college_persistence_spr_2020",style="jenks",n=5,title = "College Persistence Rate (Spring 2020)",palette = "Greens",textNA = "> 10 Students") + 
  tm_borders() +
  tm_text("college_persistence_spr_2020",size=.7) +
  tm_credits("Data from To&Through") +
  tm_layout(frame=F)
tmap_save(tm,"persistence_community.pdf")

### College Completion
tm<-tm_shape(community) +
  tm_fill("college_completion_spr2020",style="jenks",n=5,title = "College Completion Rate (Spring 2020)",palette = "Greens",textNA = "> 10 Students") + 
  tm_borders() +
  tm_text("college_completion_spr2020",size=.7) +
  tm_credits("Data from To&Through") +
  tm_layout(frame=F)
tmap_save(tm,"completion_community.pdf")

### Postsecondary Attainment Index
tm<-tm_shape(community) +
  tm_fill("postsec_attainment_index",style="jenks",n=5,title = "PS Attainment Index (2021) ",palette = "Greens",textNA = "> 10 Students") + 
  tm_borders() +
  tm_text("postsec_attainment_index",size=.7) +
  tm_credits("Data from To&Through") +
  tm_layout(frame=F)
tmap_save(tm,"ps_attainment_index_community.pdf")


