USE [GDAC]
GO

/****** Object:  Table [dbo].[divvy-tripdata-tmp]    Script Date: 4/15/2025 10:13:51 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[divvy-tripdata]') AND type in (N'U'))
DROP TABLE [dbo].[divvy-tripdata-tmp]
GO

/****** Object:  Table [dbo].[divvy-tripdata-tmp]    Script Date: 4/15/2025 10:13:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[divvy-tripdata-tmp](		--	DTS Import specification
	[ride_id] [varchar](20) NULL,				--	DT_STR	20
	[rideable_type] [varchar](30) NULL,			--	DT_STR	30
	[started_at] [datetime] NULL,				--	DT_DATE
	[ended_at] [datetime] NULL,					--	DT_DATE
	[start_station_name] [varchar](50) NULL,	--	DT_STR	50
	[start_station_id] [int] NULL,				--	Eight Byte Unsigned INT
	[end_station_name] [varchar](50) NULL,		--	DT_STR	50
	[end_station_id] [int] NULL,				--	EIGHT Byte Unsigned INT
	[start_lat] [decimal](8, 6) NULL,			--	Float
	[start_lng] [decimal](9, 6) NULL,			--	Float
	[end_lat] [decimal](8, 6) NULL,				--	Float
	[end_lng] [decimal](9, 6) NULL,				--	Float
	[member_casual] [varchar](10) NULL,			--	Float
	[ride_length] [time](7) NULL,				--	DT_DATE
	[day_of_week] [int] NULL					--	EIGHT Byte Unsigned INT
) ON [PRIMARY]
GO



