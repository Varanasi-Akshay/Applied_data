
PINNAMARAJU_ROHITH_HWK2_EIA <- function(year){

    # Reading the F860 datafile
    path_F860 = paste("ME397_A2_data/F860_", year, ".csv", sep = "")
    data_F860 = read.csv(path_F860, fileEncoding = "UTF-8-BOM")
    
    # -----------------------------------------
    # This preprocessing is used to remove a last row comment if present in the first column of the data
    data_F860[,1][data_F860[,1]==""] <- NA
    data_F860[,2][data_F860[,2]==""] <- NA
    
    l1 = length(na.omit(data_F860[,1]))
    l2 = length(na.omit(data_F860[,2]))
    options(warn=-1)
    data_F860 = data_F860[1:min(l1,l2),]
    # -----------------------------------------
    
    # Obtaining Utility ID
    col.util.id = grep("util.*id|util.*code", names(data_F860), ignore.case=TRUE)
    Utility.ID = data_F860[,col.util.id]
    Utility.ID = as.data.frame(Utility.ID)
    
    # Obtaining Utility Name
    col.util.name = grep("util.*name|name.*util", names(data_F860), ignore.case=TRUE)
    Utility.Name = data_F860[,col.util.name]
    Utility.Name = as.data.frame(Utility.Name)

    # Obtaining Plant ID
    col.plant.code = grep("plant.*id|id.*plant|plant.*code|code.*plant|plnt.*id|id.*plnt|plnt.*code|code.*plnt", names(data_F860), ignore.case=TRUE)
    Plant.Code = data_F860[,col.plant.code]
    Plant.Code = as.data.frame(Plant.Code)
    
    # Obtaining Plant Name
    col.plant.name = grep("plant.*name|name.*plant|plnt.*name|name.*plnt|plnt.*name|name.*plnt", names(data_F860), ignore.case=TRUE)
    Plant.Name = data_F860[,col.plant.name]
    Plant.Name = as.data.frame(Plant.Name)
    
    # Obtaining Energy Source 1
    col.energy.source.1 = grep("energy.*source.*1", names(data_F860), ignore.case=TRUE)
    col.energy.source.1 = col.energy.source.1[grep("planned", colnames(data_F860[,col.energy.source.1]), invert=TRUE, ignore.case = TRUE)]
    Energy.Source.1 = data_F860[,col.energy.source.1]
    Energy.Source.1 = as.data.frame(Energy.Source.1)
    
    # Obtaining Prime Mover
    col.prime.mover = grep("prime.*mover", names(data_F860), ignore.case=TRUE)
    if (length(col.prime.mover) > 1) {
      col.prime.mover = col.prime.mover[grep("planned", colnames(data_F860[,col.prime.mover]), invert=TRUE, ignore.case = TRUE)]
    }
    Prime.Mover = data_F860[,col.prime.mover]
    Prime.Mover = as.data.frame(Prime.Mover)
    
    # Obtaining Nameplate Capacity
    col.nameplate.capacity = grep("nameplate", names(data_F860), ignore.case=TRUE)
#    colnames(data_F860[,col.nameplate.capacity])
    if (length(col.nameplate.capacity) > 1) {
    col.nameplate.capacity = col.nameplate.capacity[grep("planned", colnames(data_F860[,col.nameplate.capacity]), invert=TRUE, ignore.case = TRUE)]
    }
    Nameplate.Capacity = data_F860[,col.nameplate.capacity]
    Nameplate.Capacity = as.data.frame(Nameplate.Capacity)
    
    # Obtaining Operating Year
    col.operating.year = grep("operating.*year", names(data_F860), ignore.case=TRUE)
    Operating.Year = data_F860[,col.operating.year]
    Operating.Year = as.data.frame(Operating.Year)
    
    if (year >2013){
      # Obtaining Technology
      Technology = data_F860$Technology
      Technology = as.data.frame(Technology)
      
      # Combining all the columns of the F860 datafile
      data_F860_new = cbind(Utility.ID, Utility.Name, Technology, Plant.Code, Plant.Name, Energy.Source.1, Prime.Mover, Nameplate.Capacity, Operating.Year)
      data_F860_new = as.data.frame(data_F860_new)
    
    } else{
      # Combining all the columns of the F860 datafile
      data_F860_new = cbind(Utility.ID, Utility.Name, Plant.Code, Plant.Name, Energy.Source.1, Prime.Mover, Nameplate.Capacity, Operating.Year)
      data_F860_new = as.data.frame(data_F860_new)
      
      year_sample = 2016 
      
      # Reading the F860 datafile
      path_F860_sample = paste("ME397_A2_data/F860_", year_sample, ".csv", sep = "")
      data_F860_sample = read.csv(path_F860_sample, fileEncoding = "UTF-8-BOM")
      
      # -----------------------------------------
      # This preprocessing is used to remove a last row comment if present in the first column of the data
      data_F860_sample[,1][data_F860_sample[,1]==""] <- NA
      data_F860_sample[,2][data_F860_sample[,2]==""] <- NA
      
      l1 = length(na.omit(data_F860_sample[,1]))
      l2 = length(na.omit(data_F860_sample[,2]))
      
      data_F860_sample = data_F860_sample[1:min(l1,l2),]
      # -----------------------------------------
      
      # Obtaining Technology
      Technology = data_F860_sample$Technology
      Technology = as.data.frame(Technology)
      
      # Obtaining Energy Source 1
      col.energy.source.1_sample = grep("energy.*source.*1", names(data_F860_sample), ignore.case=TRUE)
      col.energy.source.1_sample = col.energy.source.1_sample[grep("planned", colnames(data_F860_sample[,col.energy.source.1_sample]), invert=TRUE, ignore.case = TRUE)]
      Energy.Source.1_sample = data_F860_sample[,col.energy.source.1_sample]
      Energy.Source.1_sample = as.data.frame(Energy.Source.1_sample)
      
      # Obtaining Prime Mover
      col.prime.mover_sample = grep("prime.*mover", names(data_F860_sample), ignore.case=TRUE)
      col.prime.mover_sample = col.prime.mover_sample[grep("planned", colnames(data_F860_sample[,col.prime.mover_sample]), invert=TRUE, ignore.case = TRUE)]
      Prime.Mover_sample = data_F860_sample[,col.prime.mover_sample]
      Prime.Mover_sample = as.data.frame(Prime.Mover_sample)
      
      # Creating a dataframe of the 3 columns
      data_F860_new_sample = as.data.frame(cbind(Technology, Energy.Source.1_sample, Prime.Mover_sample))
      data_F860_new_sample$Technology = as.character(data_F860_new_sample$Technology)
      data_F860_new_sample$Energy.Source.1_sample = as.character(data_F860_new_sample$Energy.Source.1_sample)
      data_F860_new_sample$Prime.Mover_sample = as.character(data_F860_new_sample$Prime.Mover_sample)
      data_F860_new_sample = unique(data_F860_new_sample)
            
      # Appending the technology data to our current dataframe
      data_F860_new = merge(x=data_F860_new, y=data_F860_new_sample, by.x = c("Prime.Mover","Energy.Source.1"), by.y = c("Prime.Mover_sample", "Energy.Source.1_sample"))
      
    }
    
    data_F860_new$Utility.ID = as.character(data_F860_new$Utility.ID)
    data_F860_new$Plant.Code = as.character(data_F860_new$Plant.Code)
    data_F860_new$Prime.Mover = as.character(data_F860_new$Prime.Mover)
    data_F860_new$Energy.Source.1 = as.character(data_F860_new$Energy.Source.1)
    data_F860_new$Technology = as.character(data_F860_new$Technology)
    data_F860_new$Operating.Year = as.numeric(as.character(data_F860_new$Operating.Year))
    data_F860_new$Nameplate.Capacity = as.numeric(gsub(",", "",as.character(data_F860_new$Nameplate.Capacity)))
    
    # Utitlity name and Plant name identification
    Utility.ID.and.Name = data_F860_new[c("Utility.ID","Utility.Name")]
    Utility.ID.and.Name = unique(Utility.ID.and.Name)
    
    Plant.Code.and.Name = data_F860_new[c("Plant.Code","Plant.Name")]
    Plant.Code.and.Name = unique(Plant.Code.and.Name)

    # Aggregate of Nameplate Capacity
    Nameplate.Capacity.aggregate = as.data.frame(aggregate(x=data_F860_new$Nameplate.Capacity, by=list(data_F860_new$Utility.ID, data_F860_new$Plant.Code, data_F860_new$Technology, data_F860_new$Prime.Mover, data_F860_new$Energy.Source.1), FUN=sum))
    names(Nameplate.Capacity.aggregate) = c("Utility.ID","Plant.Code","Technology","Prime.Mover","Energy.Source.1","Nameplate.Capacity")
    
    # Aggregates of operating year
    Operating.Year.aggregates = as.data.frame(aggregate(x=data_F860_new$Operating.Year, by=list(data_F860_new$Utility.ID, data_F860_new$Plant.Code, data_F860_new$Technology, data_F860_new$Prime.Mover, data_F860_new$Energy.Source.1), FUN=function(x) c(avg=mean(x), max=max(x), min=min(x))))
    Operating.Year.aggregates = as.data.frame(cbind(Operating.Year.aggregates[c('Group.1', 'Group.2', 'Group.3', 'Group.4', 'Group.5')], as.data.frame(as.matrix(Operating.Year.aggregates$x))))  
    names(Operating.Year.aggregates) = c("Utility.ID","Plant.Code","Technology","Prime.Mover","Energy.Source.1","Average.Operating.Year","Min.Operating.Year","Max.Operating.Year")
    
    # Merged F860 data
    data_F860_merged = merge(x = Nameplate.Capacity.aggregate, y = Operating.Year.aggregates, by=c("Utility.ID","Plant.Code","Technology","Prime.Mover","Energy.Source.1"))
    data_F860_merged = merge(x = data_F860_merged, y = Utility.ID.and.Name, by = "Utility.ID")
    data_F860_merged = merge(x = data_F860_merged, y = Plant.Code.and.Name, by = "Plant.Code")
    
    # ============================================================================================================    
    # Reading in the F923 data
    path_F923 = paste("ME397_A2_data/F923_", year, ".csv", sep = "")
    data_F923 = read.csv(path_F923, fileEncoding = "UTF-8-BOM")
    
    # -----------------------------------------
    # This preprocessing is used to remove a last row comment if present in the first column of the data
    data_F923[,1][data_F923[,1]==""] <- NA
    data_F923[,2][data_F923[,2]==""] <- NA
    
    l1 = length(na.omit(data_F923[,1]))
    l2 = length(na.omit(data_F923[,2]))
    
    data_F923 = data_F923[1:min(l1,l2),]
    # -----------------------------------------
    
    # Obtaining Operator ID
    col.oper.id = grep("oper.*id|oper.*code", names(data_F923), ignore.case=TRUE)
    Operator.ID= data_F923[,col.oper.id]
    Operator.ID = as.data.frame(Operator.ID)
    
    # Obtaining Plant ID
    col.plant.code = grep("plant.*id|id.*plant|plant.*code|code.*plant|plnt.*id|id.*plnt|plnt.*code|code.*plnt", names(data_F923), ignore.case=TRUE)
    Plant.Code = data_F923[,col.plant.code]
    Plant.Code = as.data.frame(Plant.Code)
    
    # Obtaining Plant Name
    col.plant.name = grep("plant.*name|name.*plant|plnt.*name|name.*plnt|plnt.*name|name.*plnt", names(data_F923), ignore.case=TRUE)
    Plant.Name = data_F923[,col.plant.name]
    Plant.Name = as.data.frame(Plant.Name)
    
    # Obtaining Operator ID
    col.prime.mover = grep("prime.*mover", names(data_F923), ignore.case=TRUE)
    Reported.Prime.Mover = data_F923[,col.prime.mover]
    Reported.Prime.Mover = as.data.frame(Reported.Prime.Mover)
    
    # Obtaining Fuel Type Code
    col.fuel.type = grep("rep.*fuel", names(data_F923), ignore.case=TRUE)
    Reported.Fuel.Type.Code = data_F923[,col.fuel.type]
    Reported.Fuel.Type.Code = as.data.frame(Reported.Fuel.Type.Code)
    
    # Obtaining Net Generation MWh
    col.net.generation = grep("net.*gen.*m.*w.*h", names(data_F923), ignore.case=TRUE)
    Net.Generation.MWh = data_F923[,col.net.generation]
    Net.Generation.MWh = as.data.frame(Net.Generation.MWh)
    
    # Obtaining Electric Fuel Consumption MMBtu
    col.elec.fuel.consump = grep("elec.*fuel.*mmbtu", names(data_F923), ignore.case=TRUE)
    Electric.Fuel.Consumption.MMBtu = data_F923[,col.elec.fuel.consump]
    Electric.Fuel.Consumption.MMBtu = as.data.frame(Electric.Fuel.Consumption.MMBtu)
    
    # Combining all the columns of the F923 datafile
    data_F923_new = cbind(Operator.ID, Plant.Code, Plant.Name, Reported.Prime.Mover, Reported.Fuel.Type.Code, Net.Generation.MWh, Electric.Fuel.Consumption.MMBtu)
    data_F923_new$Operator.ID = as.character(data_F923_new$Operator.ID)
    data_F923_new$Plant.Code = as.character(data_F923_new$Plant.Code)
    data_F923_new$Reported.Prime.Mover = as.character(data_F923_new$Reported.Prime.Mover)
    data_F923_new$Reported.Fuel.Type.Code = as.character(data_F923_new$Reported.Fuel.Type.Code)
    data_F923_new$Net.Generation.MWh = as.numeric(gsub(",", "", as.character(data_F923_new$Net.Generation.MWh)))
    data_F923_new$Electric.Fuel.Consumption.MMBtu = as.numeric(as.character(data_F923_new$Electric.Fuel.Consumption.MMBtu))
    
    data_F923_new_unique = unique(data_F923_new)
    
    #f923_dup = data_F923_new[duplicated(data_F923_new[c("Plant.Code","Operator.ID","Reported.Fuel.Type.Code","Reported.Prime.Mover")]),]
    #dim(f923_dup)
    
    # Aggregate of Net Generation MWh
    Net.Generation.MWh.aggregate = as.data.frame(aggregate(x=data_F923_new$Net.Generation.MWh, by=list(data_F923_new$Plant.Code, data_F923_new$Operator.ID, data_F923_new$Reported.Prime.Mover, data_F923_new$Reported.Fuel.Type.Code), FUN=sum))
    names(Net.Generation.MWh.aggregate) = c("Plant.Code","Operator.ID", "Reported.Prime.Mover", "Reported.Fuel.Type.Code", "Net.Generation.MWh")
    
    # Aggregate of Fuel Consumption MMBtu
    Electric.Fuel.Consumption.MMBtu.aggregate = as.data.frame(aggregate(x=data_F923_new$Electric.Fuel.Consumption.MMBtu, by=list(data_F923_new$Operator.ID, data_F923_new$Plant.Code, data_F923_new$Reported.Prime.Mover, data_F923_new$Reported.Fuel.Type.Code), FUN=sum))
    names(Electric.Fuel.Consumption.MMBtu.aggregate) = c("Operator.ID","Plant.Code", "Reported.Prime.Mover", "Reported.Fuel.Type.Code", "Electric.Fuel.Consumption.MMBtu")
    
    # Merged F923 data
    data_F923_merged = merge(x = Net.Generation.MWh.aggregate, y = Electric.Fuel.Consumption.MMBtu.aggregate, by=c("Operator.ID","Plant.Code","Reported.Prime.Mover","Reported.Fuel.Type.Code"))

    # =====================================================================================================
    # Calculating Capacity factor and Heat Rate
    data_total_merged = merge(x=data_F860_merged, y=data_F923_merged, by.x = c("Utility.ID","Plant.Code","Prime.Mover","Energy.Source.1"), by.y = c("Operator.ID","Plant.Code", "Reported.Prime.Mover", "Reported.Fuel.Type.Code"))
    data_total_merged$Capacity.Factor = (data_total_merged$Net.Generation.MWh) / (data_total_merged$Nameplate.Capacity*8760)
    data_total_merged$Heat.Rate = (data_total_merged$Electric.Fuel.Consumption.MMBtu*1000)/(data_total_merged$Net.Generation.MWh)
    data_total_merged$Year = year
    
    
    data_total_merged_final = data_total_merged[c("Utility.ID", "Utility.Name", "Plant.Code", "Technology", "Plant.Name", "Energy.Source.1", "Prime.Mover", "Nameplate.Capacity", "Average.Operating.Year", "Min.Operating.Year", "Max.Operating.Year", "Net.Generation.MWh", "Electric.Fuel.Consumption.MMBtu", "Capacity.Factor", "Heat.Rate", "Year")]

    output_filename = paste("PINNAMARAJU_ROHITH_EIA_", year,"_DATA.csv", sep="")
    write.csv(data_total_merged_final, output_filename)
    
    # Print the required outputs
    Sum.Nameplate.Capacity.Final = sum(data_total_merged_final[!is.na(data_total_merged_final$Nameplate.Capacity),]$Nameplate.Capacity)
    Sum.Nameplate.Capacity.Initial = sum(data_F860_new[!is.na(data_F860_new$Nameplate.Capacity),]$Nameplate.Capacity)
    output1 = round(Sum.Nameplate.Capacity.Final*100/Sum.Nameplate.Capacity.Initial, 2)

    Sum.Net.Generation.Final = sum(data_total_merged_final[!is.na(data_total_merged_final$Net.Generation.MWh),]$Net.Generation.MWh)
    Sum.Net.Generation.Initial = sum(data_F923_new[!is.na(data_F923_new$Net.Generation.MWh),]$Net.Generation.MWh)
    output2 = round(Sum.Net.Generation.Final*100/Sum.Net.Generation.Initial, 2)
    
    print(paste("Nameplate.Capacity in the final dataset: ", output1, "%", sep=''))
    print(paste("Net.Generation.MWh in the final dataset: ", output2, "%", sep=''))

  } # End function  

