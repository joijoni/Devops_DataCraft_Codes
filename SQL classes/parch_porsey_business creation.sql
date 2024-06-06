----Creating a new schema and new tables in the schema and importing
create table "parch_porsey_business".orders(
"id" numeric,
	"account_id" numeric,
	"occured_at" date,
	"standard_qty" numeric,
	"gloss_qty" numeric,
	"poster_qty" numeric,
	"total" numeric,
	"standard_amt_usd" numeric,
	"gloss_amt_usd" numeric,
	"poster_amt_usd" numeric,
	"total_amt_usd" numeric
	);

select *
from "parch_porsey_business".orders;

create table "parch_porsey_business".region(
"id" numeric,
	"name" text
);

create table "parch_porsey_business".sales_rep(
"id" numeric,
	"name" text,
	"region_id" numeric
);

create table "parch_porsey_business".web_events(
"id" numeric,
	"account_id" numeric,
	"occurred_at" date,
	"channel" text
);



----- now lets join tables together using primary keys/foreign keys-----

select *
from "parch_porsey_business".accounts;

select *
from "parch_porsey_business".orders;
-----now lets join both tables together----------
select *
from "parch_porsey_business".accounts as ppa
join "parch_porsey_business".orders as ppo
on ppa.id = ppo.account_id;
---what company made the highest money?----------(we join the tables first den write another select ontop to get company name)
select ppa.name "company_name", ppa.primary_poc "sales_manager",ppo.total_amt_usd "revenue_total"
from "parch_porsey_business".accounts as ppa
join "parch_porsey_business".orders as ppo
on ppa.id = ppo.account_id;

select sum("revenue_total") as "total_revenue","company_name"
from
(select ppa.name "company_name", ppa.primary_poc "sales_manager",ppo.total_amt_usd "revenue_total"
from "parch_porsey_business".accounts as ppa
join "parch_porsey_business".orders as ppo
on ppa.id = ppo.account_id) as "total_revenue"
group by "company_name"
order by "total_revenue" desc;
-------Get the Distinct Channel-----Alao get the channels with the most sales-------------
select distinct ("channel")
from "parch_porsey_business".web_events;

select*
from "parch_porsey_business".orders
-------Get the maximum value/amount for each channel for each company,here we did for only Apple---------
select sum(ppo.total_amt_usd) "total_amount",ppw.channel "sales_channel",ppa.name "coy_name"
from "parch_porsey_business".accounts ppa
join "parch_porsey_business".orders ppo
on ppa.id = ppo.account_id
join "parch_porsey_business".web_events ppw
on ppa.id = ppw.account_id
where ppa.name='Apple'
group by "sales_channel","coy_name"
order by "total_amount" desc;

select*
from "parch_porsey_business".accounts
------For Apple what is the channel with the highest sales -------

select sum(ppo.total_amt_usd) "total_amount",ppw.channel "sales_channel",ppa.name "coy_name"
from "parch_porsey_business".accounts ppa
join "parch_porsey_business".orders ppo
on ppa.id = ppo.account_id
join "parch_porsey_business".web_events ppw
on ppa.id = ppw.account_id
where ppa.name='Apple'
group by "sales_channel","coy_name"
order by "total_amount" desc
limit 1;

----------HOW TO CREATE ANOTHER COLUMN USING CASE WHEN ELSE END STATEMENTS----------------------------------------------------

select *
from "parch_porsey_business".orders


select sum("total_amt_usd") as "sales_amount", "days_of_week"
from
(
select*,
case
when "weekday" = 6 then 'saturday'
when "weekday" = 6 then 'saturday'
when "weekday" = 5 then 'friday'
when "weekday" = 4 then 'thursday'
when "weekday" = 3 then 'wednesday'
when "weekday" = 2 then 'tuesday'
when "weekday" = 1 then 'monday'
else 'sunday'
end as "days_of_week"
from(
select*, DATE_PART('dow',occured_at) AS "weekday"
from "parch_porsey_business".orders) as table_1) as "days"
group by "days_of_week"
order by "sales_amount" desc;

-------HOW TO EXTRACT DAY/DATE  & TIME FROM OCCURED_AT COLUMN--------------------------

select *
from "parch_porsey_business".orders;

select Date_Part('dow', occured_at) as weekday,account_id
from "parch_porsey_business".orders;

select extract(Day from occured_at) as day, account_id
from "parch_porsey_business".orders;

select *,
case
when "weekday" = 6 then 'saturday'
when "weekday" = 5 then 'friday'
when "weekday" = 4 then 'thursday'
when "weekday" = 3 then 'wednesday'
when "weekday" = 2 then 'tuesday'
when "weekday" = 1 then 'monday'
else 'sunday'
end as "weekday_info"
from
(select *, DATE_PART('dow',occured_at)as "weekday"
from "parch_porsey_business".orders)as "weekday";

