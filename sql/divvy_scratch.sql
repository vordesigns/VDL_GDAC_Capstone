/** divvy_scratch.sql **/
USE GDAC
GO

EXEC sp_configure 'show advanced options', '1'
RECONFIGURE
-- this enables xp_cmdshell
	EXEC sp_configure 'xp_cmdshell', '1' 
	RECONFIGURE

TRUNCATE TABLE [dbo].[divvy-files];

declare @files table (ID int IDENTITY, FileName varchar(100));

insert into @files execute xp_cmdshell 'dir E:\GDAC\CS1 /b';

DELETE FROM @files where RIGHT(FileName,10) = '_PyTgt.csv';

DELETE FROM @files where RIGHT(FileName,3) = 'xml';

DELETE FROM @files where FileName IS NULL;

DELETE FROM @files where FileName = 'divvy-files.txt'

INSERT INTO [dbo].[divvy-files]([file_name],py_tgt, [type])
SELECT FileName
	, LEFT(FileName,LEN(FileName)-4)+'_PyTgt.csv' AS py_tgt
	, 1 FROM @files

UPDATE f
	SET type = 1 
FROM [dbo].[divvy-files] f
WHERE RIGHT(file_name,12)  = 'tripdata.csv'

UPDATE f
	SET type = 2 
FROM [dbo].[divvy-files] f
WHERE SUBSTRING(file_name,13,4) = '2019'


EXEC sp_configure 'xp_cmdshell', '0' 
RECONFIGURE

SELECT TOP (1000) [file_name]
      ,[py_tgt]
      ,[type]
  FROM [GDAC].[dbo].[divvy-files]

/*
  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [ride_id]
      ,[started_at]
      ,[ended_at]
      ,[rideable_type]
      ,[start_station_name]
      ,[start_station_id]
      ,[end_station_name]
      ,[end_station_id]
      ,[start_lat]
      ,[start_lng]
      ,[end_lat]
      ,[end_lng]
      ,[member_casual]
      ,[ride_length]
      ,[day_of_week]
  FROM [GDAC].[dbo].[divvy-tripdata]

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [trip_id] AS ride_id
      ,[start_time]
      ,[end_time]
	  ,'' AS rideable_type
      --,[bikeid]
      --,[tripduration]
      ,[from_station_name] AS stat_station_name
      ,[from_station_id] AS start_station_id
      ,[to_station_name] AS end_station_name
      ,[to_station_id] AS end_station_id
	  ,0 AS start_lat
	  ,0 AS start_lng
	  ,0 AS end_lat
	  ,0 AS end_lng
      ,[usertype] AS member_casual
      --,[gender]
      --,[birthyear]
      ,CONVERT(char(10),end_time-start_time, 108) AS ride_length
      ,CAST(CAST(ROUND(DATEPART(WEEKDAY,start_time), 0) AS INT) AS VARCHAR(1)) AS day_of_week
  FROM [GDAC].[dbo].[divvy_trips_xxxx_qx]
*/
/*
SELECT 
	YEAR(started_at) AS an_year, MONTH(started_at) AS an_month,  
	count(ride_id) AS rcount FROM [GDAC].[dbo].[divvy-tripdata]
WHERE YEAR(started_at) IN (2019, 2020)
GROUP BY YEAR(started_at), MONTH(started_at)
ORDER BY an_year, an_month
*/

---- divvy_trips_xxxx_qx calculate ride length and day of the week
--UPDATE dtxq
--set ride_length = CONVERT(char(10),end_time-start_time, 108)
--	-- CAST(CAST(ROUND(dbo.invoice_line.qty_shipped, 0) as int) as varchar(40))
--	,day_of_week =CAST(CAST(ROUND(DATEPART(WEEKDAY,start_time), 0) AS INT) AS VARCHAR(1))
--FROM [dbo].[divvy_trips_xxxx_qx] dtxq

---- divvy-tripdata calculate ride length and day of the week
--UPDATE dt
--set ride_length = CONVERT(char(10),ended_at-started_at, 108)
--	-- CAST(CAST(ROUND(dbo.invoice_line.qty_shipped, 0) as int) as varchar(40))
--	,day_of_week =CAST(CAST(ROUND(DATEPART(WEEKDAY,started_at), 0) AS INT) AS VARCHAR(1))
--FROM [dbo].[divvy-tripdata] dt


