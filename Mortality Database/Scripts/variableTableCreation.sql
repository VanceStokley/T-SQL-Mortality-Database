/* ========= 1) Schema for lookups ========= */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'lkp')
    EXEC('CREATE SCHEMA lkp');

/* ========= 2) Lookup tables (code + label) ========= */
/* Small & stable enums with labels we can safely provide */
IF OBJECT_ID('lkp.Sex','U') IS NOT NULL DROP TABLE lkp.Sex;
CREATE TABLE lkp.Sex (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(50) NULL
);

IF OBJECT_ID('lkp.Month','U') IS NOT NULL DROP TABLE lkp.Month;
CREATE TABLE lkp.Month (
  Code  CHAR(2) NOT NULL PRIMARY KEY,
  Label NVARCHAR(50) NULL
);

IF OBJECT_ID('lkp.DayOfWeek','U') IS NOT NULL DROP TABLE lkp.DayOfWeek;
CREATE TABLE lkp.DayOfWeek (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(50) NULL
);

IF OBJECT_ID('lkp.MannerOfDeath','U') IS NOT NULL DROP TABLE lkp.MannerOfDeath;
CREATE TABLE lkp.MannerOfDeath (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(100) NULL
);

IF OBJECT_ID('lkp.Autopsy','U') IS NOT NULL DROP TABLE lkp.Autopsy;
CREATE TABLE lkp.Autopsy (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(50) NULL
);

IF OBJECT_ID('lkp.MethodOfDisposition','U') IS NOT NULL DROP TABLE lkp.MethodOfDisposition;
CREATE TABLE lkp.MethodOfDisposition (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(100) NULL
);

IF OBJECT_ID('lkp.RaceRecode6','U') IS NOT NULL DROP TABLE lkp.RaceRecode6;
CREATE TABLE lkp.RaceRecode6 (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(100) NULL
);

/* ========= Larger code sets — we seed codes now; you can fill labels later ========= */
IF OBJECT_ID('lkp.AgeRecode12','U') IS NOT NULL DROP TABLE lkp.AgeRecode12;
CREATE TABLE lkp.AgeRecode12 (
  Code  CHAR(2) NOT NULL PRIMARY KEY,
  Label NVARCHAR(100) NULL
);

IF OBJECT_ID('lkp.AgeRecode27','U') IS NOT NULL DROP TABLE lkp.AgeRecode27;
CREATE TABLE lkp.AgeRecode27 (
  Code  CHAR(2) NOT NULL PRIMARY KEY,
  Label NVARCHAR(100) NULL
);