------Give us the day of the week with the most sales--------

select sum("total_amt_usd") as sales_amount,"weekday_info"
from
(select *,
case
when "weekday" = 6 then 'saturday'
when "weekday" = 5 then 'friday'
when "weekday" = 4 then 'thursday'
when "weekday" = 3 then 'wednesday'
when "weekday" = 2 then 'tuesday'
when "weekday" = 1 then 'monday'
else 'sunday'
end as "weekday_info"
from
(select *, DATE_PART('dow',occured_at)as "weekday"
from "parch_porsey_business".orders)as "weekday") as table_1
group by "weekday_info"
order by "sales_amount" desc;
----Drop table parch_porsey_business.orders;-------

------Joining Tables----------------

select *
from "parch_porsey_business".accounts ppa
join "parch_porsey_business".sales_rep pps
on ppa.sales_rep_id=pps.id;

------find the distinct chanels--------
select distinct("channel")
from "parch_porsey_business".web_events

-----Which company/chanel made the most sales?----

select sum(ppo.total_amt_usd) "total_amount",ppw.channel "sales_channel"
from "parch_porsey_business".accounts ppa
join "parch_porsey_business".orders ppo
on ppa.id = ppo.account_id
join "parch_porsey_business".web_events ppw
on ppa.id = ppw.account_id
where ppa.name = 'Apple'
group by "sales_channel"
order by "total_amount" desc;
------which channel was the most sales in each of the companies-------
----ASSIGNMENT---------
select max(shop_1.total_amount) as "most_amount",shop_1.sales_channel as "channel" , shop_1.coy_name as "comp_name" 
from
(select sum(ppo.total_amt_usd) "total_amount",ppw.channel "sales_channel",ppa.name "coy_name"
from "parch_porsey_business".accounts ppa
join "parch_porsey_business".orders ppo
on ppa.id = ppo.account_id
join "parch_porsey_business".web_events ppw
on ppa.id = ppw.account_id
group by "sales_channel","coy_name"
order by "total_amount" desc) as shop_1
group by "channel","comp_name"
order by "most_amount" desc;
;



select * from table_1 WHERE (coy_name, total_amount) in (select coy_name, max(total_amount), sales_channel from "table_1" group by coy_name)
from
(select sum(ppo.total_amt_usd) "total_amount",ppw.channel "sales_channel",ppa.name "coy_name"
from "parch_porsey_business".accounts ppa
join "parch_porsey_business".orders ppo
on ppa.id = ppo.account_id
join "parch_porsey_business".web_events ppw
on ppa.id = ppw.account_id
group by "sales_channel","coy_name"
order by "total_amount" desc) as "table_1";

select distinct("name")
from "parch_porsey_business".accounts

select *
from "parch_porsey_business".


------Q2. For each of the channel which day of the week is more sales made
select *
from "parch_porsey_business".web_events
select *
from "parch_porsey_business".orders


select sum("total_amt_usd") as sales_amount,"weekday_info","channel"
from
(select *
from "parch_porsey_business".orders ppo
join"parch_porsey_business".web_events ppw
on ppo.account_id = ppw.account_id
from
(select *,
case
when "weekday" = 6 then 'saturday'
when "weekday" = 5 then 'friday'
when "weekday" = 4 then 'thursday'
when "weekday" = 3 then 'wednesday'
when "weekday" = 2 then 'tuesday'
when "weekday" = 1 then 'monday'
else 'sunday'
end as "weekday_info"
from
(select *, DATE_PART('dow',occured_at)as "weekday"
from "parch_porsey_business".orders)as table_1
group by "weekday_info") as table_2
group by "account_id","channels"
order by "sales_amount" desc;
--group by "channels";
--order by 
----Option 2 for same question 2-----
 
 select *
from "parch_porsey_business".orders ppo
join"parch_porsey_business".web_events ppw
on ppo.account_id = ppw.account_id
from
(select sum("total_amt_usd") as sales_amount,"weekday_info"
from
(select *,
case
when "weekday" = 6 then 'saturday'
when "weekday" = 5 then 'friday'
when "weekday" = 4 then 'thursday'
when "weekday" = 3 then 'wednesday'
when "weekday" = 2 then 'tuesday'
when "weekday" = 1 then 'monday'
else 'sunday'
end as "weekday_info"
from
(select *, DATE_PART('dow',occured_at)as "weekday"
from "parch_porsey_business".orders)as "weekday") as table_1
group by "weekday_info"
order by "sales_amount" desc) as table_2
 ;