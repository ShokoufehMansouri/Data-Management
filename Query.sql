
SET SQL_SAFE_UPDATES = 0;
Use CrimeReports;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Altering Report Table

#########Altering-Date-Report-column###########
alter table Report add column new_date_Report DATE;
update Report
set new_date_Report = str_to_date(`Date-Report`, '%m-%d-%Y');
######## Altering-occuring Column#########
alter table Report add column new_date_occured DATE;
update Report
set new_date_occured = str_to_date(`Date-occured`, '%m/%d/%Y');



-- Q1: Return The Number of Victims for each sex that they are less than 18 years old
Select `Victim-Sex'`,count(`Victim-Sex'`)
from Victim 
where `Victim-age`<18
group by `Victim-Sex'`;

-- Q2: Return the crime report that their Area name contains WEST and The permise Description Does not Contain PARK
select *
from Report as R INNER JOIN `AREA-Dis` AS A
where A.`Area-Name` like '%WEST%' 
And `Permise-Code`
NOT IN( select `Permise-Code`  FROM Permise WHERE `Permise-Description` NOT Like('%PARK%'));

-- Q3:Return the number of balck victims for each Year.
SELECT count(YEAR(`new_date_Report`)),YEAR(`new_date_Report`)
from Report R
INNER JOIN Victim V 
ON R.`DR-number`=V.DR_number
where `Victim-Desecent'`='B'
group by YEAR(`new_date_Report`)
order by count(YEAR(`new_date_Report`)) desc;

-- Q4:Return  the number of Victims that happened in each year based on their race.
SELECT count(YEAR(`new_date_Report`)),YEAR(`new_date_Report`),`Victim-Desecent'`
from Report R
INNER JOIN Victim V 
ON R.`DR-number`=V.DR_number
group by YEAR(`new_date_Report`),`Victim-Desecent'`;

-- Q5: Return the number of victims based on their race for each month of the 2010 and 2013
SELECT count(MONTH(`new_date_Report`)) ,`Victim-Desecent'`,MONTH(`new_date_Report`),YEAR(`new_date_Report`) as Year_Report
from Report R
INNER JOIN Victim V 
ON R.`DR-number`=V.DR_number
group by MONTH(`new_date_Report`),`Victim-Desecent'`,YEAR(`new_date_Report`) 
having Year_Report=2010 or Year_Report=2013
order by MONTH(`new_date_Report`), Year_Report, count(MONTH(`new_date_Report`)) desc,`Victim-Desecent'` desc;

-- Q6: Return the permises that each Desecent Victim is attacked
select count(`Permise-Description`),`Victim-Desecent'`,`Permise-Description`
FROM Report as R INNER JOIN Victim as V
ON R.`DR-number`=V.DR_number
INNER JOIN Permise as P ON  P.`Permise-Code`=R.`Permise-Code`
group by `Permise-Description`,`Victim-Desecent'`
order by count(`Permise-Description`) DESC ;

-- Q7: Return The Area ID of each Address
select DR_number,Address
from Address
union 
select `DR-number`,`Area-Name`
from `AREA-Dis` as A INNER JOIN Report as R 
oN A.`Area-ID`=R.`AREA-ID`;

-- Q8: Return the Status Description of the Crime in which the Are-Name in Foothill

select `Status-Description`
from `Status-Crime`
where `Status-Code`
IN (select `Status-Code` from Report
where `AREA-ID` 
IN (select `Area-ID` from `AREA-Dis`where  `Area-Name` ='Foothill'));

-- Q9: Return the Victim Descent that the Average Crime on them is greater than the minimum average Crime in 2013
--  Return the Victim-Desecent  age that their crime is report in 2013 and month 2
-- Find the number of the victim for each Desecent in the second month of the 2013
-- Then list the Victim Desecent that they count is more than the minimume Number of Victim Descent in 2013
select  `Victim-Desecent'`,count(`Victim-Desecent'`) as V
from Victim
where DR_number IN (select `DR-number`
from Report where YEAR(`new_date_Report`)=2013 AND Month(`new_date_Report`)=2)
group by `Victim-Desecent'`
HAVING V > (select MIN(V) FROM ((select count(`Victim-Desecent'`)/12 as V
from Victim where DR_number 
IN (select `DR-number` from Report where YEAR(`new_date_Report`)=2013) 
group by `Victim-Desecent'`)as t1)) ;

-- Q10:weapons that they were not used in 2013 and month 6
select `Weapon Description` as w 
from WEAPON
Where  `Weapon-Used-Code` Not IN
(SELECT `Weapon-Used-Code`
FROM Report where YEAR(`new_date_Report`)=2013 AND Month(`new_date_Report`)=6);

-- Q11: the victim descent that it's age is max
Select distinct `Victim-Desecent'`
from Victim
where `Victim-age`>=all(select max(`Victim-age`) from Victim);

-- Q12: Return The Crime type and the Area that is happened in 2010 and NOt 2013
-- view of Crime table with Crime and AreaId for the Crime of the 2013

select *
from Crimed2010 as C1 left join Crimed2013 as C2 
on C1.CrimeCode=C2.CrimeCode 
where C2.CrimeCode is null;

create view Crimed2013(Crime,Area,CrimeCode) as 
select  `Crime-Description`,`Area-Name`,R.`Crime-Code`
from `AREA-Dis` as A INNER JOIN Report as R
ON A.`AREA-ID`= R.`AREA-ID` 
INNER JOIN Crime as C on C.`Crime-Code`=R.`Crime-Code`
where YEAR(`new_date_Report`)=2013;

create view Crimed2010(Crime,Area,CrimeCode) as 
select  `Crime-Description`,`Area-Name`,R.`Crime-Code`
from `AREA-Dis` as A INNER JOIN Report as R
ON A.`AREA-ID`= R.`AREA-ID` 
INNER JOIN Crime as C on C.`Crime-Code`=R.`Crime-Code`
where YEAR(`new_date_Report`)=2010;


-- Q13: 


