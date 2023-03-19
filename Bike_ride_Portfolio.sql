--DATA CLEANING
--Change data type before 'Union All'
ALTER TABLE ['2022_04']
ALTER COLUMN start_station_id nvarchar(255)

ALTER TABLE ['2022_07']
ALTER COLUMN start_station_id nvarchar(255)

ALTER TABLE ['2022_09']
ALTER COLUMN end_station_id nvarchar(255)

ALTER TABLE ['2022_10']
ALTER COLUMN start_station_id nvarchar(255)

ALTER TABLE ['2022_11']
ALTER COLUMN start_station_id nvarchar(255)

ALTER TABLE ['2022_11']
ALTER COLUMN end_station_id nvarchar(255)

ALTER TABLE ['2022_12']
ALTER COLUMN end_station_id nvarchar(255)

--Remove NULL values, invalid ride_id
delete from ['2022_01']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_02']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_03']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_04']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_05']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_06']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_07']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_08']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_09']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_10']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_11']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

delete from ['2022_12']
where ride_length is null
	or start_station_name is null
	or start_station_id is null
	or end_station_name is null
	or end_station_id is null
	or charindex('.', ride_id) != 0

--Create view for visualization
--DROP VIEW IF EXISTS view_for_viz --Recreate the view to add more columns
CREATE VIEW view_for_viz AS
SELECT *,
	DATEPART(hour, a.started_at) as start_hour,
	DATEPART(hour, a.ended_at) as end_hour,
	DATEPART(MONTH, started_at) as new_month,
	DATENAME(weekday, a.started_at) as day_of_week,
	(DATEPART(minute, a.ride_length)*60 + DATEPART(second, a.ride_length)) as ride_length_in_seconds,
	CONVERT(time, a.ride_length) as ride_length_in_minutes
FROM
	(SELECT *
	FROM [case_study_1].[dbo].['2022_01']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_02']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_03']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_04']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_05']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_06']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_07']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_08']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_09']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_10']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_11']
		UNION ALL
	SELECT *
	FROM [case_study_1].[dbo].['2022_12']) a

SELECT *
FROM view_for_viz
--Verify if the ride_id is unique
WITH count_ride_id AS (
	SELECT ride_id, COUNT(*) as unique_id
	FROM view_for_viz
	group by ride_id)

SELECT *
FROM count_ride_id
WHERE unique_id != 1



--DATA EXPLORATION
/*Compare the number of rides from top 20 start stations of casual 
with the number of rides of member as the corresponding stations*/
SELECT c.start_station_name, c.count_casual, m.count_member
FROM
	(SELECT TOP (20)
		member_casual, start_station_name, COUNT(*) as count_casual
	FROM view_for_viz
	GROUP BY member_casual, start_station_name
	HAVING member_casual = 'casual'
	ORDER BY 3 desc) c
JOIN
	(SELECT
		member_casual, start_station_name, COUNT(*) as count_member
	FROM view_for_viz
	GROUP BY member_casual, start_station_name
	HAVING member_casual = 'member') m
ON c.start_station_name = m.start_station_name
ORDER BY c.count_casual desc


--Compare average ride length between casual and member
SELECT member_casual, AVG(ride_length_in_seconds) as average_ride_length --Calculate ride length in seconds 
FROM view_for_viz
GROUP BY member_casual

--Compare the number of ride between casual and member based on day of the week
SELECT c.day_of_week, c.count_casual, m.count_member
FROM
	(SELECT 
		member_casual, day_of_week, COUNT(*) as count_casual
	FROM view_for_viz
	GROUP BY member_casual, day_of_week
	HAVING member_casual = 'casual') c
JOIN
	(SELECT
		member_casual, day_of_week, COUNT(*) as count_member
	FROM view_for_viz
	GROUP BY member_casual, day_of_week
	HAVING member_casual = 'member') m
ON c.day_of_week = m.day_of_week
ORDER BY c.count_casual desc

--Compare the number of ride between casual and member based on months over the years
SELECT c.new_month, c.count_casual, m.count_member
FROM
	(SELECT 
		member_casual, new_month, COUNT(*) as count_casual
	FROM view_for_viz
	GROUP BY member_casual, new_month
	HAVING member_casual = 'casual') c
JOIN
	(SELECT
		member_casual, new_month, COUNT(*) as count_member
	FROM view_for_viz
	GROUP BY member_casual, new_month
	HAVING member_casual = 'member') m
ON c.new_month = m.new_month
ORDER BY c.count_casual desc