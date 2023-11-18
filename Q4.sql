-- DBS311NEE Assignment 2 - Task 4
-- Author: Liam Toye (lctoye@myseneca.ca)

-- 4. Create a view which stores the “players on teams” information, called vwPlayerRosters
-- which includes all fields from players, rosters, and teams in a single output table.
-- You only need to include records that have exact matches.

CREATE OR REPLACE VIEW vwplayerrosters AS
    SELECT
        players.playerid     playerid,
        players.regnumber    regnumber,
        players.lastname     lastname,
        players.firstname    firstname,
        players.isactive     isactive,
        rosters.rosterid     rosterid,
        rosters.teamid       teamid,
        rosters.jerseynumber jerseynumber,
        teams.teamname       teamname,
        teams.jerseycolour   jerseycolour
    FROM
        players,
        rosters,
        teams
    WHERE
        players.playerid = rosters.playerid
        AND rosters.teamid = teams.teamid;