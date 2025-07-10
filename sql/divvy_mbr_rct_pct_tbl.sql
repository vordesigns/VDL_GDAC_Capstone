USE [GDAC]
GO

/****** Object:  Table [dbo].[divvy_mbr_rct_pct]    Script Date: 5/14/2025 11:47:00 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[divvy_mbr_rct_pct]') AND type in (N'U'))
DROP TABLE [dbo].[divvy_mbr_rct_pct]
GO

/****** Object:  Table [dbo].[divvy_mbr_rct_pct]    Script Date: 5/14/2025 11:47:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[divvy_mbr_rct_pct](
	[period_yr] [int] NOT NULL,
	[casual_ride_count] [float] NOT NULL,
	[member_ride_count] [float] NOT NULL,
	[total_ride_count] [float] NOT NULL,
	[member_as_percent_of_total] [varchar](4) NOT NULL,
	[casual_as_percent_of_total] [varchar](4) NOT NULL
) ON [PRIMARY]
GO


