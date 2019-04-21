## Class demo #1, cleaning and formatting data from the weather underground webscrape

# load needed packages -- if this fails, run "install.packages('lubridate')" then reload the library 
install.packages('lubridate')
library(lubridate)

# Weather Underground
wu_url <- 'https://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KTXAUSTI942&month=1&day=16&year=2018&format=1'

# read in the CSV from the webpage, you can't have duplicate rownames, so we have to say row.names = NULL so R knows to give us new ones
day_data <- read.csv(wu_url, row.names = NULL)

# look at the first 6 rows of the dataframe
head(day_data)

# get the dimensions of the dataframe
dim(day_data)

# get the number of rows in the dataframe *[2] would have given you the number of columns
dim(day_data)[1]

# most of the problem rows of the dataframe are the same, and since the dates are different, we can get rid of a lot of them by getting rid of duplicate rows
day_data <- day_data[!duplicated(day_data$row.names),]

# when we check, there is still one row that doesn't have the right data in it
head(day_data)

# this is more complete and could have taken the place of the previous command
day_data <- day_data[day_data$row.names != '<br>',]

# beccause we had to specify row.names = NULL, R shifted our column names to the right by a single column, and created a new column of NA's
names(day_data)

# we want to get rid of the first column name and scoot the remaning to the left
col_names <- names(day_data)[2:length(names(day_data))]
col_names

# this assigns the col_names vector to overwrite the existing column names
names(day_data) <- col_names

# now we have the issue where we have this column at the end that we want to get rid of
head(day_data)

# get the dimensions of the dataframe
dim(day_data)

# get the number of columns in the dataframe
dim(day_data)[2]

# I want one less than the number that is currently there
num_real_col <- dim(day_data)[2] - 1
num_real_col

# overwrite the dataframe with just columns 1:15 (in this case)
day_data <- day_data[c(1:num_real_col)]

head(day_data)

# there are some columns that I do not want anymore, so I am subsetting the dataframe. There are other ways to do it, but this works for any starting order of columns
day_data <- as.data.frame(cbind(as.character(day_data$Time), day_data$TemperatureF, day_data$DewpointF, day_data$WindSpeedMPH, day_data$Humidity))

head(day_data)

# I got tired of the long column names, so I renamed them to be simplier ones, also the above reordering destroyed them
names(day_data) <- c('time', 'tempF', 'DewpointF', 'wnd.spd.mph', 'RH')

# I want values to be in metric, not imperial, so here I create new columns with the translated values. Note that if I had used "day_data <- read.csv(wu_url, row.names = NULL, stringsAsFactors = F)" I would not have to convert factor -> character -> numeric here
day_data$tempC <- (as.numeric(as.character(day_data$tempF)) - 32)*(5/9)
day_data$DP_tempC <- (as.numeric(as.character(day_data$DewpointF)) - 32)*(5/9)
day_data$wnd.spd.ms <- as.integer(as.character(day_data$wnd.spd.mph))*0.44704
day_data$RH <- as.numeric(as.character(day_data$RH))*1

# Now I am going to get rid of the imperial columns by subsetting them out, I do that now becuase I am sure of the order of the columns	
day_data <- day_data[c(1, 5, 6, 7, 8)]

head(day_data)

# Up to now, R thinks the column "time" is a character, but I want to use it as a date-time object, becuase the date is in the default R format, we don't have to specify the formatt 
day_data$time <- as.POSIXct(day_data$time)

# 'ceiling_date' is a function that takes the date and round up to the nearest hour, 'floor_date' would have rounded down, this creates a new column called time_ceiling that has the rounded-up hour
day_data$time_ceiling <- ceiling_date(day_data$time, "hour")

head(day_data)

# this step averages "FUN = mean" columns 2-5 over the column "time_ceiling" 	
day_data <- aggregate(day_data[c(2:5)], by = list(day_data$time_ceiling), FUN = mean)

head(day_data)	

# the "time_ceiling" column was renamed "Group.1" as that was the first group the rest of the columns were averaged over, so here I rename	
names(day_data) <- c('time', 'RH', 'tempC', 'DP_tempC', 'wnd.spd.ms')

# for some reason I wanted to calcaute the wetbulb temperature of the air, it is a function of the other columns, so I looked up a formula on the internets and do so here
day_data$wetbulb_tempC <- (-5.806+0.672*day_data$tempC-0.006*day_data$tempC*day_data$tempC+(0.061+0.004*day_data$tempC+0.000099*day_data$tempC*day_data$tempC)*day_data$RH+(-0.000033-0.000005*day_data$tempC-0.0000001*day_data$tempC*day_data$tempC)*day_data$RH*day_data$RH)

head(day_data)	
summary(day_data)



