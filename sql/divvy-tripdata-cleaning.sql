
--/***	DATA IMPORT OF CSV FILES	**/
--USE [GDAC]
--GO
--DECLARE	@return_value int
--EXEC	@return_value = [dbo].[up_load_divvy]
--		@task = 0
--SELECT	'Return Value' = @return_value;
--GO
----
/*** Data transformations and cleanup analysis ***/
--
--	** CALCULATED FIELDS **
--
--	divvy_trips_xxxx_qx ride_length & day_of_week calculations
UPDATE dtxq
set ride_length = CONVERT(char(10),end_time-start_time, 108)
	-- CAST(CAST(ROUND(dbo.invoice_line.qty_shipped, 0) as int) as varchar(40))
	,day_of_week =CAST(CAST(ROUND(DATEPART(WEEKDAY,start_time), 0) AS INT) AS VARCHAR(1))
FROM [dbo].[divvy_trips_xxxx_qx] dtxq;

--
--	**	STARNDARDIZE member_casual VALUES IN QUARTERLY DATA **
--
-- casual
UPDATE dtxq
SET usertype = 'casual'
FROM [dbo].[divvy_trips_xxxx_qx] dtxq where usertype = 'Customer'
--
-- member
UPDATE dtxq
SET usertype = 'member'
FROM [dbo].[divvy_trips_xxxx_qx] dtxq where usertype = 'Subscriber'
--

--
--	divvy_tripdata ride_length & day_of_week calculations
UPDATE td
set ride_length = CONVERT(char(10),ended_at-started_at, 108)
	-- CAST(CAST(ROUND(dbo.invoice_line.qty_shipped, 0) as int) as varchar(40))
	,day_of_week =CAST(CAST(ROUND(DATEPART(WEEKDAY,started_at), 0) AS INT) AS VARCHAR(1))
FROM [dbo].[divvy-tripdata] td;
--

--
-- ** ADD QUARTERLY RECORDS TO divvy-tripdata
--
INSERT INTO [dbo].[divvy-tripdata](
	[ride_id]
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
	  )
SELECT 
	[trip_id] AS ride_id
	,[start_time]
	,[end_time]
	,'' AS rideable_type
	,[from_station_name] AS stat_station_name
	,[from_station_id] AS start_station_id
	,[to_station_name] AS end_station_name
	,[to_station_id] AS end_station_id
	,0 AS start_lat
	,0 AS start_lng
	,0 AS end_lat
	,0 AS end_lng
	,[usertype] AS member_casual
	,CONVERT(char(10),end_time-start_time, 108) AS ride_length
	,CAST(CAST(ROUND(DATEPART(WEEKDAY,start_time), 0) AS INT) AS VARCHAR(1)) AS day_of_week
  FROM [GDAC].[dbo].[divvy_trips_xxxx_qx]
 -- (3818004 rows affected)
 -- Completion time: 2025-04-24T10:49:10.9604695-07:00


--
--	** DUPLICATE RIDE_ID **
/*
Note: Use this only if ride_id is unique per row. Otherwise, consider ROW_NUMBER() 
partitioning or add a surrogate key for precise deletes.
*/

 --Detect Duplicate ride_ids
 --Integrity check:  !! DUPLICATES EXISTS !!
	--Next steps to consider, inserting into a cleaning table
	--and returning unique records to the divvy-tripdata
	--table.

----/*
----Store all duplicate records:
----*/
-- Get duplicate ride_id and counts
--
TRUNCATE TABLE [dbo].[divvy-tripdata_duplicate_ride_id_counts];
--
INSERT INTO [dbo].[divvy-tripdata_duplicate_ride_id_counts]
SELECT ride_id, COUNT(*) AS DuplicateCount
FROM dbo.[divvy-tripdata]
GROUP BY ride_id
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;
--
-- 420 rows affected
--
--
--  Empty divvy-tripdata_duplicates
--
TRUNCATE TABLE [dbo].[divvy-tripdata_duplicates];
GO
--
--  Load duplicate records backup
-- @@
INSERT INTO [dbo].[divvy-tripdata_duplicates]
	SELECT * FROM [dbo].[divvy-tripdata]
	WHERE ride_id IN (SELECT ride_id FROM [dbo].[divvy-tripdata_duplicate_ride_id_counts]);
