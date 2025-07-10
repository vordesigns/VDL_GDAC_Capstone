/****** Source .CSV Files List  ******/
--
-- [dbo].[divvy-files]
--
--
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
--
/****** Load trip-base trip-data records  ******/
--[dbo].[divvy-tripdata]
	DECLARE	@return_value int -- 0 = All / 1 = tripdata / 2 = Quarterly 
	EXEC	@return_value = [dbo].[up_load_divvy]
  			@task = 0 -- Default, load all
	SELECT	'Return Value' = @return_value;
--
/****** Load quarterly records into staging table  ******/
--[dbo].[divvy_trips_xxxx_qx]
	DECLARE	@return_value int -- 0 = All / 1 = tripdata / 2 = Quarterly 
	EXEC	@return_value = [dbo].[up_load_divvy]
  			@task = 2 -- Default, load all
	SELECT	'Return Value' = @return_value;

--
--[dbo].[divvy-bad_trip_records]
--

--
-- [dbo].[divvy-tripdata_duplicates]
--

--
-- [dbo].[divvy-tripdata_duplicate_ride_id_counts]
--

--
-- [dbo].[divvy_gps_problem]
--

--[dbo].[div_py_pm_dow_tod]
--
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
	WHERE DATEPART(YEAR, td.started_at) IN (2019, 2020, 2021, 2022, 2023, 2024)
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
--
/****** Year/Month/CustType/Day of Week   ******/
	SELECT [period_yr]
		  ,[period_mo]
		  ,[customer_type]
		  ,[dow]
		  ,[time_of_day]
		  ,[ride_count]
		  ,[avg_ride_length]
	FROM [GDAC].[dbo].[div_py_pm_dow_tod]
	WHERE period_yr BETWEEN 2019 and 2024
--

--
-- [dbo].[div_py_pm_dow_tod_2019_2020]
--
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

/****** Year/Month/CustType/Day of Week   ******/
	SELECT [period_yr]
		  ,[period_mo]
		  ,[customer_type]
		  ,[dow]
		  ,[time_of_day]
		  ,[ride_count]
		  ,[avg_ride_length]
	FROM [GDAC].[dbo].[div_py_pm_dow_tod]
	WHERE period_yr IN (2019, 2020)
--
-- [dbo].[div_py_pm_dow_tod_2019_2020]

