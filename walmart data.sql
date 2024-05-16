create database salesDataWalmart;
use salesDataWalmart;

create table WalmartSalesData(Invoice_id varchar(30) not null primary key,
Branch varchar(5) not null,
City varchar(30) not null,
Customer_type varchar(30) not null,
Gender varchar(10) not null,
Product_line varchar(100) not null,
Unit_price decimal(10,2) not null,
Quantity int not null,
Tax float(6,4)	not null,
Total	decimal(12,4) not null,
time Time not null,
cogs decimal(10,2) not null,
gross_margin_percentage float(11,9),
gross_income decimal(12,4) not null,
Rating float(2,1));

alter table WalmartSalesData add date DateTime not null;
alter table WalmartSalesData add payment_method varchar(15) not null;


##Time_ofday
select time,
(case 
when 'time' between "00:00:00" and "12:00:00" THEN  "MORNING"
when 'time' between "12:01:00" and "16:00:00" THEN  "AFTERNOON"
else "EVENING"
end) as time_of_date from walmartsalesdata;

alter table walmartsalesdata add time_of_day varchar(20);
update walmartsalesdata set 
time_of_day=(case 
when 'time' between "00:00:00" and "12:00:00" THEN  "MORNING"
when 'time' between "12:01:00" and "16:00:00" THEN  "AFTERNOON"
else "EVENING"
end);

#Day_Name
select date,dayname(date)  as day_name from  walmartsalesdata;
alter table walmartsalesdata add day_name  varchar(20);
update walmartsalesdata set day_name=dayname(date);

##Month Name
select time,monthname(date) as month_name from walmartsalesdata;
alter table walmartsalesdata add month_name varchar(20);
update walmartsalesdata set month_name=monthname(date);


#1.How many unique cities does the data have?
select distinct(City) from walmartsalesdata;

#2.In which city is each branch?
select distinct(branch),city from walmartsalesdata;

#3.How many unique productlines does the data have?
select count(distinct(product_line))
from walmartsalesdata;

#4.What is the most common payment method?
select payment_method ,
count(payment_method) as count from walmartsalesdata group by payment_method order by count desc;

#5.What is the most selling product line?
select product_line ,
count(product_line) as count from walmartsalesdata group by product_line order by count desc;

#6.What is the total revenue by month?
select month_name,round(sum((unit_price*quantity)),0)  as revenue from walmartsalesdata group by month_name
 order by revenue desc;
 
#7.What month had the largest COGS?
 SELECT month_name,sum(cogs) as cogs from walmartsalesdata group by month_name
 order by cogs desc limit 1;
 
 #8.What product line had the largest revenue?
 select product_line,round(sum((unit_price*quantity)),0)  as revenue from walmartsalesdata group by product_line
 order by revenue desc;
 
 #9.What is the city with the largest revenue?
 select city,round(sum((unit_price*quantity)),0)  as revenue from walmartsalesdata group by city
 order by revenue desc;
 
 #10.What productline had the largest VAt ?
 select product_line,round(avg((tax)),2)  as VAT from walmartsalesdata group by product_line
 order by VAT desc;
 
 
 ##11.Fetch each product and add a column to those productline showing "Good","Bad","Good " if its greater than average sales?
 select avg(unit_price* quantity ) as Total_Sales from
 (select product_line,(unit_price* quantity ) as sales,
 (case
 when  Sales >Total_Sales then "good"
else "bad"
end)) as cc from walmartsalesdata;



#12.Which branch sold more products than average product sold?
select branch,sum(quantity) as qty
from  walmartsalesdata group by branch having sum(quantity)>(select avg(quantity) from  walmartsalesdata);


#13.what is the most common product line by gender?
select gender,product_line,count(gender) as ttl_cnt
 from  walmartsalesdata group by gender,product_line
 order by ttl_cnt desc;
 
 /
 
 #14.wHAT IS THE AVERAGE RATING OF EACH PRODUCT LINE?
 SELECT ROUND(AVG(RATING),2) AS AVG_RATING,
 PRODUCT_LINE from  walmartsalesdata 
 GROUP BY PRODUCT_LINE order by AVG_RATING DESC;
 
 
 ##15.No. of sales made in each time of the day per weekend?
 select time_of_day,count(*) as TotalSales
 from  walmartsalesdata group by time_of_day order by TotalSales desc;
 
 
 #16.Which of the customer type brings more revenue?
 select Customer_type,round(sum((unit_price*quantity)),0)  as revenue from walmartsalesdata
 group by customer_type order by revenue desc;
 
 
 #17.Which city has the largest Vat?
 select city, round(avg(tax),2) as VAT from walmartsalesdata
 group by city order by Vat desc;
 
 #18.Which customer type pays the most in VAt
 select Customer_type,round(avg(tax),2) as VAT from walmartsalesdata
 group by customer_type order by Vat desc;
 
 
 ##19.How many unique customer types does the data have?
 select distinct(customer_type)from walmartsalesdata;
 
 ##20.How many unique payment methods does the data have?
 select distinct(payment_method)from walmartsalesdata;
 
##21.Which customer type buys the most?
select customer_type,count(*) as customer_count from walmartsalesdata  group by customer_type order by customer_count desc;

##22.What is gender of most of the customers?
select gender,count(*) as gender_count from walmartsalesdata  group by gender order by gender_count desc;


##23.Which day of the week has the best avg ratings?
select day_name, round(avg(rating),2) as avg_rating from walmartsalesdata group by day_name
order by avg_rating desc;

##24.Which day of the week has the best average ratings per branch?
select  day_name, round(avg(rating),2) as avg_rating  from walmartsalesdata where branch ="a"  group by day_name
order by avg_rating desc;