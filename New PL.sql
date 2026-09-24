select * 
from EPL_Matches;

--1. Total number of matches--

SELECT COUNT(*) AS Total_Matches
FROM EPL_Matches;

--2. Number of clubs--

SELECT COUNT(DISTINCT Team) AS Total_Teams
FROM (
    SELECT HomeTeam AS Team
    FROM EPL_Matches

    UNION

    SELECT AwayTeam AS Team
    FROM EPL_Matches
) AS Teams;

--3. Home/Away win and draw %--

SELECT
    Result,
    COUNT(*) AS Matches,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM EPL_Matches
GROUP BY Result
ORDER BY Matches DESC;

--4. Home goals, Away goals, Total goals, Average goals per match--

SELECT
    SUM(HomeGoal) AS Home_Goals,
    SUM(AwayGoal) AS Away_Goals,
    SUM(HomeGoal + AwayGoal) AS Total_Goals,
    ROUND(AVG(HomeGoal + AwayGoal), 2) AS Avg_Goals_Per_Match
FROM EPL_Matches;

--5. Top 10 highest scoring clubs--

WITH TeamGoals AS
(
    SELECT
        HomeTeam AS Team,
        SUM(HomeGoal) AS Goals
    FROM EPL_Matches
    GROUP BY HomeTeam

    UNION ALL

    SELECT
        AwayTeam AS Team,
        SUM(AwayGoal) AS Goals
    FROM EPL_Matches
    GROUP BY AwayTeam
)

SELECT TOP 10
    Team,
    SUM(Goals) AS Total_Goals
FROM TeamGoals
GROUP BY Team
ORDER BY Total_Goals DESC;


--6. Which teams performed best overall?Calculate points directly from match results--

WITH TeamResults AS
(
    -- Home team results
    SELECT
        HomeTeam AS Team,

        CAST(CASE
            WHEN Result = 'H' THEN 3
            WHEN Result = 'D' THEN 1
            ELSE 0
        END AS INT) AS Points,

        CAST(CASE
            WHEN Result = 'H' THEN 1
            ELSE 0
        END AS INT) AS Wins,

        CAST(CASE
            WHEN Result = 'D' THEN 1
            ELSE 0
        END AS INT) AS Draws,

        CAST(CASE
            WHEN Result = 'A' THEN 1
            ELSE 0
        END AS INT) AS Losses,

        CAST(HomeGoal AS INT) AS GoalsFor,
        CAST(AwayGoal AS INT) AS GoalsAgainst

    FROM EPL_Matches

    UNION ALL

    -- Away team results
    SELECT
        AwayTeam AS Team,

        CAST(CASE
            WHEN Result = 'A' THEN 3
            WHEN Result = 'D' THEN 1
            ELSE 0
        END AS INT) AS Points,

        CAST(CASE
            WHEN Result = 'A' THEN 1
            ELSE 0
        END AS INT) AS Wins,

        CAST(CASE
            WHEN Result = 'D' THEN 1
            ELSE 0
        END AS INT) AS Draws,

        CAST(CASE
            WHEN Result = 'H' THEN 1
            ELSE 0
        END AS INT) AS Losses,

        CAST(AwayGoal AS INT) AS GoalsFor,
        CAST(HomeGoal AS INT) AS GoalsAgainst

    FROM EPL_Matches
)

SELECT
    Team,
    SUM(Points) AS TotalPoints,
    SUM(Wins) AS Wins,
    SUM(Draws) AS Draws,
    SUM(Losses) AS Losses,
    SUM(GoalsFor) AS GoalsFor,
    SUM(GoalsAgainst) AS GoalsAgainst,
    SUM(GoalsFor) - SUM(GoalsAgainst) AS GoalDifference

FROM TeamResults
GROUP BY Team
ORDER BY TotalPoints DESC;

--7. Best home records--

