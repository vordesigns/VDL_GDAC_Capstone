-- v6
TRUNCATE TABLE [dbo].[div_qtr_dow_tod_crc_mrc_arl];

TRUNCATE TABLE [dbo].[div_qtr_dow_tod_crc_mrc_arl_1920];

INSERT INTO [dbo].[div_qtr_dow_tod_crc_mrc_arl] 
SELECT 
    CAST(YEAR(started_at) AS CHAR(4)) AS period_yr,
    CONCAT(CAST(YEAR(started_at) AS CHAR(4)), 'Q', DATEPART(QUARTER, started_at)) AS prd_qtr,
    DATENAME(WEEKDAY, started_at) AS day_of_week_name,
    CASE 
        WHEN DATEPART(HOUR, started_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, started_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, started_at) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(CASE WHEN [member_casual] = 'casual' THEN [ride_id] END) AS casual_ride_count,
    COUNT(CASE WHEN [member_casual] = 'member' THEN [ride_id] END) AS member_ride_count,
    ROUND(AVG(CAST(DATEDIFF(SECOND, 0, TRY_CAST([ride_length] AS TIME)) AS FLOAT) / 60.0),-1) AS avg_ride_length_minutes,
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
    DATEPART(WEEKDAY, started_at),
    DATENAME(WEEKDAY, started_at),
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
ORDER BY prd_qtr, day_of_week_num,time_of_day_order;

INSERT INTO [dbo].[div_qtr_dow_tod_crc_mrc_arl_1920] 
SELECT * 
FROM [dbo].[div_qtr_dow_tod_crc_mrc_arl] 
WHERE period_yr IN ('1920', '2020')
ORDER BY prd_qtr, day_of_week_num,time_of_day_order;
