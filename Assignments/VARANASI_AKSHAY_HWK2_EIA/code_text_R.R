	ex1<-as.data.frame(aggregate(x=f860$Nameplate.Capacity..MW., by=list(f860$Technology, f860$Prime.Mover),FUN=function(x) c(sum=sum(x), n=length(x))))
	ex1<-ex1[order(ex1$Group.1),]
	head(ex1,n=25)
	unique(ex1$Group.1)
	f860_r1<-f860[c('Utility.ID','Plant.Code','Technology','Prime.Mover','Energy.Source.1','Nameplate.Capacity..MW.')]
	head(f860_r1)
	ex2<-as.data.frame(aggregate(x=f860_r1$Nameplate.Capacity..MW.,by=list(f860_r1$Utility.ID,f860_r1$Plant.Code, f860_r1$Technology,f860_r1$Prime.Mover,f860_r1$Energy.Source.1),FUN=sum))
	names(ex2)<-c('Utility.ID','Plant.Code','Technology','Prime.Mover','Energy.Source.1','Nameplate.Capacity')
	head(ex2,n=15)
	f860_r2<-f860[c('Utility.ID','Plant.Code','Technology','Prime.Mover','Energy.Source.1','Operating.Year')]
	ex3<-as.data.frame(aggregate(x=f860_r2$Operating.Year,by=list(f860_r2$Utility.ID,f860_r2$Plant.Code,f860_r2$Technology,f860_r2$Prime.Mover,f860_r2$Energy.Source.1),FUN=function(x) c(avg=mean(x), max=max(x),min=min(x))))
	names(ex3)
	summary(ex3$x)
	summary(as.data.frame(ex3$x[,1]))
	ex4<-as.data.frame(cbind(ex3[c('Group.1','Group.2','Group.3','Group.4','Group.5')]))
	names(ex4)<-c('Utility.ID','Plant.Code','Technology','Prime.Mover','Energy.Source.1','Operating.Year.avg','Operating.Year.max','Operating.Year.min')
	dim(ex4)
	head(ex4,n=15)
	m1<-merge(x=ex2,y=ex4,by=c('Utility.ID','Plant.Code','Technology','Prime.Mover','Energy.Source.1'))
	dim(m1)
	head(m1)
	m1[m1$Plant.Code==3,]
	f923[f923$Plant.Id==3,][,c(1,4:6,14:15,24:25)]
	dim(m1)
	dim(f923)
	head(m1)
	f923[1:5,c(1,4:6,14:15,24:25)]
	m2<-merge(x=m1,y=f923,by.x=c('Utility.ID','Plant.Code','Technology','Prime.Mover','Energy.Source.1'),by.y=c('Operating.Id','Plant.Id','Reported.Prime.Mover','Reported.Fuel.Type.Code'))
	dim(m2)
	m2[1:10,c(1:9,29:30)]
	sum(m2$Nameplate.Capacity)
	sum(m1$Nameplate.Capacity)
	dim(m1)
	f923_dup<-f923[duplicated(f923[c('Plant.Id','Operating.Id','Reported.Fuel.Type.Code','Reported.Prime.Mover')])]
	dim(f923_dup)
	summary(f923_dup)	
	a1<-aggregate(x=f923$Net.Generation..Megawatthours.,by=list(f923$Plant.Id,f923$Operating.Id,f923$Reported.Prime.Mover,f923$Reported.Fuel.Type.Code),FUN=sum)	
	names(a1)<-c('Plant.Id','Operating.Id','Reported.Prime.Mover','Reported.Fuel.Type.Code','Net.Generation..Megawatthours.')
 	head(a1)
 	m3<-merge(x=m1,y=a1,by.x=c('Utility.ID','Plant.Id','Prime.Mover','Energy.Source.1'),by.y=c('Operating.Id','Plant.Id','Reported.Prime.Mover','Reported.Fuel.Type.Code'))
 	dim(m3)
 	head(m3)
 	sum(m3$Nameplate.Capacity)
 	
 	
	## Extra columns 
	m3$cap_fac<-m3$Net.Generation..Megawatthours./(m3$Nameplate.Capacity*8760)
	head(m3)
	summary(m3$cap_fac)
	hist(m3$cap_fac,n=100)
	m3[m3$cap_fac>1,]
	sum(m3$Nameplate.Capacity[m3$cap_fac>1])
	sum(m3$Nameplate.Capacity[m3$cap_fac>1])/sum(m3$Nameplate.Capacity)
	sum(m3$Net.Generation..Megawatthours.[m3$cap_fac>1])
	sum(m3$Net.Generation..Megawatthours.[m3$cap_fac>1])/sum(m3$Net.Generation..Megawatthours.)
	m3[m3$cap_fac<0,]
	m3[m3$Technology=='Hydroelelectricity Pumped Storage',]
	sum(m3$Nameplate.Capacity[m3$cap_fac<=1 & m3$cap_fac >=0])/sum(m3$Nameplate.Capacity)
	sum(m3$Net.Generation..Megawatthours.[m3$cap_fac<=1&m3$cap_fac >=0])/sum(m3$Net.Generation..Megawatthours.)
	
	## Functions to print these values to the console
	nameplate_capacity<-sum(m3$Nameplate.Capacity)/sum(f860$Nameplate.Capacity..MW.)
	print(paste("Nameplate.Capacity in the final dataset:",nameplate_capacity,sep=''))
	
	netgeneration<-sum(m3$Net.Generation..Megawatthours.)/sum(f923$Net.Generation..Megawatthours.) 
	print(paste("Net.Generation.MWh in the final dataset:",netgeneration,sep=''))
	
	
	
	## Saving the final merged data in csv file
	write.csv(x=m3,file=paste('VARANASI_AKSHAY_EIA_',year,'_data.csv',sep=''),row.names=F)
  
	#Utility.ID, Utility.Name, Plant.Code, Technology[*****], Plant.Name, Energy.Source.1, Prime.Mover, Nameplate.Capacity, Average.Operating.Year, Min.Operating.Year, Max.Operating.Year, Net.Generation.MWh, Elec.Fuel.Consumption.MMBtu, Capacity.Factor, Heat.Rate, Year

