###### DATA VIZ, ME397 DATA ANALYSIS CLASS ####### Joshua D. Rhodes, PhD | The Univeristy of Texas at Austin | @joshdr83

library(tidyr)
library(RColorBrewer)
library (sp)
library (rgdal)
library (raster)
library(randomcoloR)
							

## read in data
eia <- read.csv('RHODES_JOSHUA_EIA_2016_data.csv')

## get amount of capacity added per year 
		## NOTE HAVE TO ROUND YEARS, BECUASE I DON'T WANT TO HAVE A VALUE AT 1978.33 OR SOMETHING LIKE THAT
e2 <- aggregate(eia$Nameplate.Capacity, by = list(round(eia$Operating.Year.avg, 0)), FUN = sum)
names(e2) <- c('year', 'MW_cap')

head(e2)

### most simple plot
plot(e2$MW_cap)



############################################### line graph ###############################################

plot(e2$MW_cap, type = 'l')


## here is what can happen if your data are out of order
e3 <- e2[sample(nrow(e2)),]
plot(e3$MW_cap, type = 'l')


## let's index the y values to correct x values (dates)
plot(MW_cap ~ year, data = e2, type = 'l')

## we call this "art" but not science...
plot(MW_cap ~ year, data = e2, type = 'l')

## let's start to make this look pretty

	# change line color: col = 'blue'
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue')
	# change line width: lwd = 3
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3)
	# rotate y-axis labels: las = 1
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1)
	# add/change x-axis label: xlab = 'Year'
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year')

## let's change some of the margins around

par(mar = c(5.1, 4.1, 4.1, 2.1))
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year')

par(mar = c(5.1, 5.1, 4.1, 2.1))
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year')

par(mar = c(5.1, 6.1, 4.1, 2.1))
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year')

## still having trouble with the y-axis label touching the axis labels, so call it '' in the main function call and use mtext()
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year', ylab = '')
mtext(text = 'Capacity (MW)', side = 2)

mtext(text = 'Capacity (MW)', side = 2, line = 2)
mtext(text = 'Capacity (MW)', side = 2, line = 4)
mtext(text = 'Capacity (MW)', side = 2, line = 6)
mtext(text = 'Capacity (MW)', side = 2, line = -2)

## line = 4 looks to be about right
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year', ylab = '')
mtext(text = 'Capacity (MW)', side = 2, line = 4)

## the label is too small, let's make it bigger: cex = 2
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year', ylab = '')
mtext(text = 'Capacity (MW)', side = 2, line = 4, cex = 2)

## let's make the x-axis label bigger too
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2)
mtext(text = 'Capacity (MW)', side = 2, line = 4, cex = 2)

## to add a title, there are a few ways

	# to the main plot call: main = 'my title' | let's also make it larger than it would be: cex.main = 2
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2, main = 'Capacity (MW) added per year to the US grid', cex.main = 2)
mtext(text = 'Capacity (MW)', side = 2, line = 4, cex = 2)

	# using the mtext 
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2)
mtext(text = 'Capacity (MW)', side = 2, line = 4, cex = 2)
mtext(text = 'Capacity (MW) added per year to the US grid', side = 3, line = 1, cex = 2)

## let's do the axes a different way so that we can have more control

	# first turn the axes off
plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2, xaxt = 'n', yaxt = 'n')
mtext(text = 'Capacity (MW)', side = 2, line = 4, cex = 2)
mtext(text = 'Capacity (MW) added per year to the US grid', side = 3, line = 1, cex = 2)


plot(MW_cap ~ year, data = e2, type = 'l', col = 'blue', lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2, xaxt = 'n', yaxt = 'n')
mtext(text = 'Capacity (GW)', side = 2, line = 4, cex = 2)
mtext(text = 'Capacity (GW) added per year to the US grid', side = 3, line = 1, cex = 2)
axis(side = 1, cex.axis = 2, at = seq(from = 1900, to = 2020, by = 20), labels = seq(from = 1900, to = 2020, by = 20)) # same as origional
axis(side = 2, cex.axis = 2, at = seq(from = 0, to = 60000, by = 10000), labels = seq(from = 0, to = 60, by = 10), las = 1) # values divided by 1,000 so labels: MW -> GW


## let's add come context to the graph: show the deregulation of the US power sector: https://live-energy-institute.pantheonsite.io/sites/default/files/UTAustin_FCe_History_2016.pdf

light_gray_you_can_see_through <- rgb(red = 192/255, green = 192/255, blue = 192/255, alpha = 0.5)
rect(xleft = 1992, ybottom = -200000, xright = 2000, ytop = 80000, col = light_gray_you_can_see_through, border = light_gray_you_can_see_through)

## let's get some better colors: 
https://coolors.co/

better_blue <- rgb(red = 0, green = 159, blue = 253, max = 255)



