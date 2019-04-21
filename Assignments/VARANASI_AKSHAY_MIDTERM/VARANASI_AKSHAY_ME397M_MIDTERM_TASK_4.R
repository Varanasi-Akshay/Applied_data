  # VARANASI AKSHAY ME397M MIDTERM TASK 4

  ## load them packages
  library(sp)
  library(rgdal)
  library(raster)
  library(colorRamps)
  library(rasterVis)
  library(rgeos)
  library(plotrix)
  library(animation)
  
  
  # Reading the Texas map
  county <- shapefile('./ME397M_midterm_data/US_COUNTY_SHPFILE/US_county_cont.shp')
  
  ## simple R-type subset of the polygon can give you only Texas
  tx <- county[county$STATE_NAME == 'Texas',]
  
  # Getting only the state boundary by union of counties
  tx_state<-gUnaryUnion(tx,id=tx@data$STATE_NAME)
  
  # Transforming it
  tx_state<-spTransform(tx_state,CRS("+init=epsg:26978"))
  
  # Reading the GLO State Submerged Lands
  glo<-shapefile("./ME397M_midterm_data/StateSubmergedLands/SubmergedOTLS.shp")
  
  # Transforming it
  glo<-spTransform(glo,CRS("+init=epsg:26978"))
  
  # Considering only the ones which are not within 3 miles
  texas_state_buffer = buffer(tx_state, 4828.03)
  glo_3mi <- gDifference(glo, texas_state_buffer)
  glo_3mi <- raster::intersect(glo, glo_3mi)
  
  # Finding out the co-ordinates for limiting the plot
  glo_3mi@bbox
  
  # Combining based on waterbody
  state_sub<-gUnaryUnion(glo_3mi,id=glo_3mi@data$WATERBODY )
  # Transforming it
  state_sub<-spTransform(state_sub,CRS("+init=epsg:26978"))
  
  
  plot(state_sub,xlim = c(495145.7 , 860556.0), ylim = c(-795668.4 ,-335621.8) , col='green')
  plot(tx_state,xlim = c(495145.7 , 860556.0), ylim = c(-795668.4 ,-335621.8),add=T)
  # we got the co-ordinates using glo@bbox
  
  # Reading the Gulf of Mexico 90-m Windspeed Offshore Wind
  gulf<-shapefile("./ME397M_midterm_data/Gulf_of_Mexico_90mwindspeed_offshore_Wind_High_Resolution/gom/gulf_of_mexico_90mwindspeed_off.shp")
  
  # Transforming it
  gulf<-spTransform(gulf,CRS("+init=epsg:26978"))
  
  # Finding the intersection
  intersect_data <- raster::intersect(glo_3mi,gulf)
  
  #Calculating capacity factor
  intersect_data$cap_fac = (intersect_data$Speed_90 * 5.26 - 8.38)/100
  
  # Calculating Number of turbines
  intersect_data$num_turbines = round(intersect_data$ACREAGE/413, 6)
  
  # Calculating annual energy produced
  intersect_data$annual_energy_produced = round(intersect_data$num_turbines * intersect_data$cap_fac * 8.25 * 24 * 365 , 2)
  
  
  # Seeing the first few lines of the data
  head(intersect_data)
  
  # Printing the total energy
  total_energy=sum(intersect_data$annual_energy_produced)/10^6
  print(paste('The TX Gulf Coast GLO State Submerged Lands could produce up to:', prettyNum(round(total_energy,0),big.mark=",",scientific=FALSE),'TWh per year.',sep=''))
  