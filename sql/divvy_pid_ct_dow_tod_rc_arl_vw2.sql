USE [GDAC]
GO

/****** Object:  View [dbo].[divvy_pid_ct_dow_tod_rc_arl_vw2]    Script Date: 5/1/2025 3:59:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[divvy_pid_ct_dow_tod_rc_arl_vw2]
AS
SELECT TOP (100) PERCENT
  --CAST([period_yr] AS varchar(4)) AS period_year,
  CAST([period_yr] AS varchar(4)) + RIGHT('0' + CAST([period_mo] AS varchar(2)), 2) AS period_id,
  [dow],
  [customer_type],
  [time_of_day],
  SUM([ride_count]) AS sum_ride_count,
  AVG([avg_ride_length]) AS avg_ride_length_2
FROM [GDAC].[dbo].[div_py_pm_dow_tod]
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

GO