--
DELETE FROM [dbo].[divvy-tripdata] WHERE ride_id IN (SELECT ride_id FROM [dbo].[divvy-tripdata_duplicate_ride_id_counts]);



--
SELECT top(100) *
FROM [divvy-tripdata]
WHERE CAST(started_at AS DATE) = '1900-01-01';
-- no records

SELECT top(100) *
FROM [divvy-tripdata]
WHERE [started_at] < '1901-01-01';
-- no records

SELECT top(100) *
FROM [divvy-tripdata]
WHERE [started_at]::time = [started_at];
--Msg 243, Level 16, State 4, Line 12
--Type started_at is not a defined system type.

SELECT TOP 100 started_at
FROM [divvy-tripdata]
WHERE ISDATE(started_at) = 0;

SELECT TOP 100 *,
  DATEDIFF(SECOND, started_at, ended_at) AS ride_seconds
FROM [dbo].[divvy-tripdata]
WHERE ended_at < started_at;

SELECT COUNT(*) --TOP 100 *
FROM [dbo].[divvy-tripdata]
WHERE ended_at < started_at;

SELECT  * 
FROM dbo.[divvy-tripdata]
WHERE DATEPART(YEAR, started_at) = 2020 and DATEPART(MONTH,started_at) = 12 and day_of_week = 3 and ride_length < '00:00:60'
ORDER BY ride_length


/*	Get total records count from divvy-tripdata */
--select count(*) from dbo.[divvy-tripdata]
--
-- 30,791,636 rows
--

/*
-- Date validity checks
*/
--SELECT CAST(started_at AS DATE) AS DateOnly, COUNT(*) AS Count
--FROM [divvy-tripdata]
--GROUP BY CAST(started_at AS DATE)
--ORDER BY DateOnly DESC;
--
-- produced dates within the year data range of 2019 through 2025
--

----
---- Check for records that start/end at the same time
----
--SELECT count(*)
--FROM dbo.[divvy-tripdata]
--WHERE started_at = ended_at;
----
---- Produces 2891 records
---- This leads me to believe that there are bad records that should be selected into 
---- a table for reference and removed from the data set
----

----
---- check for records that start at "exactly" midnight which are probably bad
----
--SELECT count(*)
--FROM dbo.[divvy-tripdata]
--WHERE CAST(started_at AS TIME) = '00:00:00';
----
---- Produces 106 records
---- This leads me to believe that they are bad records that should be selected into
---- a table for reference and removed from the data set
----

----
---- Check for records where the ride_length calculation produced 
---- inaapropriate results like NULL or 00:00:00
----
--PRINT 'Check for bad ride_length records'
--SELECT TOP 100 ride_id, started_at, ended_at, ride_length
--FROM dbo.[divvy-tripdata]
--WHERE ride_length IS NULL 
--   OR ride_length = '00:00:00'
--ORDER BY started_at;
----
---- Produces the capped 100 records
---- This leads me to believe that there are bad records that should be selected
---- into a table for reference and removed from the data set, it is possible that 
---- the previous query where the casted started_at to time - '00:00:00' will 
---- catch quite a few of these.


----
---- Check for trips that last more than a day
---- 
--PRINT 'Check for tips lasting more than a day'
--SELECT TOP 100 ride_id, started_at, ended_at, ride_length
--FROM dbo.[divvy-tripdata]
--WHERE DATEDIFF(DAY, started_at, ended_at) > 1
--ORDER BY started_at;
----
---- Produces the capped 100 records
----

----
---- You could also fine-tune this based on hours if the data suggests multi-hour rentals are rare:
----
--PRINT 'Check for duration greater than 24 hours'
--SELECT TOP 1000 ride_id, started_at, ended_at, ride_length
--FROM dbo.[divvy-tripdata]
--WHERE DATEDIFF(HOUR, started_at, ended_at) > 24
--ORDER BY started_at;
----
---- Produces the capped 100 records
----

--/*
--Consolidate All Suspicious Conditions Into One Table
--Let’s define a #BadTripRecords table with all identified flags:
--*/
--PRINT 'Bad Trip records temp table build'
--SELECT *
--INTO #BadTripRecords
--FROM dbo.[divvy-tripdata]
--WHERE
--      started_at = ended_at
--   OR CAST(started_at AS TIME) = '00:00:00'
--   OR ride_length IS NULL
--   OR ride_length = '00:00:00'
--   OR DATEDIFF(HOUR, started_at, ended_at) > 24;
----
--Select count(*) from #BadTripRecords
--Select * from 
----
---- Produces 32,071 records
----


