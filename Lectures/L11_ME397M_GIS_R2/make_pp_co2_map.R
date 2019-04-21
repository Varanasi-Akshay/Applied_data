#### SPATIAL (GIS) DATA IN R ####

make_pp_co2_map <- function(){


library(sp)
library(rgdal)
library(raster)
library(colorRamps)
library(rasterVis)
library(rgeos)
library(plotrix)
library(animation)


#################################################################################################################################

################################################### US counties data ###################################################

## read in county shapefile data
county <- shapefile('US_COUNTY_SHPFILE/US_county_cont.shp')

## transform that data to a more conocial view
county <- spTransform(county, CRS("+init=epsg:26978"))

## dissolve the county shapefile inst states
states <- gUnaryUnion(county, id = county@data$STATE_NAME)


################################################### CO2 pipelines ###################################################

## read in shapefile of CO2 pipelines
co2 <- shapefile('CO2_pipeline_shapefile/CO2_shpfile.shp')

## transform that data to a more conocial view
co2 <- spTransform(co2, CRS("+init=epsg:26978"))

################################################### Powerplant data ###################################################

## get power plants
pp2 <- shapefile('power_plant_shapefile.shp')


################################################### clip/crop data ################################################### 

## get the polygons (US counties) that intersect (touch) the CO2 pipelines
US_counties_with_co2_pipelines <- raster::intersect(county, co2)

## get the CO2 pipeline segments that are inside Texas counties (polygons in tx)
co2_pipelines_in_US <- raster::intersect(co2, county)

## get only NGCC plants within 10km of existing CO2 pipelines
co2_pp <- pp2[pp2$Tchnl %in% c('Natural Gas Fired Combined Cycle', 'Conventional Steam Coal'),]

CRS.new<-CRS("+proj=lcc +lat_1=27.41666666666667 +lat_2=34.91666666666666 +lat_0=31.16666666666667 +lon_0=-100 +x_0=1000000 +y_0=1000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")  
proj4string(co2_pp) <- CRS.new 
proj4string(co2_pipelines_in_US) <- CRS.new

## calcualte the distace from each point (power plant) to the nearest line (CO2 pipeline) that are within 10 km
dist <- gDistance(co2_pp, co2_pipelines_in_US, byid=TRUE)

## get the minimum distance from each ngcc power plant to the nearest CO2 pipeline
d_min <- apply(dist,2,min)

## get the power plants that are within 10km of a CO2 pipeline
d2 <- d_min[d_min < 16093]

## subset the powerplants shapefile to those that are within 10km of the CO2 pieplines
co2_pp_10km <- co2_pp[row.names(co2_pp) %in% names(d2),]



#### get egrid data for 10km power plants ####

egrid <- read.csv('EGRID_plant.csv')
egrid <- egrid[egrid$ORISPL %in% unique(co2_pp_10km$Pln_C),]
egrid <- egrid[c('ORISPL', 'PLFUELCT', 'PSTATABB', 'PNAME', 'ISORTO', 'NAMEPCAP', 'PLHTRT', 'CAPFAC', 'PLCO2RTA', 'PLSO2RTA', 'PLNOXRTA')]

yr_data <- co2_pp_10km@data
yr_data <- yr_data[!duplicated(yr_data$Pln_C),]
yr_data <- yr_data[c('Pln_C', 'Oprtng_Yr_')]
names(yr_data) <- c('Pln_C', 'Oprtng_Yr')

m1 <- merge(x = egrid, y = yr_data, by.x = 'ORISPL', by.y = 'Pln_C')
m1$Oprtng_Yr <- round(m1$Oprtng_Yr, 0)

#### get plant type from F923 data

f923 <- read.csv('F923_2016.csv')
f923 <- f923[c('Plant.Id', 'Sector.Name')]
f923 <- f923[!duplicated(f923),]

m2 <- merge(x = m1, y = f923, by.x = 'ORISPL', by.y = 'Plant.Id', all.x = T)
plants_good <- c(56319,	55479,	56596,	7504,	56609,	6101,	6469,	6095,	8066,	55470,	52006,	52088,	55419,	55404,	55117,	52132,	56233,	50558,	56458,	52176,	55173,	55104,	55146,	55358,	55065,	55215,	56349)
m3 <- m2[m2$ORISPL %in% plants_good,]
m3_sub <- m3[c('ORISPL', 'NAMEPCAP')]

temp <- co2_pp_10km@data
temp <- temp[!duplicated(temp$Pln_C),]
temp <- temp[temp$Pln_C %in% plants_good,]

m4 <- merge(x = temp, y = m3_sub, by.x = 'Pln_C', by.y = 'ORISPL')

pp_to_plot <- SpatialPointsDataFrame(cbind(m4$Lngtd,m4$Lattd), data = m4, proj4string = CRS("+init=epsg:4202"))
pp_to_plot <- spTransform(pp_to_plot, CRS("+init=epsg:26978"))
pp_to_plot$cap_round <- round(pp_to_plot$NAMEPCAP)


high <- seq(from = 90, to = 2500, by = 1)
low <- seq(from = 2, to = 8, by = 6/(2500-90))
bubble <- as.data.frame(cbind(high, low))
names(bubble) <- c('cap', 'point_cex')


#################### plot the stuff ######################

coal_color <- rgb(250, 159, 66, max = 255, alpha = 128)
ngcc_color <- rgb(44, 73, 127, max = 255, alpha = 128)
coal_border <- rgb(250, 159, 66, max = 255, alpha = 255)
ngcc_border <- rgb(44, 73, 127, max = 255, alpha = 255)
county_color <- rgb(105, 48, 109, max = 255, alpha = 64)
county_border <- rgb(105, 48, 109, max = 255, alpha = 255)
pipe_color <- rgb(234, 82, 111, max = 255)


## set pp color
pp_to_plot$col <- coal_color
pp_to_plot$col[pp_to_plot$Tchnl == 'Natural Gas Fired Combined Cycle'] <- ngcc_color

pp_to_plot$border_col <- coal_border
pp_to_plot$border_col[pp_to_plot$Tchnl == 'Natural Gas Fired Combined Cycle'] <- ngcc_border

## set pp size
pp_to_plot <- merge(x = pp_to_plot, y = bubble, by.x = 'cap_round', by.y = 'cap')

pdf('CO2_power_plants_US.pdf', height = 9, width = 9)
par(mar = c(0,0,0,0), bg = 'white')


#### NEED TO SOMEHOW LINK THE m3 DATA WITH THE PLOTTING OF HT3 POINTS...

plot(US_counties_with_co2_pipelines, col = county_color, border = county_border, lwd = 1, xlim = c(-73545.1, 779699), ylim = c(-808666.4, 1790417.1))
plot(states, lwd = 2, add = T, border = 'white', col = 'lightgray')
plot(co2_pipelines_in_US, add = T, col = pipe_color, lwd = 3)
plot(pp_to_plot, add = T, bg = pp_to_plot$col, col = pp_to_plot$border_col, pch = 21, cex = pp_to_plot$point_cex, lwd = 2)
mtext(side = 3, cex = 1, text = '                                                                                                                Joshua D. Rhodes, PhD | @joshdr83 \n                                                                                                                 Energy Institute, The University of Texas at Austin', line = -2)
box()
legend('bottomleft', lty=c(NA, NA, 1), lwd = c(2, 2, 3), pch=c(21, 21, NA), pt.cex = c(3, 3, NA), pt.bg = c(coal_color, ngcc_color, NA), legend = c('Coal plants', 'NGCC plants', 'CO2 pipelines'), col = c(coal_color, ngcc_color, pipe_color), bty = 'n', cex = 1.5)
#legend('bottomright', lty=c(NA, NA, NA), pch = c(21, NA, 21), pt.cex = c(2, NA, 7.856), legend = c(' 90 MW', '', ' 2,500 MW'), pt.bg = 'lightgray', col = 'darkgray', lwd = 2, cex = 1.5, bty = 'n')

legend(x = 1121048, y = -444918.6, lty=c(NA, NA, NA), pch = c(21, NA, 21), pt.cex = c(2, NA, 7.856), legend = c('90 MW', '', '2,500 MW'), col = 'black', lwd = 2, cex = 1.5, bty = 'n', pt.bg = 'darkgray')


dev.off()

im.convert('CO2_power_plants_US.pdf', output = 'CO2_power_plants_US.png', extra.opts="-density 150")


#sum(co2_pp_10km$Nmp_C)



}



