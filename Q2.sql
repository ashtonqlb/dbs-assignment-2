-- DBS311NEE Assignment 2 - Task 2
-- Author: Liam Toye (lctoye@myseneca.ca)

/*  For each table in (Players, Teams, Rosters), create an additional Stored Procedure, 
    called spTableNameSelectAll that outputs the contents of the table to the script window 
    (using DBMS_OUTPUT) for the standard SELECT * FROM <tablename> statement.   */

-- PLAYERS
CREATE OR REPLACE PROCEDURE spPlayersSelectAll IS
BEGIN
    dbms_output.put_line('PlayerID RegNumber LastName FirstName IsActive');
    dbms_output.put_line('-------- ---------- -------- --------- --------');
    FOR i IN (
        SELECT
            *
        FROM
            players
    ) LOOP
        dbms_output.put_line(i.playerid || ' ' || i.regnumber || ' ' || i.lastname || ' ' || i.firstname || ' ' || i.isactive);
    END LOOP;
END;
/

-- ROSTERS
CREATE OR REPLACE PROCEDURE spRostersSelectAll IS
BEGIN
    dbms_output.put_line('RosterID PlayerID TeamID IsActive JerseyNumber');
    dbms_output.put_line('-------- -------- ------ -------- ------------');
    FOR i IN (
        SELECT
            *
        FROM
            rosters
    ) LOOP
        dbms_output.put_line(i.rosterid || ' ' || i.playerid|| ' ' || i.teamid|| ' ' || i.isactive|| ' ' || i.jerseynumber);
    END LOOP;
END;
/

-- TEAMS
CREATE OR REPLACE PROCEDURE spTeamsSelectAll IS
BEGIN
    dbms_output.put_line('TeamID TeamName IsActive JerseyColour');
    dbms_output.put_line('------ -------- -------- ------------');
    FOR i IN (
        SELECT
            *
        FROM
            teams
    ) LOOP
        dbms_output.put_line(i.teamid || ' ' || i.teamname || ' ' || i.isactive || ' ' || i.jerseycolour);
    END LOOP;
END;
/