--USE master;
--GO
--EXECUTE sp_configure 'show advanced options', 1;
--GO
--RECONFIGURE;
--GO
--EXECUTE sp_configure 'xp_cmdshell', 1;
--GO
--RECONFIGURE;
--GO
--USE GDAC
--TRUNCATE TABLE [dbo].[divvy-files]
--GO
--declare @files table (ID int IDENTITY, FileName varchar(100))
--insert into @files execute xp_cmdshell 'dir E:\GDAC\CS1\*.csv /b'
--delete from @files where FileName IS NULL
----select * from @files
--INSERT INTO [dbo].[divvy-files]
--select [FileName], SUBSTRING([FileName],1,LEN([FileName])-4)+'_PyTgt.csv' AS PyTgt , 1 AS type from @files WHERE RIGHT(FileName,5) = 'a.csv'
--UNION ALL
--select [FileName], SUBSTRING([FileName],1,LEN([FileName])-4)+'_PyTgt.csv' AS PyTgt , 2 AS type from @files WHERE RIGHT(FileName,6) IN ('Q1.csv','Q2.csv','Q3.csv','Q4.csv');
--GO
--GO
--USE master;
--GO
--EXECUTE sp_configure 'xp_cmdshell', 0;
--GO
--RECONFIGURE;
--GO
--EXECUTE sp_configure 'show advanced options', 0;
--GO
--RECONFIGURE;
--GO
--USE GDAC
--GO
---- Ctrl+T <-- To Text
--select CAST('"' as CHAR(1))+RTRIM([file_name])+CAST('"' as CHAR(1)) from [dbo].[divvy-files] where [type] = 1
--select CAST('"' as CHAR(1))+RTRIM([file_name])+CAST('"' as CHAR(1)) from [dbo].[divvy-files] where [type] = 2

---- Ctrl+D <-- To Grid
--select * from [dbo].[divvy-files];

-- Broken records check
--select * from dbo.[divvy_trips_xxxx_qx] where usertype NOT IN ('casual', 'member')


-- usertype identification tripdata
--select distinct 
--    [member_casual]
--FROM [GDAC].[dbo].[divvy-tripdata]

---- usertype identification trips_xxxx_qx
--SELECT DISTINCT
--      [usertype]	-- AS member_casual
--  FROM [GDAC].[dbo].[divvy_trips_xxxx_qx]


--  -- Update usertype data in divvy_trips_xxxx_qx
--UPDATE dtxq
--SET usertype = 'casual'
--FROM [dbo].[divvy_trips_xxxx_qx] dtxq where usertype = 'Customer'

--UPDATE dtxq
--SET usertype = 'member'
--FROM [dbo].[divvy_trips_xxxx_qx] dtxq where usertype = 'Subscriber'

--
-- Bad start_station_id checks and analysis
--
---- Select distinct Station information and long/lat data
--SELECT DISTINCT [start_station_id],[start_station_name], MIN(start_lat) AS start_lat, MIN(start_lng) AS start_lng
--FROM dbo.[divvy-tripdata] WHERE start_station_id IS NOT NULL
--GROUP BY [start_station_id], [start_station_name]
--ORDER BY [start_station_id]
--
---- Bad station id Throop/Hastings Mobile Station
----select top (5) * from dbo.[divvy-tripdata] WHERE start_station_id in ('Throop/Hastings Mobile Station')
--/*
--ride_id	rideable_type	started_at	ended_at	start_station_name	start_station_id	end_station_name	end_station_id	start_lat	start_lng	end_lat	end_lng	member_casual	ride_length	day_of_week
--12805ED7C0B9303D	electric_bike	2021-11-10 12:13:21.000	2021-11-10 12:13:24.000	Throop/Hastings Mobile Station	Throop/Hastings Mobile Station	Throop/Hastings Mobile Station	Throop/Hastings Mobile Station	41.851560	-87.659111	41.851556	-87.659158	member	00:00:03	4
--78333AAEE3F9177F	electric_bike	2021-11-10 12:13:31.000	2021-11-10 12:33:22.000	Throop/Hastings Mobile Station	Throop/Hastings Mobile Station	NULL	NULL	41.851556	-87.659158	41.850000	-87.660000	member	00:19:51	4
--*/
--select top (1) * from dbo.[divvy-tripdata] WHERE start_station_name in ('Throop/Hastings Mobile Station') and start_station_id not in ('Throop/Hastings Mobile Station')
---- returns no records
--
--
-- Bad station id Wilton Ave & Diversey Pkwy - Charging
----select top (5) * from dbo.[divvy-tripdata] WHERE start_station_id in ('Wilton Ave & Diversey Pkwy - Charging')
--/*
--ride_id	rideable_type	started_at	ended_at	start_station_name	start_station_id	end_station_name	end_station_id	start_lat	start_lng	end_lat	end_lng	member_casual	ride_length	day_of_week
--1FDCFA22DDDDCBCB	classic_bike	2022-03-25 18:25:05.000	2022-03-25 18:32:07.000	Wilton Ave & Diversey Pkwy - Charging	Wilton Ave & Diversey Pkwy - Charging	Greenview Ave & Fullerton Ave	TA1307000001	41.932418	-87.652705	41.925330	-87.665800	member	00:07:02	6
--22C430A9D436BB6C	electric_bike	2022-03-30 06:08:19.000	2022-03-30 06:23:30.000	Wilton Ave & Diversey Pkwy - Charging	Wilton Ave & Diversey Pkwy - Charging	McClurg Ct & Erie St	KA1503000041	41.932338	-87.652771	41.894503	-87.617854	member	00:15:11	4
--2393F24302999195	classic_bike	2022-03-25 23:43:29.000	2022-03-25 23:54:50.000	Wilton Ave & Diversey Pkwy - Charging	Wilton Ave & Diversey Pkwy - Charging	DuSable Lake Shore Dr & Belmont Ave	TA1309000049	41.932418	-87.652705	41.940775	-87.639192	member	00:11:21	6
--41E287865EA265B7	electric_bike	2022-03-24 06:49:22.000	2022-03-24 07:07:30.000	Wilton Ave & Diversey Pkwy - Charging	Wilton Ave & Diversey Pkwy - Charging	Clinton St & Madison St	TA1305000032	41.932321	-87.652718	41.882242	-87.641066	casual	00:18:08	5
--4ED32A42F995CFCF	electric_bike	2022-03-21 18:47:24.000	2022-03-21 18:56:19.000	Wilton Ave & Diversey Pkwy - Charging	Wilton Ave & Diversey Pkwy - Charging	NULL	NULL	41.932278	-87.652720	41.930000	-87.630000	casual	00:08:55	2
--*/
--select top (1) * from dbo.[divvy-tripdata] WHERE start_station_name in ('Wilton Ave & Diversey Pkwy - Charging') and start_station_id not in ('Wilton Ave & Diversey Pkwy - Charging')
---- returns no records

