
######### adding integrity constraints to one or more tables
### Add these constraints : UNIQUE, check,not null ,primary key
#optymize Q3 with CONSTRAINT and index
#ALTER TABLE victim
#DROP CONSTRAINT VictimAge;

ALTER TABLE victim
ADD CONSTRAINT VictimAge CHECK(0 < VictimAge and VictimAge<=100);

#########  adding indix
ALTER TABLE victim
DROP INDEX idx_age;
CREATE INDEX idx_age
ON victim (VictimAge);


SELECT VictimSex, VictimDescent,count(VictimAge)  
FROM victim 
FORCE INDEX (idx_age)
WHERE (VictimAge<30 AND VictimAge>18) AND VictimSex='M'
GROUP BY VictimDescent;

######### adding views or new (materialized) tables derived from the existing database tables
#optymize Q4

ALTER TABLE area
DROP CONSTRAINT AreaID;

ALTER TABLE area
ADD CONSTRAINT AreaID UNIQUE (AreaID);

CREATE OR REPLACE VIEW total_crime AS SELECT * FROM report;
## Optimize with view and CONSTRAINT
# The number of crime in 2010
SELECT DateReported,count(YEAR(new_date)),AreaName
FROM total_crime T
INNER JOIN area A
ON T.AreaID=A.AreaID
where A.AreaName like '%WEST%' and YEAR(new_date)=2010
group by YEAR(new_date),AreaName;

##################### rewrite Q6
select year(new_date) as Year_Report, CrimeCode 
from Report R inner join Victim V on R.DRnumber = V.DRnumber 
where  Victimage <18 
group by Year_Report,CrimeCode
having min(Year_Report)>=2014
order by year(new_date), count(CrimeCode) desc;

################rewrite Q7
select *
from Crimed2011 as a left join Crimed2012 as b on a.CrimeCode = b.CrimeCode
where b.CrimeCode is null;
 
 ################rewrite Q8
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




