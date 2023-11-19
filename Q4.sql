-- DBS311NEE Assignment 2 - Task 4
-- Author: Liam Toye (lctoye@myseneca.ca) & Ashton Lunken (abennet@myseneca.ca)

-- 4. Create a view which stores the “players on teams” information, called vwPlayerRosters
-- which includes all fields from players, rosters, and teams in a single output table.
-- You only need to include records that have exact matches.

CREATE OR REPLACE VIEW vwPlayerRosters AS
    SELECT
        p.playerid     playerid,
        p.regnumber    regnumber,
        p.lastname     lastname,
        p.firstname    firstname,
        p.isactive     isactive,
        r.rosterid     rosterid,
        r.teamid       teamid,
        r.jerseynumber jerseynumber,
        t.teamname     teamname,
        t.jerseycolour jerseycolour
    FROM
        players p
    INNER JOIN rosters r ON p.playerid = r.playerid
    INNER JOIN teams t ON r.teamid = t.teamid;