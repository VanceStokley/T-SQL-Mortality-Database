USE NVSS_Mortality;

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='mcod') EXEC('CREATE SCHEMA mcod');

IF OBJECT_ID('mcod.UCOD_All','U') IS NOT NULL DROP TABLE mcod.UCOD_All;
CREATE TABLE mcod.UCOD_All
(
  MortalityID           BIGINT IDENTITY(1,1) PRIMARY KEY,
  [Year]                INT NOT NULL,
  ResidentStatus        CHAR(1)  NULL,
  StateFIPS             CHAR(2)  NULL,
  CountyFIPS            CHAR(3)  NULL,
  MonthOfDeath          CHAR(2)  NULL,
  DayOfWeek             CHAR(1)  NULL,
  Sex                   CHAR(1)  NULL,
  DetailAgeRaw          CHAR(4)  NULL,
  AgeSubFlag            CHAR(1)  NULL,
  AgeRecode52           CHAR(2)  NULL,
  AgeRecode27           CHAR(2)  NULL,
  AgeRecode12           CHAR(2)  NULL,
  InfantAgeRecode22     CHAR(2)  NULL,
  PlaceOfDeath          CHAR(1)  NULL,
  MaritalStatus         CHAR(1)  NULL,
  MethodOfDisposition   CHAR(1)  NULL,
  Autopsy               CHAR(1)  NULL,
  MannerOfDeath         CHAR(1)  NULL,
  ICD10_Underlying      CHAR(4)  NULL,
  Recode358             CHAR(3)  NULL,
  Recode113             CHAR(3)  NULL,
  Recode130Infant       CHAR(3)  NULL,
  Recode39              CHAR(2)  NULL,
  EntityAxisCount       TINYINT  NULL,
  RecordAxisCount       TINYINT  NULL,
  RaceImputeFlag        CHAR(1)  NULL,
  RaceRecode6           CHAR(1)  NULL,  -- 2022+
  HispOrigin            CHAR(3)  NULL,
  HispOrigRaceRecode    CHAR(2)  NULL,  -- 2022+
  RaceRecode40          CHAR(2)  NULL,
  UsualOccupation       CHAR(4)  NULL,  -- 2020+
  UsualIndustry         CHAR(4)  NULL   -- 2020+
);

IF OBJECT_ID('mcod.RecordAxis','U') IS NOT NULL DROP TABLE mcod.RecordAxis;
CREATE TABLE mcod.RecordAxis
(
  RecordAxisID BIGINT IDENTITY(1,1) PRIMARY KEY,
  MortalityID  BIGINT NOT NULL,
  Slot         TINYINT NOT NULL,    -- 1..20
  Raw5         CHAR(5) NULL,
  ICD10        CHAR(4) NULL,
  CONSTRAINT FK_RecordAxis_UCOD_All FOREIGN KEY (MortalityID)
    REFERENCES mcod.UCOD_All(MortalityID)
);

IF OBJECT_ID('mcod.EntityAxis','U') IS NOT NULL DROP TABLE mcod.EntityAxis;
CREATE TABLE mcod.EntityAxis
(
  EntityAxisID BIGINT IDENTITY(1,1) PRIMARY KEY,
  MortalityID  BIGINT NOT NULL,
  Slot         TINYINT NOT NULL,    -- 1..20
  Raw7         CHAR(7) NULL,
  ICD10        CHAR(4) NULL,
  CONSTRAINT FK_EntityAxis_UCOD_All FOREIGN KEY (MortalityID)
    REFERENCES mcod.UCOD_All(MortalityID)
);

CREATE INDEX IX_UCOD_All_Year_State ON mcod.UCOD_All([Year], StateFIPS, CountyFIPS);