--/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000) [ride_id]
--      ,[rideable_type]
--      ,[started_at]
--      ,[ended_at]
--      ,[start_station_name]
--      ,[start_station_id]
--      ,[end_station_name]
--      ,[end_station_id]
--      ,[start_lat]
--      ,[start_lng]
--      ,[end_lat]
--      ,[end_lng]
--      ,[member_casual]
--      ,[ride_length]
--      ,[day_of_week]
--  FROM [GDAC].[dbo].[divvy-tripdata]

--  SELECT TOP 5 * from [GDAC].[dbo].[divvy-tripdata] WHERE start_lat = 41.900000 and start_lng = -87.690000 and start_station_id IS NOT NULL
--/*
--ride_id	rideable_type	started_at	ended_at	start_station_name	start_station_id	end_station_name	end_station_id	start_lat	start_lng	end_lat	end_lng	member_casual	ride_length	day_of_week
--005AD3803F46AACA	electric_bike	2023-04-28 08:37:26.000	2023-04-28 08:51:01.000	Campbell Ave & Augusta Blvd	410	NULL	NULL	41.900000	-87.690000	41.910000	-87.660000	member	00:13:35	6
--0345FAB7FC4197A1	electric_bike	2023-04-10 08:21:15.000	2023-04-10 08:45:28.000	Public Rack - Rockwell & Division	1052	NULL	NULL	41.900000	-87.690000	41.880000	-87.620000	casual	00:24:13	2
--03A1977E55A44C49	electric_bike	2023-05-08 07:21:09.000	2023-05-08 07:37:14.000	Campbell Ave & Augusta Blvd	410	Wabash Ave & Wacker Pl	TA1307000131	41.900000	-87.690000	41.886875	-87.626030	member	00:16:05	2
--0514A6B7ED0F744A	electric_bike	2023-05-16 07:30:39.000	2023-05-16 07:37:16.000	Public Rack - Rockwell & Division	1052	NULL	NULL	41.900000	-87.690000	41.900000	-87.670000	member	00:06:37	3
--0561144BBF86E1E3	electric_bike	2023-05-07 18:46:48.000	2023-05-07 18:54:08.000	Campbell Ave & Augusta Blvd	410	NULL	NULL	41.900000	-87.690000	41.890000	-87.670000	casual	00:07:20	1
--*/

-- Find non-numeric start station ids
--divvy_xxxx_qx
--select * from dbo.divvy_trips_xxxx_qx where from_station_id not like '%[0-9]%'
-- Returned no records
-- divvy-stripdata
--select * from dbo.[divvy-tripdata] where start_station_id not like '%[0-9]%'