SELECT TOP 10
    HomeTeam AS Team,
    COUNT(*) AS Home_Matches,
    SUM(CASE WHEN Result = 'H' THEN 1 ELSE 0 END) AS Home_Wins,
    SUM(CASE WHEN Result = 'D' THEN 1 ELSE 0 END) AS Draws,
    SUM(CASE WHEN Result = 'A' THEN 1 ELSE 0 END) AS Losses,
    ROUND(
        SUM(CASE WHEN Result = 'H' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Home_Win_Percentage
FROM EPL_Matches
GROUP BY HomeTeam
HAVING COUNT(*) >= 100
ORDER BY Home_Win_Percentage DESC;

--8. Best away records--

SELECT TOP 10
    AwayTeam AS Team,
    COUNT(*) AS Away_Matches,
    SUM(CASE WHEN Result = 'A' THEN 1 ELSE 0 END) AS Away_Wins,
    SUM(CASE WHEN Result = 'D' THEN 1 ELSE 0 END) AS Draws,
    SUM(CASE WHEN Result = 'H' THEN 1 ELSE 0 END) AS Losses,
    ROUND(
        SUM(CASE WHEN Result = 'A' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Away_Win_Percentage
FROM EPL_Matches
GROUP BY AwayTeam
HAVING COUNT(*) >= 100
ORDER BY Away_Win_Percentage DESC;

--9. Highest scoring games--

SELECT TOP 10
    Season,
    Year,
    Month,
    Day,
    HomeTeam,
    AwayTeam,
    HomeGoal,
    AwayGoal,
    HomeGoal + AwayGoal AS Total_Goals
FROM EPL_Matches
ORDER BY Total_Goals DESC;

--10. Which referees officiated the most matches?--

SELECT TOP 10
    Referee,
    COUNT(*) AS Matches_Officiated
FROM EPL_Matches
GROUP BY Referee
ORDER BY Matches_Officiated DESC;

--11. Which referees gave the most cards?--

SELECT TOP 10
    Referee,
    COUNT(*) AS Matches_Officiated,
    SUM(HomeYellow + AwayYellow) AS Yellow_Cards,
    SUM(HomeRed + AwayRed) AS Red_Cards,
    SUM(HomeYellow + AwayYellow + HomeRed + AwayRed) AS Total_Cards,
	ROUND(
        SUM(HomeYellow + AwayYellow + HomeRed + AwayRed) * 1.0
        / COUNT(*), 2
    ) AS Cards_Per_Match
FROM EPL_Matches
GROUP BY Referee
ORDER BY Total_Cards DESC;

--12. Are home teams more likely to win derbies?--

SELECT
    IsDerby,
    Result,
    COUNT(*) AS Matches,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY IsDerby),
        2
    ) AS Percentage
FROM EPL_Matches
GROUP BY IsDerby, Result
ORDER BY IsDerby, Percentage DESC;


--13. How has VAR affected matches?--

SELECT
    VAR,
    COUNT(*) AS Matches
FROM EPL_Matches
GROUP BY VAR;

SELECT
    VAR,
    Result,
    COUNT(*) AS Matches,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY VAR),
        2
    ) AS Percentage
FROM EPL_Matches
GROUP BY VAR, Result
ORDER BY VAR, Result;

--14. How has average scoring changed by season?

SELECT
    Year,
    CONCAT(
        Year,
        '/',
        RIGHT(CAST(Year + 1 AS VARCHAR(4)), 2)
    ) AS Season_Label,
    COUNT(*) AS Matches,
    SUM(HomeGoal + AwayGoal) AS Total_Goals,
    ROUND(AVG(HomeGoal + AwayGoal), 2) AS Average_Goals_Per_Match
FROM EPL_Matches
GROUP BY Year
ORDER BY Year;

--15. Which season had the most goals per match?--

SELECT TOP 5
    Year,
    CONCAT(
        Year,
        '/',
        RIGHT(CAST(Year + 1 AS VARCHAR(4)), 2)
    ) AS Season,
    COUNT(*) AS Matches,
    SUM(HomeGoal + AwayGoal) AS Total_Goals,
    ROUND(AVG(HomeGoal + AwayGoal), 2) AS Goals_Per_Match
FROM EPL_Matches
GROUP BY Year
ORDER BY Goals_Per_Match DESC;

--16. Which teams were the most disciplined?--

SELECT TOP 10
    Team,
    COUNT(*) AS Matches,
    SUM(Yellow_Cards) AS Yellow_Cards,
    SUM(Red_Cards) AS Red_Cards,
    ROUND(
        SUM(Yellow_Cards + Red_Cards) * 1.0 / COUNT(*), 2
    ) AS Cards_Per_Match
