%%%%% check cores on machines %%%%%

library(parallel)
detectCores(all.tests = FALSE, logical = TRUE)







%%%%% Create a table

CREATE TABLE EIA_DATA_TABLE_RHODES(


	Utility_ID int,
	Plant_Code int,
	Prime_Mover text,
	Energy_Source_1 text,
	Utility_Name text,
	Technology text,
	Plant_Name text,
	Nameplate_Capacity numeric,
	Operating_Year_avg numeric,
	Operating_Year_max numeric,
	Operating_Year_min numeric,
	NERC_Region	text,
	Net_Generation_MWh integer,
	Elec_Fuel_Consumption_MMBtu integer,
	Capacity_Factor numeric,
	Heat_Rate numeric,
	Year integer

);

%%%%% IMPORT data using pgADMIN4 -> IMPORT



%%%%% Need to clean data  first

eia <- read.csv('RHODES_JOSHUA_EIA_2016_data.csv', stringsAsFactors = F)
summary(eia)

eia$Heat.Rate[is.na(eia$Heat.Rate)] <- -9999999999
eia$Heat.Rate[is.infinite(eia$Heat.Rate)] <- -9999999999

summary(eia)
write.csv(eia, 'cleaned_eia.csv', row.names = F)











%%%%%%%%%%%%%%%%%%% query to get info from two tables restricting to rows that appear in both tables

select
	e07.utility_id,
	e07.plant_code,
	e07.prime_mover,
	e07.energy_source_1,
	e16.utility_id,
	e16.plant_code,
	e16.prime_mover,
	e16.energy_source_1,
	round(e07.capacity_factor, 2) as cf_07,
	round(e16.capacity_factor, 2) as cf_16
	
from
	public.e07,
	public.e16
	
where
	e07.utility_id = e16.utility_id
and
	e07.plant_code = e16.plant_code
and
	e07.prime_mover = e16.prime_mover
and
	e07.energy_source_1 = e16.energy_source_1



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% query to merge two tables sum and average values

select
	t1.technology, 
	cf07, 
	energy07, 
	cf16, 
	energy16

from 
    
    (select 
    	technology, 
    	avg(capacity_factor) as cf07, 
    	sum(net_generation_mwh) as energy07 

    from 
    	public.e07 
    group by 1) t1, -- that comma is important!


    (select 
    	technology, 
    	avg(capacity_factor) AS cf16, 
    	sum(net_generation_mwh) AS energy16 

    from 
    	public.e16 
    group by 1) t2

where
	t1.technology = t2.technology











