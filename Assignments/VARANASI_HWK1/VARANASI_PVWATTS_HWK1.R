VARANASI_PVWATTS_HWK1<-function(lat,long,capacity,array_type){
  
  
  # Loading necessary libraries
  library(xml2)
  library(rvest)
  library(curl)
  library(jsonlite)
  
  # This is key is different for different people
  api_key<-'degFxR2CFF8naLF4HQM81I2yUHc5sXmw00Y9RSNG'
  
  
  
#   data<-read_html('https://developer.nrel.gov/api/pvwatts/v5.json?api_key=degFxR2CFF8naLF4HQM81I2yUHc5sXmw00Y9RSNG&lat=latitude.5&lon=longitude&system_capacity=capacity&array_type=array_type_inp&module_type=1&losses=10&azimuth=180&tilt=35.5
# &timeframe=hourly')

  # this creates the URL with current inputs
  location <- paste('https://developer.nrel.gov/api/pvwatts/v5.json?api_key=',api_key,'&lat=',lat,'&lon=',long,'&system_capacity=',capacity,'&array_type=',array_type,'&module_type=1&losses=10&azimuth=180&tilt=35.5&timeframe=hourly',sep='')
  
  # reading the json file into data
  data<-fromJSON(location)
  
  # Dividing the hourly generation by capacity
  data3<-(data$outputs$ac/(capacity*1000))
  
  # Returning the data
  return(data3)
}