SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tim Andaya
-- Create date: 2025/05/15
-- Description:	Populates [dbo].[divvy-files]
--	with records necessary for for the stored
--	procedure, [dbo].[up_load_divvy].
-- Intent; get list of csv files from the 
--	designated directory and set flags for 
--	which section of the dependent store
--	procedure thje files will be processed in.
-- =============================================
CREATE PROCEDURE [dbo].[up_get_divvy_file_list] 
AS
BEGIN

EXEC sp_configure 'show advanced options', '1'
RECONFIGURE
-- this enables xp_cmdshell
	EXEC sp_configure 'xp_cmdshell', '1' 
	RECONFIGURE

TRUNCATE TABLE [dbo].[divvy-files];

declare @files table (ID int IDENTITY, FileName varchar(100));

insert into @files execute xp_cmdshell 'dir E:\GDAC\CS1 /b';

DELETE FROM @files where RIGHT(FileName,10) = '_PyTgt.csv';

DELETE FROM @files where RIGHT(FileName,3) = 'xml';

DELETE FROM @files where FileName IS NULL;

DELETE FROM @files where FileName = 'divvy-files.txt'

INSERT INTO [dbo].[divvy-files]([file_name],py_tgt, [type])
SELECT FileName
	, LEFT(FileName,LEN(FileName)-4)+'_PyTgt.csv' AS py_tgt
	, 1 FROM @files

UPDATE f
	SET type = 1 
FROM [dbo].[divvy-files] f
WHERE RIGHT(file_name,12)  = 'tripdata.csv'

UPDATE f
	SET type = 2 
FROM [dbo].[divvy-files] f
WHERE SUBSTRING(file_name,13,4) = '2019'


EXEC sp_configure 'xp_cmdshell', '0' 
RECONFIGURE

END
GO
