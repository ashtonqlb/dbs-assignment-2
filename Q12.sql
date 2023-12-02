-- ************************************************************
-- DO NOT COPY TO MAIN SUBMISSION - NOT FINISHED!
-- ************************************************************

-- DBS311NEE Assignment 2 - Task 12
-- Author: Liam Toye (lctoye@myseneca.ca)

-- 12. Using the Standings calculation demo code provided earlier in the semester,
-- create a Stored Procedure, named spRunStandings, that replaces a temporary static table,
-- named tempStandings, with the output of the SELECT code provided.

CREATE OR REPLACE PROCEDURE spRunStandings AS
BEGIN
 -- Insert data into tempStandings using your SELECT statement
    INSERT INTO tempStandings (
        theteamid,
        teamname,
        gp,
        w,
        l,
        t,
        pts,
        gf,
        ga,
        gd
    )
        SELECT
            theteamid,
            (
                SELECT
                    teamname
                FROM
                    teams
                WHERE
                    teamid = t.theteamid
            ) AS teamname,
            SUM(gamesplayed) AS gp,
            SUM(wins) AS w,
            SUM(losses) AS l,
            SUM(ties) AS t,
            SUM(wins) * 3 + SUM(ties) AS pts,
            SUM(goalsfor) AS gf,
            SUM(goalsagainst) AS ga,
            SUM(goalsfor) - SUM(goalsagainst) AS gd
        FROM
            (
                SELECT
                    hometeam        AS theteamid,
                    COUNT(gameid)   AS gamesplayed,
                    SUM(homescore)  AS goalsfor,
                    SUM(visitscore) AS goalsagainst,
                    SUM(
                        CASE
                            WHEN homescore > visitscore THEN
                                1
                            ELSE
                                0
                        END)        AS wins,
                    SUM(
                        CASE
                            WHEN homescore < visitscore THEN
                                1
                            ELSE
                                0
                        END)        AS losses,
                    SUM(
                        CASE
                            WHEN homescore = visitscore THEN
                                1
                            ELSE
                                0
                        END)        AS ties
                FROM
                    games
                WHERE
                    isplayed = 1
                GROUP BY
                    hometeam
                UNION
                ALL
 -- From the perspective of the visiting team
                SELECT
                    visitteam       AS theteamid,
                    COUNT(gameid)   AS gamesplayed,
                    SUM(visitscore) AS goalsfor,
                    SUM(homescore)  AS goalsagainst,
                    SUM(
                        CASE
                            WHEN homescore < visitscore THEN
                                1
                            ELSE
                                0
                        END)        AS wins,
                    SUM(
                        CASE
                            WHEN homescore > visitscore THEN
                                1
                            ELSE
                                0
                        END)        AS losses,
                    SUM(
                        CASE
                            WHEN homescore = visitscore THEN
                                1
                            ELSE
                                0
                        END)        AS ties
                FROM
                    games
                WHERE
                    isplayed = 1
                GROUP BY
                    visitteam
            )     t
        GROUP BY
            theteamid;
END spRunStandings;