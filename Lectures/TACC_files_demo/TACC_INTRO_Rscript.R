##

source('RHODES_WU_HWK1.R')

wdata <- RHODES_WU_HWK1(month = 1, day = 1, year = 2017, station_id = 'KILFRANK2')

head(wdata)

write.csv(wdata, 'wu_output.csv', row.names = F)