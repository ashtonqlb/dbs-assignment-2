-- DBS311NEE Assignment 2 - Task 5
-- Author: Liam Toye (lctoye@myseneca.ca)

-- 5. Using the vwPlayerRosters view, create an SP, named spTeamRosterByID, that outputs
-- the team rosters, with names, for a team given a specific input parameter of teamID

CREATE OR REPLACE PROCEDURE spteamrosterbyid (
    v_teamid IN NUMBER
) AS
BEGIN
    FOR i IN (
        SELECT
            *
        FROM
            vwplayerrosters
        WHERE
            teamid = v_teamid
    ) LOOP
 -- Perhaps adjust this later; some columns may not be needed
        dbms_output.put_line( i.playerid || ' ' || i.regnumber || ' ' || i.lastname || ' ' || i.firstname || ' ' || i.isactive || ' ' || i.rosterid || ' ' || i.teamid || ' ' || i.jerseynumber || ' ' || i.teamname || ' ' || i.jerseycolour);
    END LOOP;
END;
/

BEGIN
    spteamrosterbyid(210);
END;