----which channel was the most sales in each of the companies------
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


---------Q2. For each of the channel which day of the week is more sales made---------

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