CREATE TABLE "Class_A".my_table
(
    "SALES_ID" numeric,
    "SALES_REP" text,
    "EMAILS" character varying,
    "BRANDS" text,
    "PLANT_COST" numeric,
    "UNIT_PRICE" numeric,
    "QUANTITY" numeric,
    "COST" numeric,
    "PROFIT" numeric,
    "COUNTRIES" text,
    "REGION" text,
    "MONTHS" text,
	"YEARS" numeric
);

SELECT * FROM "Class_A".my_table;

--1. Within the space of the last three years, what was the profit worth of the breweries,
--inclusive of the anglophone and the francophone territories?

select sum("PROFIT") as "profit_sum","YEARS","BRANDS","COUNTRIES"
from "Class_A".my_table
where "BRANDS" not like '%malt'
group by "BRANDS","PROFIT","YEARS","COUNTRIES"
order by "PROFIT" asc;

select sum("PROFIT") as profit_sum,"COUNTRIES"
from "Class_A".my_table
where "COUNTRIES" in ('Ghana','Nigeria')
group by "COUNTRIES"
order by"profit_sum" desc;


select sum("PROFIT") as profit_sum,"COUNTRIES"
from "Class_A".my_table
where "COUNTRIES" not in ('Ghana','Nigeria')
group by "COUNTRIES"
order by"profit_sum" desc;

-----For Francophone Countries----

select sum("profit_sum") as "francophone_sum"
from(
select sum("PROFIT") as profit_sum,"COUNTRIES","YEARS"
from "Class_A".my_table
where "COUNTRIES" not in ('Ghana','Nigeria')
group by "COUNTRIES","YEARS"
order by "profit_sum" desc);

-----Anglophone Countries------------------------
select sum("profit_sum") as "Anglophone_sum_profit"
from (
select sum("PROFIT") as profit_sum,"COUNTRIES","YEARS"
from "Class_A".my_table
where "COUNTRIES" in ('Ghana','Nigeria')
group by "COUNTRIES","YEARS"
order by "profit_sum" desc) as "Anglophone_sum_profit";

-----3. Country that generated the highest profit in 2019----
select sum("PROFIT") as sum_profit,"COUNTRIES"
from "Class_A".my_table
where "YEARS" = 2019
group by "COUNTRIES"
order by sum_profit desc;
----4. Help him find the year with the highest profit.-------
select sum("PROFIT") as profit_highest,"YEARS"
from "Class_A".my_table
group by "YEARS"
order by "profit_highest" desc
limit 1;
---5. Which month in the three years was the least profit generated?-----
select min("PROFIT") as profit_lowest,"MONTHS"
from "Class_A".my_table
group by "MONTHS"
order by "profit_lowest" asc
limit 1;
---5b class answer
select min("PROFIT") as min_profit,"MONTHS"
from "Class_A".my_table
where "YEARS" = 2017
group by "MONTHS"
order by "min_profit" asc
limit 1;

--6. What was the minimum profit in the month of December 2018?-----
select min("PROFIT") as profit_lowest,"MONTHS"
from "Class_A".my_table
where "MONTHS"= 'December' and "YEARS" = 2018
group by "MONTHS"
order by "profit_lowest" asc;

---7. Compare the profit in percentage for each of the month in 2019------
select sum("PROFIT") as profit_lowest,"MONTHS"
from "Class_A".my_table
where "YEARS" = 2019
group by "MONTHS"
order by "profit_lowest" asc;

select sum("PROFIT") as profit_lowest
from "Class_A".my_table
where "YEARS" = 2019;

select (("PROFIT")/sum("PROFIT")) *100 as percentage_profit,"MONTHS"
from "Class_A".my_table
where "YEARS" = 2019
group by "MONTHS"
order by "percentage_profit" asc;

--8. Which particular brand generated the highest profit in Senegal?--
select sum("PROFIT") as profit_lowest,"BRANDS"
from "Class_A".my_table
where "COUNTRIES" = 'Senegal'
group by "BRANDS"
order by "profit_lowest" desc
limit 1;

select sum("PROFIT") as profit_sum,"LANGUAGE_TERRITORY"--,"YEARS"
from
(select *,
CASE
	when "COUNTRIES" in ('Ghana', 'Nigeria')then 'Anglophone'
	else 'Francophone'
end as "LANGUAGE_TERRITORY"
from "Class_A".my_table) as "LANGUAGE_TERRITORY"
where "YEARS"=2017
group by "LANGUAGE_TERRITORY"
order by profit_sum desc;

-----To Segregate the email servers based on their emails-------
select *,
case
	when "EMAILS" like '%gmails%' then 'GMAILSERVER'
	when "EMAILS" like '%uk%' then 'UKMAILSERVER'
else 'YAHOOMAILSERVER'
end as "EMAIL_SERVER_NAME"
from "Class_A".my_table;

----- Now lets combine some parts of the upper statement to make this one longer

select *,
CASE
	when "COUNTRIES" in ('Ghana', 'Nigeria')then 'Anglophone'
	else 'Francophone'
