VARANASI_AKSHAY_HWK2_EIA<-function(year){
# 
#   year='2008'
  # Reading both the files
	f860<-read.csv(paste('ME397_A2_data/F860_',year,'.csv',sep=''),stringsAsFactors = FALSE)
	f860_2016<-read.csv(paste('ME397_A2_data/F860_2016.csv',sep=''),stringsAsFactors = FALSE)
	
	#f860[1:5,1:5]
	f923<-read.csv(paste('ME397_A2_data/F923_',year,'.csv',sep=''),stringsAsFactors = FALSE)
	#f923[1:5,1:5]
	
	## Preprocessing both the files
	
	# For removing the last row comment if present in the first column in both the files
	f860[,1][f860[,1]==""] <- NA
	f860[,2][f860[,2]==""] <- NA
	
	f860_2016[,1][f860_2016[,1]==""] <- NA
	f860_2016[,2][f860_2016[,2]==""] <- NA
	
	
	l1=length(na.omit(f860[,1]))
	l2=length(na.omit(f860[,2]))
	
	
	l1_2016=length(na.omit(f860_2016[,1]))
	l2_2016=length(na.omit(f860_2016[,2]))
	
	
	f860=f860[1:min(l1,l2),]
	f860_2016=f860_2016[1:min(l1_2016,l2_2016),]
	
	
	# f860$Nameplate.Capacity..MW.[f860$Nameplate.Capacity..MW.=='']<-NA
	# View(f860$Nameplate.Capacity..MW.)
	# f860$Nameplate.Capacity..MW.=na.omit(f860$Nameplate.Capacity..MW.)
	# nm=length(f860$Nameplate.Capacity..MW.)
	# For warnings
	options(warn=-1)
	f923[,1][f923[,1]==""] <- NA
	f923[,2][f923[,2]==""] <- NA
	
	l1 = length(na.omit(f923[,1]))
	l2 = length(na.omit(f923[,2]))
	
	f923 = f923[1:min(l1,l2),]
	
	## Getting the required columns from f860
	
	# Utility ID
	Utility.ID=f860[,grep('util.*code|code.*util|util.*id|id.*util',names(f860),ignore.case = TRUE)]
	Utility.ID=as.data.frame(Utility.ID)
	
	# Utility Name
	Utility.Name=f860[,grep('util.*name|name.*util',names(f860),ignore.case = TRUE)]
	Utility.Name=as.data.frame(Utility.Name)
	
	# Energy source
	col.energy.source.1 = grep("energy.*source.*1", names(f860), ignore.case=TRUE)
	if (length(col.energy.source.1) > 1) {
	  col.energy.source.1 = col.energy.source.1[grep("planned", colnames(f860[,col.energy.source.1]), invert=TRUE, ignore.case = TRUE)]
	}
	Energy.Source.1 = f860[,col.energy.source.1]
	Energy.Source.1=as.data.frame(Energy.Source.1)
	
	# Prime Mover
	col.prime.mover = grep("prime.*mover", names(f860), ignore.case=TRUE)
	if (length(col.prime.mover) > 1) {
	  col.prime.mover = col.prime.mover[grep("planned", colnames(f860[,col.prime.mover]), invert=TRUE, ignore.case = TRUE)]
	}
	Prime.Mover = f860[,col.prime.mover]
	Prime.Mover = as.data.frame(Prime.Mover)
	
	# Energy source for 2016
	col.energy.source.1_2016 = grep("energy.*source.*1", names(f860_2016), ignore.case=TRUE)
	if (length(col.energy.source.1_2016) > 1) {
	  col.energy.source.1_2016 = col.energy.source.1_2016[grep("planned", colnames(f860_2016[,col.energy.source.1_2016]), invert=TRUE, ignore.case = TRUE)]
	}
	Energy.Source.1_2016 = f860_2016[,col.energy.source.1_2016]
	Energy.Source.1_2016=as.data.frame(Energy.Source.1_2016)
	
	# Prime Mover
	col.prime.mover_2016 = grep("prime.*mover", names(f860_2016), ignore.case=TRUE)
	if (length(col.prime.mover_2016) > 1) {
	  col.prime.mover_2016 = col.prime.mover_2016[grep("planned", colnames(f860_2016[,col.prime.mover_2016]), invert=TRUE, ignore.case = TRUE)]
	}
	Prime.Mover_2016 = f860_2016[,col.prime.mover_2016]
	Prime.Mover_2016 = as.data.frame(Prime.Mover_2016)
	
	# Technology
	if(as.numeric(year)<2014){
	  Technology = f860_2016$Technology
	  Technology = as.data.frame(Technology)
	  f860_2016_new=cbind(Prime.Mover_2016,Energy.Source.1_2016,Technology)
	  
	  f860_2016_new=unique(f860_2016_new)
	  f860_2016_new=as.data.frame(f860_2016_new)
	  
	  f860_for_tech=cbind(Prime.Mover,Energy.Source.1)
	  # f860_new=unique(f860_new)
	  # f860_new=as.data.frame(f860_new)
	  # 
	  Technology_temp=merge(x=f860_for_tech,y=f860_2016_new,by.x=c("Prime.Mover","Energy.Source.1"),by.y =c("Prime.Mover_2016","Energy.Source.1_2016"))
	  Technology_temp=unique(Technology_temp)
	  Technology_temp=as.data.frame(Technology_temp)
	  Technology=Technology_temp$Technology
	  Technology=as.data.frame(Technology)
	}else{
	Technology = f860$Technology
	Technology = as.data.frame(Technology)
	}
	
	# Plant Code
	Plant.Code=f860[,grep("plant.*id|id.*plant|plant.*code|code.*plant|plnt.*id|id.*plnt|plnt.*code|code.*plnt",names(f860),ignore.case = TRUE)]
	Plant.Code=as.data.frame(Plant.Code)
	
	# Plant Name
	Plant.Name=f860[,grep('plnt.*name|plant.*name|name.*plnt|name.*plant',names(f860),ignore.case = TRUE)]
	Plant.Name=as.data.frame(Plant.Name)
	

	
	# Nameplate Capacity
	col.nameplate.capacity = grep("nameplate", names(f860), ignore.case=TRUE)
	if (length(col.nameplate.capacity) > 1) {
	  col.nameplate.capacity = col.nameplate.capacity[grep("planned", colnames(f860[,col.nameplate.capacity]), invert=TRUE, ignore.case = TRUE)]
	}
	Nameplate.Capacity = f860[,col.nameplate.capacity]
	Nameplate.Capacity = as.data.frame(Nameplate.Capacity)
	
	# Operating Year
	Operating.Year = f860[,grep("operating.*year", names(f860), ignore.case=TRUE)]
	Operating.Year = as.data.frame(Operating.Year)
	
	# Combining all the columns of the F860 datafile
	if(as.numeric(year)<2014){
	f860_new = cbind(Utility.ID, Utility.Name, Plant.Code, Plant.Name, Energy.Source.1, Prime.Mover, Nameplate.Capacity, Operating.Year)
	f860_new = as.data.frame(f860_new)
	f860_new = merge(x=f860_new, y=Technology_temp, by=c("Prime.Mover","Energy.Source.1"))
	}else{
	  f860_new = cbind(Utility.ID, Utility.Name, Technology,Plant.Code, Plant.Name, Energy.Source.1, Prime.Mover, Nameplate.Capacity, Operating.Year)
	  f860_new = as.data.frame(f860_new)
	  
	}
	
	f860_new$Utility.ID = as.character(f860_new$Utility.ID)
	f860_new$Plant.Code = as.character(f860_new$Plant.Code)
	f860_new$Prime.Mover = as.character(f860_new$Prime.Mover)
	f860_new$Energy.Source.1 = as.character(f860_new$Energy.Source.1)
	f860_new$Technology = as.character(f860_new$Technology)
	f860_new$Operating.Year = as.numeric(as.character(f860_new$Operating.Year))
	f860_new$Nameplate.Capacity = as.numeric(gsub(",", "",as.character(f860_new$Nameplate.Capacity)))
	
	# Utitlity name and Plant name identification
	Utility.ID.and.Name = f860_new[c("Utility.ID","Utility.Name")]
	Utility.ID.and.Name = unique(Utility.ID.and.Name)
	
	Plant.Code.and.Name = f860_new[c("Plant.Code","Plant.Name")]
	Plant.Code.and.Name = unique(Plant.Code.and.Name)
	
	# Aggregate of Nameplate Capacity
	Nameplate.Capacity.aggregate = as.data.frame(aggregate(x=f860_new$Nameplate.Capacity, by=list(f860_new$Utility.ID, f860_new$Plant.Code, f860_new$Technology, f860_new$Prime.Mover, f860_new$Energy.Source.1), FUN=sum))
	names(Nameplate.Capacity.aggregate) = c("Utility.ID","Plant.Code","Technology","Prime.Mover","Energy.Source.1","Nameplate.Capacity")
	
	# Aggregates of operating year
	Operating.Year.aggregates = as.data.frame(aggregate(x=f860_new$Operating.Year, by=list(f860_new$Utility.ID, f860_new$Plant.Code, f860_new$Technology, f860_new$Prime.Mover, f860_new$Energy.Source.1), FUN=function(x) c(avg=mean(x), max=max(x), min=min(x))))
	Operating.Year.aggregates = as.data.frame(cbind(Operating.Year.aggregates[c('Group.1', 'Group.2', 'Group.3', 'Group.4', 'Group.5')], as.data.frame(as.matrix(Operating.Year.aggregates$x))))  
	names(Operating.Year.aggregates)
	names(Operating.Year.aggregates) = c("Utility.ID","Plant.Code","Technology","Prime.Mover","Energy.Source.1","Average.Operating.Year","Min.Operating.Year","Max.Operating.Year")
	
	# Merged F860 data
	f860_merged = merge(x = Nameplate.Capacity.aggregate, y = Operating.Year.aggregates, by=c("Utility.ID","Plant.Code","Technology","Prime.Mover","Energy.Source.1"))
	f860_merged = merge(x = f860_merged, y = Utility.ID.and.Name, by = "Utility.ID")
	f860_merged = merge(x = f860_merged, y = Plant.Code.and.Name, by = "Plant.Code")
	

	## Getting the required columns from f923
	
	
	# Operator ID
	Operator.ID= f923[,grep("oper.*id|oper.*code", names(f923), ignore.case=TRUE)]
	Operator.ID = as.data.frame(Operator.ID)
	
	
	# Obtaining Plant ID
	Plant.Code=f923[,grep('plnt.*id|plant.*code|plant.*id|id.*plnt|code.*plant|id.*plant',names(f923),ignore.case = TRUE)]
	Plant.Code=as.data.frame(Plant.Code)
	
	# Obtaining Plant Name
	Plant.Name = f923[,grep("plant.*name|name.*plant|plnt.*name|name.*plnt|plnt.*name|name.*plnt", names(f923), ignore.case=TRUE)]
	Plant.Name=as.data.frame(Plant.Name)
	
	# Obtaining Net Generation MWh
	Net.Generation.MWh = f923[,grep("net.*gen.*m.*w.*h", names(f923), ignore.case=TRUE)]
	Net.Generation.MWh = as.data.frame(Net.Generation.MWh)
	  
	# Obtaining Electric Fuel Consumption MMBtu
	Electric.Fuel.Consumption.MMBtu = f923[,grep("elec.*fuel.*mmbtu", names(f923), ignore.case=TRUE)]
	Electric.Fuel.Consumption.MMBtu=as.data.frame(Electric.Fuel.Consumption.MMBtu)
	
	
	# Prime mover
	col.prime.mover = grep("prime.*mover", names(f923), ignore.case=TRUE)
	Reported.Prime.Mover = f923[,col.prime.mover]
	Reported.Prime.Mover = as.data.frame(Reported.Prime.Mover)
	
	# Obtaining Fuel Type Code
	col.fuel.type = grep("rep.*fuel", names(f923), ignore.case=TRUE)
	Reported.Fuel.Type.Code = f923[,col.fuel.type]
	Reported.Fuel.Type.Code = as.data.frame(Reported.Fuel.Type.Code)
	
	# Combining all the columns of the F923 datafile
	f923_new = cbind(Operator.ID, Plant.Code, Plant.Name, Reported.Prime.Mover, Reported.Fuel.Type.Code, Net.Generation.MWh, Electric.Fuel.Consumption.MMBtu)
	f923_new$Operator.ID = as.character(f923_new$Operator.ID)
	f923_new$Plant.Code = as.character(f923_new$Plant.Code)
	f923_new$Reported.Prime.Mover = as.character(f923_new$Reported.Prime.Mover)
	f923_new$Reported.Fuel.Type.Code = as.character(f923_new$Reported.Fuel.Type.Code)
	f923_new$Net.Generation.MWh = as.numeric(gsub(",", "", as.character(f923_new$Net.Generation.MWh)))
	f923_new$Electric.Fuel.Consumption.MMBtu = as.numeric(gsub(",", "",as.character(f923_new$Electric.Fuel.Consumption.MMBtu)))
	
	f923_new_unique = unique(f923_new)
	
	#f923_dup = f923_new[duplicated(f923_new[c("Plant.Code","Operator.ID","Reported.Fuel.Type.Code","Reported.Prime.Mover")]),]
	#dim(f923_dup)
	
	# Aggregate of Net Generation MWh
	Net.Generation.MWh.aggregate = as.data.frame(aggregate(x=f923_new$Net.Generation.MWh, by=list(f923_new$Plant.Code, f923_new$Operator.ID, f923_new$Reported.Prime.Mover, f923_new$Reported.Fuel.Type.Code), FUN=sum))
	names(Net.Generation.MWh.aggregate) = c("Plant.Code","Operator.ID", "Reported.Prime.Mover", "Reported.Fuel.Type.Code", "Net.Generation.MWh")
	
	# Aggregate of Fuel Consumption MMBtu
	Electric.Fuel.Consumption.MMBtu.aggregate = as.data.frame(aggregate(x=f923_new$Electric.Fuel.Consumption.MMBtu, by=list(f923_new$Operator.ID, f923_new$Plant.Code, f923_new$Reported.Prime.Mover, f923_new$Reported.Fuel.Type.Code), FUN=sum))
	names(Electric.Fuel.Consumption.MMBtu.aggregate) = c("Operator.ID","Plant.Code", "Reported.Prime.Mover", "Reported.Fuel.Type.Code", "Electric.Fuel.Consumption.MMBtu")
	
	# Merged F923 data
	f923_merged = merge(x = Net.Generation.MWh.aggregate, y = Electric.Fuel.Consumption.MMBtu.aggregate, by=c("Operator.ID","Plant.Code","Reported.Prime.Mover","Reported.Fuel.Type.Code"))
	
	# =====================================================================================================
	# Calculating Capacity factor and Heat Rate
	file_merged = merge(x=f860_merged, y=f923_merged, by.x = c("Utility.ID","Plant.Code","Prime.Mover","Energy.Source.1"), by.y = c("Operator.ID","Plant.Code", "Reported.Prime.Mover", "Reported.Fuel.Type.Code"))
	file_merged$Capacity.Factor = (file_merged$Net.Generation.MWh) / (file_merged$Nameplate.Capacity*8760)
	file_merged$Heat.Rate = (file_merged$Electric.Fuel.Consumption.MMBtu*1000)/(file_merged$Net.Generation.MWh)
	file_merged$Year = year
	
	
	file_merged_final = file_merged[c("Utility.ID", "Utility.Name", "Plant.Code", "Technology", "Plant.Name", "Energy.Source.1", "Prime.Mover", "Nameplate.Capacity", "Average.Operating.Year", "Min.Operating.Year", "Max.Operating.Year", "Net.Generation.MWh", "Electric.Fuel.Consumption.MMBtu", "Capacity.Factor", "Heat.Rate", "Year")]
	
	
	Nameplate.Capacity.Final = sum(file_merged_final[!is.na(file_merged_final$Nameplate.Capacity),]$Nameplate.Capacity)
	Nameplate.Capacity.Initial = sum(f860_new[!is.na(f860_new$Nameplate.Capacity),]$Nameplate.Capacity)
	nameplate_capacity= round(Nameplate.Capacity.Final*100/Nameplate.Capacity.Initial, 2)
	
	Net.Generation.Final = sum(file_merged_final[!is.na(file_merged_final$Net.Generation.MWh),]$Net.Generation.MWh)
	Net.Generation.Initial = sum(f923_new[!is.na(f923_new$Net.Generation.MWh),]$Net.Generation.MWh)
	netgeneration= round(Net.Generation.Final*100/Net.Generation.Initial, 2)
	
	## Functions to print these values to the console
	print(paste("Nameplate.Capacity in the final dataset:",nameplate_capacity,"%",sep=''))
	print(paste("Net.Generation.MWh in the final dataset:",netgeneration,"%",sep=''))

	## Saving the final merged data in csv file
	write.csv(x=file_merged_final,file=paste('VARANASI_AKSHAY_EIA_',year,'_DATA.csv',sep=''),row.names=F)


}