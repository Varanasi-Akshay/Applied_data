#### SPATIAL (GIS) DATA IN R ####

###### ###### ###### ###### raster work ###### ###### ###### ###### 


library(sp)
library(rgdal)
library(raster)
library(colorRamps)
library(rasterVis)
library(rgeos)



county <- shapefile('US_COUNTY_SHPFILE/US_county_cont.shp')


county
head(county)

## plot the county -- leave in LAT/LONG formatt for this excercise
plot(county)

## simple R-type subset of the polygon can give you only Texas
tx <- county[county$STATE_NAME == 'Texas',]

plot(tx)

## read in elevation raster and convert them to the same coordinate system as the TX shapefile
ras1 <- raster('n30w098/imgn30w098_1.img')
ras1p <- projectRaster(ras1, crs = crs(tx))

ras2 <- raster('n30w099/imgn30w099_1.img')
ras2p <- projectRaster(ras2, crs = crs(tx))

ras3 <- raster('n31w098/imgn31w098_1.img')
ras3p <- projectRaster(ras3, crs = crs(tx))

ras4 <- raster('n31w099/imgn31w099_1.img')
ras4p <- projectRaster(ras4, crs = crs(tx))

## plot all of the raster layers do these one at a time
plot(ras1p, add = T)
plot(ras2p, add = T)
plot(ras3p, add = T)
plot(ras4p, add = T)

## "zoom in" to Texas counties
plot(tx, xlim = c(-99.00306, -96.99701), ylim = c(28.99701, 31.00306))
box()

## plot all the raster layers again
plot(ras1p, add = T)
plot(ras2p, add = T)
plot(ras3p, add = T)
plot(ras4p, add = T)

## plot the zoomed in TX counties again
plot(tx, xlim = c(-99.00306, -96.99701), ylim = c(28.99701, 31.00306), add = T)
polygonsLabel(tx, labels = tx$NAME, cex = 0.75)

## merge the rasters together
ras <- merge(x = ras1p, y = ras2p) ## might throw error!

## https://gis.stackexchange.com/questions/167445/different-origin-problem-while-merging-rasters

origin(ras1p)
origin(ras2p)

origin(ras1)
origin(ras2)

## probably best to merge on the origional ones and then convert the whole thing
ras <- merge(x = ras1, y = ras2)
ras <- merge(x = ras, y = ras3)
ras <- merge(x = ras, y = ras4)

## convert the raster to be in the same coordinates as the TX county
ras <- projectRaster(ras, crs = crs(tx))

plot(ras, las = 1)
plot(tx, add = T)

## add labels in *optimal* locations
polygonsLabel(tx, labels = tx$NAME, cex = 0.25)


## crop the data 
c_tx <- tx[tx$NAME %in% c('Travis', 'Hays', 'Comal', 'Blanco'),]
plot(c_tx)
polygonsLabel(c_tx, labels = c_tx$NAME)

## crop the raster to the 4 counties
ras_crop <- crop(x = ras, y = c_tx)

## plot the smaller piece
plot(ras_crop)
plot(c_tx, add = T)
polygonsLabel(c_tx, labels = c_tx$NAME)

############# ############# ############# FEW MORE STEPS ############# ############# ############# 


## plot the reduced raster and counties
plot(ras_crop, las = 1)
plot(c_tx, add = T)
polygonsLabel(c_tx, labels = c_tx$NAME, cex = 2)


longs <- round(seq(from = extent(c_tx)@xmin, to = extent(c_tx)@xmax, by = 0.05), 2)
lats <- round(seq(from = extent(c_tx)@ymin, to = extent(c_tx)@ymax, by = 0.05), 2)

all_cords <- expand.grid(longs,lats)
names(all_cords) <- c('long', 'lat')

all_points <- SpatialPointsDataFrame(cbind(all_cords$long,all_cords$lat), data = all_cords, proj4string = crs(ras))

plot(all_points, add = T, col = 'red', pch = 16)


## intersect the new points with the polygons (c_tx counties)
tp <- intersect(x = all_points, y = c_tx)

## use the extract function to get the elevation at each point and add it to the tp SpatialPointsDataFrame
tp$elev <- extract(ras_crop, cbind(tp$long, tp$lat))

## calculate the average of each point within each county
aggregate(tp$elev, by = list(tp$NAME), FUN = mean)

