RHODES_WU_HWK1 <- function(month, day, year = 2018, station_id){
	
	## Load an R package that I will use to deal with dates and times -- makes it a lot easier
	library(lubridate)
	
	## The "paste" function creates a string from other strings as well as other variables passed to it
	# sample: https://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KTXAUSTI942&month=1&day=16&year=2018&format=1
	
	wu_url <- paste('http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=',station_id,'&month=',month,'&day=',day,'&year=',year,'&format=1', sep = '')
	day_data <- read.csv(wu_url, row.names = NULL)
	
	#print(wu_url)
	
	#if(dim(day_data)[1] == 0){stop()}
	
	## This entire IF statement is designed to skip over days that do not have any data
	if(dim(day_data)[1] != 0){
	
	#print('in')
	
	closeAllConnections()
	
	Sys.sleep(30)
	
	day_data <- day_data[!duplicated(day_data$row.names),]
	day_data <- day_data[day_data$row.names != '<br>',]
	
	col_names <- names(day_data)[2:length(names(day_data))]
	names(day_data) <- col_names
	
	num_real_col <- dim(day_data)[2] - 1
	day_data <- day_data[c(1:num_real_col)]
	
	
	day_data <- as.data.frame(cbind(as.character(day_data$Time), day_data$TemperatureF, day_data$DewpointF, day_data$WindSpeedMPH, day_data$Humidity))
	names(day_data) <- c('time', 'tempF', 'DewpointF', 'wnd.spd.mph', 'RH')
		
	day_data$tempC <- (as.numeric(as.character(day_data$tempF)) - 32)*(5/9)
	day_data$DP_tempC <- (as.numeric(as.character(day_data$DewpointF)) - 32)*(5/9)
	day_data$wnd.spd.ms <- as.integer(as.character(day_data$wnd.spd.mph))*0.44704
	day_data$RH <- as.numeric(as.character(day_data$RH))*1
	
	day_data <- day_data[c(1, 5, 6, 7, 8)]
	day_data$time <- as.POSIXct(day_data$time)
	day_data$time_ceiling <- ceiling_date(day_data$time, "hour")
	
	
	day_data <- aggregate(day_data[c(2:5)], by = list(day_data$time_ceiling) , mean)
	
	
	names(day_data) <- c('time', 'RH', 'tempC', 'DP_tempC', 'wnd.spd.ms')
	day_data$wetbulb_tempC <- (-5.806+0.672*day_data$tempC-0.006*day_data$tempC*day_data$tempC+(0.061+0.004*day_data$tempC+0.000099*day_data$tempC*day_data$tempC)*day_data$RH+(-0.000033-0.000005*day_data$tempC-0.0000001*day_data$tempC*day_data$tempC)*day_data$RH*day_data$RH)
	#day_data$time <- day_data$time - 1800
	#day_data$time <- as.character(day_data$time)

	return(day_data)

	}else(c(NA, NA, NA))
	
}