FROM
(
    SELECT
        HomeTeam AS Team,
        HomeYellow AS Yellow_Cards,
        HomeRed AS Red_Cards
    FROM EPL_Matches

    UNION ALL

    SELECT
        AwayTeam AS Team,
        AwayYellow AS Yellow_Cards,
        AwayRed AS Red_Cards
    FROM EPL_Matches
) AS Discipline
GROUP BY Team
HAVING COUNT(*) >= 100
ORDER BY Cards_Per_Match ASC;

--17. Which teams received the most red cards?--

SELECT TOP 10
    Team,
    SUM(Red_Cards) AS Red_Cards
FROM
(
    SELECT
        HomeTeam AS Team,
        HomeRed AS Red_Cards
    FROM EPL_Matches

    UNION ALL

    SELECT
        AwayTeam AS Team,
        AwayRed AS Red_Cards
    FROM EPL_Matches
) AS RedCards
GROUP BY Team
ORDER BY Red_Cards DESC;


--18. Does scoring first matter?--

SELECT
    CASE
        WHEN [HomeGoal_HalfTime] > [AwayGoal_HalfTime]
            THEN 'Home Team Leading'
        WHEN [AwayGoal_HalfTime] > [HomeGoal_HalfTime]
            THEN 'Away Team Leading'
        ELSE 'Level at Half-Time'
    END AS HalfTime_State,
    COUNT(*) AS Matches,
    SUM(
        CASE
            WHEN
                ([HomeGoal_HalfTime] > [AwayGoal_HalfTime] AND Result = 'H')
                OR
                ([AwayGoal_HalfTime] > [HomeGoal_HalfTime] AND Result = 'A')
            THEN 1
            ELSE 0
        END
    ) AS Matches_Won_By_Leading_Team
FROM EPL_Matches
GROUP BY
    CASE
        WHEN [HomeGoal_HalfTime] > [AwayGoal_HalfTime]
            THEN 'Home Team Leading'
        WHEN [AwayGoal_HalfTime] > [HomeGoal_HalfTime]
            THEN 'Away Team Leading'
        ELSE 'Level at Half-Time'
    END;

--19. How often do teams come back after trailing at half-time?--

SELECT
    COUNT(*) AS Matches_Trailing_At_HalfTime,
    SUM(
        CASE
            WHEN
                (
                    [HomeGoal_HalfTime] < [AwayGoal_HalfTime]
                    AND Result = 'H'
                )
                OR
                (
                    [AwayGoal_HalfTime] < [HomeGoal_HalfTime]
                    AND Result = 'A'
                )
            THEN 1
            ELSE 0
        END
    ) AS Comeback_Wins
FROM EPL_Matches
WHERE
    [HomeGoal_HalfTime] <> [AwayGoal_HalfTime];

--20. Attendance analysis--

SELECT TOP 10
    Season,
    HomeTeam,
    AwayTeam,
    Attendance,
    HomeGoal,
    AwayGoal,
    Result
FROM EPL_Matches
WHERE Attendance IS NOT NULL
ORDER BY Attendance DESC;

--21. Average attendance by season--

SELECT
    Year,
    ROUND(AVG(Attendance), 0) AS Average_Attendance,
    MAX(Attendance) AS Highest_Attendance
FROM EPL_Matches
WHERE Attendance IS NOT NULL
GROUP BY Year
ORDER BY Year;

--22. Teams with the highest average attendance at home--

SELECT TOP 10
    HomeTeam AS Team,
    COUNT(*) AS Matches,
    ROUND(AVG(Attendance), 0) AS Average_Home_Attendance
FROM EPL_Matches
WHERE Attendance IS NOT NULL
GROUP BY HomeTeam
HAVING COUNT(*) >= 100
ORDER BY Average_Home_Attendance DESC;


--23. Summary of dataset--

SELECT
    COUNT(*) AS Total_Matches,
    COUNT(DISTINCT Season) AS Total_Seasons,
    COUNT(DISTINCT HomeTeam) AS Unique_Home_Teams,
    SUM(HomeGoal + AwayGoal) AS Total_Goals,
    ROUND(AVG(HomeGoal + AwayGoal), 2) AS Avg_Goals_Per_Match,
    ROUND(AVG(Attendance), 0) AS Avg_Attendance,
    SUM(CASE WHEN Result = 'H' THEN 1 ELSE 0 END) AS Home_Wins,
    SUM(CASE WHEN Result = 'D' THEN 1 ELSE 0 END) AS Draws,
    SUM(CASE WHEN Result = 'A' THEN 1 ELSE 0 END) AS Away_Wins
FROM EPL_Matches;