---- 
--truncate table [dbo].[div_py_pm_dow_tod_2019_2020]
----
---- Insert Summary 2019-2020 
----
--INSERT INTO [dbo].[div_py_pm_dow_tod_2019_2020]
--SELECT
--    DATEPART(YEAR, td.started_at) AS period_yr,
--    DATEPART(MONTH, td.started_at) AS period_mo,
--    td.member_casual AS customer_type,
--    CASE td.day_of_week
--        WHEN 1 THEN 'Sun'
--        WHEN 2 THEN 'Mon'
--        WHEN 3 THEN 'Tue'
--        WHEN 4 THEN 'Wed'
--        WHEN 5 THEN 'Thu'
--        WHEN 6 THEN 'Fri'
--        WHEN 7 THEN 'Sat'
--    END AS dow,
--    CASE 
--        WHEN CONVERT(time, td.started_at) >= '05:00:00' AND CONVERT(time, td.started_at) < '12:00:00' THEN 'morning'
--        WHEN CONVERT(time, td.started_at) >= '12:00:00' AND CONVERT(time, td.started_at) < '17:00:00' THEN 'afternoon'
--        ELSE 'evening'
--    END AS time_of_day,
--    COUNT(td.ride_id) AS ride_count,
--    AVG(DATEDIFF(MINUTE, td.started_at, td.ended_at)) AS avg_ride_length
----INTO div_py_pm_dow_tod_2019_2020
--FROM dbo.[divvy-tripdata] td WITH (INDEX(div_stat_mc_dow))
--WHERE DATEPART(YEAR, td.started_at) IN (2019, 2020)
--GROUP BY 
--    DATEPART(YEAR, td.started_at),
--    DATEPART(MONTH, td.started_at),
--    td.member_casual,
--    td.day_of_week,
--    CASE 
--        WHEN CONVERT(time, td.started_at) >= '05:00:00' AND CONVERT(time, td.started_at) < '12:00:00' THEN 'morning'
--        WHEN CONVERT(time, td.started_at) >= '12:00:00' AND CONVERT(time, td.started_at) < '17:00:00' THEN 'afternoon'
--        ELSE 'evening'
--    END
--ORDER BY period_yr, period_mo, td.day_of_week, time_of_day;

--SELECT
--  CAST([period_yr] AS varchar(4)) AS period_year,
--  CAST([period_yr] AS varchar(4)) + RIGHT('0' + CAST([period_mo] AS varchar(2)), 2) AS period_id,
--  [customer_type],
--  [dow],
--  [time_of_day],
--  [ride_count],
--  [avg_ride_length]
--FROM [GDAC].[dbo].[div_py_pm_dow_tod_2019_2020]
--ORDER BY 
--  period_yr, 
--  period_mo,
--  CASE dow 
--    WHEN 'Sun' THEN 1 
--    WHEN 'Mon' THEN 2 
--    WHEN 'Tue' THEN 3  
--    WHEN 'Wed' THEN 4 
--    WHEN 'Thu' THEN 5 
--    WHEN 'Fri' THEN 6 
--    ELSE 7 
--  END,
--  customer_type,
--  CASE time_of_day 
--    WHEN 'morning' THEN 1 
--    WHEN 'afternoon' THEN 2 
--    ELSE 3 
--  END

--/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT CAST([period_yr] AS varchar(4))+RIGHT('0'+CAST([period_mo] AS varchar(2)),2) AS period_id
--	  ,CAST([period_yr] AS varchar(4))+RIGHT('0'+CAST([period_mo] AS varchar(2)), 2) AS period_id,

--      ,[customer_type]
--      ,[dow]
--      ,[time_of_day]
--      ,[ride_count]
--      ,[avg_ride_length]
--  FROM [GDAC].[dbo].[div_py_pm_dow_tod_2019_2020]
--  ORDER BY period_yr, period_mo, CASE dow when 'Sun' then 1 when 'Mon' then 2 when 'Tue' then 3 when 'Wed' then 4 when 'Thu' then 5 when 'Fri' then 6 else 7 end
--  , customer_type, CASE time_of_day when 'morning' then 1 when 'afternoon' then 2 else 3 end

