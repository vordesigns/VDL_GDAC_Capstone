USE [GDAC]
GO

/****** Object:  View [dbo].[divvy-trip_date_summary_by_period_customer_type_vw]    Script Date: 5/1/2025 4:33:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[divvy-trip_date_summary_by_period_customer_type_vw]
AS
SELECT        TOP (100) PERCENT CAST(YEAR(trip_date) AS char(4)) +  
	CASE 
		WHEN MONTH(trip_date) IN (1, 2, 3) THEN '01'
		WHEN MONTH(trip_date) IN (4, 5, 6) THEN '02'
		WHEN MONTH(trip_date) IN (7, 8, 9) THEN '03'
		WHEN MONTH(trip_date) IN (10, 11, 12) THEN '04'
	END AS trip_period, member_type
	, SUM(total_trips) AS total_trips
	, MIN(trip_date) AS first_trip
	, MAX(trip_date) AS last_rtip
FROM            dbo.[divvy-trip_date_summary_by_customer_type]
GROUP BY CAST(YEAR(trip_date) AS char(4)) +  
	CASE 
		WHEN MONTH(trip_date) IN (1, 2, 3) THEN '01'
		WHEN MONTH(trip_date) IN (4, 5, 6) THEN '02'
		WHEN MONTH(trip_date) IN (7, 8, 9) THEN '03'
		WHEN MONTH(trip_date) IN (10, 11, 12) THEN '04'
	END, member_type
ORDER BY trip_period, member_type
GO


