USE GDAC
GO

--SELECT CAST(YEAR(started_at) AS char(4))+
--	CASE MONTH(started_at) WHEN 1 THEN '01'	WHEN 2 THEN '01' WHEN 3 THEN '01' 
--		WHEN 4 THEN '02' WHEN 5 THEN '02' WHEN 6 THEN '02'
--		WHEN 7 THEN '03' WHEN 8 THEN '03' WHEN 9 THEN '03'
--		WHEN 10 THEN '04' WHEN 11 THEN '04' WHEN 12 THEN '04'
--		END AS period, COUNT(*) AS NoStartStationCount 
--FROM [dbo].[divvy-tripdata] 
--WHERE RTRIM(ISNULL(start_station_id,'')) ='' OR start_station_id = 'NULL'
--GROUP BY CAST(YEAR(started_at) AS char(4))+
--	CASE MONTH(started_at) WHEN 1 THEN '01'	WHEN 2 THEN '01' WHEN 3 THEN '01' 
--		WHEN 4 THEN '02' WHEN 5 THEN '02' WHEN 6 THEN '02'
--		WHEN 7 THEN '03' WHEN 8 THEN '03' WHEN 9 THEN '03'
--		WHEN 10 THEN '04' WHEN 11 THEN '04' WHEN 12 THEN '04'
--		END

/****** div_qtr_dow_tod_crc_mrc_arl load tables  ******/ 
TRUNCATE TABLE [dbo].[div_qtr_dow_tod_crc_mrc_arl];

INSERT INTO [dbo].[div_qtr_dow_tod_crc_mrc_arl] 
SELECT 
    COUNT(CASE WHEN [member_casual] = 'casual' THEN [ride_id] END) AS casual_ride_count,
    ROUND(
        AVG(CASE 
                WHEN [member_casual] = 'casual' 
                THEN CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0
            END), -1) AS casual_avg_ride_minutes,
    COUNT(CASE WHEN [member_casual] = 'member' THEN [ride_id] END) AS member_ride_count,
    ROUND(
        AVG(CASE 
                WHEN [member_casual] = 'member' 
                THEN CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0
            END), -1) AS member_avg_ride_minutes,
    DATEPART(WEEKDAY, started_at) AS day_of_week_num,
    CASE 
        WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 1
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 2
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 3
        ELSE 4
    END AS time_of_day_order
FROM [dbo].[divvy-tripdata]
WHERE YEAR(started_at) < 2025

GROUP BY
    YEAR(started_at),
    DATEPART(QUARTER, started_at),
    DATENAME(WEEKDAY, started_at),
    DATEPART(WEEKDAY, started_at),
    CASE 
        WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END,
    CASE 
        WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 1
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 2
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 3
        ELSE 4
    END

ORDER BY prd_qtr, day_of_week_num, time_of_day_order;

TRUNCATE TABLE [dbo].[div_qtr_dow_tod_crc_mrc_arl_1920];

INSERT INTO [dbo].[div_qtr_dow_tod_crc_mrc_arl_1920] 
SELECT * 
FROM [dbo].[div_qtr_dow_tod_crc_mrc_arl] 
WHERE period_yr IN ('2019', '2020')
ORDER BY prd_qtr, day_of_week_num,time_of_day_order;

/****** div_qtr_dow_tod_crc_mrc_arl_1920 data frame query  ******/
SELECT TOP (1000) [period_yr]
      ,[prd_qtr]
      ,[day_of_week_name]
      ,[time_of_day]
      ,[casual_ride_count]
      ,[member_ride_count]
      ,[avg_ride_length_minutes]
      ,[day_of_week_num]
      ,[time_of_day_order]
  FROM [GDAC].[dbo].[div_qtr_dow_tod_crc_mrc_arl_1920]
  ORDER BY [prd_qtr],[day_of_week_num],[time_of_day_order]

    
/*** ***/
select YEAR(started_at) AS period_yr, 'all' AS total_ride_count
FROM [dbo].[divvy-tripdata] 

