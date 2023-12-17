################################################################################
##################################Part 1########################################

##Setting up Directory
getwd()
#setwd("SET HERE IF Necessary")

#Importing the election candidate information dataset
election <- read.csv("results.csv")

#install.packages("tidyverse")
#install.packages("sf")
#install.packages("rgeos")
#install.packages("viridis")
#install.packages("raster")
library(tidyverse)

#Removing observations with year values 2017
election <- filter(election, Year != 2017)

#Calculating number of candidates in each constituency for 2015 and 2020.
total_candidates_ac <- election %>% 
  group_by(Year, Constituency_No, Constituency_Name) %>% 
  summarise(totalCandidates=n())

################################################################################
##################################Part 2########################################

library(sf)
library(rgeos)
library(viridis)

#Importing the shp file containing map of city Constituencies
city_shp <- st_read("city-shp/city-ac.shp")

#Fortifying into a dataframe
city_shp<- fortify(city_shp, region = "AC_NO")

#Merging the shp file with the total candidates per constituency dataset
city_shp_merged <- total_candidates_ac %>% 
  #select(Constituency_No, totalCandidates, Year) %>% 
  left_join(city_shp, by = c("Constituency_No" = "AC_NO"))

#Restricting the data to recent election date i.e. 2020
city_shp_merged <- city_shp_merged %>% 
  filter(Year == 2020)

#Extracting centroids for each constituencies
city_centroids <- cbind(city_shp, st_coordinates(st_centroid(city_shp$geometry)))

#Creating a choropleth map containing number of candidates for each constituency 
ggplot(city_shp) + 
  geom_sf(aes(fill = city_shp_merged$totalCandidates)) +
  theme_void() +
  scale_fill_viridis(option = "magma", direction = -1, name = "Total Candidates") +
  geom_text(data= city_centroids,aes(x=X, y=Y, label=AC_NO),
            color = "darkslategray",fontface = "bold", check_overlap = T, size = 3.3) +
  ggtitle("Total Number of Candidates in Each Constituency") +
  labs(caption = "Note: Constituencies are mapped with their respective constituency number.") +
  theme(plot.title = element_text(hjust=0.45, vjust = 1, size = 18),
        plot.caption = element_text(size = 12, face = "bold"))
ggsave("city_constituency_candidates.png", width = 13, height = 9)

#Choosing Constituency_Number = 1 for line intersection
city_1_shp = filter(city_shp, AC_NO == 1)
city_1_coord <- st_coordinates(city_1_shp$geometry)

##For line passing through the centroid and perpendicular to the north:
#Centroid of 1st Constituency = (77.13454, 28.81963)
#This line will intersect at (0,28.81963) with y-axis
#We now have two co-ordinates i.e. (77.13454, 28.81963) & (0, 28.81963) to construct a line
#Extending the line across the constituency will require another co-ordinate beyond the eastern border
#So, we have taken (78, 28.81963) as our next point

line = SpatialLines(list(Lines(list(Line(cbind(c(77.13454, 0, 78),c(28.81963,28.81963, 28.81963)))), 
                               ID="line")))

poly = SpatialPolygons(list(Polygons(list(Polygon(cbind(city_1_coord[,"X"],city_1_coord[,"Y"]))), 
                                     ID="polygon")))

#Intersecting the Line with Polygon 
lpintersect <- gIntersection(poly, line)

#Creating a thin layered buffer for intersecting a line
blpintersect <- gBuffer(lpintersect, width = 0.000001)  

#Splitting the Polygon with gDifference
dpintersect <- gDifference(poly, blpintersect)                

#Plotting the intersected line 
png("Constituency_1.png", width = 900, height = 550)
plot(poly)
plot(SpatialPolygons(list(Polygons(list(dpintersect@polygons[[1]]@Polygons[[1]]), "1"))), add=T, col = "lightblue")
plot(SpatialPolygons(list(Polygons(list(dpintersect@polygons[[1]]@Polygons[[2]]), "2"))), 
     add = TRUE, col = "lightgreen")
title(main = "Constituency 1", font.main = 1, col.main = "black", line = 1, cex.main = 2.5)
dev.off()

#Calculating Area for the Southern-Half and Northern-Half of Constituency 1
library(raster)

#Area in Sq.Km
#Northern Area
area(SpatialPolygons(list(Polygons(list(dpintersect@polygons[[1]]@Polygons[[1]]), "1"))))/1000000
#Southern Area
area(SpatialPolygons(list(Polygons(list(dpintersect@polygons[[1]]@Polygons[[2]]), "2"))))/1000000

################################################################################
################################################################################
################################################################################