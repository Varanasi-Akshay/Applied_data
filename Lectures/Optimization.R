library(ggplot2)

constraint1= function(w){
  b=(15000-120*w)/210
  return(b)
}


constraint2= function(w){
  b=(4000-110*w)/30
  return(b)
}


constraint3= function(w){
  b=(75-w)
  return(b)
}

profitContour = function(wArray,p){
  b<-numeric(length(wArray))
  for (i in 0:length(w)){
    b[i] = (p-110*1.3*w[i])/(2*30)
  }
  return(b)
}

w=seq(0,40)

plotDF=data.frame(w,constraint1(w),constraint2(w),constraint3(w))
names(plotDF) = c('w','con1','con2','con3')

View(plotDF)

for (p in c(1500,3000,4500,6000,7500)){
  b<-data.frame(profitContour(w,p))
  names(b) = paste('p',p,sep='')
  plotDF<-cbind(plotDF,b)
}
View(plotDF)
plotDF<-replace(plotDF,plotDF<0,0)
p0=ggplot(plotDF,aes(x=w))+coord_cartesian(ylim=c(0,80),xlim = c(0,40))+geom_line(aes(y=constraint1),color='red',linetype=2)+geom_line(aes(y=constraint2),color='red',linetype=2)+geom_line(aes(y=constraint3),color='red',linetype=2)+xlab('wheat')+ylab('barley')
p0
          