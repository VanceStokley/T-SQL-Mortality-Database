CREATE DATABASE NVSS_Mortality
ON PRIMARY (
  NAME = N'NVSS_Mortality',
  FILENAME = N'D:\SQLData\NVSS_Mortality.mdf',
  SIZE = 40GB,           -- adjust for your free space
  FILEGROWTH = 1024MB
)
LOG ON (
  NAME = N'NVSS_Mortality_log',
  FILENAME = N'D:\SQLLogs\NVSS_Mortality_log.ldf',
  SIZE = 8GB,
  FILEGROWTH = 512MB
);
GO

-- Keep the log small while bulk loading
ALTER DATABASE NVSS_Mortality SET RECOVERY SIMPLE;
GO