
---- Table 1 should be named “LASTNAME_FIRSTNAME_EIA_PP” and should contain
---- the data found in the CSV file “RHODES_JOSHUA_EIA_2016_data.csv”

-- CREATE TABLE VARANASI_AKSHAY_EIA_PP(

-- 	Utility_ID int,
-- 	Plant_Code int,
-- 	Prime_Mover text,
-- 	Energy_Source_1 text,
-- 	Utility_Name text,
-- 	Technology text,
-- 	Plant_Name text,
-- 	Nameplate_Capacity numeric,
-- 	Operating_Year_avg numeric,
-- 	Operating_Year_max numeric,
-- 	Operating_Year_min numeric,
-- 	NERC_Region	text,
-- 	Net_Generation_MWh integer,
-- 	Elec_Fuel_Consumption_MMBtu integer,
-- 	Capacity_Factor numeric,
-- 	Heat_Rate numeric,
-- 	Year integer

-- );

---- Using import option imported the CSV file “RHODES_JOSHUA_EIA_2016_data.csv” after cleaning the csv and creating the table


---- 1.2 Table 2 should be named “LASTNAME_FIRSTNAME_EIA_LOC” and should
----contain the data found in the CSV file “EIA_F860M_LL.csv”


-- CREATE TABLE VARANASI_AKSHAY_EIA_LOC(

-- 	Plant_ID int,
-- 	Latitude numeric,
-- 	Longitude numeric,
-- 	Balancing_Authority_Code text

-- );

---- Using import option imported the CSV file “EIA_F860M_LL.csv” after creating the table


---- Granting the access to those tables created before

GRANT SELECT ON public.VARANASI_AKSHAY_EIA_PP TO joshdr;
GRANT SELECT ON public.VARANASI_AKSHAY_EIA_PP TO whiphi92;

GRANT SELECT ON public.VARANASI_AKSHAY_EIA_LOC TO joshdr;
GRANT SELECT ON public.VARANASI_AKSHAY_EIA_LOC TO whiphi92;

---- Merging the databases based on plant code in table1=plant id in table2


select
	Plant_ID,
	Technology,
	Nameplate_Capacity,
	Latitude,
	Longitude
	
from 
	public.VARANASI_AKSHAY_EIA_PP table1,
	public.VARANASI_AKSHAY_EIA_LOC table2

where table1.Plant_Code = table2.Plant_ID
