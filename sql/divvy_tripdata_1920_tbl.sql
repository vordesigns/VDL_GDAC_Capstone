USE [GDAC]
GO

/****** Object:  Table [dbo].[divvy_tripdata_1920]    Script Date: 5/13/2025 10:07:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[divvy_tripdata_1920](
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
	[day_of_week] [int] NULL
) ON [PRIMARY]
GO


