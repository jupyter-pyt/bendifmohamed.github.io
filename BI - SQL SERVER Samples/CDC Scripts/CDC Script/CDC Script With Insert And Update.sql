USE [AdventureWorks2008R2];
GO
EXEC sp_changedbowner 'sa'
GO

--Enable CDC on the database
EXEC sys.sp_cdc_enable_db;
GO

--Check CDC is enabled on the database
SELECT name, is_cdc_enabled
FROM sys.databases WHERE database_id = DB_ID();

--Next Step to Enbale CDC on selected table(s)
USE [AdventureWorks2008R2];
GO

--Enable CDC on a specific table
EXECUTE sys.sp_cdc_enable_table
@source_schema = N'HumanResources'
,@source_name = N'Employee'
,@role_name = N'cdc_Admin'
,@capture_instance = N'HumanResources_Employee'
,@supports_net_changes = 1;


--Check CDC is enabled on the table
SELECT [name], is_tracked_by_cdc FROM sys.tables
WHERE [object_id] = OBJECT_ID(N'HumanResources.Employee');
--Alternatively, use the built-in CDC help procedure
EXECUTE sys.sp_cdc_help_change_data_capture
@source_schema = N'HumanResources',
@source_name = N'Employee';
GO

--Original Source Table
SELECT * FROM [HumanResources].[Employee]

--CDC Change Capture or Instanct table (Under System Tables)
SELECT * FROM [cdc].[HumanResources_Employee_CT]

--Destination Table
SELECT * FROM [dbo].[CDC_Employee_destination]




--Check data prior to changes
Select * FROM HumanResources.Employee



--Make an update to the source table HireDate
UPDATE HumanResources.Employee
SET HireDate = DATEADD(day, 1, HireDate)
WHERE [BusinessEntityID] IN (1, 2, 3);

--Let's insert a row
Insert Into HumanResources.Employee
([BusinessEntityID] , NationalIDNumber,	LoginID,		JobTitle,	BirthDate,	MaritalStatus,	
Gender,	HireDate, SalariedFlag, VacationHours,	SickLeaveHours,	CurrentFlag,	rowguid,	ModifiedDate)
Values (293, 2958472842,	'adventure-works\AlexA',	'Research and Development Resource',	'1985-03-02',	
'S',	'M',	'2016-02-16',	1, 99,	69,	1,	newID(),	getdate())
