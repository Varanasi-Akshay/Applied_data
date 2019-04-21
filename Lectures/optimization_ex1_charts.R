# linear program example from 
# http://lpsolve.sourceforge.net/5.5/formulate.htm
# in this script, we don't solve the linear program but plot it in 2-d space
# for visualization purposes. 

library(ggplot2)

### set up some functions to define the constraints and the profit
# money constraint
# 120*w + 210*b <= 15000
constraint1 = function(w){
  b = (15000 - 120*w)/210
  return(b)
}

# storage constraint
# 110*w + 30*b <= 4000
constraint2 = function(w){
  b = (4000 - 110*w)/30
  return(b)
}

# acreage constraint
# w + b <= 75
constraint3 = function(w){
  b = 75 - w
  return(b)
}

# profit contours - returns barley given wheat and profit. i.e. gives us the information needed to plot a line of (wheat, barley) combinations that yield a given amount of profit
# p = 110*1.30*w + 30*2.00*p
profitContour = function(wArray, p){
  b <- numeric(length(wArray))
  for (i in 0:length(w)){
    b[i] = (p - 110*1.30*w[i]) / (30*2.00)
  }
  return(b)
}


### set up data frame for plotting. Data frame will put barley in terms of wheat. Wheat will be our x axis, and barley will be our y axis.
w = seq(0,40)
# add data for plotting the constraints. I.e. how much barley we can have in each constraint given an amount of wheat.
plotDF = data.frame(w, constraint1(w), constraint2(w), constraint3(w))
names(plotDF) = c('w','con1','con2','con3')
plotDF$zero = rep(0,length(w))
# add data for plotting the profit contours. I.e. how much barlet do we need to make a certain profit given a certain amount of wheat.
for (p in c(1500, 3000, 4500, 6000, 7500)){
  b <- data.frame(profitContour(w, p))
  names(b) = paste('p', p, sep="")
  plotDF <- cbind(plotDF, b)
}
#set all negatives to zero, since you can't have negative barley
plotDF <- replace(plotDF, plotDF<0, 0)


### set up and view the charts
# plot the constraint lines
p0 = ggplot(plotDF, aes(x = w)) + 
  coord_cartesian(ylim=c(0,80),xlim = c(0,40))+                      
  geom_line(aes(y = con1), colour = 'red', linetype = 2) +
  geom_line(aes(y = con2), colour = 'red', linetype = 2) +
  geom_line(aes(y = con3), colour = 'red', linetype = 2) +
  xlab('wheat') +
  ylab('barley') 

# add an area plot underneath the constraint lines. This is the feasible solution space.
p1 <- p0 +  geom_area(aes(y = pmin(con1,con2,con3)), fill = 'gray40')
# view the constraints and feasible solution space
p1

# add the profit contour lines
p2 <- p1 +                    
  geom_line(aes(y = p1500), colour = 'blue', linetype = 1) +
  geom_line(aes(y = p3000), colour = 'blue', linetype = 1) +
  geom_line(aes(y = p4500), colour = 'blue', linetype = 1) +
  geom_line(aes(y = p6000), colour = 'blue', linetype = 1) +
  geom_line(aes(y = p7500), colour = 'blue', linetype = 1)
# view the whole chart
p2

