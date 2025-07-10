USE [GDAC]
GO

/****** Object:  Table [dbo].[divvy-tripdata]    Script Date: 4/15/2025 10:13:51 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[divvy-tripdata]') AND type in (N'U'))
DROP TABLE [dbo].[divvy-tripdata]
GO

/****** Object:  Table [dbo].[divvy-tripdata]    Script Date: 4/15/2025 10:13:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[divvy-tripdata](		--	DTS Import specification
	[ride_id] [varchar](20) NULL,				--	DT_STR	20				RAW DATA
	[rideable_type] [varchar](30) NULL,			--	DT_STR	30				RAW DATA
	[started_at] [datetime] NULL,				--	DT_DATE					RAW DATA
	[ended_at] [datetime] NULL,					--	DT_DATE					RAW DATA
	[start_station_name] [varchar](50) NULL,	--	DT_STR	50				RAW DATA
	[start_station_id] [int] NULL,				--	Four Byte Unsigned INT	RAW DATA
	[end_station_name] [varchar](50) NULL,		--	DT_STR	50				RAW DATA
	[end_station_id] [int] NULL,				--	Four Byte Unsigned INT	RAW DATA
	[start_lat] [decimal](8, 6) NULL,			--	Float					RAW DATA
	[start_lng] [decimal](9, 6) NULL,			--	Float					RAW DATA
	[end_lat] [decimal](8, 6) NULL,				--	Float					RAW DATA
	[end_lng] [decimal](9, 6) NULL,				--	Float					RAW DATA
	[member_casual] [varchar](10) NULL,			--	Float					RAW DATA
	[ride_length] [time](7) NULL,				--	DT_DATE					CALCULATED 
	[day_of_week] [int] NULL					--	Four Byte Unsigned INT	CALCULATED
) ON [PRIMARY]
GO