/* [dbo].[divvy_mbr_pct_cas_vw] */
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE OR ALTER VIEW [dbo].[divvy_mbr_pct_cas_vw]
--AS
--SELECT TOP (100) PERCENT period_yr
--	, ROUND(CAST(casual_ride_count AS FLOAT),0) AS casual_ride_count
--	, ROUND(CAST(member_ride_count AS FLOAT),0)AS member_ride_count
--	, ROUND(CAST(total_ride_count AS FLOAT),0) AS total_ride_count
--	, CASE WHEN member_ride_count > 0 THEN 
--		CAST(ROUND(CAST(member_ride_count AS FLOAT) / total_ride_count * 100, 2) AS VARCHAR(10)) + '%'
--			ELSE NULL END AS member_as_percent_of_total
--	, CASE WHEN casual_ride_count > 0 THEN 
--		CAST(ROUND(CAST(casual_ride_count AS FLOAT) / total_ride_count * 100, 2) AS VARCHAR(10)) + '%'
--			ELSE NULL END AS casual_as_percent_of_total
--FROM (
--		SELECT c1.period_yr
--		, t2.total_ride_count
--		, SUM(CASE WHEN customer_type = 'casual' THEN ride_count ELSE 0 END) AS casual_ride_count
--		, SUM(CASE WHEN customer_type = 'member' THEN ride_count ELSE 0 END) AS member_ride_count
--		FROM (
--				SELECT YEAR(started_at) AS period_yr
--					, member_casual AS customer_type
--					, COUNT(ride_id) AS ride_count
--                FROM            dbo.[divvy-tripdata] t1
--                WHERE        (YEAR(started_at) < 2025)
--                GROUP BY YEAR(started_at), member_casual
--			) AS c1
--			LEFT JOIN (select YEAR(started_at) AS period_yr, COUNT(ride_id) AS total_ride_count FROM [dbo].[divvy-tripdata] GROUP BY YEAR(started_at)
--									) t2 ON c1.period_yr = t2.period_yr
--				GROUP BY c1.period_yr, t2.total_ride_count
--		) AS final
--ORDER BY period_yr
--GO
SELECT * from [dbo].[divvy_mbr_pct_cas_vw] WHERE period_yr < 2025 ORDER BY period_yr
-- Long data conversion

SELECT period_yr, 'casual' AS customer_type, casual_ride_count AS ride_count, total_ride_count, casual_as_percent_of_total AS ride_pct from [dbo].[divvy_mbr_pct_cas_vw] WHERE period_yr < 2025
UNION ALL
SELECT period_yr, 'member' AS customer_type, member_ride_count AS ride_count, total_ride_count, member_as_percent_of_total AS ride_pct from [dbo].[divvy_mbr_pct_cas_vw] WHERE period_yr < 2025
ORDER BY period_yr

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

/** Load divvy-trip_date_summary table **/
--TRUNCATE TABLE [dbo].[divvy-trip_date_summary]

--INSERT INTO  [dbo].[divvy-trip_date_summary]
--SELECT 
--    CAST(started_at AS DATE) AS trip_date,
--    COUNT(*) AS total_trips,
--    COUNT(DISTINCT CAST(started_at AS TIME)) AS unique_start_times,
--    MIN(started_at) AS first_trip,
--    MAX(started_at) AS last_rtip
------INTO [divvy-trip_date_summary_by_customer_type]
--FROM dbo.[divvy-tripdata]
--GROUP BY CAST(started_at AS DATE) --, member_casual;
--ORDER BY CAST(started_at AS DATE), first_trip, last_rtip

--/*
--Future Analysis Note
--That query for grouping by CAST(started_at AS DATE) is indeed best run overnight or loaded into a temp table:
--Load divvy-trip_date_summary_by_customer_type
--*/
--TRUNCATE TABLE [dbo].[divvy-trip_date_summary_by_customer_type]

