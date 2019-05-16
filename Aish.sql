--DROP table public.VARANASI_AKSHAY_AISH

-- Create table and then use import to import the csv
--  CREATE TABLE VARANASI_AKSHAY_ORDERS(

--  	ID_Num numeric,
-- 	User_ID numeric,
--  	Total numeric,
--  	created text

--  );
 

-- Create table and then use import to import the csv
--  CREATE TABLE VARANASI_AKSHAY_ORDER_DETAILS(

--  	ID_Num numeric,
-- 	Order_ID numeric,
-- 	Product_ID numeric, 
--  	Quantity numeric,
-- 	Price numeric
	 
--  ); 
 
-- Did not work as i am not the superuser
-- COPY VARANASI_AKSHAY_AISH2 FROM '/home/akshay/Desktop/Applied_data/Q1 (1).csv' WITH CSV HEADER;

-- Merged the two data base based on Id in orders with order id in orders detail.
select
	Order_ID ,
	Product_ID , 
 	Quantity,
	Price,
	Total,
	Total*Quantity as Order_total
from 
	public.VARANASI_AKSHAY_ORDERS table1,
	public.VARANASI_AKSHAY_ORDER_DETAILS table2

where table1.ID_Num = table2.Order_ID

--group by Order_ID, Product_ID