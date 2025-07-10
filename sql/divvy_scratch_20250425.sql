SELECT top(100) *
FROM [divvy-tripdata]
WHERE CAST(started_at AS DATE) = '1900-01-01';
-- no records

SELECT top(100) *
FROM [divvy-tripdata]
WHERE [started_at] < '1901-01-01';
-- no records

SELECT top(100) *
FROM [divvy-tripdata]
WHERE [started_at]::time = [started_at];
--Msg 243, Level 16, State 4, Line 12
--Type started_at is not a defined system type.

SELECT CAST(started_at AS DATE) AS DateOnly, COUNT(*) AS Count
FROM [divvy-tripdata]
GROUP BY CAST(started_at AS DATE)
ORDER BY DateOnly DESC;

select count(*) from dbo.[divvy-tripdata]

-- bad data data cleaning analysis
SELECT count(*)
FROM dbo.[divvy-tripdata]
WHERE started_at = ended_at;

SELECT count(*)
FROM dbo.[divvy-tripdata]
WHERE CAST(started_at AS TIME) = '00:00:00';

SELECT TOP 100 ride_id, started_at, ended_at, ride_length
FROM dbo.[divvy-tripdata]
WHERE ride_length IS NULL 
   OR ride_length = '00:00:00'
ORDER BY started_at;
-- Produces records

/*
Now Let’s Add: Trips that last more than a day
These are usually errors, unless you're renting a bike across states (which seems unlikely):
*/
SELECT TOP 1000 ride_id, started_at, ended_at, ride_length
FROM dbo.[divvy-tripdata]
WHERE DATEDIFF(DAY, started_at, ended_at) > 1
ORDER BY started_at;
--

/*
You could also fine-tune this based on hours if the data suggests multi-hour rentals are rare:
*/
SELECT TOP 1000 ride_id, started_at, ended_at, ride_length
FROM dbo.[divvy-tripdata]
WHERE DATEDIFF(HOUR, started_at, ended_at) > 24
ORDER BY started_at;
--

/*
Consolidate All Suspicious Conditions Into One Table
Let’s define a #BadTripRecords table with all identified flags:
*/
SELECT *
INTO #BadTripRecords
FROM dbo.[divvy-tripdata]
WHERE
      started_at = ended_at
   OR CAST(started_at AS TIME) = '00:00:00'
   OR ride_length IS NULL
   OR ride_length = '00:00:00'
   OR DATEDIFF(HOUR, started_at, ended_at) > 24;
--

/*
Want to Clean Instead of Flag? Use CTE for Delete
You can remove them from the main table using a WITH CTE construct to avoid re-evaluating the full WHERE clause:
*/
WITH BadTrips AS (
    SELECT ride_id
    FROM dbo.[divvy-tripdata]
    WHERE
          started_at = ended_at
       OR CAST(started_at AS TIME) = '00:00:00'
       OR ride_length IS NULL
       OR ride_length = '00:00:00'
       OR DATEDIFF(HOUR, started_at, ended_at) > 24
)
DELETE FROM dbo.[divvy-tripdata]
WHERE ride_id IN (SELECT ride_id FROM BadTrips);
--

/*
Note: Use this only if ride_id is unique per row. Otherwise, consider ROW_NUMBER() 
partitioning or add a surrogate key for precise deletes.
*/

/*
Future Analysis Note
That query for grouping by CAST(started_at AS DATE) is indeed best run overnight or loaded into a temp table:
*/
SELECT 
    CAST(started_at AS DATE) AS TripDate,
    COUNT(*) AS TotalTrips,
    COUNT(DISTINCT CAST(started_at AS TIME)) AS UniqueStartTimes,
    MIN(started_at) AS FirstTrip,
    MAX(started_at) AS LastTrip
INTO TripDateSummary
FROM dbo.[divvy-tripdata]
GROUP BY CAST(started_at AS DATE);
--