----
---- Evaluate cleaing solutions:
---- Remove bade records from the main table using a WITH CTE construct to avoid re-evaluating the full WHERE clause:
----	Concern, no backup
---- NOT RUN
----
--WITH BadTrips AS (
--    SELECT ride_id
--    FROM dbo.[divvy-tripdata]
--    WHERE
--          started_at = ended_at
--       OR CAST(started_at AS TIME) = '00:00:00'
--       OR ride_length IS NULL
--       OR ride_length = '00:00:00'
--       OR DATEDIFF(HOUR, started_at, ended_at) > 24
--)
--DELETE FROM dbo.[divvy-tripdata]
--WHERE ride_id IN (SELECT ride_id FROM BadTrips);
----

/*
Note: Use this only if ride_id is unique per row. Otherwise, consider ROW_NUMBER() 
partitioning or add a surrogate key for precise deletes.
*/
--
-- Detect Duplicate ride_ids
-- Integrity check:  !! DUPLICATES EXISTS !!
--	Next steps to consider, inserting into a cleaning table
--	and returning unique records to the divvy-tripdata
--	table.
--
--SELECT ride_id, COUNT(*) AS DuplicateCount
--FROM dbo.[divvy-tripdata]
--GROUP BY ride_id
--HAVING COUNT(*) > 1
--ORDER BY DuplicateCount DESC;

