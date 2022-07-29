
# Databace:crime-in-los-angeles
# Shokoufeh Mansourihafshejani:1889621 
# Masoumeh Shariat : 1916321
# https://www.kaggle.com/cityofLA/crime-in-los-angeles
SET SQL_SAFE_UPDATES = 0;
###############################  Q1  ###############################
#Finding the time that the most crime were reported.
alter table Report drop column new_date ;
alter table Report add column new_date DATE;
update Report
set new_date = str_to_date(`DateReported`, '%m/%d/%Y');
 
select new_date,count(new_date),crime.crimecodedescription
from report inner join crime 
on report.crimecode=crime.crimecode
group by new_date,crimecodedescription
order by count(datereported) desc
limit 5 ;


###############################  Q2  ###############################
# Return the number of reported crimes  that their victim Desecent are White—‘W’.
SELECT YEAR(new_date),count(YEAR(new_date))
from Report R
INNER JOIN victim V 
ON R.DRNumber=V.DRNumber
where VictimDescent='W'
group by YEAR(new_date)
order by count(YEAR(new_date)) desc;

###############################  Q3  ###############################
# return top 5 number of the youngest male victims in each descent.
# Young men(less than 30 and more than 18 years old).

Select VictimDescent,VictimSex,count(VictimAge) as `numbers of young victim`
from victim
where (VictimAge<30 and VictimAge>18) and VictimSex='M'
group by VictimDescent 
;

###############################  Q4  ###############################
#Return the number of crimes that happened in 2010 in West area.
SELECT DateReported,count(YEAR(new_date)),AreaName
from Report R
INNER JOIN area A
ON R.AreaID=A.AreaID
where A.AreaName like '%WEST%' and YEAR(new_date)=2010
group by YEAR(new_date),AreaName;

###############################  Q5  ###############################
# Retun dates and places that kidnapping occurred and the age of victim and its weapon
select DateOccurred,VictimAge,WeaponDescription,PremiseDescription as 'the place that kidnapping occured'
from total_crime as T 
inner join crime as C on T.CrimeCode=C.CrimeCode
INNER JOIN Premise as P ON  P.PremiseCode=T.PremiseCode 
INNER JOIN victim as V ON  T.DRNumber=V.DRNumber
INNER JOIN weapon as W ON  T.WeaponUsedCode=W.WeaponUsedCode
where c.CrimeCodeDescription like '%KIDNAPPING%' 
order by DateOccurred ;
#limit 5;
###############################  Q6  ###############################
# crimes that offended in people less than 18 for years after 2014
select year(new_date) as Year_Report, CrimeCode 
from Report 
where DRnumber in
( select DRnumber from Victim  where Victimage <18 )
group by Year_Report,CrimeCode
having min(Year_Report)>=2014
order by year(new_date), count(CrimeCode) desc;

###############################  Q7  ###############################
#-Return The Crime type and the Area that is happened in 2011 and NOt 2012
-- view of Crime table with Crime and AreaId for the Crime of the 2011

SELECT *
from Crimed2011 as C1
WHERE NOT EXISTS
  (SELECT *
   FROM   Crimed2012 as C2
   WHERE  C1.CrimeCode=C2.CrimeCode);

create or replace view Crimed2011(Crime,Area,CrimeCode) as 
select  CrimeCodeDescription,AreaName,R.CrimeCode
from Area as A INNER JOIN Report as R
ON A.AreaID= R.AreaID
INNER JOIN Crime as C on C.CrimeCode=R.CrimeCode
where YEAR(new_date)=2011;

create or replace view Crimed2012(Crime,Area,CrimeCode) as 
select  CrimeCodeDescription,AreaName,R.CrimeCode
from Area as A INNER JOIN report as R
ON A.AreaID= R.AreaID 
INNER JOIN Crime as C on C.CrimeCode=R.CrimeCode
where YEAR(new_date)=2012;
###############################  Q8  ###############################
# return the victims, who are female or less than 18 for 2010,2013 and 2016 years
# and the type of weapon that used most

(select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') and year(R.new_date)=2010
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
limit 2)

union
(select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') and year(R.new_date)=2011
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
limit 2)

union
(select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') and year(R.new_date)=2012
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
limit 2)

union
(select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') and year(R.new_date)=2013
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
limit 2)

union
(select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') and year(R.new_date)=2014
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
limit 2)

union
(select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') and year(R.new_date)=2015
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
limit 2)

union
(select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') and year(R.new_date)=2016
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
limit 2)

union
(select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') and year(R.new_date)=2017
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
limit 2);

###############################  Q9  ###############################
#crimes that happen more than 500 times in a year 

select year(new_date),CrimeCodeDescription
from Crime C join Report R on C.CrimeCode = R.CrimeCode
group by year(R.new_date),CrimeCodeDescription
having count(C.CrimeCodeDescription)>500 ;

###############################  Q10  ###############################
#return race of victims in area that be offended most
select AreaName, max(VictimDescent)
from area as A join Report as R on A.AreaID = R.AreaID
inner join Victim as V on R.DRnumber = V.DRnumber
group by AreaName;