plot(MW_cap ~ year, data = e2, type = 'l', col = better_blue, lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2, xaxt = 'n', yaxt = 'n')
mtext(text = 'Capacity (GW)', side = 2, line = 4, cex = 2)
mtext(text = 'Capacity (GW) added per year to the US grid', side = 3, line = 1, cex = 2)
axis(side = 1, cex.axis = 2, at = seq(from = 1900, to = 2020, by = 20), labels = seq(from = 1900, to = 2020, by = 20)) 
axis(side = 2, cex.axis = 2, at = seq(from = 0, to = 60000, by = 10000), labels = seq(from = 0, to = 60, by = 10), las = 1) 
rect(xleft = 1992, ybottom = -200000, xright = 2000, ytop = 80000, col = light_gray_you_can_see_through, border = light_gray_you_can_see_through)


## let's move this to a PDF formatt so that we can get the final tweaks to the sizes just right


pdf(file = 'RHODES_JOSHUA_EIA_US_CAPACITY_LINE.pdf', height = 6, width = 9)

par(mar = c(5.1, 6.1, 4.1, 2.1))
plot(MW_cap ~ year, data = e2, type = 'l', col = better_blue, lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2, xaxt = 'n', yaxt = 'n')
mtext(text = 'Capacity (GW)', side = 2, line = 4, cex = 2)
mtext(text = 'Capacity (GW) added per year to the US grid', side = 3, line = 1, cex = 2)
axis(side = 1, cex.axis = 2, at = seq(from = 1900, to = 2020, by = 20), labels = seq(from = 1900, to = 2020, by = 20)) 
axis(side = 2, cex.axis = 2, at = seq(from = 0, to = 60000, by = 10000), labels = seq(from = 0, to = 60, by = 10), las = 1) 
rect(xleft = 1992, ybottom = -200000, xright = 2000, ytop = 80000, col = light_gray_you_can_see_through, border = light_gray_you_can_see_through)

dev.off()


## I think reduce the size of the axis labels a bit and make the title a little bigger

pdf(file = 'RHODES_JOSHUA_EIA_US_CAPACITY_LINE.pdf', height = 6, width = 9)

par(mar = c(5.1, 6.1, 4.1, 2.1))
plot(MW_cap ~ year, data = e2, type = 'l', col = better_blue, lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2, xaxt = 'n', yaxt = 'n')

axis(side = 1, cex.axis = 1.5, at = seq(from = 1900, to = 2020, by = 20), labels = seq(from = 1900, to = 2020, by = 20)) 
axis(side = 2, cex.axis = 1.5, at = seq(from = 0, to = 60000, by = 10000), labels = seq(from = 0, to = 60, by = 10), las = 1) 

mtext(side = 2, line = 4, cex = 2, text = 'Capacity (GW)')
mtext(side = 3, line = 1, cex = 2.25, text = 'Capacity (GW) added per year to the US grid')

rect(xleft = 1992, ybottom = -200000, xright = 2000, ytop = 80000, col = light_gray_you_can_see_through, border = light_gray_you_can_see_through)

dev.off()


############################################### stacked bar graph ###############################################

## aggregate the data by decade and technology
e4 <- aggregate(eia$Nameplate.Capacity, by = list(round(eia$Operating.Year.avg, -1), eia$Technology), FUN = sum)
names(e4) <- c('year', 'tech', 'MW_cap')
head(e4)

e5 <- spread(data = e4, key = year, value = MW_cap, fill = 0)
head(e5)

e6 <- e5
e6$techSum <- rowSums(e6[,-1])
e6 <- e6[e6$techSum > 2000,]
e6 <- e6[,-ncol(e6)]

#simple stacked barplot
set.seed(2)
cols <- distinctColorPalette(nrow(e6))


par(mar = c(5.1, 6.1, 4.1, 2.1))
mids <- barplot(as.matrix(e6[2:14]/1000), las = 1, col = cols, xaxt = 'n', yaxt = 'n', xlab = '')

axis(side = 1, cex.axis = 1.25, at = mids, labels = seq(from = 1900, to = 2020, by = 10)) 
axis(side = 2, cex.axis = 1.5, at = seq(from = 0, to = 250, by = 50), labels = seq(from = 0, to = 250, by = 50), las = 1) 

mtext(side = 1, cex = 2, line = 3, text = 'Decade ending')
mtext(side = 2, line = 4, cex = 2, text = 'Capacity (GW)')
mtext(side = 3, line = 1, cex = 2.25, text = 'Capacity (GW) added per decade to the US grid by type')

legend('topleft', legend = e6$tech, fill = cols, cex = 1.25, bty = 'n') ## add a legend


## make a png file v1

png(file = 'RHODES_JOSHUA_EIA_US_CAPACITY_STACKEDBAR.png', height = 6, width = 9, units = 'in', res = 360)

