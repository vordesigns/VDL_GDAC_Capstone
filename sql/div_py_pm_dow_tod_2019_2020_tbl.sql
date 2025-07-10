USE [GDAC]
GO

/****** Object:  Table [dbo].[div_py_pm_dow_tod_2019_2020]    Script Date: 4/24/2025 3:19:22 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[div_py_pm_dow_tod_2019_2020]') AND type in (N'U'))
DROP TABLE [dbo].[div_py_pm_dow_tod_2019_2020]
GO

/****** Object:  Table [dbo].[div_py_pm_dow_tod_2019_2020]    Script Date: 4/24/2025 3:19:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[div_py_pm_dow_tod_2019_2020](
	[period_yr] [int] NULL,
	[period_mo] [int] NULL,
	[customer_type] [varchar](10) NULL,
	[dow] [varchar](3) NULL,
	[time_of_day] [varchar](9) NOT NULL,
	[ride_count] [int] NULL,
	[avg_ride_length] [int] NULL
) ON [PRIMARY]
GO


