-- DBS311NEE Assignment 2 - Task 8
-- Author: Ashton Lunken (abennet@myseneca.ca)

/**
 * Retrieves the number of active players in a team based on the team ID.
 * 
 * @param p_team_id The ID of the team. It should be a valid number representing the team's primary key.
 * @return A number representing the count of active players.
 * 
 * @exception NO_DATA_FOUND This exception is raised when no team is found with the given ID.
 * @exception OTHERS Catches any other exceptions that might occur during the function's execution.
 * 
 * This function queries the 'vwTeamsNumPlayers' view to obtain the count of active players.
 * If the count of players ('num_players') is not null, it returns this count.
 * If 'num_players' is null, the function does not explicitly return a value, 
 * which should be handled by the calling environment accordingly.
 */

CREATE OR REPLACE FUNCTION fncNumPlayersByTeamID (
    p_team_id IN NUMBER
) RETURN NUMBER
IS
    v_num_players NUMBER;
BEGIN
    SELECT 
        num_players
    INTO
        v_num_players
    FROM
        vwTeamsNumPlayers
    WHERE 
        teamid = p_team_id;

    IF v_num_players IS NOT NULL THEN
        RETURN v_num_players;
    END IF;

EXCEPTION
WHEN NO_DATA_FOUND THEN
    RETURN -1; 
WHEN OTHERS THEN
    RETURN -4;
END;
/