--  SELECT 
--  CAST([period_yr] AS varchar(4)) + RIGHT('0' + CAST([period_mo] AS varchar(2)), 2) AS period_id,
--  [customer_type],
--  [dow],
--  [time_of_day],
--  [ride_count],
--  [avg_ride_length]
--FROM [GDAC].[dbo].[div_py_pm_dow_tod_2019_2020]
--ORDER BY 
--  period_yr, 
--  period_mo,
--  CASE dow 
--    WHEN 'Sun' TH EN 1 
--    WHEN 'Mon' THEN 2 
--    WHEN 'Tue' THEN 3  
--    WHEN 'Wed' THEN 4 
--    WHEN 'Thu' THEN 5 
--    WHEN 'Fri' THEN 6 
--    ELSE 7 
--  END,
--  customer_type,
--  CASE time_of_day 
--    WHEN 'morning' THEN 1 
--    WHEN 'afternoon' THEN 2 
--    ELSE 3 
--  END
SELECT top(1000) s.ride_id, s.started_at 
FROM dbo.[divvy-tripdata] s
WHERE 
        s.started_at IS NOT NULL
    AND ISDATE(s.started_at) = 1
    AND s.started_at <> FORMAT(s.started_at, 'yyyymmdd');
--
-- Msg 242, Level 16, State 3, Line 310
-- The conversion of a nvarchar data type to a datetime data type resulted in an out-of-range value.

----
--SELECT top(100) *
--FROM [divvy-tripdata]
--WHERE CAST(started_at AS DATE) = '1900-01-01';
---- no records

----
--SELECT top(100) *
--FROM [divvy-tripdata]
--WHERE [started_at] < '1901-01-01';
---- no records

--
SELECT top(100) *
FROM [divvy-tripdata]
WHERE [started_at]::time = [started_at];
--Msg 243, Level 16, State 4, Line 12
--Type started_at is not a defined system type.

SELECT CAST(started_at AS DATE) AS DateOnly, COUNT(*) AS Count
FROM [divvy-tripdata]
GROUP BY CAST(started_at AS DATE)
ORDER BY DateOnly DESC;

select count(*) from dbo.[divvy-tripdata]

-- bad data data cleaning analysis
-- I modified the query you gave me
----
--SELECT TOP 1000 ride_id, started_at, ended_at
--FROM dbo.[divvy-tripdata]
--WHERE started_at = ended_at;
----
--to count records rather than producing them to evaluate rather than display
--
SELECT count(*)
FROM dbo.[divvy-tripdata]
WHERE started_at = ended_at;
----
--Produces 2891 records
--This leads me to believe that they are bad records that should be selected into a table for reference and removed from the data set
---
--I did the same thing with this query
----
--SELECT TOP 1000 ride_id, started_at
--FROM dbo.[divvy-tripdata]
--WHERE CAST(started_at AS TIME) = '00:00:00';
---- 
SELECT count(*)
FROM dbo.[divvy-tripdata]
WHERE CAST(started_at AS TIME) = '00:00:00';
----
--Produces 106 records
--This leads me to believe that they are bad records that should be selected into a table for reference and removed from the data set
---
--I doubt that this would produce any results because the ride_length was calculated post record import.
----
SELECT TOP 1000 ride_id, started_at, ended_at, ride_length
FROM dbo.[divvy-tripdata]
WHERE ride_length IS NULL 
   OR ride_length = '00:00:00'
ORDER BY started_at;
---- Produces records

