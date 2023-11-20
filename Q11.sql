-- DBS311NEE Assignment 2 - Task 11
-- Author: Liam Toye (lctoye@myseneca.ca)
-- Create a stored procedure, spSchedPastGames, using DBMS_OUTPUT, that displays
-- the games that have been played in the past n days, where n is an input parameter.
-- Make sure your code will work on any day of the year.
CREATE OR REPLACE PROCEDURE spSchedPastGames (
    n IN NUMBER
) IS
BEGIN
    FOR i IN (
        SELECT
            *
        FROM
            games
        WHERE
            gamedatetime BETWEEN sysdate - n AND sysdate -- scheduled in past n days
            AND isplayed = 1 -- played at all
    ) LOOP
        dbms_output.put_line(i.gameid || ' ' || i.divid || ' ' || i.gamenum || ' ' || i.gamedatetime || ' ' || i.hometeam || ' ' || i.homescore|| ' ' || i.visitteam || ' ' || i.visitscore || ' ' || i.locationid || ' ' || i.isplayed || ' ' || i.notes);
    END LOOP;
END;
/