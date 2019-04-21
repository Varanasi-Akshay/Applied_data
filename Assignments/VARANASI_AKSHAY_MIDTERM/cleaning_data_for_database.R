
eia <- read.csv('RHODES_JOSHUA_EIA_2016_data.csv', stringsAsFactors = F)
summary(eia)

eia$Heat.Rate[is.na(eia$Heat.Rate)] <- -9999999999
eia$Heat.Rate[is.infinite(eia$Heat.Rate)] <- -9999999999

summary(eia)
write.csv(eia, 'cleaned_RHODES_JOSHUA_EIA_2016_data.csv', row.names = F)