/*
TRUNCATE TABLE  [dbo].[div_py_pm_dow_tod];
-- Insert Summary All Years 
--
INSERT INTO [dbo].[div_py_pm_dow_tod]
SELECT
    DATEPART(YEAR, td.started_at) AS period_yr,
    DATEPART(MONTH, td.started_at) AS period_mo,
    td.member_casual AS customer_type,
    CASE td.day_of_week
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tue'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thu'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
    END AS dow,
    CASE 
        WHEN CONVERT(time, td.started_at) >= '05:00:00' AND CONVERT(time, td.started_at) < '12:00:00' THEN 'morning'
        WHEN CONVERT(time, td.started_at) >= '12:00:00' AND CONVERT(time, td.started_at) < '17:00:00' THEN 'afternoon'
        ELSE 'evening'
    END AS time_of_day,
    COUNT(td.ride_id) AS ride_count,
    AVG(DATEDIFF(MINUTE, td.started_at, td.ended_at)) AS avg_ride_length
--INTO div_py_pm_dow_tod_2019_2020
FROM dbo.[divvy-tripdata] td WITH (INDEX(div_stat_mc_dow))
WHERE DATEPART(YEAR, td.started_at) IN (2019, 2020, 2021, 2022, 2023, 2025)
GROUP BY 
    DATEPART(YEAR, td.started_at),
    DATEPART(MONTH, td.started_at),
    td.member_casual,
    td.day_of_week,
    CASE 
        WHEN CONVERT(time, td.started_at) >= '05:00:00' AND CONVERT(time, td.started_at) < '12:00:00' THEN 'morning'
        WHEN CONVERT(time, td.started_at) >= '12:00:00' AND CONVERT(time, td.started_at) < '17:00:00' THEN 'afternoon'
        ELSE 'evening'
    END
ORDER BY period_yr, period_mo, td.day_of_week, time_of_day;
---
-- Insert Summary 2019-2020 
--
TRUNCATE TABLE [dbo].[div_py_pm_dow_tod_2019_2020];

INSERT INTO [dbo].[div_py_pm_dow_tod_2019_2020]
SELECT
    DATEPART(YEAR, td.started_at) AS period_yr,
    DATEPART(MONTH, td.started_at) AS period_mo,
    td.member_casual AS customer_type,
    CASE td.day_of_week
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tue'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thu'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
    END AS dow,
    CASE 
        WHEN CONVERT(time, td.started_at) >= '05:00:00' AND CONVERT(time, td.started_at) < '12:00:00' THEN 'morning'
        WHEN CONVERT(time, td.started_at) >= '12:00:00' AND CONVERT(time, td.started_at) < '17:00:00' THEN 'afternoon'
        ELSE 'evening'
    END AS time_of_day,
    COUNT(td.ride_id) AS ride_count,
    AVG(DATEDIFF(MINUTE, td.started_at, td.ended_at)) AS avg_ride_length
--INTO div_py_pm_dow_tod_2019_2020
FROM dbo.[divvy-tripdata] td WITH (INDEX(div_stat_mc_dow))
WHERE DATEPART(YEAR, td.started_at) IN (2019, 2020)
GROUP BY 
    DATEPART(YEAR, td.started_at),
    DATEPART(MONTH, td.started_at),
    td.member_casual,
    td.day_of_week,
    CASE 
        WHEN CONVERT(time, td.started_at) >= '05:00:00' AND CONVERT(time, td.started_at) < '12:00:00' THEN 'morning'
        WHEN CONVERT(time, td.started_at) >= '12:00:00' AND CONVERT(time, td.started_at) < '17:00:00' THEN 'afternoon'
        ELSE 'evening'
    END
ORDER BY period_yr, period_mo, td.day_of_week, time_of_day;
*/
/*
Future Analysis Note
That query for grouping by CAST(started_at AS DATE) is indeed best run overnight or loaded into a temp table:
*/
--SELECT 
--    CAST(started_at AS DATE) AS trip_date,
--	member_casual AS member_type,
--    COUNT(*) AS total_trips,
--    COUNT(DISTINCT CAST(started_at AS TIME)) AS unique_start_times,
--    MIN(started_at) AS first_trip,
--    MAX(started_at) AS last_rtip
--INTO [divvy-trip_date_summary_by_customer_type]
--FROM dbo.[divvy-tripdata]
--GROUP BY CAST(started_at AS DATE), member_casual;
--
--
/*
SELECT 
  --CAST([period_yr] AS varchar(4)) AS period_year,
  CAST([period_yr] AS varchar(4)) + RIGHT('0' + CAST([period_mo] AS varchar(2)), 2) AS period_id,
  [dow],
  [customer_type],
  [time_of_day],
  SUM([ride_count]) AS sum_ride_count,
  AVG([avg_ride_length]) AS avg_ride_length_2
FROM [GDAC].[dbo].[div_py_pm_dow_tod_2019_2020]
GROUP BY CAST([period_yr] AS varchar(4)) + RIGHT('0' + CAST([period_mo] AS varchar(2)), 2) , dow, customer_type, time_of_day
ORDER BY period_id
	, CASE dow 
		WHEN 'Sun' THEN 1 
		WHEN 'Mon' THEN 2 
		WHEN 'Tue' THEN 3  
		WHEN 'Wed' THEN 4 
		WHEN 'Thu' THEN 5 
		WHEN 'Fri' THEN 6 
		ELSE 7 
	END
	, customer_type
	, CASE time_of_day 
		WHEN 'morning' THEN 1 
		WHEN 'afternoon' THEN 2 
		ELSE 3 
	END

*/
SELECT SUBSTRING(period_id,1,4) AS period_yr 
	,SUBSTRING(period_id,1,4)+
	CASE substring(period_id,5,2) 
		WHEN '01' THEN 'Q1'
		WHEN '02' THEN 'Q1'
		WHEN '03' THEN 'Q1'
		WHEN '04' THEN 'Q2'
		WHEN '05' THEN 'Q2'
		WHEN '06' THEN 'Q2'
		WHEN '07' THEN 'Q3'
		WHEN '08' THEN 'Q3'
		WHEN '09' THEN 'Q3'
		WHEN '10' THEN 'Q4'
		WHEN '11' THEN 'Q4'
		WHEN '12' THEN 'Q4'
		END AS prd_qtr 
		, dow
		, customer_type
		, SUM(sum_ride_count) AS sum_ride_count
		, AVG(avg_ride_length_2) AS avg_ride_length3
