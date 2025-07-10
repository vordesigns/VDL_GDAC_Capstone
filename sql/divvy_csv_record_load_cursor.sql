--
-- SET UP 
--
EXEC sp_configure 'show advanced options', '1'
RECONFIGURE
-- this enables xp_cmdshell
	EXEC sp_configure 'xp_cmdshell', '1' 
	RECONFIGURE
	GO
	DECLARE @fn as VARCHAR(100);
	DECLARE @sql as NVARCHAR(500);
	DECLARE @prt as varchar(100)
	--
	TRUNCATE TABLE [dbo].[divvy-tripdata]
	TRUNCATE TABLE [dbo].[divvy_trips_xxxx_qx]
--
-- BUILD CURSOR1
--
GETFILELIST1:
	BEGIN
		DECLARE CUR_FILES CURSOR LOCAL FOR SELECT [py_tgt] from [dbo].[divvy-files] WHERE type = 1

		--GOTO LOADTABLES1

	END
--
-- LOAD TABLES 1
--
LOADTABLES1:
	SET @sql=''
	BEGIN
		OPEN CUR_FILES
			FETCH  NEXT FROM CUR_FILES INTO @fn
		WHILE @@FETCH_STATUS = 0
			BEGIN
				--
					SET @prt = SUBSTRING(@fn,1,LEN(@fn)-4)
					SET @sql = 'PRINT	'''+@fn+ '''
						BULK INSERT [dbo].[divvy-tripdata]
						FROM ''E:\GDAC\CS1\'+@fn+'''
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = '','',  --CSV field delimiter
						ROWTERMINATOR = ''\n'',   --Use to shift the control to next row
						ERRORFILE = ''E:\GDAC\CS1\'+@fn+'_ErrorRows.csv'',
						TABLOCK
						)'
					--PRINT @sql
					EXEC sp_executesql @sql
				FETCH NEXT FROM CUR_FILES INTO @fn 
			END
		CLOSE CUR_FILES
		DEALLOCATE CUR_FILES
	END

--
-- BUILD CURSOR2
--
GETFILELIST2:
	BEGIN
		DECLARE CUR_FILES CURSOR LOCAL FOR SELECT [py_tgt] from [dbo].[divvy-files] WHERE type = 2

		--GOTO LOADTABLES2

	END
--
-- LOAD TABLES 2
--
LOADTABLES2:
	SET @sql=''
	BEGIN
		OPEN CUR_FILES
			FETCH  NEXT FROM CUR_FILES INTO @fn
		WHILE @@FETCH_STATUS = 0
			BEGIN
				--
					SET @sql = 'PRINT	'''+@fn+ '''
						BULK INSERT [dbo].[divvy_trips_xxxx_qx]
						FROM ''E:\GDAC\CS1\'+@fn+'''
						WITH
						(
						FIRSTROW = 2,
						FIELDTERMINATOR = '','',  --CSV field delimiter
						ROWTERMINATOR = ''\n'',   --Use to shift the control to next row
						FORMATFILE = ''E:\GDAC\CS1\divvy_trips_xxxx_qx-c.xml'',
						ERRORFILE = ''E:\GDAC\CS1\'+@fn+'_ErrorRows.csv'',
						TABLOCK
						)'
					--PRINT @sql
					EXEC sp_executesql @sql
				FETCH NEXT FROM CUR_FILES INTO @fn 
			END
		CLOSE CUR_FILES
		DEALLOCATE CUR_FILES
	END


-- this disables xp_cmdshell
EXEC sp_configure 'xp_cmdshell', '0' 
RECONFIGURE
GO
--
