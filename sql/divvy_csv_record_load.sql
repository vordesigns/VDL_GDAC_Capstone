USE GDAC
GO
TRUNCATE TABLE [GDAC].[dbo].[divvy-tripdata]
CHECKPOINT

PRINT 'E:\GDAC\CS1\202004-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202004-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202004-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT  'E:\GDAC\CS1\202005-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202005-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202005-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT  'E:\GDAC\CS1\202006-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202006-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202006-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202007-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202007-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202007-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202008-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202008-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202008-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT  'E:\GDAC\CS1\202009-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202009-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202009-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202010-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202010-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202010-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202011-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202011-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202011-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202012-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202012-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202012-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202101-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202101-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202101-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202102-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202102-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202102-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202103-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202103-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202103-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202104-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202104-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202104-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202105-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202105-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202105-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202106-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202106-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202106-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202107-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202107-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202107-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202108-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202108-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202108-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202109-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202109-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202109-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202110-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202110-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202110-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202111-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202111-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202111-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202112-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202112-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202112-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202201-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202201-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202201-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202202-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202202-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202202-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202203-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202203-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202203-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202204-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202204-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202204-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202205-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202205-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202205-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202206-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202206-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202206-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202207-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202207-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202207-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202208-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202208-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202208-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202209-divvy-publictripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202209-divvy-publictripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202209-divvy-publictripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202210-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202210-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202210-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202211-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202211-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202211-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202212-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202212-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202212-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202301-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202301-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202301-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202302-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202302-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202302-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202303-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202303-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202303-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202304-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202304-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202304-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202305-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202305-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202305-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202306-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202306-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202306-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202307-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202307-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202307-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202308-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202308-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202308-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202309-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202309-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202309-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202310-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202310-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202310-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202311-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202311-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202311-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202312-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202312-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202312-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202401-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202401-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202401-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202402-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202402-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202402-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202403-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202403-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202403-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202404-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202404-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202404-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202405-divvy-tripdata.csv'
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202405-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202405-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

PRINT 'E:\GDAC\CS1\202406-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended as datatime reflects time value only, all records'
PRINT '		Other defects observed, no station information collected'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202406-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202406-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)
*/
PRINT 'E:\GDAC\CS1\202407-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended as datatime reflects time value only, all records'
PRINT '		Other defects observed, no station information collected'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202407-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202407-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

*/
PRINT 'E:\GDAC\CS1\202408-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended as datatime reflects time value only, all records'
PRINT '		Other defects observed, no station information collected'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202408-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202408-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

*/
PRINT 'E:\GDAC\CS1\202409-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended as datatime reflects time value only, all records'
PRINT '		Other defects observed, no station information collected'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202409-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202409-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

*/
PRINT 'E:\GDAC\CS1\202410-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended_at datatime reflects time value only, all records'
PRINT '		Other facts observed, no station information collected for some or all records'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202410-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202410-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

*/
PRINT 'E:\GDAC\CS1\202411-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended_at datatime reflects time value only, all records'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202411-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202411-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)

*/
PRINT 'E:\GDAC\CS1\202412-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended_at datatime reflects time value only, all records'
PRINT '		Other facts observed, no station information collected for some or all records'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202412-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202412-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)
*/
PRINT 'E:\GDAC\CS1\202501-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended_at datatime reflects time value only, all records'
PRINT '		Other facts observed, no station information collected for some or all records'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202501-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202501-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)
*/

PRINT 'E:\GDAC\CS1\202502-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended_at datatime reflects time value only, all records'
PRINT '		Other facts observed, no station information collected for some or all records'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202502-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202502-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)
*/

PRINT 'E:\GDAC\CS1\202503-divvy-tripdata.csv'
PRINT '		Bad data, started_at datatime reflects time value only, all records'
PRINT '		Bad data, ended_at datatime reflects time value only, all records'
PRINT '		Other facts observed, no station information collected for some or all records'
PRINT '		File not loaded'
/*
BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\202503-divvy-tripdata.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\202503-divvy-tripdata.csv_ErrorRows.csv',
						TABLOCK
						)
*/

