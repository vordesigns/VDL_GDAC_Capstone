USE [GDAC]
GO

/****** Object:  Table [dbo].[divvy_bike_type_analysis_1]    Script Date: 7/3/2025 1:55:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[divvy_bike_type_analysis_1](
	[period_yr] [int] NULL,
	[period_id] [varchar](6) NULL,
	[customer_type] [varchar](10) NULL,
	[bike_type] [varchar](30) NULL,
	[bike_type_usage] [int] NULL,
	[max_ride_hours] [float] NULL,
	[avg_ride_hours] [float] NULL
) ON [PRIMARY]
GO


