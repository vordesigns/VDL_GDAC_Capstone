--USE [GDAC]
--GO

--/****** Object:  Table [dbo].[divvy_trips_xxxx_qx]    Script Date: 4/21/2025 11:23:08 AM ******/
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[divvy_trips_xxxx_qx]') AND type in (N'U'))
--DROP TABLE [dbo].[divvy_trips_xxxx_qx]
--GO

--/****** Object:  Table [dbo].[divvy_trips_xxxx_qx]    Script Date: 4/21/2025 11:23:08 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[divvy_trips_xxxx_qx](		    --	DTS Import specification	Comment
--	[trip_id] [varchar](20) NULL,				    --	DT_
--	[start_time] [datetime] NULL,				    --	DT_DATE					    RAW DATA
--	[end_time] [datetime] NULL,						--	DT_DATE					    RAW DATA
--	[bikeid] [varchar](50) NULL,				    --	DT_STR	50					RAW DATA
--	[tripduration] [varchar](100) NULL,				--	DT_STR	100					RAW DATA
--	[from_station_id] [varchar](100) NULL,			--	DT_STR	100					RAW DATA
--	[from_station_name] [varchar](100) NULL,		--	DT_STR	100					RAW DATA
--	[to_station_id] [varchar](100) NULL,			--	DT_STR	100					RAW DATA
--	[to_station_name] [varchar](100) NULL,			--	DT_STR	100					RAW DATA
--	[usertype] [varchar](100) NULL,					--	DT_STR	100					RAW DATA
--	[gender] [varchar](50) NULL,				    --	DT_STR	50					RAW DATA
--	[birthyear] [varchar](50) NULL,				    --	DT_STR	50					RAW DATA
--	[ride_length] [varchar](50) NULL,				--	DT_STR	50					CALCULATED
--	[day_of_week] [varchar](50) NULL				--	DT_STR	50					CALCULATED
--) ON [PRIMARY]
--GO


