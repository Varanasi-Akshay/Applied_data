## running your R code in parallel ##

library(parallel)
library(foreach)
library(doMC) ## for Mac/Linux
#library(doSNOW) ## for Windows


################################ vectorized functions in R ################################

log(3)

log(1:10)

hundred_million_nums = sample(1:10, size=100000000, replace=TRUE)


## function to loop through all those numbers

log_novec = function(n){
   ret = rep(NA, length(n))
   for(i in seq_along(n)){
     ret[i] = log(n[i])
   }
   return(ret)
 }

## see the difference
system.time(log_novec(hundred_million_nums))

system.time(log(hundred_million_nums))



################################ apply family of functions in R ################################

##### using apply #####

m <- matrix(c(1:10, 11:20), nrow = 10, ncol = 2)

# mean of the rows
apply(m, 1, mean)

# mean of the columns
apply(m, 2, mean)

# divide all values by 2
apply(m, 1:2, function(x) x/2)


##### using by #####

eia <- read.csv('RHODES_JOSHUA_EIA_2016_data_OPTHW.csv')

# get the mean of the Nameplate capacity, operating year, and capacity factor, by Technology
b1 <- by(data = eia[c('Nameplate.Capacity', 'Operating.Year.avg', 'cap_fac')], INDICES = eia$Technology, FUN = colMeans)

b1

b1$Nuclear


## Other examples of the apply family can be found:
## https://nsaunders.wordpress.com/2010/08/20/a-brief-introduction-to-apply-in-r/


################################ parallelized loops in R ################################


## this function in the parallel library lets you see how many cores you have to work with on your local machine
detectCores()

## before you run something in parallel, you have to tell the system how many cores you want to work over

## FOR MAC/LINUX
registerDoMC(cores=4) ## use 4 cores at a time
# 
# ## FOR WINDOWS
# cl<-makeCluster(5)
# registerDoSNOW(cl)


## example of when parallelization is not a good idea using the foreach loop

system.time( foreach (i = 1:100000) %do% mean(rnorm(100)) )
system.time( foreach (i = 1:100000) %dopar% mean(rnorm(100)) )

system.time( for(i in 1:100000) mean(rnorm(100)) )

## toy example of how the system works
system.time( for(i in 1:5) {Sys.sleep(5)} )

system.time( foreach(i = 1:5) %dopar% {Sys.sleep(5)} )


## doing HWK2 in half the time
source('RHODES_JOSHUA_HWK2_EIA.R')
system.time( for(i in 2007:2016){RHODES_JOSHUA_HWK2_EIA(i)} )
system.time( foreach(i = 2007:2016) %dopar% {RHODES_JOSHUA_HWK2_EIA(i)} )

## WINDOWS MUST STOP CLUSTERS!!!
#stopCluster(cl)

## a couple more examples
# did not work
# system.time( for(i in 1:10){  ginv(matrix(rnorm(n = 1000^2), nrow = 1000, ncol = 1000)) } )
# system.time( foreach(i = 1:10) %dopar% {  ginv(matrix(rnorm(n = 1000^2), nrow = 1000, ncol = 1000)) } )



## more links

## Windows: https://www.r-bloggers.com/how-to-go-parallel-in-r-basics-tips/