FROM [dbo].[divvy_pid_ct_dow_tod_rc_arl_vw] 
GROUP BY SUBSTRING(period_id,1,4)
	,SUBSTRING(period_id,1,4)+
	CASE substring(period_id,5,2) 
		WHEN '01' THEN 'Q1'
		WHEN '02' THEN 'Q1'
		WHEN '03' THEN 'Q1'
		WHEN '04' THEN 'Q2'
		WHEN '05' THEN 'Q2'
		WHEN '06' THEN 'Q2'
		WHEN '07' THEN 'Q3'
		WHEN '08' THEN 'Q3'
		WHEN '09' THEN 'Q3'
		WHEN '10' THEN 'Q4'
		WHEN '11' THEN 'Q4'
		WHEN '12' THEN 'Q4'
		END
		,dow,customer_type 
ORDER BY prd_qtr
	, CASE dow 
		WHEN 'Sun' THEN 1 
		WHEN 'Mon' THEN 2 
		WHEN 'Tue' THEN 3  
		WHEN 'Wed' THEN 4 
		WHEN 'Thu' THEN 5 
		WHEN 'Fri' THEN 6 
		ELSE 7 
	END
	, customer_type
SELECT * FROM [dbo].[divvy-trip_date_summary] WHERE YEAR(trip_date) IN (2019, 2020) ORDER BY trip_date
SELECT * FROM [dbo].[divvy-trip_date_summary_by_customer_type] WHERE YEAR(trip_date) IN (2019, 2020) ORDER BY trip_date, member_type
SELECT * FROM [dbo].[divvy-trip_date_summary_by_period_customer_type_vw] where SUBSTRING(trip_period, 1,4) in ('2019', '2020') ORDER BY trip_period, member_type

SELECT * FROM [dbo].[divvy_bad_trip_counts_by_period_vw] where SUBSTRING(bd_period, 1,4) in ('2019', '2020') 


--
/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000) [trip_date]
--      ,[member_type]
--      ,[total_trips]
--      ,[unique_start_times]
--      ,[first_trip]
--      ,[last_rtip]
--  FROM [GDAC].[dbo].[divvy-trip_date_summary_by_customer_type]
--  ORDER BY trip_date, member_type


--SELECT TOP (1000) CAST(YEAR(trip_date) AS char(4))+
--	CASE MONTH(trip_date) 
--		WHEN 1 THEN '01'
--		WHEN 2 THEN '01'
--		WHEN 3 THEN '01'
--		WHEN 4 THEN '02'
--		WHEN 5 THEN '02'
--		WHEN 6 THEN '02'
--		WHEN 7 THEN '03'
--		WHEN 8 THEN '03'
--		WHEN 9 THEN '03'
--		WHEN 10 THEN '04'
--		WHEN 11 THEN '04'
--		WHEN 12 THEN '04'
--	END AS trip_period
--	, [member_type]
--	, SUM([total_trips]) AS total_trips
--	, MIN(trip_date) AS first_trip
--	, MAX(trip_date) AS last_rtip
--FROM [GDAC].[dbo].[divvy-trip_date_summary_by_customer_type]
--GROUP BY CAST(YEAR(trip_date) AS char(4))+
--	CASE MONTH(trip_date) 
--		WHEN 1 THEN '01'
--		WHEN 2 THEN '01'
--		WHEN 3 THEN '01'
--		WHEN 4 THEN '02'
--		WHEN 5 THEN '02'
--		WHEN 6 THEN '02'
--		WHEN 7 THEN '03'
--		WHEN 8 THEN '03'
--		WHEN 9 THEN '03'
--		WHEN 10 THEN '04'
--		WHEN 11 THEN '04'
--		WHEN 12 THEN '04'
--	END, member_type
--ORDER BY CAST(YEAR(trip_date) AS char(4))+
--	CASE MONTH(trip_date) 
--		WHEN 1 THEN '01'
--		WHEN 2 THEN '01'
--		WHEN 3 THEN '01'
--		WHEN 4 THEN '02'
--		WHEN 5 THEN '02'
--		WHEN 6 THEN '02'
--		WHEN 7 THEN '03'
--		WHEN 8 THEN '03'
--		WHEN 9 THEN '03'
--		WHEN 10 THEN '04'
--		WHEN 11 THEN '04'
--		WHEN 12 THEN '04'
--	END, member_type

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [trip_period]
      ,[member_type]
      ,[total_trips]
      ,[first_trip]
      ,[last_rtip]
