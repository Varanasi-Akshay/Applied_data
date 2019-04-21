#### SPATIAL (GIS) DATA IN R ####

library(sp)
library(rgdal)
library(raster)
library(colorRamps)
library(rasterVis)
library(rgeos)


####################################################################################################################################################################################

## read in county shapefile data
county <- shapefile('US_COUNTY_SHPFILE/US_county_cont.shp')

county
head(county)

## draw the plot of US counties
plot(county)

## simple R-type subset of the polygon can give you only Texas
tx <- county[county$STATE_NAME == 'Texas',]

## plot just Texas
plot(tx)

## plot Texas between certain lat/long cordinates using R syntax
plot(tx, ylim = c(31, 34), xlim = c(-106, -98))
box() ## put a box on it! works on most all plots, puts a box around the "plot area" just inside the margins: mar = c(...)

## plot just Travis county, TX
plot(county[county$NAME == 'Travis',])

## Plot Travis and Williamson counties
plot(county[county$NAME %in% c('Travis', 'Williamson'),])

## Plot Travis and Williamson counties in Texas only
plot(county[county$NAME %in% c('Travis', 'Williamson') & county$STATE_NAME == 'Texas',])

## transform that data to a more conocial view
county <- spTransform(county, CRS("+init=epsg:26978"))

plot(county)

## simple subset of the polygon using R syntax
tx <- county[county$STATE_NAME == 'Texas',]

plot(tx)

## read in CO2 pipeline data

## read in shapefile of CO2 pipelines
co2 <- shapefile('CO2_pipeline_shapefile/CO2_shpfile.shp')

## transform that data to a more conocial view
co2 <- spTransform(co2, CRS("+init=epsg:26978"))

plot(co2, add = T, col = 'red', lwd = 3)



########################## plotting points (power plant) data from x-y coordinates (lat-long) ########################## 

eia <- read.csv('RHODES_JOSHUA_EIA_2016_data.csv')
ll <- read.csv('EIA_F860M_LL.csv')
m1 <- merge(x = eia, y = ll, by.x = 'Plant.Code', by.y = 'Plant.ID')

## convert the points to the same projection as the county and make a shapefile of the points 

m1 = SpatialPointsDataFrame(cbind(m1$Longitude,m1$Latitude), data = m1, proj4string = CRS("+init=epsg:4202")) # for some reason you have to convert it to a couple to get it to work...
m1 <- spTransform(m1, CRS("+init=epsg:26978"))
shapefile(m1, "power_plant_shapefile.shp")
pp2 <- shapefile('power_plant_shapefile.shp')

dev.off()

plot(tx)
plot(pp2, add = T, col = 'blue')



############################################## intersections ##############################################

## get the polygons (counties in Texas) that intersect (touch) the CO2 pipelines
tx_counties_with_co2_pipelines <- raster::intersect(tx, co2)

## get the CO2 pipeline segments that are inside Texas counties (polygons in tx)
co2_pipelines_in_tx <- raster::intersect(co2, tx)

## get the power plants (points) that are inside Texas (inside polygons in tx)
pp_in_tx <- raster::intersect(pp2, tx)

plot(tx)

## plot the couties with CO2 pipelines in orange, the CO2 pipelines in red, the power plants inside Texas in blue
plot(tx_counties_with_co2_pipelines, add = T, col = 'orange', lwd = 2)
plot(co2_pipelines_in_tx, add = T, col = 'red', lwd = 3)
plot(pp_in_tx, add = T, col = 'blue')

## get names from data.frame just like in regular R
head(pp_in_tx)
unique(pp_in_tx$Tchnl)

## subset the Texas power plants to just the NGCC plants
ngcc_tx <- pp_in_tx[pp_in_tx$Tchnl == 'Natural Gas Fired Combined Cycle',]
plot(ngcc_tx, add = T, col = 'green', pch = 20)

## add a title
mtext(side = 3, text = 'All the things in Texas', cex = 3)

## save a shapefile of the NGCC power plants in Texas
shapefile(ngcc_tx, 'ngcc_powerplants_tx.shp')











############################################## find distances between objects ##############################################

## convert both of the spatial objects to the Texas standard: http://spatialreference.org/ref/epsg/3081/

CRS.new<-CRS("+proj=lcc +lat_1=27.41666666666667 +lat_2=34.91666666666666 +lat_0=31.16666666666667 +lon_0=-100 +x_0=1000000 +y_0=1000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")  
proj4string(ngcc_tx) <- CRS.new 
proj4string(co2_pipelines_in_tx) <- CRS.new

## calcualte the distace from each point (power plant) to the nearest line (CO2 pipeline) that are within 10 km
dist <- gDistance(ngcc_tx, co2_pipelines_in_tx, byid=TRUE)

## get the minimum distance from each ngcc power plant to the nearest CO2 pipeline
d_min <- apply(dist,2,min)

## get the power plants that are within 10km of a CO2 pipeline
d2 <- d_min[d_min < 10000]

## subset the powerplants shapefile to those that are within 10km of the CO2 pieplines
ngcc2 <- ngcc_tx[row.names(ngcc_tx) %in% names(d2),]

## plot the close power plants
plot(ngcc2, add = T, col = 'purple', pch = 16)

## how much NGCC capacity is within 10km of a CO2 pipeline
sum(ngcc2$Nmp_C)




##### plot a subsection of a map #### (need to work on coordinates here)

county <- shapefile('US_COUNTY_SHPFILE/US_county_cont.shp')
tx <- county[county$STATE_NAME == 'Texas',]
plot(tx, ylim = c(31, 34), xlim = c(-106, -98))

