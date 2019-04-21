GRANT SELECT ON public.webber_solar_lab TO joshdr;


%%%%Which version of PS am I running?

SELECT version();



%%%%% how to start to query a database (* = all columns)

select * from public.webber_solar_lab
-- how to comment
limit 10



%%%%% query a database selectively

select * from public.webber_solar_lab

where timestamp_utc between '2014-05-01 00:00:00' and '2014-05-01 00:05:00'



%%%%%% query a database more selectively


select * from public.webber_solar_lab

where timestamp_utc between '2014-05-01 00:00:00' and '2014-05-01 00:15:00'

and gh_rad_avg > 670 


%%%%%% query just a few columns in a database 

select timestamp_utc, gh_rad_avg, out_temp_avg 

from public.webber_solar_lab

where timestamp_utc between '2014-05-01 00:00:00' and '2014-05-01 00:15:00'



%%%%%% aggregate columns on date in database

select 
	date_trunc('hour', timestamp_utc) as time_local, 
	avg(gh_rad_avg) as gh_avg, 
	round(avg(out_temp_avg), 2) as temp_avg,
	max(gh_rad_avg) as gh_max,
	max(out_temp_avg) as temp_max

from public.webber_solar_lab

where timestamp_utc between '2014-08-01 00:00:00' and '2014-08-02 00:00:00'

group by time_local
order by time_local




%%%%%% query and merge two databases 

select
	date_trunc('hour', ercot_spp_table.timestamp_ercot) as time_ercot,
	date_trunc('hour', webber_solar_lab.timestamp_utc) as time_ercot,
	round(avg(ercot_spp_table.hb_busavg), 2) as ercot_price,
	round(avg(webber_solar_lab.gh_rad_avg), 2) as gh_avg
	
from
	public.ercot_spp_table,
	public.webber_solar_lab
	
where
	ercot_spp_table.timestamp_ercot BETWEEN '2014-06-01 00:00:00' and '2014-08-31 23:59:59'

and
	date_trunc('hour', ercot_spp_table.timestamp_ercot) = date_trunc('hour', webber_solar_lab.timestamp_utc)
	
and 	
	ercot_spp_table.hb_busavg > 100
	
and 
	webber_solar_lab.gh_rad_avg > 200
	
group by 1, 2
order by 1, 2






%%%%% Create a table

CREATE TABLE rhodes_first_table(
	-- column_name type_of_column
	timestamp_cst timestamp without time zone, 
	hour text,
	number_hour numeric

);

%%%% ADD csv file using provided data file

select * from public.rhodes_first_table



%%%%%% delete a table

DROP table public.rhodes_first_table