--INSERT INTO [dbo].[divvy-trip_date_summary_by_customer_type]
--SELECT 
--    CAST(started_at AS DATE) AS trip_date,
--	member_casual AS member_type,
--    COUNT(*) AS total_trips,
--    COUNT(DISTINCT CAST(started_at AS TIME)) AS unique_start_times,
--    MIN(started_at) AS first_trip,
--    MAX(started_at) AS last_rtip
------INTO [divvy-trip_date_summary_by_customer_type]
--FROM dbo.[divvy-tripdata]
--GROUP BY CAST(started_at AS DATE), member_casual;
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

--
-- GPS inspection and problem identification
--
--select distinct top 10 start_station_id, start_lat, start_lng from dbo.[divvy-tripdata] where start_station_id = '238'
--select distinct start_station_id, start_lat, start_lng from dbo.[divvy-tripdata] --where start_station_id = '238'

INSERT INTO [dbo].[divvy_gps_problem]
SELECT station_id, latitude, longitude,sum(rcount) AS rcount 
FROM (
	select * from( select ISNULL(start_station_id,'Z-ID_Missing') AS station_id, start_lat AS latitude, start_lng AS longitude, count(*) AS rcount from dbo.[divvy-tripdata] GROUP BY start_station_id, start_lat, start_lng HAVING COUNT(*) > 1 ) ss
	UNION ALL
	SELECT * FROM (select ISNULL(end_station_id,'Z-ID_Missing') AS station_id, end_lat AS latitude, end_lng AS longitude, count(*) AS rcount from dbo.[divvy-tripdata] GROUP BY end_station_id, end_lat, end_lng HAVING COUNT(*) > 1 ) es
	) us
GROUP BY station_id, latitude, longitude
ORDER BY station_id, latitude,longitude

--CREATE TABLE [dbo].[divvy_gps_problem](
--	[station_id] VARCHAR(100) NULL
--	, [latitude] DECIMAL(8,6) NULL
--	, [longitude] DECIMAL(8,6) NULL
--	, [rcount] INT NULL
--	)

SELECT TOP 10 * from [dbo].[divvy_gps_problem] WHERE [station_id] = '021320' ORDER BY station_id, latitude, longitude
select DISTINCT [station_id], COUNT(*) AS rcount FROM [dbo].[divvy_gps_problem] GROUP BY [station_id] HAVING COUNT(*) > 1 ORDER BY [station_id]

/*** Bad trip counts with reasons ***/
--
SELECT [bd_period]
      ,[reason]
      ,[rcount]
FROM [GDAC].[dbo].[divvy_bad_trip_counts_by_period_vw]
ORDER BY [bd_period], [reason]
--

--
SELECT TOP (100) PERCENT '000000' AS bd_period,'Total record count' AS reason, SUM(rcount) AS rcount from [dbo].[divvy_bad_trip_counts_by_period_vw] 
WHERE SUBSTRING(bd_period,1,4) IN (2019, 2020) 
UNION ALL
Select TOP (100) PERCENT * from [dbo].[divvy_bad_trip_counts_by_period_vw]
WHERE SUBSTRING(bd_period,1,4) IN (2019, 2020)
ORDER BY bd_period
--

--
-- Load divvy_mbr_rct_pct_tbl
TRUNCATE TABLE [dbo].[divvy_mbr_rct_pct];
--
INSERT INTO  [dbo].[divvy_mbr_rct_pct]
SELECT TOP (100) PERCENT period_yr
	, ROUND(CAST(casual_ride_count AS FLOAT),-1) AS casual_ride_count
	, ROUND(CAST(member_ride_count AS FLOAT),-1)AS member_ride_count
	, ROUND(CAST(total_ride_count AS FLOAT),-1) AS total_ride_count
	, CASE WHEN member_ride_count > 0 THEN 
		CAST(ROUND(CAST(member_ride_count AS FLOAT) / total_ride_count * 100, -1) AS VARCHAR(10)) + '%'
			ELSE NULL END AS member_as_percent_of_total
	, CASE WHEN casual_ride_count > 0 THEN 
		CAST(ROUND(CAST(casual_ride_count AS FLOAT) / total_ride_count * 100, -1) AS VARCHAR(10)) + '%'
			ELSE NULL END AS casual_as_percent_of_total
