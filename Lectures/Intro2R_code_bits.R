## some commands for "Introduction to R" class
## Joshua D. Rhodes, PhD


## This is a comment, put here for your benefit, but R ignores ignores everything after hashtags/pound signs

## Read in the data
gen <- read.csv('gen_ercot_try.csv')

## look at first 6 rows of data, look at last 6 rows of data
head(gen)
tail(gen)

## subsetting data: give me all rows of datafram "gen" such that in the column "County" says "Menard"
gen[gen$County == 'Menard',]


## aggregating functions: give me a list of unique "Fuel" types and sum up all the "cap_MW" values associated with them (could do max, min, mean, etc.)
aggregate(x = gen$cap_MW, by = list(gen$Fuel), FUN = sum)


## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## 

## simple scraping web data
https://www.wunderground.com/weather/us/tx/austin/KTXAUSTI1256

## CSV-based API (nore on this later)
https://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KTXAUSTI1256&month=9&day=11&year=2018&format=1

## the same read.csv command can read in a CSV on the web
wdata <- read.csv('https://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KTXAUSTI1256&month=9&day=11&year=2018&format=2', row.names = NULL)

# row.names = NULL is given to prevent R from assuming rownames are same



## this data retrevial can be automated by 'paste'-ing together a string to send as a URL
for(i in 5:8){

	day <- i
	url <- paste('https://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KTXAUSTI1256&month=9&day=', i,'&year=2018&format=2', sep = '')
	wdata <- read.csv(url, row.names = NULL)
	print(head(wdata))

}


