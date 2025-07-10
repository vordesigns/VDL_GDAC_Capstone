USE [GDAC]
GO

/****** Object:  View [dbo].[divvy_mbr_pct_cas_vw]    Script Date: 5/14/2025 11:25:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER   VIEW [dbo].[divvy_mbr_pct_cas_vw]
AS
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
					, COUNT(ride_id) AS ride_count
                FROM            dbo.[divvy-tripdata] t1
                WHERE        (YEAR(started_at) < 2025)
                GROUP BY YEAR(started_at), member_casual
			) AS c1
			LEFT JOIN (select YEAR(started_at) AS period_yr, COUNT(ride_id) AS total_ride_count FROM [dbo].[divvy-tripdata] GROUP BY YEAR(started_at)
									) t2 ON c1.period_yr = t2.period_yr
				GROUP BY c1.period_yr, t2.total_ride_count
		) AS final
ORDER BY period_yr
GO