FROM [GDAC].[dbo].[divvy-trip_date_summary_by_period_customer_type_vw]
ORDER BY trip_period, member_type


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT CASE 
			WHEN SUBSTRING([trip_period],5,2) IN ('01', '02','03') THEN SUBSTRING(trip_period,1,4)+'Q1' 
			WHEN SUBSTRING([trip_period],5,2) IN ('04', '05','06') THEN SUBSTRING(trip_period,1,4)+'Q2' 
			WHEN SUBSTRING([trip_period],5,2) IN ('07', '08','09') THEN SUBSTRING(trip_period,1,4)+'Q3' 
			WHEN SUBSTRING([trip_period],5,2) IN ('10', '11','12') THEN SUBSTRING(trip_period,1,4)+'Q4'
		END AS period_qtr
      ,[member_type]
      ,SUM([total_trips]) AS total_trips
      ,MIN([first_trip]) AS first_trip
      ,MAX([last_rtip]) AS last_trip
FROM [GDAC].[dbo].[divvy-trip_date_summary_by_period_customer_type_vw]
GROUP BY CASE 
			WHEN SUBSTRING([trip_period],5,2) IN ('01', '02','03') THEN SUBSTRING(trip_period,1,4)+'Q1' 
			WHEN SUBSTRING([trip_period],5,2) IN ('04', '05','06') THEN SUBSTRING(trip_period,1,4)+'Q2' 
			WHEN SUBSTRING([trip_period],5,2) IN ('07', '08','09') THEN SUBSTRING(trip_period,1,4)+'Q3' 
			WHEN SUBSTRING([trip_period],5,2) IN ('10', '11','12') THEN SUBSTRING(trip_period,1,4)+'Q4'
		END
      ,[member_type]
ORDER BY period_qtr, member_type


SELECT 
  CAST(YEAR(td.[started_at]) AS varchar(4)) AS period_year
  ,RIGHT('0' + CAST(MONTH(td.[started_at]) AS varchar(2)), 2) AS period_mo
  ,td.[member_casual] AS customer_type
  ,CASE td.day_of_week
	WHEN 1 THEN 'Sun'
	WHEN 2 THEN 'Mon'
	WHEN 3 THEN 'Tue'
	WHEN 4 THEN 'Wed'
	WHEN 5 THEN 'Thu'
	WHEN 6 THEN 'Fri'
	WHEN 7 THEN 'Sat'
	END AS dow
  ,[time_of_day],
  SUM([ride_count]) AS sum_ride_count,
  AVG([avg_ride_length]) AS avg_ride_length_2
FROM [GDAC].[dbo].[divvy-tripdata] td
GROUP BY CAST([period_yr] AS varchar(4)) + RIGHT('0' + CAST([period_mo] AS varchar(2)), 2) , dow, customer_type, time_of_day
ORDER BY period_id
	, CASE dow 
		WHEN 'Sun' THEN 1 
		WHEN 'Mon' THEN 2 
		WHEN 'Tue' THEN 3  
		WHEN 'Wed' THEN 4 
		WHEN 'Thu' THEN 5 
		WHEN 'Fri' THEN 6 
		ELSE 7 
	END
	, customer_type
	, CASE time_of_day 
		WHEN 'morning' THEN 1 
		WHEN 'afternoon' THEN 2 
		ELSE 3 
	END

USE GDAC
GO
--
SELECT 
  YEAR(dt.started_at) AS period_yr
  , CASE 
    WHEN MONTH(dt.started_at) IN (1, 2, 3) THEN 'Q1'
    WHEN MONTH(dt.started_at) IN (4, 5, 6) THEN 'Q2'
    WHEN MONTH(dt.started_at) IN (7, 8, 9) THEN 'Q3'
    WHEN MONTH(dt.started_at) IN (10, 11, 12) THEN 'Q4'
  END AS period_qtr
  ,dt.member_casual
  ,count(ride_id) AS nmbr_rides
  ,ROUND(
    AVG(DATEDIFF(SECOND, 0, CAST(dt.ride_length AS time))) / 60.0,
    1
  ) AS avg_ride_minutes
FROM [dbo].[divvy-tripdata] dt
GROUP BY 
  YEAR(dt.started_at),
  CASE 
    WHEN MONTH(dt.started_at) IN (1, 2, 3) THEN 'Q1'
    WHEN MONTH(dt.started_at) IN (4, 5, 6) THEN 'Q2'
    WHEN MONTH(dt.started_at) IN (7, 8, 9) THEN 'Q3'
    WHEN MONTH(dt.started_at) IN (10, 11, 12) THEN 'Q4'
  END,
  dt.member_casual
ORDER BY period_yr, period_qtr, dt.member_casual;
