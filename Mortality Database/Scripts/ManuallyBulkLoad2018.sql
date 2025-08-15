USE NVSS_Mortality;

IF OBJECT_ID('mcod.Raw_2018','U') IS NOT NULL DROP TABLE mcod.Raw_2018;
IF OBJECT_ID('mcod.Raw_2018_stage','U') IS NOT NULL DROP TABLE mcod.Raw_2018_stage;

CREATE TABLE mcod.Raw_2018_stage ( RawLine VARCHAR(490) NOT NULL );

BULK INSERT mcod.Raw_2018_stage
FROM 'C:\nvss\2018\mort2018us.dat'
WITH (FORMATFILE='C:\nvss\fmt_mort_490.xml', CODEPAGE='RAW', TABLOCK, MAXERRORS=0);

ALTER TABLE mcod.Raw_2018_stage ADD RawID BIGINT IDENTITY(1,1) NOT NULL;
EXEC sp_rename 'mcod.Raw_2018_stage','Raw_2018','OBJECT';

DECLARE @Out18 TABLE (RowNum INT IDENTITY(1,1), MortalityID BIGINT);
INSERT INTO mcod.UCOD_All (
  [Year], ResidentStatus, StateFIPS, CountyFIPS, MonthOfDeath, DayOfWeek, Sex,
  DetailAgeRaw, AgeSubFlag, AgeRecode52, AgeRecode27, AgeRecode12, InfantAgeRecode22,
  PlaceOfDeath, MaritalStatus, MethodOfDisposition, Autopsy, MannerOfDeath,
  ICD10_Underlying, Recode358, Recode113, Recode130Infant, Recode39,
  EntityAxisCount, RecordAxisCount,
  RaceImputeFlag, RaceRecode6, HispOrigin, HispOrigRaceRecode, RaceRecode40,
  UsualOccupation, UsualIndustry
)
OUTPUT inserted.MortalityID INTO @Out18(MortalityID)
SELECT
  2018,
  SUBSTRING(r.RawLine,20,1), SUBSTRING(r.RawLine,29,2), SUBSTRING(r.RawLine,35,3),
  SUBSTRING(r.RawLine,65,2), SUBSTRING(r.RawLine,85,1), SUBSTRING(r.RawLine,69,1),
  SUBSTRING(r.RawLine,70,4), SUBSTRING(r.RawLine,74,1), SUBSTRING(r.RawLine,75,2),
  SUBSTRING(r.RawLine,77,2), SUBSTRING(r.RawLine,79,2), SUBSTRING(r.RawLine,81,2),
  SUBSTRING(r.RawLine,83,1), SUBSTRING(r.RawLine,84,1), SUBSTRING(r.RawLine,108,1),
  SUBSTRING(r.RawLine,109,1), SUBSTRING(r.RawLine,107,1),
  SUBSTRING(r.RawLine,146,4), SUBSTRING(r.RawLine,150,3), SUBSTRING(r.RawLine,154,3),
  SUBSTRING(r.RawLine,157,3), SUBSTRING(r.RawLine,160,2),
  TRY_CONVERT(TINYINT,SUBSTRING(r.RawLine,163,2)),
  TRY_CONVERT(TINYINT,SUBSTRING(r.RawLine,341,2)),
  SUBSTRING(r.RawLine,448,1), NULL, SUBSTRING(r.RawLine,484,3), NULL, SUBSTRING(r.RawLine,489,2),
  NULL, NULL
FROM mcod.Raw_2018 r
ORDER BY r.RawID;

DECLARE @Map18 TABLE (MortalityID BIGINT, RawID BIGINT PRIMARY KEY);
WITH r AS (SELECT RawID, ROW_NUMBER() OVER (ORDER BY RawID) RN FROM mcod.Raw_2018)
INSERT @Map18 SELECT o.MortalityID, r.RawID FROM @Out18 o JOIN r ON r.RN=o.RowNum;

;WITH Slots AS (SELECT TOP (20) ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS Slot FROM sys.all_objects)
INSERT mcod.RecordAxis (MortalityID, Slot, Raw5, ICD10)
SELECT m.MortalityID, s.Slot,
       SUBSTRING(x.RawLine,344+(s.Slot-1)*5,5),
       LEFT(SUBSTRING(x.RawLine,344+(s.Slot-1)*5,5),4)
FROM @Map18 m JOIN mcod.Raw_2018 x ON x.RawID=m.RawID JOIN Slots s ON 1=1
WHERE LTRIM(RTRIM(SUBSTRING(x.RawLine,344+(s.Slot-1)*5,5)))<> '';

;WITH Slots AS (SELECT TOP (20) ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS Slot FROM sys.all_objects)
INSERT mcod.EntityAxis (MortalityID, Slot, Raw7, ICD10)
SELECT m.MortalityID, s.Slot,
       SUBSTRING(x.RawLine,165+(s.Slot-1)*7,7),
       LEFT(SUBSTRING(x.RawLine,165+(s.Slot-1)*7,7),4)
FROM @Map18 m JOIN mcod.Raw_2018 x ON x.RawID=m.RawID JOIN Slots s ON 1=1
WHERE LTRIM(RTRIM(SUBSTRING(x.RawLine,165+(s.Slot-1)*7,7)))<> '';

