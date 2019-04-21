library(tidyr)

# Read the data
eia_data <- read.csv('RHODES_JOSHUA_EIA_2016_data.csv')

## Aggregate the data by decade(that is why -1) and technology
eia_data_agg <- aggregate(eia_data$Nameplate.Capacity, by = list(round(eia_data$Operating.Year.avg, -1), eia_data$Technology), FUN = sum)
names(eia_data_agg) <- c('year', 'tech', 'MW_cap')


# Makes the column data into a matrix
spread_eia_data <- spread(data = eia_data_agg, key = year, value = MW_cap, fill = 0)

eia_data_new <- spread_eia_data

# Finding the sum for each technology
eia_data_new$techSum <- rowSums(eia_data_new[,-1])

# Consider only those technologies which have sum > 2000 or else they won't be seen in the graph anyway. 
eia_data_new <- eia_data_new[eia_data_new$techSum > 2000,]

# Removing the column having the sum
eia_data_new <- eia_data_new[,-ncol(eia_data_new)]

# Plot in pdf file
pdf(file = 'VARANASI_AKSHAY_EIA_DATA_VIZ_Q2.pdf', height = 6, width = 9)

# Setting the seed 
set.seed(10)

# Giving the color map for the plot
cols = colorRampPalette(c("maroon","coral","orange","chocolate","red","yellow","green","blue","purple","sienna"))(20)

# Ploting the barplot
mids <- barplot(as.matrix(eia_data_new[2:14]/1000), las = 1, col = cols, xaxt = 'n', yaxt = 'n', xlab = '')

# Controlling the labels on axis
axis(side = 1, cex.axis = 0.8, at = mids, labels = seq(from = 1900, to = 2020, by = 10)) 
axis(side = 2, cex.axis = 0.8, at = seq(from = 0, to = 250, by = 50), labels = seq(from = 0, to = 250, by = 50), las = 1) 

# Text on axis
mtext(side = 1, cex = 1.3, line = 2.5, text = 'Decade ending')
mtext(side = 2, line = 2.6, cex = 1.5, text = 'Capacity (GW)')
mtext(side = 3, line = 0, cex = 1.5, text = 'Capacity (GW) added per decade to the\n US grid by type')

legend('topleft', legend = eia_data_new$tech, fill = cols, cex = 1, bty = 'n') ## add a legend

dev.off()