/*
You can even index TripDateSummary if needed for dashboarding later.
*/

/*
1. Create a BadTripRecords Table with Flag Reasons
We'll build a BadTripRecords table with the original row data plus a "Reason" column showing why it was flagged.
--
This builds a well-labeled and de-duplicated subset for auditing, future cleaning, or export.
*/
-- Step 1: Create the destination table
CREATE TABLE dbo.BadTripRecords (
    ride_id             VARCHAR(20),
    rideable_type       VARCHAR(30),
    started_at          DATETIME,
    ended_at            DATETIME,
    start_station_name  VARCHAR(100),
    start_station_id    VARCHAR(100),
    end_station_name    VARCHAR(100),
    end_station_id      VARCHAR(100),
    start_lat           DECIMAL(8,6),
    start_lng           DECIMAL(9,6),
    end_lat             DECIMAL(8,6),
    end_lng             DECIMAL(9,6),
    member_casual       VARCHAR(10),
    ride_length         NVARCHAR(8),
    day_of_week         INT,
    reason              VARCHAR(100)  -- Reason for flag
);

-- Step 2: Populate with flagged records, tagging each with reason

-- A. Equal start and end datetime
INSERT INTO dbo.BadTripRecords
SELECT *, 'Start and end are identical'
FROM dbo.[divvy-tripdata]
WHERE started_at = ended_at;

-- B. Midnight-only timestamps (possibly incomplete records)
INSERT INTO dbo.BadTripRecords
SELECT *, 'Time is 00:00:00'
FROM dbo.[divvy-tripdata]
WHERE CAST(started_at AS TIME) = '00:00:00'
AND ride_id NOT IN (SELECT ride_id FROM dbo.BadTripRecords);  -- Avoid duplicates

-- C. Null or zero-length rides
INSERT INTO dbo.BadTripRecords
SELECT *, 'Ride length is null or 00:00:00'
FROM dbo.[divvy-tripdata]
WHERE (ride_length IS NULL OR ride_length = '00:00:00')
AND ride_id NOT IN (SELECT ride_id FROM dbo.BadTripRecords);

-- D. Rides lasting over 24 hours
INSERT INTO dbo.BadTripRecords
SELECT *, 'Ride longer than 24 hours'
FROM dbo.[divvy-tripdata]
WHERE DATEDIFF(HOUR, started_at, ended_at) > 24
AND ride_id NOT IN (SELECT ride_id FROM dbo.BadTripRecords);
--

/*
2. Detect Duplicate ride_ids
This is an excellent integrity check:
*/
SELECT ride_id, COUNT(*) AS DuplicateCount
FROM dbo.[divvy-tripdata]
GROUP BY ride_id
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;
--
/*
If you want to store the actual duplicate records:
*/
SELECT *
INTO dbo.DuplicateRideIDs
FROM dbo.[divvy-tripdata]
WHERE ride_id IN (
    SELECT ride_id
    FROM dbo.[divvy-tripdata]
    GROUP BY ride_id
    HAVING COUNT(*) > 1
);
--

/*
 3. Remove Flagged Records from Main Table
🧭 Step-by-step breakdown:
We assume ride_id uniquely identifies a record.

We only remove records that exist in BadTripRecords, based on ride_id.
--
 Optional: Run this first to confirm how many would be deleted:
*/
SELECT COUNT(*) AS RecordsToDelete
FROM dbo.[divvy-tripdata]
WHERE ride_id IN (SELECT ride_id FROM dbo.BadTripRecords);
--

/*
 Actual delete operation:
*/
DELETE FROM dbo.[divvy-tripdata]
WHERE ride_id IN (SELECT ride_id FROM dbo.BadTripRecords);
--

/*
Important Safeguards:
If ride_id is not unique per row (e.g., duplicates exist with the same ride_id but different timestamps), we’d need a more precise delete using a primary key or ROW_NUMBER()-based match.

You may want to archive flagged rows before deleting them from the main table (which you already did with BadTripRecords, nicely done).

If you want to back up the to-be-deleted records to another table first, just run:

sql
Copy
Edit
*/

