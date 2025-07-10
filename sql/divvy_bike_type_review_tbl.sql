USE [GDAC]
GO

/****** Object:  Table [dbo].[divvy_bike_type_review]    Script Date: 7/3/2025 2:02:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[divvy_bike_type_review](
	[period_yr] [char](4) NULL,
	[period_qtr] [varchar](17) NOT NULL,
	[period_id] [varchar](6) NOT NULL,
	[dow_num] [int] NULL,
	[tod_num] [int] NOT NULL,
	[tod_nam] [varchar](9) NOT NULL,
	[dow_nam] [varchar](3) NULL,
	[customer_type] [varchar](10) NULL,
	[rideable_type] [varchar](30) NULL,
	[ride_count] [int] NULL
) ON [PRIMARY]
GO