end as "LANGUAGE_TERRITORY"
from
(select *,
case
	when "EMAILS" like '%gmails%' then 'GMAILSERVER'
	when "EMAILS" like '%uk%' then 'UKMAILSERVER'
else 'YAHOOMAILSERVER'
end as "EMAIL_SERVER_NAME"
from "Class_A".my_table) as "Lang";
------SECTION BBBB-------------------------------------
---1. Within the last two years, the brand manager wants to know the top three brands
--consumed in the francophone countries
select distinct("BRANDS") as top_brands 
from(
select sum("PROFIT") as profit_sum,"COUNTRIES","BRANDS"
from "Class_A".my_table
where "COUNTRIES" not in ('Ghana','Nigeria') and "YEARS" in (2018, 2019)
group by "COUNTRIES","BRANDS"
order by "profit_sum" desc);
limit 3;

---2. Find out the top two choice of consumer brands in Ghana-----
select distinct("BRANDS"),"COUNTRIES"
from "Class_A".my_table
where "COUNTRIES" = 'Ghana'
order by "BRANDS" desc
limit 2;

---3 Find out the details of beers consumed in the past three years in the most oil reached
---country in West Africa.

select sum("QUANTITY") as qty,"BRANDS"
from "Class_A".my_table
where "BRANDS" not like '%malt' and "COUNTRIES" in ('Nigeria')
group by "BRANDS"
order by "qty" desc;

---4 Favorites malt brand in Anglophone region between 2018 and 2019--
select distinct ("YEARS") as most_years
from ( select sum("QUANTITY") as qty,"BRANDS","YEARS","COUNTRIES"
from "Class_A".my_table
where "BRANDS" like '%malt' and "COUNTRIES" in ('Ghana','Nigeria') and ("YEARS" between 2018 and 2019)
group by "BRANDS","YEARS","COUNTRIES"
order by "YEARS" desc);

---5. Which brands sold the highest in 2019 in Nigeria?---
select sum("QUANTITY") as qty,"BRANDS"
from "Class_A".my_table
where "YEARS" = 2019 and "COUNTRIES" = 'Nigeria'
group by "BRANDS" 
order by qty desc;

--6. Favorites brand in South_South region in Nigeria--
select sum("QUANTITY")as qty, "BRANDS","REGION"
from "Class_A".my_table
where "REGION" = 'southsouth'
group by "BRANDS","REGION"
order by qty desc
limit 1;

---7 Bear consumption in Nigeria----
select sum("QUANTITY") as qty,"BRANDS"
from "Class_A".my_table
where "BRANDS" not like '%malt' and "COUNTRIES" = 'Nigeria'
group by "BRANDS"
order by qty desc
limit 1;

--8. Level of consumption of Budweiser in the regions in Nigeria--
select *
from "Class_A".my_table

select sum("QUANTITY") as qty,"BRANDS","REGION"
from "Class_A".my_table
where "COUNTRIES" = 'Nigeria'and "BRANDS" = 'budweiser'
group by "BRANDS","REGION"
order by qty desc;

--9. Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)----
select sum("QUANTITY") as qty_level,"BRANDS","REGION","YEARS"
from "Class_A".my_table
where "COUNTRIES" = 'Nigeria'and "BRANDS" = 'budweiser' and "YEARS"=2019
group by "BRANDS","REGION","YEARS"
order by qty_level desc;

-----GIT STUFFS WITH---------COACH-----------------------------

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv/Devops_DataCraft_Codes (main)
$ cd

Josey@DESKTOP-Q00UONJ MINGW64 ~
$ cd Python_projects

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects
$ ls
Devops_DataCraft_Codes/  Project1/

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects
$ cd Projects1
bash: cd: Projects1: No such file or directory

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects
$ Project1
bash: Project1: command not found

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects
$ cd Project1

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1
$ ls
app.ipynb  dataengineering/  devops/  devops_dataengineering/  venv/

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1
$ cd venv

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv
$ ls
Devops_DataCraft_Codes/  Include/  Lib/  Scripts/  app.ipynb  ml_design.ipynb  pyvenv.cfg  share/

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv
$ rmdir Devops_DataCraft_Codes
rmdir: failed to remove 'Devops_DataCraft_Codes': Directory not empty

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv
$ rm -rf Devops_DataCraft_Codes

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv
$ ls
Include/  Lib/  Scripts/  app.ipynb  ml_design.ipynb  pyvenv.cfg  share/

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv
$ git clone https://github.com/joijoni/Devops_DataCraft_Codes.git
Cloning into 'Devops_DataCraft_Codes'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (3/3), done.

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv
$ cd Devops_DataCraft_Codes

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv/Devops_DataCraft_Codes (main)
$ ls
README.md

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv/Devops_DataCraft_Codes (main)
$ touch command.sql

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv/Devops_DataCraft_Codes (main)
$ ls
README.md  command.sql

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv/Devops_DataCraft_Codes (main)
$ git add .

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv/Devops_DataCraft_Codes (main)
$ git remote add todaysclass https://github.com/joijoni/Devops_DataCraft_Codes.git

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv/Devops_DataCraft_Codes (main)
$ git push todaysclass
Everything up-to-date

Josey@DESKTOP-Q00UONJ MINGW64 ~/Python_projects/Project1/venv/Devops_DataCraft_Codes (main)

