USE [GDAC]
GO

/****** Object:  Table [dbo].[divvy_bad_trip_records]    Script Date: 4/28/2025 12:46:42 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[divvy_BadTripRecords]') AND type in (N'U'))
DROP TABLE [dbo].[divvy-bad_trip_records]
GO

/****** Object:  Table [dbo].[divvy_bad_trip_records]    Script Date: 4/28/2025 12:46:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[divvy-bad_trip_records](
	[ride_id] [varchar](20) NULL,
	[rideable_type] [varchar](30) NULL,
	[started_at] [datetime] NULL,
	[ended_at] [datetime] NULL,
	[start_station_name] [varchar](100) NULL,
	[start_station_id] [varchar](100) NULL,
	[end_station_name] [varchar](100) NULL,
	[end_station_id] [varchar](100) NULL,
	[start_lat] [decimal](8, 6) NULL,
	[start_lng] [decimal](9, 6) NULL,
	[end_lat] [decimal](8, 6) NULL,
	[end_lng] [decimal](9, 6) NULL,
	[member_casual] [varchar](10) NULL,
	[ride_length] [nvarchar](8) NULL,
	[day_of_week] [int] NULL,
	[reason] [varchar](100) NULL
) ON [PRIMARY]
GO