IF OBJECT_ID('lkp.AgeRecode52','U') IS NOT NULL DROP TABLE lkp.AgeRecode52;
CREATE TABLE lkp.AgeRecode52 (
  Code  CHAR(2) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

IF OBJECT_ID('lkp.InfantAgeRecode22','U') IS NOT NULL DROP TABLE lkp.InfantAgeRecode22;
CREATE TABLE lkp.InfantAgeRecode22 (
  Code  CHAR(2) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

IF OBJECT_ID('lkp.RaceRecode40','U') IS NOT NULL DROP TABLE lkp.RaceRecode40;
CREATE TABLE lkp.RaceRecode40 (
  Code  CHAR(2) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

IF OBJECT_ID('lkp.HispanicOrigin3','U') IS NOT NULL DROP TABLE lkp.HispanicOrigin3;
CREATE TABLE lkp.HispanicOrigin3 (
  Code  CHAR(3) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

IF OBJECT_ID('lkp.HispOrigRaceRecode','U') IS NOT NULL DROP TABLE lkp.HispOrigRaceRecode;
CREATE TABLE lkp.HispOrigRaceRecode (
  Code  CHAR(2) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

IF OBJECT_ID('lkp.RaceImputeFlag','U') IS NOT NULL DROP TABLE lkp.RaceImputeFlag;
CREATE TABLE lkp.RaceImputeFlag (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

IF OBJECT_ID('lkp.PlaceOfDeath','U') IS NOT NULL DROP TABLE lkp.PlaceOfDeath;
CREATE TABLE lkp.PlaceOfDeath (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

IF OBJECT_ID('lkp.ResidentStatus','U') IS NOT NULL DROP TABLE lkp.ResidentStatus;
CREATE TABLE lkp.ResidentStatus (
  Code  CHAR(1) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

/* Occupation/Industry (4-digit). Create tables now; label fill can come later from external crosswalks. */
IF OBJECT_ID('lkp.UsualOccupation','U') IS NOT NULL DROP TABLE lkp.UsualOccupation;
CREATE TABLE lkp.UsualOccupation (
  Code  CHAR(4) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

IF OBJECT_ID('lkp.UsualIndustry','U') IS NOT NULL DROP TABLE lkp.UsualIndustry;
CREATE TABLE lkp.UsualIndustry (
  Code  CHAR(4) NOT NULL PRIMARY KEY,
  Label NVARCHAR(200) NULL
);

/* ========= 3) Seed the simple enums with known labels ========= */
INSERT INTO lkp.Sex (Code, Label) VALUES
('M','Male'), ('F','Female'), ('U','Unknown');

INSERT INTO lkp.Month (Code, Label) VALUES
('01','January'),('02','February'),('03','March'),('04','April'),('05','May'),('06','June'),
('07','July'),('08','August'),('09','September'),('10','October'),('11','November'),('12','December');

INSERT INTO lkp.DayOfWeek (Code, Label) VALUES
('1','Sunday'),('2','Monday'),('3','Tuesday'),('4','Wednesday'),
('5','Thursday'),('6','Friday'),('7','Saturday');

INSERT INTO lkp.MannerOfDeath (Code, Label) VALUES
('1','Natural'), ('2','Accident'), ('3','Suicide'), ('4','Homicide'),
('5','Pending investigation'), ('6','Could not be determined');

INSERT INTO lkp.Autopsy (Code, Label) VALUES
('Y','Yes'), ('N','No'), ('U','Unknown');

INSERT INTO lkp.MethodOfDisposition (Code, Label) VALUES
('B','Burial'), ('C','Cremation'), ('E','Entombment'), ('R','Removal/Transport'),
('D','Donation'), ('O','Other'), ('U','Unknown');

INSERT INTO lkp.RaceRecode6 (Code, Label) VALUES
('1','White'), ('2','Black'), ('3','American Indian or Alaska Native'),
('4','Asian'), ('5','Native Hawaiian or Other Pacific Islander'),
('6','More than one race');

/* ========= 4) Seed all other lookup tables with the codes that actually appear in your data ========= */
/* (Labels left NULL for now — you can fill them later or import official crosswalks.) */

;WITH Dist AS (
  SELECT DISTINCT AgeRecode12 FROM mcod.UCOD_All WHERE AgeRecode12 IS NOT NULL
)
INSERT INTO lkp.AgeRecode12 (Code) SELECT AgeRecode12 FROM Dist
EXCEPT SELECT Code FROM lkp.AgeRecode12;

;WITH Dist AS (
  SELECT DISTINCT AgeRecode27 FROM mcod.UCOD_All WHERE AgeRecode27 IS NOT NULL
)
INSERT INTO lkp.AgeRecode27 (Code) SELECT AgeRecode27 FROM Dist
EXCEPT SELECT Code FROM lkp.AgeRecode27;

;WITH Dist AS (
  SELECT DISTINCT AgeRecode52 FROM mcod.UCOD_All WHERE AgeRecode52 IS NOT NULL
)
INSERT INTO lkp.AgeRecode52 (Code) SELECT AgeRecode52 FROM Dist
EXCEPT SELECT Code FROM lkp.AgeRecode52;

;WITH Dist AS (
  SELECT DISTINCT InfantAgeRecode22 FROM mcod.UCOD_All WHERE InfantAgeRecode22 IS NOT NULL
)
INSERT INTO lkp.InfantAgeRecode22 (Code) SELECT InfantAgeRecode22 FROM Dist
EXCEPT SELECT Code FROM lkp.InfantAgeRecode22;

;WITH Dist AS (
  SELECT DISTINCT RaceRecode40 FROM mcod.UCOD_All WHERE RaceRecode40 IS NOT NULL
)
INSERT INTO lkp.RaceRecode40 (Code) SELECT RaceRecode40 FROM Dist
EXCEPT SELECT Code FROM lkp.RaceRecode40;

;WITH Dist AS (
  SELECT DISTINCT HispOrigin FROM mcod.UCOD_All WHERE HispOrigin IS NOT NULL
)
INSERT INTO lkp.HispanicOrigin3 (Code) SELECT HispOrigin FROM Dist
EXCEPT SELECT Code FROM lkp.HispanicOrigin3;

;WITH Dist AS (
  SELECT DISTINCT HispOrigRaceRecode FROM mcod.UCOD_All WHERE HispOrigRaceRecode IS NOT NULL
)
INSERT INTO lkp.HispOrigRaceRecode (Code) SELECT HispOrigRaceRecode FROM Dist
EXCEPT SELECT Code FROM lkp.HispOrigRaceRecode;

;WITH Dist AS (
  SELECT DISTINCT RaceImputeFlag FROM mcod.UCOD_All WHERE RaceImputeFlag IS NOT NULL
)
INSERT INTO lkp.RaceImputeFlag (Code) SELECT RaceImputeFlag FROM Dist
EXCEPT SELECT Code FROM lkp.RaceImputeFlag;

;WITH Dist AS (
  SELECT DISTINCT PlaceOfDeath FROM mcod.UCOD_All WHERE PlaceOfDeath IS NOT NULL
)
INSERT INTO lkp.PlaceOfDeath (Code) SELECT PlaceOfDeath FROM Dist
EXCEPT SELECT Code FROM lkp.PlaceOfDeath;

;WITH Dist AS (
  SELECT DISTINCT ResidentStatus FROM mcod.UCOD_All WHERE ResidentStatus IS NOT NULL
)
INSERT INTO lkp.ResidentStatus (Code) SELECT ResidentStatus FROM Dist
EXCEPT SELECT Code FROM lkp.ResidentStatus;

/* Occupation/Industry: store the 4-digit codes you actually have */
;WITH Dist AS (
  SELECT DISTINCT UsualOccupation FROM mcod.UCOD_All WHERE UsualOccupation IS NOT NULL
)
INSERT INTO lkp.UsualOccupation (Code) SELECT UsualOccupation FROM Dist
EXCEPT SELECT Code FROM lkp.UsualOccupation;

;WITH Dist AS (
  SELECT DISTINCT UsualIndustry FROM mcod.UCOD_All WHERE UsualIndustry IS NOT NULL
)
INSERT INTO lkp.UsualIndustry (Code) SELECT UsualIndustry FROM Dist
EXCEPT SELECT Code FROM lkp.UsualIndustry;

/* ========= 5) (Optional) A convenience view with friendly labels where available ========= */
IF OBJECT_ID('mcod.vUCOD_All_Labeled','V') IS NOT NULL DROP VIEW mcod.vUCOD_All_Labeled;
GO
CREATE VIEW mcod.vUCOD_All_Labeled
AS
SELECT
  u.*,
  sx.Label     AS Sex_Label,
  mon.Label    AS MonthOfDeath_Label,
  dow.Label    AS DayOfWeek_Label,
  man.Label    AS MannerOfDeath_Label,
  au.Label     AS Autopsy_Label,
  md.Label     AS MethodOfDisposition_Label,
  r6.Label     AS RaceRecode6_Label
  -- You can LEFT JOIN additional lkp tables here once you fill their labels
FROM mcod.UCOD_All u
LEFT JOIN lkp.Sex               sx  ON sx.Code  = u.Sex
LEFT JOIN lkp.Month             mon ON mon.Code = u.MonthOfDeath
LEFT JOIN lkp.DayOfWeek         dow ON dow.Code = u.DayOfWeek
LEFT JOIN lkp.MannerOfDeath     man ON man.Code = u.MannerOfDeath
LEFT JOIN lkp.Autopsy           au  ON au.Code  = u.Autopsy
LEFT JOIN lkp.MethodOfDisposition md ON md.Code = u.MethodOfDisposition
LEFT JOIN lkp.RaceRecode6       r6  ON r6.Code  = u.RaceRecode6;
GO