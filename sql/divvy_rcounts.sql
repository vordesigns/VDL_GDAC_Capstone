SELECT YEAR(started_at) AS an_year, MONTH(started_at) AS an_month,  
	count(ride_id) AS rcount FROM [GDAC].[dbo].[divvy-tripdata]
WHERE YEAR(started_at) IN (2019, 2020)
GROUP BY YEAR(started_at), MONTH(started_at)
ORDER BY an_year, an_month