FROM (
		SELECT c1.period_yr
		, t2.total_ride_count
		, SUM(CASE WHEN customer_type = 'casual' THEN ride_count ELSE 0 END) AS casual_ride_count
		, SUM(CASE WHEN customer_type = 'member' THEN ride_count ELSE 0 END) AS member_ride_count
		FROM (
				SELECT YEAR(started_at) AS period_yr
					, member_casual AS customer_type
					, COUNT(*) AS ride_count
                FROM            dbo.[divvy-tripdata] t1
                WHERE        (YEAR(started_at) < 2025)
                GROUP BY YEAR(started_at), member_casual
			) AS c1
			LEFT JOIN (select YEAR(started_at) AS period_yr, COUNT(*) AS total_ride_count FROM [dbo].[divvy-tripdata] GROUP BY YEAR(started_at)
									) t2 ON c1.period_yr = t2.period_yr
				GROUP BY c1.period_yr, t2.total_ride_count
		) AS final
ORDER BY period_yr
--

--
-- Load divvy_mbr_rct_pct_frame
SELECT period_yr, 'casual' AS customer_type, casual_ride_count AS ride_count
	, total_ride_count, casual_as_percent_of_total AS ride_pct 
FROM [dbo].[divvy_mbr_rct_pct] WHERE period_yr < 2025
UNION ALL
SELECT period_yr, 'member' AS customer_type, member_ride_count AS ride_count
	, total_ride_count, member_as_percent_of_total AS ride_pct 
FROM [dbo].[divvy_mbr_rct_pct] WHERE period_yr < 2025
ORDER BY period_yr
--

-- div_ri_rss_stse_mc_rl_dow_down_maen_tod_frame
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ride_id]
      ,YEAR([started_at]) AS [year]
	  ,CAST(YEAR([started_at]) AS varchar(4))+
		  CASE RIGHT('0'+CAST(DATEPART(MONTH,[started_at]) AS varchar(2)),2)
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
			END AS per_qtr
	  ,[started_at] AS ride_start
	  --,CONVERT(char(10),[started_at],126) AS ride_start
	  ,[ended_at] AS ride_stop
      --,CONVERT(char(10),[ended_at], 126) AS ride_stop
      ,[member_casual]
      ,[day_of_week]
	  ,LEFT(DATENAME(WEEKDAY, started_at),3) AS day_of_week_name
	  ,CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
		END AS time_of_day
      ,ROUND(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0,0,-1) AS ride_minutes
--INTO [dbo].[divvy_ri_rss_stse_mc_rl_dow_down_maen_tod_1920]
  FROM [GDAC].[dbo].[divvy_tripdata_1920]
  ORDER BY [started_at], ride_id
--
SELECT * 
FROM [dbo].[divvy_ri_rss_stse_mc_rl_dow_down_maen_tod_1920]
ORDER BY [year], [ride_start], [ride_id]

--
SELECT YEAR([started_at]) AS [year]
	  ,CAST(YEAR([started_at]) AS varchar(4))+
		  CASE RIGHT('0'+CAST(DATEPART(MONTH,[started_at]) AS varchar(2)),2)
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
			END AS per_qtr
      ,[member_casual]
      ,[day_of_week]
	  ,LEFT(DATENAME(WEEKDAY, started_at),3) AS day_of_week_name
	  ,CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
		END AS time_of_day
	  --,ROUND(MIN(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0),0,-1) AS min_ride_minutes
      --,ROUND(MAX(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0),0,-1) AS max_ride_minutes
      ,ROUND((MAX(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0) /60.0),2,0)  AS max_ride_hour
	  ,ROUND(AVG(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0),0,-1) AS avg_ride_minutes