----/*
----If you want to store the actual duplicate records:
----*/
----SELECT *
----INTO dbo.DuplicateRideIDs
----FROM dbo.[divvy-tripdata]
----WHERE ride_id IN (
----    SELECT ride_id
----    FROM dbo.[divvy-tripdata]
----    GROUP BY ride_id
----    HAVING COUNT(*) > 1
--
-- 420 rows affected
--
-- Push records that have duplicated ride_id into an evaluation table

/*
1. Create a BadTripRecords Table with Flag Reasons
We'll build a BadTripRecords table with the original row data plus a "Reason" column showing why it was flagged.
--
This builds a well-labeled and de-duplicated subset for auditing, future cleaning, or export.
*/
---- Step 1: Create the destination table
--CREATE TABLE dbo.divvy_BadTripRecords (
--    ride_id             VARCHAR(20),
--    rideable_type       VARCHAR(30),
--    started_at          DATETIME,
--    ended_at            DATETIME,
--    start_station_name  VARCHAR(100),
--    start_station_id    VARCHAR(100),
--    end_station_name    VARCHAR(100),
--    end_station_id      VARCHAR(100),
--    start_lat           DECIMAL(8,6),
--    start_lng           DECIMAL(9,6),
--    end_lat             DECIMAL(8,6),
--    end_lng             DECIMAL(9,6),
--    member_casual       VARCHAR(10),
--    ride_length         NVARCHAR(8),
--    day_of_week         INT,
--    reason              VARCHAR(100)  -- Reason for flag
--);
--
-- GO
---- Step 2: Populate with flagged records, tagging each with reason

-- ! Flush target table
TRUNCATE TABLE [dbo].[divvy-bad_trip_records];

-- A. Equal start and end datetime
-- SELECT COUNT(*) FROM dbo.[divvy-tripdata] WHERE started_at = ended_at;
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'started_at and ended_at are identical'
FROM dbo.[divvy-tripdata]
WHERE started_at = ended_at;
--
-- (2891 rows affected)
--

-- B. Midnight-only timestamps (possibly incomplete records)
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'started_at time is 00:00:00'
FROM dbo.[divvy-tripdata]
WHERE CAST(started_at AS TIME) = '00:00:00'
AND ride_id NOT IN (SELECT ride_id FROM [dbo].[divvy-bad_trip_records]);  -- Avoid duplicates
--
-- (106 rows affected)
--

-- C. Null or zero-length rides
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'Calculated ride_length is null or 00:00:00'
FROM dbo.[divvy-tripdata]
WHERE (ride_length IS NULL OR ride_length = '00:00:00')
AND ride_id NOT IN (SELECT ride_id FROM [dbo].[divvy-bad_trip_records]);
--
-- (1096 rows affected)
--

-- D. Rides lasting over 24 hours
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'ride_length longer than 24 hours'
FROM dbo.[divvy-tripdata]
WHERE DATEDIFF(HOUR, started_at, ended_at) > 24
AND ride_id NOT IN (SELECT ride_id FROM [dbo].[divvy-bad_trip_records]);
--
-- (27978 rows affected)
--

-- E. Rides with started_at after ended_at
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'rides that ended before they started'
FROM [dbo].[divvy-tripdata]
WHERE ended_at < started_at;

-- F. Rides that lasted less than a minute
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT  *, 'rides lasted less than a minute' 
FROM dbo.[divvy-tripdata]
WHERE ride_length < '00:00:60'


select reason, COUNT(*) AS record_count from [dbo].[divvy-bad_trip_records] GROUP BY reason


--
--CREATE VIEW [dbo].[vw_divvy_bad_trip_counts_by_period]
--
SELECT TOP (100) PERCENT '000000' AS bd_period,'Total record count' AS reason, COUNT(*) AS rcount from [dbo].[divvy-bad_trip_records]
UNION ALL
Select TOP (100) PERCENT * from [dbo].[divvy_bad_trip_counts_by_period_vw]
-- @@

--/****** Object:  View [dbo].[divvy_bad_trip_counts_by_period_vw]    Script Date: 5/6/2025 6:50:15 PM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


--CREATE VIEW [dbo].[divvy_bad_trip_counts_by_period_vw]
--AS
--Select TOP 100 PERCENT CAST(YEAR(started_at) AS char(4))+
--	CASE MONTH(started_at) WHEN 1 THEN '01'	WHEN 2 THEN '01' WHEN 3 THEN '01' 
--		WHEN 4 THEN '02' WHEN 5 THEN '02' WHEN 6 THEN '02'
--		WHEN 7 THEN '03' WHEN 8 THEN '03' WHEN 9 THEN '03'
--		WHEN 10 THEN '04' WHEN 11 THEN '04' WHEN 12 THEN '04'
--		END AS bd_period
--	, reason
--	, count(*) AS rcount
--FROM [dbo].[divvy-bad_trip_records] 
--GROUP BY CAST(YEAR(started_at) AS char(4))+
--	CASE MONTH(started_at) WHEN 1 THEN '01'	WHEN 2 THEN '01' WHEN 3 THEN '01' 
--		WHEN 4 THEN '02' WHEN 5 THEN '02' WHEN 6 THEN '02'
--		WHEN 7 THEN '03' WHEN 8 THEN '03' WHEN 9 THEN '03'
--		WHEN 10 THEN '04' WHEN 11 THEN '04' WHEN 12 THEN '04'
--		END 
--		,reason
--ORDER BY bd_period, reason

--GO


/*
 3. Remove Flagged Records from Main Table
🧭 Step-by-step breakdown:
We assume ride_id uniquely identifies a record.

We only remove records that exist in BadTripRecords, based on ride_id.
--
 Optional: Run this first to confirm how many would be deleted:
*/

SELECT COUNT(*) AS RecordsToDelete
FROM dbo.[divvy-tripdata]
WHERE ride_id IN (SELECT ride_id FROM [dbo].[divvy-bad_trip_records]);
--
-- Records to delete:  32,071 
-- (546843 rows affected)
--

/*
 Actual delete operation:
*/
BEGIN TRAN
DELETE FROM dbo.[divvy-tripdata]
WHERE ride_id IN (SELECT ride_id FROM [dbo].[divvy-bad_trip_records]);
--
-- (32071 rows affected) +
-- (546843)
-- COMMIT TRAN
--

 --CREATE TABLE [dbo].[div_py_pm_dow_tod](
	-- [period_yr] [int] NULL,
	-- [period_mo] [int] NULL,
	-- [customer_type] [varchar](10) NULL,
	-- [dow] [varchar](3) NULL,
	-- [time_of_day] [varchar](9) NOT NULL,
	-- [ride_count] [int] NULL,
	-- [avg_ride_length] [int] NULL
 --) ON [PRIMARY]


 SELECT TOP 20 [ride_length], 
       TRY_CAST([ride_length] AS TIME) AS cast_as_time
FROM [dbo].[divvy-tripdata]
WHERE [ride_length] IS NOT NULL