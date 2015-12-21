
DROP DATABASE IF EXISTS income;
CREATE DATABASE income;
USE income;



CREATE TABLE HOUSING_RECORD (
SERIALNO bigint(20),
NP	bigint(20),
ACCESS	bigint(20),
ACR	bigint(20),
BATH	bigint(20),
BDSP	bigint(20),
HFL	bigint(20),
LAPTOP	bigint(20),
TEL	bigint(20),
TEN	bigint(20),
VEH	bigint(20),
HUPAC	bigint(20),
MULTG	bigint(20),
MV	bigint(20),
NOC	bigint(20),
NPF	bigint(20),
RESMODE	bigint(20),
FS	bigint(20),
FULP	bigint(20),
GASP	bigint(20),
RMSP	bigint(20),
YBL	bigint(20),
R60	bigint(20),

PRIMARY KEY(SERIALNO)
);


CREATE TABLE PERSON_RECORD (
SERIALNO bigint(20),
SPORDER bigint(20), 
PUMA	bigint(20),
PWGTP	bigint(20),
AGEP	bigint(20),
CIT	bigint(20),
COW	bigint(20), 
HINS1	bigint(20),
HINS2	bigint(20),
HINS4	bigint(20),
JWMNP	bigint(20), 
LANX	bigint(20),
MAR	bigint(20),
SCHL	bigint(20),
SEX	bigint(20),
WAGP	bigint(20), 
WKHP	bigint(20), 
WKW	bigint(20), 
PRIVCOV	bigint(20),
PUBCOV	bigint(20),
RAC1P	bigint(20),
NATIVITY	bigint(20),
SOCP	bigint(20), 
DPHY	bigint(20),
JWTR	bigint(20), 
DIS	bigint(20),
HICOV	bigint(20),
QTRBIR	bigint(20),
ST	bigint(20),

PRIMARY KEY(SERIALNO, SPORDER),
FOREIGN KEY(SERIALNO) REFERENCES HOUSING_RECORD(SERIALNO)
);
