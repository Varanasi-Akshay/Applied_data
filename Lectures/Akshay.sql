SELECT version();

-- select * from public.webber_solar_lab
-- -- how to comment
-- limit 10

-- -- Selecting rows between that timeframe
-- select * from public.webber_solar_lab

-- where timestamp_utc between '2014-05-01 00:00:00' and '2014-05-01 00:05:00'

-- -- Selecting row between that timeframe and with the condition gh_rad_avg > 670 
-- select * from public.webber_solar_lab

-- where timestamp_utc between '2014-05-01 00:00:00' and '2014-05-01 00:15:00'

-- and gh_rad_avg > 670 

-- -- Selecting only these columns and these rows
-- select timestamp_utc, gh_rad_avg, out_temp_avg 

-- from public.webber_solar_lab

-- where timestamp_utc between '2014-05-01 00:00:00' and '2014-05-01 00:15:00'

-- -- aggregate columns on date in database
-- select 
-- 	date_trunc('hour', timestamp_utc) as time_local, -- Truncating the date 2018-09-25 22:15:07->22:00:00
-- 	avg(gh_rad_avg) as gh_avg, 
-- 	round(avg(out_temp_avg), 2) as temp_avg,
-- 	max(gh_rad_avg) as gh_max,
-- 	max(out_temp_avg) as temp_max

-- from public.webber_solar_lab

-- where timestamp_utc between '2014-08-01 00:00:00' and '2014-08-02 00:00:00'

-- -- whenever you do aggregation then you must always tell you want to group by this
-- group by time_local
-- -- you don't need to order in large database as it might take some time
-- order by time_local

-- --query and merge two databases 
-- select
-- 	date_trunc('hour', ercot_spp_table.timestamp_ercot) as time_ercot,
-- 	date_trunc('hour', webber_solar_lab.timestamp_utc) as time_webber,
-- 	round(avg(ercot_spp_table.hb_busavg), 2) as ercot_price,
-- 	round(avg(webber_solar_lab.gh_rad_avg), 2) as gh_avg
	
-- from
-- 	public.ercot_spp_table,
-- 	public.webber_solar_lab
	
-- where
-- 	ercot_spp_table.timestamp_ercot BETWEEN '2014-06-01 00:00:00' and '2014-08-31 23:59:59'

-- and
-- 	date_trunc('hour', ercot_spp_table.timestamp_ercot) = date_trunc('hour', webber_solar_lab.timestamp_utc)
	
-- and 	
-- 	ercot_spp_table.hb_busavg > 100
	
-- and 
-- 	webber_solar_lab.gh_rad_avg > 200
	
-- group by 1, 2
-- order by 1, 2

-- CREATE TABLE varanasi_first_table(
-- 	-- column_name type_of_column
-- 	timestamp_cst timestamp without time zone, 
-- 	hour text,
-- 	number_hour numeric

-- );

-- %%%% ADD csv file using provided data file

select * from public.varanasi_first_table

--- Import the data from csv file by selecting the table

-- %%%%%% delete a table

-- DROP table public.varanasi_first_table