FROM [GDAC].[dbo].[divvy_tripdata_1920]
GROUP BY YEAR([started_at])
	,CAST(YEAR([started_at]) AS varchar(4))+
		  CASE RIGHT('0'+CAST(DATEPART(MONTH,[started_at]) AS varchar(2)),2)
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
      ,[member_casual]
      ,[day_of_week]
	  ,LEFT(DATENAME(WEEKDAY, started_at),3)
	  ,CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
		END
ORDER BY [year], per_qtr, [member_casual], day_of_week, time_of_day
--

--TRUNCATE TABLE [dbo].[divvy_ride_minutes_yr_dow_tod]
---- divvy_ride_minutes_yr_dow_tod
--INSERT INTO [dbo].[divvy_ride_minutes_yr_dow_tod]
--SELECT YEAR([started_at]) AS period_yr,
--	[member_casual] AS customer_type,
--	CASE [day_of_week]
--		WHEN 1 THEN 'Sun'
--		WHEN 2 THEN 'Mon'
--		WHEN 3 THEN 'Tue'
--		WHEN 4 THEN 'Wed'
--		WHEN 5 THEN 'Thu'
--		WHEN 6 THEN 'Fri'
--		WHEN 7 THEN 'Sat'
--	END AS dow,
--	CASE
--		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
--		WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
--		WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
--		ELSE 'Night'
--	END AS time_of_day,
--	[day_of_week] AS dow_num,
--	CASE
--		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 1
--		WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 2
--		WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 3
--		ELSE 4
--	END AS tod_num,
--	--(COUNT([ride_id])) AS sum_ride_ct,
--	ROUND(AVG(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0),0,-1) AS avg_ride_minutes,
--	ROUND(AVG(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0 / 60.0),1,0) AS avg_ride_hours
----INTO [dbo].[divvy_ride_minutes_yr_dow_tod]
----FROM [dbo].[divvy_tripdata_1920
--FROM [dbo].[divvy-tripdata] 
--GROUP BY YEAR([started_at]), 
--	member_casual, 
--	CASE [day_of_week]
--		WHEN 1 THEN 'Sun'
--		WHEN 2 THEN 'Mon'
--		WHEN 3 THEN 'Tue'
--		WHEN 4 THEN 'Wed'
--		WHEN 5 THEN 'Thu'
--		WHEN 6 THEN 'Fri'
--		WHEN 7 THEN 'Sat'
--	END,
--	CASE
--		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
--		WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
--		WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
--		ELSE 'Night'
--	END,
--	[day_of_week],
--	CASE
--		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 1
--		WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 2
--		WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 3
--		ELSE 4
--	END
--ORDER BY
--period_yr, customer_type, [day_of_week],tod_num
----

SELECT * 
FROM [dbo].[divvy_ride_minutes_yr_dow_tod]
ORDER BY period_yr, dow_num, tod_num

SELECT year AS period_yr
	, per_qtr
	, member_casual AS customer_type
	, ROUND(AVG(ride_minutes),0,-1) avg_ride_minutes
FROM [dbo].[divvy_ri_rss_stse_mc_rl_dow_down_maen_tod_1920]
GROUP BY [year], per_qtr, member_casual
ORDER BY [period_yr], [per_qtr], [customer_type]

SELECT year AS period_yr
	, per_qtr
	, member_casual AS customer_type
	, day_of_week AS dow_num
	, day_of_week_name AS dow
	, ROUND(AVG(ride_minutes),0,-1) avg_ride_minutes
FROM [dbo].[divvy_ri_rss_stse_mc_rl_dow_down_maen_tod_1920]
GROUP BY [year], per_qtr, member_casual, day_of_week, day_of_week_name
ORDER BY [period_yr], [per_qtr], dow_num, [customer_type]

--
-- Bike type
--
--
TRUNCATE TABLE [dbo].[divvy_bike_type_review]
--
INSERT INTO [dbo].[divvy_bike_type_review]
SELECT CAST(YEAR(started_at) AS CHAR(4)) AS period_yr
	, CONCAT(CAST(YEAR(started_at) AS CHAR(4)), 'Q', DATEPART(QUARTER, started_at)) AS period_qtr
	, CONCAT(CAST(YEAR(started_at) AS CHAR(4)), (RIGHT('0' + CAST(DATEPART(MONTH, started_at) AS VARCHAR(2)),2))) AS period_id
	, day_of_week AS dow_num
	  ,CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 1
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 2
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 3
        ELSE 4
		END AS tod_num
	  ,CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
		END AS tod_nam
	, CASE day_of_week
		WHEN 1 THEN 'Sun'
		WHEN 2 THEN 'Mon'
		WHEN 3 THEN 'Tue'
		WHEN 4 THEN 'Wed'
		WHEN 5 THEN 'Thu'
		WHEN 6 THEN 'Fri'
		WHEN 7 THEN 'Sat'
		END AS dow_nam
	, member_casual AS customer_type
	, rideable_type
	, count(*) AS ride_count
--INTO [dbo].[divvy_bike_type_review]
FROM [dbo].[divvy-tripdata]
GROUP BY
CAST(YEAR(started_at) AS CHAR(4))
	, CONCAT(CAST(YEAR(started_at) AS CHAR(4)), 'Q', DATEPART(QUARTER, started_at))
	, CONCAT(CAST(YEAR(started_at) AS CHAR(4)), (RIGHT('0' + CAST(DATEPART(MONTH, started_at) AS VARCHAR(2)),2)))
	, day_of_week
	  ,CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 1
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 2
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 3
        ELSE 4
		END
	  ,CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
		END
	, CASE day_of_week
		WHEN 1 THEN 'Sun'
		WHEN 2 THEN 'Mon'
		WHEN 3 THEN 'Tue'
		WHEN 4 THEN 'Wed'
		WHEN 5 THEN 'Thu'
		WHEN 6 THEN 'Fri'
		WHEN 7 THEN 'Sat'
		END
	, member_casual
	, rideable_type
ORDER BY period_yr
	, period_qtr
	, period_id
	, dow_num
	, tod_num
	, customer_type
	, rideable_type
---- 
SELECT * from [dbo].[divvy_bike_type_review]
--

--
SELECT CAST(YEAR(started_at) AS CHAR(4)) AS period_yr,
    CONCAT(CAST(YEAR(started_at) AS CHAR(4)), 'Q', DATEPART(QUARTER, started_at)) AS prd_qtr,
    DATENAME(WEEKDAY, started_at) AS dow_name,
    CASE 
        WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day
	, member_casual AS customer_type
	, rideable_type
	, day_of_week AS dow_num
	, count(*) AS ride_count
FROM [dbo].[divvy-tripdata]
GROUP BY
CAST(YEAR(started_at) AS CHAR(4)),
    CONCAT(CAST(YEAR(started_at) AS CHAR(4)), 'Q', DATEPART(QUARTER, started_at)),
    day_of_week,
	DATENAME(WEEKDAY, started_at),
    CASE 
        WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END
	, member_casual
	, rideable_type
ORDER BY period_yr, prd_qtr, dow_num
--

----
----	[dbo].[divvy_yr_ctype_rct_max_rh_min_rh_avg_rh]
--select CAST(DATEPART(YEAR,[started_at]) AS varchar(4)) AS period_yr
--	, [member_casual] AS customer_type
--	, COUNT(*) AS ride_count
--	, ROUND((MAX(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0) /60.0),2,0)  AS max_ride_hours
--	, ROUND((MIN(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0 /60.0)),2,0)  AS min_ride_hours
--	, ROUND((AVG(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0 /60.0)),2,0)  AS avg_ride_hours
----INTO [dbo].[divvy_yr_ctype_rct_max_rh_min_rh_avg_rh]
--FROM [dbo].[divvy-tripdata]
--WHERE YEAR(started_at) <= 2024
--GROUP BY CAST(DATEPART(YEAR,[started_at]) AS varchar(4))
--	, [member_casual]
--ORDER BY period_yr, customer_type
----
SELECT * FROM [dbo].[divvy_yr_ctype_rct_max_rh_min_rh_avg_rh] ORDER BY period_yr, customer_type

----
----
---- Bike Type Analysis 1
----
--
TRUNCATE TABLE [dbo].[divvy_bike_type_analysis_1]
--
INSERT INTO [dbo].[divvy_bike_type_analysis_1]
SELECT     DATEPART(YEAR, td.started_at) AS period_yr,
	CAST(YEAR(td.[started_at]) AS varchar(4)) + RIGHT('0' + CAST(MONTH(td.[started_at]) AS varchar(2)), 2) AS period_id,
	td.member_casual AS customer_type,
	td.[rideable_type] AS bike_type,
	COUNT(*) AS bike_type_usage,
    ROUND((MAX(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0) /60.0),2,0)  AS max_ride_hours,
	ROUND((AVG(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0) /60.0),2,0) AS avg_ride_hours
--INTO [dbo].[divvy_bike_type_analysis_1]
FROM [dbo].[divvy-tripdata] td
WHERE [rideable_type] <> ''
GROUP BY DATEPART(YEAR, td.started_at),
	CAST(YEAR(td.[started_at]) AS varchar(4)) + RIGHT('0' + CAST(MONTH(td.[started_at]) AS varchar(2)), 2),
	td.member_casual,
	td.[rideable_type]
ORDER BY period_id, customer_type, bike_type
--

SELECT * FROM [dbo].[divvy_bike_type_analysis_1] ORDER BY period_yr, bike_type_usage DESC

--
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [period_yr]
      ,[period_qtr]
      ,[period_id]
      ,[dow_num]
      ,[tod_num]
      ,[tod_nam]
      ,[dow_nam]
      ,[customer_type]
      ,CASE [rideable_type]
		WHEN '' THEN 'Not Provided'
		ELSE [rideable_type] END as rideable_type
      ,[ride_count]
  FROM [GDAC].[dbo].[divvy_bike_type_review]
  ORDER BY [period_yr]
      ,[period_qtr]
      ,[period_id]
      ,[dow_num]
      ,[tod_num]
      ,[tod_nam]
      ,[dow_nam]
      ,[customer_type]
      ,[rideable_type]

select distinct station_id, s.station_name
from (
select distinct start_station_id AS station_id, start_station_name as station_name
from [dbo].[divvy-tripdata]
union all
select distinct end_station_id AS station_id, end_station_name as station_name
from [dbo].[divvy-tripdata]) s
where station_name IS NOT NULL

--
-- 2025/06/27 Work
--
TRUNCATE TABLE dbo.divvy_ride_habits;
CHECKPOINT;
INSERT INTO dbo.divvy_ride_habits
SELECT 
	YEAR([started_at]) AS per_yr
	, CAST(YEAR([started_at]) AS varchar(4))+
		  CASE RIGHT('0'+CAST(DATEPART(MONTH,[started_at]) AS varchar(2)),2)
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
			END AS per_qtr
	, RIGHT('0'+CAST(MONTH(started_at) AS VARCHAR(2)),2) AS per_mo
	, RIGHT('0'+CAST(DAY(started_at) AS VARCHAR(2)),2) AS per_day
	, CASE day_of_week
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tue'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thu'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
      END AS dow
	, CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
	  END AS time_of_day
	, [member_casual] AS customer_type
--	, [started_at], [ended_at]
	, [start_station_name], [end_station_name]
	, COUNT(ride_id) AS ride_count
    , ROUND((MAX(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0) /60.0),2,0)  AS max_ride_hours
	, ROUND((AVG(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0) /60.0),2,0) AS avg_ride_hours
--	, [ride_length]
	, [day_of_week] AS dow_sort 
	, CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 1
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 2
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 2
        ELSE 4
		END AS tod_sort
FROM [dbo].[divvy-tripdata] WHERE YEAR(started_at) >= 2019 and YEAR(started_at) <= 2024
GROUP BY YEAR([started_at]), CAST(YEAR([started_at]) AS varchar(4))+
		  CASE RIGHT('0'+CAST(DATEPART(MONTH,[started_at]) AS varchar(2)),2)
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
		, RIGHT('0'+CAST(MONTH(started_at) AS VARCHAR(2)),2)
		, RIGHT('0'+CAST(DAY(started_at) AS VARCHAR(2)),2)
		, CASE day_of_week
			WHEN 1 THEN 'Sun'
			WHEN 2 THEN 'Mon'
			WHEN 3 THEN 'Tue'
			WHEN 4 THEN 'Wed'
			WHEN 5 THEN 'Thu'
			WHEN 6 THEN 'Fri'
			WHEN 7 THEN 'Sat'
			END
		, CASE
			WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
			WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
			WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
			ELSE 'Night'
			END
		, [member_casual]
		--, [started_at]
		--, [ended_at]
		, [start_station_name]
		, [end_station_name]
--		, [ride_length]
		, [day_of_week]
	, CASE
		WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 1
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 2
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 2
        ELSE 4
		END
ORDER BY [per_yr], per_qtr, per_mo, per_day, customer_type, dow_sort, tod_sort;

--SELECT *
--INTO dbo.divvy_bad_ride_habits
--FROM dbo.divvy_ride_habits WHERE start_station_name IS NULL;
--DELETE FROM dbo.divvy_ride_habits WHERE start_station_name IS NULL;
--INSERT INTO dbo.divvy_bad_ride_habits
--SELECT * 
--FROM dbo.divvy_ride_habits WHERE end_station_name IS NULL;
--DELETE FROM dbo.divvy_ride_habits WHERE end_station_name IS NULL;

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [per_yr]
      ,[per_qtr]
      ,[per_mo]
      ,[per_day]
      ,[dow]
      ,[time_of_day]
      ,[customer_type]
      ,[start_station_name]
      ,[end_station_name]
      ,[ride_count]
      ,[max_ride_hours]
      ,[avg_ride_hours]
      ,[dow_sort]
      ,[tod_sort]
  FROM [GDAC].[dbo].[divvy_ride_habits]
  ORDER BY per_qtr, start_station_name, end_station_name, per_yr, per_mo, per_day, dow_sort, tod_sort;


/*
--
query = "SELECT [per_yr]
      ,[per_qtr]
      ,[per_mo]
      ,[per_day]
      ,[dow]
      ,[time_of_day]
      ,[customer_type]
      ,[start_station_name]
      ,[end_station_name]
      ,[ride_count]
      ,[max_ride_hours]
      ,[avg_ride_hours]
      ,[dow_sort]
      ,[tod_sort]
  FROM [GDAC].[dbo].[divvy_ride_habits] WHERE per_yr IN (2019, 2020)
  ORDER BY per_qtr, start_station_name, end_station_name, per_yr, per_mo, per_day, dow_sort, tod_sort;"
div_ride_habits_1920 <- fetch_data(con, query)
--
*/

--
-- Top 20 casual user departure stations 2019-2020
SELECT start_station_id, start_station_name, ride_count
FROM (
SELECT TOP 20 start_station_id, start_station_name, member_casual, count(ride_id) AS ride_count
FROM [dbo].[divvy-tripdata] WHERE start_station_id IS NOT NULL AND member_casual = 'casual' AND YEAR(started_at) BETWEEN 2019 AND 2020
GROUP BY start_station_id, member_casual, start_station_name
ORDER by ride_count DESC, start_station_id
) tsd
ORDER by ride_count DESC, start_station_id
--