PRINT 'E:\GDAC\CS1\Divvy_Trips_2020_Q1.csv'
PRINT '		loaded directly into divvy-tripdata'

BULK INSERT [dbo].[divvy-tripdata]
						FROM 'E:\GDAC\CS1\Divvy_Trips_2020_Q1.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						ERRORFILE = 'E:\GDAC\CS1\Divvy_Trips_2020_Q1.csv_ErrorRows.csv',
						TABLOCK
						)

--PRINT 'E:\GDAC\CS1\Divvy_Trips_2020_Q1_PyTgt.csv'
--BULK INSERT [dbo].[divvy_trips_xxxx_qx]
--						FROM 'E:\GDAC\CS1\Divvy_Trips_2020_Q1_PyTgt.csv'
--						WITH
--						(
--						FIRSTROW = 2,
--						FIELDTERMINATOR = ',',  --CSV field delimiter
--						ROWTERMINATOR = '\n',   --Use to shift the control to next row
--						FORMATFILE = 'E:\GDAC\CS1\divvy_trips_xxxx_qx-c.xml',
--						ERRORFILE = 'E:\GDAC\CS1\Divvy_Trips_2020_Q1_PyTgt_ErrorRows.csv',
--						TABLOCK
--						)


PRINT '-----------------------------------------------------------------'
PRINT 'Divvy_Trips_YYYY_Qx files must be loaded into a staging table, '
PRINT '-----------------------------------------------------------------'

TRUNCATE TABLE [GDAC].[dbo].[divvy_trips_xxxx_qx]
CHECKPOINT
--
PRINT  'E:\GDAC\CS1\Divvy_Trips_2019_Q1_PyTgt.csv'
BULK INSERT [dbo].[divvy_trips_xxxx_qx]
	FROM 'E:\GDAC\CS1\Divvy_Trips_2019_Q1_PyTgt.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',  --CSV field delimiter
	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	FORMATFILE = 'E:\GDAC\CS1\divvy_trips_xxxx_qx-c.xml',
	ERRORFILE = 'E:\GDAC\CS1Divvy_Trips_2019_Q1_PyTgt_ErrorRows.csv',
	TABLOCK
	)
--
PRINT	'E:\GDAC\CS1\Divvy_Trips_2019_Q2_PyTgt.csv'
BULK INSERT [dbo].[divvy_trips_xxxx_qx]
	FROM 'E:\GDAC\CS1\Divvy_Trips_2019_Q2_PyTgt.csv'
	WITH
	(
		FIRSTROW = 2,  -- Skip the header row
		FIELDTERMINATOR = ',',  -- CSV field delimiter
		ROWTERMINATOR = '\n',
		FORMATFILE = 'E:\GDAC\CS1\divvy_trips_xxxx_qx-c.xml',
		ERRORFILE = 'E:\GDAC\CS1\Divvy_Trips_2019_Q2_PyTgt_ErrorRows.csv',
		TABLOCK
	)
--
PRINT 'E:\GDAC\CS1\Divvy_Trips_2019_Q3_PyTgt.csv'
BULK INSERT [dbo].[divvy_trips_xxxx_qx]
	FROM 'E:\GDAC\CS1\Divvy_Trips_2019_Q3_PyTgt.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',  --CSV field delimiter
	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	FORMATFILE = 'E:\GDAC\CS1\divvy_trips_xxxx_qx-c.xml',
	ERRORFILE = 'E:\GDAC\CS1\Divvy_Trips_2019_Q3_PyTgt_ErrorRows.csv',
	TABLOCK
	)
-- 
PRINT 'E:\GDAC\CS1\Divvy_Trips_2019_Q4_PyTgt.csv'
BULK INSERT [dbo].[divvy_trips_xxxx_qx]
						FROM 'E:\GDAC\CS1\Divvy_Trips_2019_Q4_PyTgt.csv'
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',  --CSV field delimiter
						ROWTERMINATOR = '\n',   --Use to shift the control to next row
						FORMATFILE = 'E:\GDAC\CS1\divvy_trips_xxxx_qx-c.xml',
						ERRORFILE = 'E:\GDAC\CS1\Divvy_Trips_2019_Q4_PyTgt_ErrorRows.csv',
						TABLOCK
						)
-- 

