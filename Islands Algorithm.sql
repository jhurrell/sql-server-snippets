/*
The "Islands "Algorith" locatates contiguous sequences between values.

This can be useful for summarizing schedules or groups of items.
*/
;WITH [Islands] AS 
(
	-- [PrimaryKey] can be any type or even multiple columns.
	SELECT 1 AS [PrimaryKey], CAST('2017-12-01' AS DATE) AS [Value] UNION ALL
	SELECT 1 AS [PrimaryKey], CAST('2017-12-02' AS DATE) AS [Value] UNION ALL
	SELECT 1 AS [PrimaryKey], CAST('2017-12-04' AS DATE) AS [Value] UNION ALL
								
	SELECT 2 AS [PrimaryKey], CAST('2017-06-01' AS DATE) AS [Value] UNION ALL
	SELECT 2 AS [PrimaryKey], CAST('2017-06-02' AS DATE) AS [Value] UNION ALL
	SELECT 2 AS [PrimaryKey], CAST('2017-06-03' AS DATE) AS [Value] UNION ALL
	SELECT 2 AS [PrimaryKey], CAST('2017-06-04' AS DATE) AS [Value]
)
, [IslandGroups] AS 
(
	SELECT
		*
		-- Note that in order to produce the Island Groups correctly, you must make sure the ORDER BY part
		-- of the DENSE_RANK() includes the [PrimaryKey] and [Value] columns.
		,DATEDIFF(DAY, '1900-01-01', [Value]) - DENSE_RANK() OVER (PARTITION BY [PrimaryKey] ORDER BY [PrimaryKey], [Value]) AS [IslandGroup]
	FROM
		[Islands]
)
SELECT
	[PrimaryKey]
	,MIN([Value]) AS [StartOfIsland]
	,MAX([Value]) AS [EndOfIsland]
	,CONCAT(MIN([Value]), '  through  ', MAX([Value])) AS [IslandsText]
FROM
	[IslandGroups]
GROUP BY
	[PrimaryKey]
	,[IslandGroup]
ORDER BY
	[PrimaryKey]
	,[IslandGroup]	


-- Here is another example where we want to summarize the days when a Person has a schedule with a Client.
;WITH [Islands] AS 
(
	SELECT 'Alex' AS [Person], 'ACME' AS [Client], CAST('2024-01-01' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Alex' AS [Person], 'ACME' AS [Client], CAST('2024-01-02' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Alex' AS [Person], 'ACME' AS [Client], CAST('2024-01-03' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Alex' AS [Person], 'ACME' AS [Client], CAST('2024-01-05' AS DATE) AS [ScheduledDate] UNION ALL

	SELECT 'Blake' AS [Person], 'Widgets Inc.' AS [Client], CAST('2024-01-01' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Blake' AS [Person], 'Widgets Inc.' AS [Client], CAST('2024-01-02' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Blake' AS [Person], 'ACME'         AS [Client], CAST('2024-01-03' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Blake' AS [Person], 'Widgets Inc.' AS [Client], CAST('2024-01-04' AS DATE) AS [ScheduledDate] UNION ALL

	SELECT 'Charlie' AS [Person], 'ACME'         AS [Client], CAST('2024-01-01' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Charlie' AS [Person], 'Widgets Inc.' AS [Client], CAST('2024-01-02' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Charlie' AS [Person], 'Widgets Inc.' AS [Client], CAST('2024-01-03' AS DATE) AS [ScheduledDate] UNION ALL
	SELECT 'Charlie' AS [Person], 'Widgets Inc.' AS [Client], CAST('2024-01-05' AS DATE) AS [ScheduledDate]
)
, [IslandGroups] AS 
(
	SELECT
		*
		,DATEDIFF(DAY, '1900-01-01', [ScheduledDate]) - DENSE_RANK() OVER (PARTITION BY [Person], [Client] ORDER BY [Person], [Client], [ScheduledDate]) AS [IslandGroup]
	FROM
		[Islands]
)
SELECT
	[Person]
	,[Client]
	,MIN([ScheduledDate]) AS [StartOfIsland]
	,MAX([ScheduledDate]) AS [EndOfIsland]
	,[IslandGroup]
	,CONCAT(MIN([ScheduledDate]), '  through  ', MAX([ScheduledDate])) AS [IslandsText]
FROM
	[IslandGroups]
GROUP BY
	[Person]
	,[Client]
	,[IslandGroup]
ORDER BY
	[Person]
	,[Client]
	,[IslandGroup]