USE [AdventureWorks2008R2];
GO
--Let’s check for all changes since the same time yesterday
DECLARE @begin_time AS DATETIME = GETDATE() - 1;
--Let’s check for changes up to right now
DECLARE @end_time AS DATETIME = GETDATE();
--Map the time intervals to a CDC query range (using LSNs)
DECLARE @from_lsn AS BINARY(10)
= sys.fn_cdc_map_time_to_lsn('smallest greater than or equal',
@begin_time);
DECLARE @to_lsn AS BINARY(10)
= sys.fn_cdc_map_time_to_lsn('largest less than or equal',
@end_time);
--Validate @from_lsn using the minimum LSN available in the capture instance
DECLARE @min_lsn AS BINARY(10)
= sys.fn_cdc_get_min_lsn('HumanResources_Employee');
IF @from_lsn < @min_lsn SET @from_lsn = @min_lsn;
--Return the NET changes that occurred within the specified time
SELECT * FROM
cdc.fn_cdc_get_net_changes_HumanResources_Employee
(@from_lsn, @to_lsn, N'all with mask');


