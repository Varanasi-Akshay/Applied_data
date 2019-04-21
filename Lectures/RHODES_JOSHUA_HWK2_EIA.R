RHODES_JOSHUA_HWK2_EIA <- function(year){
  
  ######## Read in EIA F860 data, standardize wanted column names, and clean/merge ######## 
  f860 <- read.csv(paste('ME397_A2_data/F860_', year, '.csv', sep = ''), stringsAsFactors = FALSE)
  f860_names <- names(f860)
  
  ## standardize column names for all years in F860 data
  f860_names <- replace(f860_names, f860_names %in% c('UTILCODE', 'UTILITY_ID', 'Utility.ID'), 'Utility.ID')
  f860_names <- replace(f860_names, f860_names %in% c('UTILNAME', 'UTILITY_NAME', 'Utility.Name'), 'Utility.Name')
  f860_names <- replace(f860_names, f860_names %in% c('PLNTCODE', 'PLANT_CODE', 'Plant.Code'), 'Plant.Code')
  f860_names <- replace(f860_names, f860_names %in% c('PLNTNAME', 'PLANT_NAME', 'Plant.Name'), 'Plant.Name')
  f860_names <- replace(f860_names, f860_names %in% c('ENERGY_SOURCE_1', 'Energy.Source.1'), 'Energy.Source.1')
  f860_names <- replace(f860_names, f860_names %in% c('PRIMEMOVER', 'PRIME_MOVER', 'Prime.Mover'), 'Prime.Mover')
  f860_names <- replace(f860_names, f860_names %in% c('NAMEPLATE', 'Nameplate.Capacity..MW.'), 'Nameplate.Capacity')
  f860_names <- replace(f860_names, f860_names %in% c('OPERATING_YEAR', 'Operating.Year'), 'Operating.Year')
  
  names(f860) <- f860_names
  
  ## Get 'Technology' column from 2016 data to merge with 2007-2013
  f860.16 <- read.csv(paste('ME397_A2_data/F860_', 2016, '.csv', sep = ''), stringsAsFactors = FALSE)
  f860.16 <- f860.16[c('Prime.Mover', 'Energy.Source.1', 'Technology')]
  f860.16 <- f860.16[!duplicated(f860.16),]
  
  ## If the year doesn't have a 'Technology' column then merge with the one from 2016
  if(!'Technology' %in% names(f860)){
  	
  	f860 <- merge(x = f860.16, y = f860, by.x = c('Prime.Mover', 'Energy.Source.1'), all = T)
  	f860$Technology[is.na(f860$Technology)] <- 'OTHER'
  	
  }
  
  ## make some factors to nunerics
  f860$Nameplate.Capacity <- as.numeric(as.character(gsub(",", "", f860$Nameplate.Capacity)))
  f860$Operating.Year <- as.numeric(as.character(gsub(",", "", f860$Operating.Year)))
  
  
  #clean up F860 data  
  
  #reduce F860 data down to just the rows we care to aggregate on (nameplace capacity)
  f860_r1 <- f860[c('Utility.ID', 'Utility.Name', 'Plant.Code', 'Technology', 'Plant.Name', 'Energy.Source.1', 'Prime.Mover', 'Nameplate.Capacity')]
  
  #aggregate F860 data in order to get nameplate capacity based on utility ID, plantc code, technology, and prime mover
	ex2 <- as.data.frame(aggregate(x = f860_r1$Nameplate.Capacity, by = list(f860_r1$Utility.ID, f860_r1$Utility.Name, f860_r1$Plant.Code, f860_r1$Technology, f860_r1$Plant.Name, f860_r1$Energy.Source.1, f860_r1$Prime.Mover), FUN = sum))  
	
  #rename the columns after aggregate in order to make easier to read
  names(ex2) <- c('Utility.ID', 'Utility.Name', 'Plant.Code', 'Technology', 'Plant.Name', 'Energy.Source.1', 'Prime.Mover', 'Nameplate.Capacity')
  
  #reduce F860 data down to just the rows we care to aggregate on (operating year)
  f860_r2 <- f860[c('Utility.ID', 'Utility.Name', 'Plant.Code', 'Technology', 'Plant.Name', 'Energy.Source.1', 'Prime.Mover', 'Operating.Year')]
  
  #aggregate F860 data in order to get average, min, and max operating year based on utility ID, plantc code, technology, and prime mover
  ex3 <- as.data.frame(aggregate(x = f860_r2$Operating.Year, by = list(f860_r2$Utility.ID, f860_r2$Utility.Name, f860_r2$Plant.Code, f860_r2$Technology, f860_r2$Plant.Name, f860_r2$Energy.Source.1, f860_r1$Prime.Mover), FUN = function(x) c(avg = mean(x), max = max(x), min = min(x))))
  
  #convert that last vector, x, that is holding three columns into three distince columns
  ex4 <- as.data.frame(cbind(ex3[c('Group.1', 'Group.2', 'Group.3', 'Group.4', 'Group.5', 'Group.6', 'Group.7')], as.data.frame(as.matrix(ex3$x))))
  
  #rename the columns after aggregate in order to make easier to read
  names(ex4) <- c('Utility.ID', 'Utility.Name', 'Plant.Code', 'Technology', 'Plant.Name', 'Energy.Source.1', 'Prime.Mover', 'Operating.Year.avg', 'Operating.Year.max', 'Operating.Year.min')
  
  #merge the two different F860 datasets back together
  m1 <- merge(x = ex2, y = ex4, by = c('Utility.ID', 'Utility.Name', 'Plant.Code', 'Technology', 'Plant.Name', 'Energy.Source.1', 'Prime.Mover'))
  
  

  ######## Read in EIA F923 data, standardize wanted column names, and clean/merge ########
  
  f923 <- read.csv(paste('ME397_A2_data/F923_', year, '.csv', sep = ''), stringsAsFactors = FALSE)
  f923_names <- names(f923)
  
  ## standardize column names for all years in F923 data
  f923_names <- replace(f923_names, f923_names %in% c('Plant.ID', 'Plant.Id'), 'Plant.Id')
  f923_names <- replace(f923_names, f923_names %in% c('Operator.Id', 'Operator.ID'), 'Operator.Id')
  f923_names <- replace(f923_names, f923_names %in% c('Net.Generation..Megawatthours.', 'NET.GENERATION..megawatthours.'), 'Net.Generation.MWh')
  f923_names <- replace(f923_names, f923_names %in% c('ELEC.FUEL.CONSUMPTION.MMBTUS', 'Elec.Fuel.Consumption.MMBtu'), 'Elec.Fuel.Consumption.MMBtu')
  
  names(f923) <- f923_names

  ## get rid of commas in the numbers and convert to numerics
  f923$Net.Generation.MWh <- as.numeric(as.character(gsub(",", "", f923$Net.Generation.MWh)))
  f923$Elec.Fuel.Consumption.MMBtu <- as.numeric(as.character(gsub(",", "", f923$Elec.Fuel.Consumption.MMBtu)))
  
  
  ######## clean up F923 data  ######## 
  
  #aggregate F923 data in order to get total MWh generated based on plant ID, operator ID, prime mover, and fuel type
  a1 <- aggregate(x = cbind(f923$Net.Generation.MWh, f923$Elec.Fuel.Consumption.MMBtu), by = list(f923$Plant.Id, f923$Operator.Id, f923$NERC.Region, f923$Reported.Prime.Mover, f923$Reported.Fuel.Type.Code), FUN = sum)
  
  #rename the columns after aggregate in order to make easier to read
  names(a1) <- c('Plant.Id', 'Operator.Id', 'NERC.Region', 'Reported.Prime.Mover', 'Reported.Fuel.Type.Code', 'Net.Generation.MWh', 'Elec.Fuel.Consumption.MMBtu')
  
  #merge the F860 and F923 data together
  m3 <- merge(x = m1, y = a1, by.x = c('Utility.ID', 'Plant.Code', 'Prime.Mover', 'Energy.Source.1'), by.y = c('Operator.Id', 'Plant.Id', 'Reported.Prime.Mover', 'Reported.Fuel.Type.Code'))
  
  #capcluate the total amount of capacity and energy in the final dataset as compared to what we started with
  cap <- sum(m3$Nameplate.Capacity, na.rm = T)/sum(f860$Nameplate.Capacity, na.rm = T)
  energy <- sum(m3$Net.Generation.MWh, na.rm = T)/sum(f923$Net.Generation.MWh, na.rm = T)
  
  #print these results to the console
  print(paste('Nameplate.Capacity in final dataset: ', round(cap*100, 2), '%', sep = ''))
  print(paste('Net.Generation.MWh in final dataset: ', round(energy*100, 2), '%', sep = ''))
    
  m3$Capacity.Factor <- m3$Net.Generation.MWh/(m3$Nameplate.Capacity*8760)
  m3$Heat.Rate <- m3$Elec.Fuel.Consumption.MMBtu*1000/m3$Net.Generation.MWh
  m3$Year <- year
  
  write.csv(x = m3, file = paste('RHODES_JOSHUA_EIA_', year,'_data.csv', sep = ''), row.names = F)
    
}