

CREATE TABLE WEAPON(
id INT,
WeaponUsedCode INT,
WeaponDescription VARCHAR(500),
 PRIMARY KEY (WeaponDescription)
);

LOAD DATA local INFILE '/home/shekofeh/Desktop/Data Management/Crime/Area.csv'
INTO TABLE WEAPON 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE WEAPON
DROP COLUMN id;
#load Area table
CREATE TABLE area(
 id INT,
AreaName VARCHAR(500),
AREAID INT,
 PRIMARY KEY (AreaID)
);

LOAD DATA local INFILE '/home/shekofeh/Desktop/Data Management/Crime/Area.csv'
INTO TABLE AREA
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
CREATE TABLE Crime(
 ID INT,
CrimeCode INT,
CrimeDescription varchar(500),
PRIMARY KEY (CrimeCode)
);
LOAD DATA local INFILE '/home/shekofeh/Desktop/Data Management/Crime/Crime.csv'
INTO TABLE Crime
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
ALTER TABLE Crime
DROP COLUMN id;

CREATE TABLE StatusCrime(
 ID INT,
StatusCode INT,
StatusDescription varchar(500),
PRIMARY KEY (StatusCode)
);
LOAD DATA local INFILE '/home/shekofeh/Desktop/Data Management/Crime/Status.csv'
INTO TABLE `Status-Crime`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
#load report dataset
CREATE TABLE Report(  ID INT,  ID1 INT,  DRnumber INT,  DateReport nvarchar(100)
,  Dateoccured nvarchar(100),  Timeocuured INT,  AREAID INT,   Report_District INT,
  CrimeCode INT,  Mo_codes varchar(500),  PermiseCode INT,  WeaponUsedCode INT, 
  StatusCode varchar(100),  FOREIGN KEY (AREAID)  REFERENCES AREA(AREAID)  
  ON UPDATE CASCADE  ON DELETE RESTRICT,  FOREIGN KEY (CrimeCode)  REFERENCES Crime(CrimeCode) 
  ON UPDATE CASCADE  ON DELETE RESTRICT,  FOREIGN KEY (PermiseCode)  REFERENCES Permise(PermiseCode)  
  ON UPDATE CASCADE  ON DELETE RESTRICT,  FOREIGN KEY (WeaponUsedCode)  REFERENCES WEAPON(WeaponUsedCode) 
  ON UPDATE CASCADE  ON DELETE RESTRICT,  FOREIGN KEY (StatusCode)  REFERENCES StatusCrime(StatusCode)  
  ON UPDATE CASCADE  ON DELETE RESTRICT )ENGINE=INNODB;
LOAD DATA local INFILE '/home/shekofeh/Desktop/Data Management/Crime/Report.csv' 
INTO TABLE Report FIELDS TERMINATED BY ','  ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
#Load Address dataset
CREATE TABLE Address(   id INT,   DR_number INT,   Address nvarchar(100),  
CrossStreet varchar(100),  Location varchar(100),   FOREIGN KEY (DR_number) 
 REFERENCES Report(DRnumber)  ON UPDATE CASCADE  ON DELETE RESTRICT )	ENGINE=INNODB;
LOAD DATA local INFILE '/home/shekofeh/Desktop/Data Management/Crime/Address.csv' 
INTO TABLE Address FIELDS TERMINATED BY ','  ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
Alter table Address ADD Primary key(DR_number);
#LOad Victim Dataset
CREATE TABLE Victim(   id INT,   DR_number INT,  Victimage INT,  VictimSex varchar(100),  
VictimDesecent varchar(100) )ENGINE=INNODB;
ALTER TABLE Victim ADD FOREIGN KEY (DR_number) REFERENCES Report(`DR-number`);
LOAD DATA local INFILE '/home/shekofeh/Desktop/Data Management/Crime/Victim.csv' 
INTO TABLE Victim FIELDS TERMINATED BY ','  ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


