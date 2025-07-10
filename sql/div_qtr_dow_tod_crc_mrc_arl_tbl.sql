USE [GDAC]
GO

/****** Object:  Table [dbo].[div_qtr_dow_tod_crc_mrc_arl]    Script Date: 5/13/2025 5:12:21 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[div_qtr_dow_tod_crc_mrc_arl]') AND type in (N'U'))
DROP TABLE [dbo].[div_qtr_dow_tod_crc_mrc_arl]
GO

/****** Object:  Table [dbo].[div_qtr_dow_tod_crc_mrc_arl]    Script Date: 5/13/2025 5:12:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[div_qtr_dow_tod_crc_mrc_arl](
	[period_yr] [varchar](4) NOT NULL,
	[prd_qtr] [varchar](6) NOT NULL,
	[day_of_week_name] [varchar](10) NOT NULL,
	[time_of_day] [varchar](10) NOT NULL,
	[casual_ride_count] [numeric](18, 0) NOT NULL,
	[casual_avg_ride_minutes] [numeric](18, 0) NOT NULL,
	[member_ride_count] [numeric](18, 0) NOT NULL,
	[member_avg_ride_minutes] [numeric](18, 0) NOT NULL,
	[day_of_week_num] [int] NOT NULL,
	[time_of_day_order] [int] NOT NULL
) ON [PRIMARY]
GO


