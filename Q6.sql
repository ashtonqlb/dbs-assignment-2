-- DBS311NEE Assignment 2 - Task 6
-- Author: Ashton Lunken (abennet@myseneca.ca)

/**
 * Executes the 'spTeamRosterByName' stored procedure to fetch and display the team roster.
 * This procedure searches the 'vwPlayerRosters' view for a team that includes the specified
 * string in its name and prints out the roster to DBMS_OUTPUT.
 *
 * @param p_team_name A partial or full team name to search for within the team names.
 * 
 * @note It is case-insensitive.
 * 
 */

CREATE OR REPLACE PROCEDURE spTeamRosterByName (
    p_team_name IN VARCHAR2
) AS
    v_result_quantity INTEGER := 0;
    CURSOR cTeamRoster IS
        SELECT
            playerid,
            regnumber,
            lastname,
            firstname,
            isactive,
            rosterid,
            teamid,
            jerseynumber,
            teamname,
            jerseycolour
        FROM
            vwPlayerRosters
        WHERE
            LOWER(teamname) LIKE LOWER('%' || p_team_name || '%');
BEGIN
    FOR roster_record IN cTeamRoster LOOP
        v_result_quantity := v_result_quantity + 1; -- Increment the counter
        DBMS_OUTPUT.PUT_LINE
        (
            'Result ' || TO_CHAR(v_result_quantity) || CHR(10) 
            || 'Name: ' || roster_record.firstname || ' ' || roster_record.lastname || CHR(10)
            || 'Jersey Number: ' || roster_record.jerseynumber || CHR(10)
            || 'Team: ' || roster_record.teamname || CHR(10)
        );
    END LOOP;

EXCEPTIONS
    WHEN NO_DATA_FOUND THEN
        p_error_code := 1;
    WHEN VALUE_ERROR THEN
        p_error_code := -3;
    WHEN OTHERS THEN
        p_error_code := -4;
END;
/

BEGIN 
    spTeamRosterByName('Aurora');
END;
/