SELECT *
INTO dbo.Backup_Tripdata_Deleted
FROM dbo.[divvy-tripdata]
WHERE ride_id IN (SELECT ride_id FROM dbo.BadTripRecords);
--

/*
Then follow up with the DELETE afterward.
*/

/*
Script Outline
1. Creates BadTripRecords table with reason tags.
2. Creates a backup of records to be deleted.
4. 3eletes flagged records from the main table.
4. Optional: Identifies duplicate ride_ids and saves them for inspection.
--
Full Cleanup Script
*/
-- STEP 1: Create a table to store flagged records with reasons
IF OBJECT_ID('dbo.BadTripRecords', 'U') IS NOT NULL DROP TABLE dbo.BadTripRecords;

CREATE TABLE dbo.BadTripRecords (
    ride_id             VARCHAR(20),
    rideable_type       VARCHAR(30),
    started_at          DATETIME,
    ended_at            DATETIME,
    start_station_name  VARCHAR(100),
    start_station_id    VARCHAR(100),
    end_station_name    VARCHAR(100),
    end_station_id      VARCHAR(100),
    start_lat           DECIMAL(8,6),
    start_lng           DECIMAL(9,6),
    end_lat             DECIMAL(8,6),
    end_lng             DECIMAL(9,6),
    member_casual       VARCHAR(10),
    ride_length         NVARCHAR(8),
    day_of_week         INT,
    reason              VARCHAR(100)
);

-- STEP 2: Populate BadTripRecords with flagged rows

-- A. started_at = ended_at
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'Start and end are identical'
FROM dbo.[divvy-tripdata]
WHERE started_at = ended_at;

-- B. Midnight-only time
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'Time is 00:00:00'
FROM dbo.[divvy-tripdata]
WHERE CAST(started_at AS TIME) = '00:00:00'
  AND ride_id NOT IN (SELECT ride_id FROM dbo.BadTripRecords);

-- C. ride_length null or zero
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'Ride length is null or 00:00:00'
FROM dbo.[divvy-tripdata]
WHERE (ride_length IS NULL OR ride_length = '00:00:00')
  AND ride_id NOT IN (SELECT ride_id FROM dbo.BadTripRecords);

-- D. Over 24-hour duration
INSERT INTO [dbo].[divvy-bad_trip_records]
SELECT *, 'Ride longer than 24 hours'
FROM dbo.[divvy-tripdata]
WHERE DATEDIFF(HOUR, started_at, ended_at) > 24
  AND ride_id NOT IN (SELECT ride_id FROM dbo.BadTripRecords);

---- STEP 3: Backup flagged rows before deletion (optional but recommended)
--IF OBJECT_ID('dbo.Backup_Tripdata_Deleted', 'U') IS NOT NULL DROP TABLE dbo.Backup_Tripdata_Deleted;

--SELECT *
--INTO dbo.Backup_Tripdata_Deleted
--FROM dbo.[divvy-tripdata]
--WHERE ride_id IN (SELECT ride_id FROM dbo.BadTripRecords);

-- STEP 4: Delete bad rows from main table
DELETE FROM dbo.[divvy-tripdata]
WHERE ride_id IN (SELECT ride_id FROM [dbo].[divvy-bad_trip_records]);

-- STEP 5: (Optional) Identify and store duplicate ride_id rows
IF OBJECT_ID('dbo.DuplicateRideIDs', 'U') IS NOT NULL DROP TABLE dbo.DuplicateRideIDs;

SELECT *
INTO dbo.DuplicateRideIDs
FROM dbo.[divvy-tripdata]
WHERE ride_id IN (
    SELECT ride_id
    FROM dbo.[divvy-tripdata]
    GROUP BY ride_id
    HAVING COUNT(*) > 1
);
--

/*


