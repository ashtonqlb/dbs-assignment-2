-- DBS311NEE Assignment 2 - Task 14
-- Author: Liam Toye (lctoye@myseneca.ca) & Ashton Lunken (abennet@myseneca.ca)

-- Outputs the all-star lineup of players who scored the most goals for their team this season
CREATE OR REPLACE PROCEDURE spGetAllStars IS
BEGIN
    dbms_output.put_line('*** Your All-Star Lineup Is... ***');
    FOR rec IN (
        SELECT
            t.teamName,
            p.firstName || ' ' || p.lastName AS playerName,
            COUNT(g.playerId)                AS goals
        FROM
            players     p
            JOIN rosters ro
            ON p.playerId = ro.playerId JOIN teams t
            ON ro.teamId = t.teamId
            JOIN goalscorers g
            ON p.playerId = g.playerId
        WHERE
            ro.isActive = 1
        GROUP BY
            t.teamId,
            t.teamName,
            p.firstName,
            p.lastName
        HAVING
            COUNT(g.playerId) = (
                SELECT
                    MAX(goalsCount)
                FROM
                    (
                        SELECT
                            COUNT(g2.playerId) AS goalsCount
                        FROM
                            goalscorers g2
                            JOIN rosters ro2
                            ON g2.playerId = ro2.playerId
                        WHERE
                            ro2.teamId = t.teamId
                            AND ro2.isActive = 1
                        GROUP BY
                            g2.playerId
                    )
            )
        ORDER BY
            t.teamName
    ) LOOP
        dbms_output.put_line(trim(rec.teamName) || ': ' || trim(rec.playerName) || ' with ' || trim(rec.goals) || ' goals this season!');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: Unable to retrieve all star players.');
END spGetAllStars;
/