set.seed(2)
cols <- distinctColorPalette(nrow(e6))


par(mar = c(5.1, 6.1, 4.1, 2.1))
mids <- barplot(as.matrix(e6[2:14]/1000), las = 1, col = cols, xaxt = 'n', yaxt = 'n', xlab = '')

axis(side = 1, cex.axis = 1.25, at = mids, labels = seq(from = 1900, to = 2020, by = 10)) 
axis(side = 2, cex.axis = 1.5, at = seq(from = 0, to = 250, by = 50), labels = seq(from = 0, to = 250, by = 50), las = 1) 

mtext(side = 1, cex = 2, line = 3, text = 'Decade ending')
mtext(side = 2, line = 4, cex = 2, text = 'Capacity (GW)')
mtext(side = 3, line = 1, cex = 2.25, text = 'Capacity (GW) added per decade to the US grid by type')

legend('topleft', legend = e6$tech, fill = cols, cex = 1.25, bty = 'n') ## add a legend

dev.off()


## make a png file v2, with fixed units/labels/etc.

png(file = 'RHODES_JOSHUA_EIA_US_CAPACITY_STACKEDBAR.png', height = 6, width = 9, units = 'in', res = 360)

set.seed(2)
cols <- distinctColorPalette(nrow(e6))


par(mar = c(5.1, 6.1, 4.1, 2.1))
mids <- barplot(as.matrix(e6[2:14]/1000), las = 1, col = cols, xaxt = 'n', yaxt = 'n', xlab = '')

axis(side = 1, cex.axis = 1, at = mids, labels = seq(from = 1900, to = 2020, by = 10)) 
axis(side = 2, cex.axis = 1.5, at = seq(from = 0, to = 250, by = 50), labels = seq(from = 0, to = 250, by = 50), las = 1) 

mtext(side = 1, cex = 2, line = 3, text = 'Decade ending')
mtext(side = 2, line = 4, cex = 2, text = 'Capacity (GW)')
mtext(side = 3, line = 0, cex = 2, text = 'Capacity (GW) added per decade to the\n US grid by type')

legend('topleft', legend = e6$tech, fill = cols, cex = 1, bty = 'n') ## add a legend

dev.off()




############################################### PUT TWO CHARTS TOGETHER ###############################################

par(mar = c(5.1, 6.1, 4.1, 2.1), mfrow=c(2,2)) ## we are giving it the grid(2,2)

####### plot 1 #####

plot(MW_cap ~ year, data = e2, type = 'l', col = better_blue, lwd = 3, las = 1, xlab = 'Year', ylab = '', cex.lab = 2, xaxt = 'n', yaxt = 'n')

axis(side = 1, cex.axis = 1.5, at = seq(from = 1900, to = 2020, by = 20), labels = seq(from = 1900, to = 2020, by = 20)) 
axis(side = 2, cex.axis = 1.5, at = seq(from = 0, to = 60000, by = 10000), labels = seq(from = 0, to = 60, by = 10), las = 1) 

mtext(side = 2, line = 4, cex = 2, text = 'Capacity (GW)')
mtext(side = 3, line = 1, cex = 2.25, text = 'Capacity (GW) added per year to the US grid')

text(x = 1980, y = 60000, labels = c('Market reforms'))
arrows(x0 = 1980, y0 = 55000, x1 = 1990, y1 = 55000, length = 0.125)

rect(xleft = 1992, ybottom = -200000, xright = 2000, ytop = 80000, col = light_gray_you_can_see_through, border = light_gray_you_can_see_through)


###### empty plots 2 & 3 #######

plot.new()
plot.new()


###### plot 4 #######

set.seed(2)
cols <- distinctColorPalette(nrow(e6))

mids <- barplot(as.matrix(e6[2:14]/1000), las = 1, col = cols, xaxt = 'n', yaxt = 'n', xlab = '')

axis(side = 1, cex.axis = 1, at = mids, labels = seq(from = 1900, to = 2020, by = 10)) 
axis(side = 2, cex.axis = 1.5, at = seq(from = 0, to = 250, by = 50), labels = seq(from = 0, to = 250, by = 50), las = 1) 

mtext(side = 1, cex = 2, line = 3, text = 'Decade ending')
mtext(side = 2, line = 4, cex = 2, text = 'Capacity (GW)')
mtext(side = 3, line = 0, cex = 2, text = 'Capacity (GW) added per decade to the\n US grid by type')

legend('topleft', legend = e6$tech, fill = cols, cex = 0.8, bty = 'n') ## add a legend




############################################### Let's get spatial ###############################################

## read in county shapefile data
county <- shapefile('US_COUNTY_SHPFILE/US_county_cont.shp')

## transform that data to a more conocial view
county <- spTransform(county, CRS("+init=epsg:26978"))


plot(county)
plot(county, col = 'blue')




