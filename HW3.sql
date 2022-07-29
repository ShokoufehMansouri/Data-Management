###################### Q1 ######################
# Q1. Return top 5 number of the youngest male victims in each descent. 
# Young men(less than 30 and more than 18 years old).
#LTER TABLE victim
#ROP INDEX idx_age;
CREATE INDEX idx_age
ON victim (VictimAge);

SELECT VictimDescent, VictimSex,count(VictimAge) as `numbers of young victim` 
FROM victim 
FORCE INDEX (idx_age)
WHERE (VictimAge<30 AND VictimAge>18) AND VictimSex='M'
GROUP BY VictimDescent 
order by count(VictimAge) desc;
###################### Q2 ######################
# Q2: Finding the date that the most crime were reported.
select new_date,count(new_date),crime.crimecodedescription
from report inner join crime 
on report.crimecode=crime.crimecode
group by new_date,crimecodedescription
order by count(datereported) desc ;

###################### Q3 ######################
# Q3: Return the number of crimes that happened in 2010 in West area.
SELECT DateReported,count(YEAR(new_date)),AreaName
from Report R
INNER JOIN area A
ON R.AreaID=A.AreaID
where A.AreaName like '%WEST%' and YEAR(new_date)=2010
group by YEAR(new_date),AreaName;

###################### Q4 ######################
#Q4:  Return the number of reported crimes  that their victim Descents are White ‘W’.
select year(new_date) as year, count(year(new_date)) as number_of_crimes
from Report R
INNER JOIN victim V 
ON R.DRNumber=V.DRNumber
where VictimDescent='W'
group by YEAR(new_date)
order by count(YEAR(new_date)) desc;

###################### Q5######################
#Q5: Return dates and places that kidnapping occurred and the age of victim and weapons were used.
select new_date,VictimAge,WeaponDescription,PremiseDescription as 'the place that kidnapping occured'
from total_crime as T 
inner join crime as C on T.CrimeCode=C.CrimeCode
INNER JOIN Premise as P ON  P.PremiseCode=T.PremiseCode 
INNER JOIN victim as V ON  T.DRNumber=V.DRNumber
INNER JOIN weapon as W ON  T.WeaponUsedCode=W.WeaponUsedCode
where c.CrimeCodeDescription like '%KIDNAPPING%' 
order by new_date ;
#limit 5;
######################Q6 ######################
select year(new_date) as Year_Report, CrimeCode 
from Report R inner join Victim V on R.DRnumber = V.DRnumber 
where  Victimage <18 
group by Year_Report,CrimeCode
having min(Year_Report)>=2014
order by year(new_date), count(CrimeCode) desc;

######################Q7 ######################
SET @ranking = 0, @prev_val = NULL;
select *,
@ranking:= if(@prev_val=Year_Report,@ranking+1,1) as ranking , @prev_val:=Year_Report
from(
select year(R.new_date) as Year_Report,Avg(V.Victimage), V.VictimSex ,count(W.WeaponUsedCode),
W.WeaponDescription
from Victim as V inner join Report as R on V.DRnumber = R.DRnumber
inner join WEAPON as W on W.WeaponUsedCode = R.WeaponUsedCode
where (V.Victimage <18 or V.VictimSex ='F') 
group by Year_Report,V.VictimSex, W.WeaponUsedCode
order by Year_Report,count(W.WeaponDescription) desc
)t
having ranking<=2;

######################Q8 ######################
#crimes that happen more than 500 times in a year 

select year(new_date),CrimeCodeDescription
from Crime C join Report R on C.CrimeCode = R.CrimeCode
group by year(R.new_date),CrimeCodeDescription
having count(C.CrimeCodeDescription)>500 ;
######################Q9 ######################
#return race of victims in area that be offended most
select AreaName, max(VictimDescent)
from area as A join Report as R on A.AreaID = R.AreaID
inner join Victim as V on R.DRnumber = V.DRnumber
group by AreaName;