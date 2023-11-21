-- DBS311NEE Assignment 2 - Task 1
-- Author: Ashton Lunken (abennet@myseneca.ca)

/**
 * This class handles database operations related to the PLAYERS, TEAMS and ROSTERS table.
 * It includes methods to insert, update, delete, and select player records, along with sample execution code.
 *
 * Error Codes:
 * <table border="1" summary="Error codes and their meanings">
 *     <tr>
 *         <th>Error Code</th>
 *         <th>Meaning</th>
 *     </tr>
 *     <tr>
 *         <td>-1</td>
 *         <td>Record does not exist</td>
 *     </tr>
 *     <tr>
 *         <td>-2</td>
 *         <td>Duplicate record found (for unique constraints like player ID or registration number).</td>
 *     </tr>
 *     <tr>
 *         <td>-3</td>
 *         <td>Value error in data types or formats.</td>
 *     </tr>
 *     <tr>
 *         <td>-4</td>
 *         <td>Generic or unexpected error.</td>
 *     </tr>
 * </table>
 *
 * Each method in this class corresponds to a stored procedure in the database.
 * The methods will return an appropriate error code based on the outcome of the database operation.
 */

/**
 * Inserts a new player into the PLAYERS table.
 * If the provided player ID is NULL, it automatically generates a new ID.
 *
 * @param p_player_id   The ID of the player (optional). If NULL, a new ID is generated.
 * @param p_reg_number  The registration number of the player. Must be unique.
 * @param p_last_name   The last name of the player.
 * @param p_first_name  The first name of the player.
 * @param p_is_active   Indicates whether the player is active (1) or not (0).
 * @param p_error_code  (OUT) Indicate the type of any potential errors. See table.
 *
 * @exception DUP_VAL_ON_INDEX Raised when a duplicate player ID or registration number is encountered.
 * @exception VALUE_ERROR Raised when there is a mismatch in data types or formats.
 * @exception OTHERS Catches all other exceptions and displays the error message.
 */
CREATE OR REPLACE PROCEDURE spPlayersInsert (
    p_player_id IN INTEGER DEFAULT NULL,
    p_reg_number IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_first_name IN VARCHAR2,
    p_is_active IN INTEGER,
    p_error_code OUT INTEGER
) IS
    v_max_id INTEGER := 0;
BEGIN
    IF p_player_id IS NULL THEN
        SELECT COALESCE(MAX(playerid), 0) + 1 INTO v_max_id FROM PLAYERS;
    ELSE
        v_max_id := p_player_id;
    END IF;

    INSERT INTO PLAYERS (playerid, regnumber, lastname, firstname, isactive)
    VALUES (v_max_id, p_reg_number, p_last_name, p_first_name, p_is_active);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            p_error_code := -2;
        WHEN VALUE_ERROR THEN
            p_error_code := -3;
        WHEN OTHERS THEN
            p_error_code := -4;
END;
/

/**
 * Updates an existing player's details in the PLAYERS table.
 *
 * @param p_player_id   The ID of the player to be updated.
 * @param p_reg_number  The new registration number for the player.
 * @param p_last_name   The new last name for the player.
 * @param p_first_name  The new first name for the player.
 * @param p_is_active   The new active status for the player (1 for active, 0 for inactive).
 *
 * @note If no player is found with the provided ID, an informative message is displayed.
 *
 * @exception VALUE_ERROR Raised when there is a mismatch in data types or formats.
 * @exception OTHERS Catches all other exceptions and displays the error message.
 */

CREATE OR REPLACE PROCEDURE spPlayersUpdate (
    p_player_id IN INTEGER,
    p_reg_number IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_first_name IN VARCHAR2,
    p_is_active IN INTEGER,
    p_error_code OUT INTEGER
) IS BEGIN
    UPDATE PLAYERS
    SET   regnumber = p_reg_number,
          lastname  = p_last_name,
          firstname = p_first_name,
          isactive  = p_is_active
    WHERE playerid  = p_player_id;

    IF SQL%ROWCOUNT = 0 THEN
        p_error_code := -1;
    END IF;

    EXCEPTION
        WHEN VALUE_ERROR THEN
            p_error_code := -3;
        WHEN OTHERS THEN
            p_error_code := -4;
END;
/

/**
 * Deletes a player from the PLAYERS table based on the provided player ID.
 *
 * @param p_player_id  The ID of the player to be deleted.
 * @param p_error_code (OUT) Indicate the type of any potential errors. See table.

 * @note If no player is found with the provided ID, an informative message is displayed.
 *
 * @exception OTHERS Catches all exceptions and displays the error message.
 */

CREATE OR REPLACE PROCEDURE spPlayersDelete (
    p_player_id IN INTEGER,
    p_error_code OUT INTEGER
) IS
BEGIN
    DELETE FROM PLAYERS WHERE playerid = p_player_id;

    IF SQL%ROWCOUNT = 0 THEN
        p_error_code := -1; 
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_error_code := -4;
END spPlayersDelete;
/

/**
 * Selects and returns details of a player from the PLAYERS table based on the provided player ID.
 *
 * @param p_player_id   The ID of the player to be selected.
 * @param p_reg_number  (OUT) The registration number of the player.
 * @param p_last_name   (OUT) The last name of the player.
 * @param p_first_name  (OUT) The first name of the player.
 * @param p_is_active   (OUT) Indicates whether the player is active (1) or not (0).
 * @param p_error_code  (OUT) Indicate the type of any potential errors. See table.
 *
 * @note If no player is found with the provided ID, an informative message is displayed.
 *       If multiple players are found, a TOO_MANY_ROWS exception is raised.
 *
 * @exception NO_DATA_FOUND Raised when no player is found with the provided ID.
 * @exception TOO_MANY_ROWS Raised when multiple players are found with the provided ID.
 * @exception OTHERS Catches all other exceptions and displays the error message.
 */

CREATE OR REPLACE PROCEDURE spPlayersSelect (
    p_player_id IN INTEGER,
    p_reg_number OUT VARCHAR2,
    p_last_name OUT VARCHAR2,
    p_first_name OUT VARCHAR2,
    p_is_active OUT INTEGER,
    p_error_code OUT INTEGER
) IS BEGIN
    SELECT regnumber, lastname, firstname, isactive INTO p_reg_number, p_last_name, p_first_name, p_is_active
    FROM PLAYERS WHERE playerid = p_player_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_error_code := -1;
    WHEN TOO_MANY_ROWS THEN
        p_error_code := -2;
    WHEN OTHERS THEN
        p_error_code := -4;
END;
/

/**
 * Tests all database operations related to the PLAYERS tables.
 * This procedure sequentially executes insert, update, select, and delete operations for players.
 * It displays the outcome of each operation and handles any errors that arise.
 *
 * <p>Operations Tested:</p>
 * <ul>
 *     <li>Insert a new player.</li>
 *     <li>Update the player's details.</li>
 *     <li>Select the player's details.</li>
 *     <li>Delete the player.</li>
 * </ul>
 *
 * <p>Each operation checks for errors and outputs the result using DBMS_OUTPUT.</p>
 *
 * @note This procedure is intended for testing and demonstration purposes and assumes the presence of
 *       the spPlayersInsert, spPlayersUpdate, spPlayersSelect, spPlayersDelete procedures.
 *
 * @exception OTHERS Catches all unexpected errors and displays a message.
 */

CREATE OR REPLACE PROCEDURE spPlayersTestOperations IS
    v_player_id INTEGER;
    v_reg_number VARCHAR2(100);
    v_last_name VARCHAR2(100);
    v_first_name VARCHAR2(100);
    v_is_active INTEGER;
    v_error_code INTEGER;
BEGIN
    v_player_id := NULL;
    v_reg_number := '12345';
    v_last_name := 'Doe';
    v_first_name := 'John';
    v_is_active := 1;

    spPlayersInsert(v_player_id, v_reg_number, v_last_name, v_first_name, v_is_active, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Inserted new player.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('PLAYERS: Error in insert operation: ' || v_error_code);
        RETURN;
    END IF;

    SELECT COALESCE(MAX(playerid), 0) INTO v_player_id FROM PLAYERS;

    v_last_name := 'Smith';
    spPlayersUpdate(v_player_id, v_reg_number, v_last_name, v_first_name, v_is_active, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Updated player with ID ' || v_player_id || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('PLAYERS: Error in update operation: ' || v_error_code);
        RETURN;
    END IF;

    spPlayersSelect(v_player_id, v_reg_number, v_last_name, v_first_name, v_is_active, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Selected player details: Reg Number=' || v_reg_number || ', Name=' || v_first_name || ' ' || v_last_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE('PLAYERS: Error in select operation: ' || v_error_code);
        RETURN;
    END IF;

    spPlayersDelete(v_player_id, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Deleted player with ID ' || v_player_id || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('PLAYERS: Error in delete operation: ' || v_error_code);
        RETURN;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        v_error_code := -4;
END spPlayersTestOperations;
/

/**
 * Inserts a new team into the TEAMS table.
 * If the provided team ID is NULL, it automatically generates a new ID.
 *
 * @param p_team_id        The ID of the team (optional). If NULL, a new ID is generated.
 * @param p_team_name      The name of the team.
 * @param p_is_active      Indicates whether the team is active (1) or not (0).
 * @param p_jersey_colour  The colour of the team's jersey.
 * @param p_error_code     (OUT) Indicate the type of any potential errors. See table.
 */

CREATE OR REPLACE PROCEDURE spTeamsInsert (
    p_team_id IN INTEGER DEFAULT NULL,
    p_team_name IN VARCHAR2,
    p_is_active IN INTEGER,
    p_jersey_colour IN VARCHAR2,
    p_error_code OUT INTEGER
) IS 
    v_max_id INTEGER := 0;
BEGIN 
    IF p_team_id IS NULL THEN
        SELECT COALESCE(MAX(teamid), 0) + 1 INTO v_max_id FROM TEAMS;
    ELSE
        v_max_id := p_team_id;
    END IF;

    INSERT INTO TEAMS (teamid, teamname, isactive, jerseycolour)
    VALUES (p_team_id, p_team_name, p_is_active, p_jersey_colour);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            p_error_code := -2;
        WHEN VALUE_ERROR THEN
            p_error_code := -3;
        WHEN OTHERS THEN
            p_error_code := -4;
END;
/

/**
 * Updates an existing team's details in the TEAMS table.
 *
 * @param p_team_id        The ID of the team to be updated.
 * @param p_team_name      The new name for the team.
 * @param p_is_active      The new active status for the team (1 for active, 0 for inactive).
 * @param p_jersey_colour  The new jersey colour for the team.
 * @param p_error_code     (OUT) Indicate the type of any potential errors. See table.
 *
 * @note If no team is found with the provided ID, an error code is returned.
 */

CREATE OR REPLACE PROCEDURE spTeamsUpdate (
    p_team_id IN INTEGER DEFAULT NULL,
    p_team_name IN VARCHAR2,
    p_is_active IN INTEGER,
    p_jersey_colour IN VARCHAR2,
    p_error_code OUT INTEGER
) IS BEGIN
    UPDATE TEAMS
    SET   teamid = p_team_id,
          teamname  = p_team_name,
          isactive = p_is_active,
          jerseycolour  = p_jersey_colour
    WHERE teamid  = p_team_id;

    IF SQL%ROWCOUNT = 0 THEN
        p_error_code := -1;
    END IF;

    EXCEPTION
        WHEN VALUE_ERROR THEN
            p_error_code := -3;
        WHEN OTHERS THEN
            p_error_code := -4;
END;
/

/**
 * Deletes a team from the TEAMS table based on the provided team ID.
 *
 * @param p_team_id    The ID of the team to be deleted.
 * @param p_error_code (OUT) Indicate the type of any potential errors. See table.
 *
 * @note If no team is found with the provided ID, an error code is returned.
 */

CREATE OR REPLACE PROCEDURE spTeamsDelete (
    p_team_id IN INTEGER,
    p_error_code OUT INTEGER
) IS BEGIN
    DELETE FROM TEAMS WHERE teamid = p_team_id;

    IF SQL%ROWCOUNT = 0 THEN
        p_error_code := -1; 
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_error_code := -4;
END;
/

/**
 * Selects and returns details of a team from the TEAMS table based on the provided team ID.
 *
 * @param p_team_id        The ID of the team to be selected.
 * @param p_team_name      (OUT) The name of the team.
 * @param p_is_active      (OUT) Indicates whether the team is active (1) or not (0).
 * @param p_jersey_colour  (OUT) The jersey colour of the team.
 * @param p_error_code     (OUT) Indicate the type of any potential errors. See table.
 *
 * @note If no team is found with the provided ID, an error code is returned.
 */

CREATE OR REPLACE PROCEDURE spTeamsSelect (
    p_team_id IN INTEGER,
    p_team_name OUT VARCHAR2,
    p_is_active OUT INTEGER,
    p_jersey_colour OUT VARCHAR2,
    p_error_code OUT INTEGER
) IS BEGIN 

SELECT teamname, isactive, jerseycolour INTO p_team_name, p_is_active, p_jersey_colour
    FROM TEAMS WHERE teamid = p_team_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_error_code := -1;
    WHEN TOO_MANY_ROWS THEN
        p_error_code := -2;
    WHEN OTHERS THEN
        p_error_code := -4;
END;
/

/**
 * Tests all database operations related to the TEAMS tables.
 * This procedure sequentially executes insert, update, select, and delete operations for teams.
 * It displays the outcome of each operation and handles any errors that arise.
 *
 * <p>Operations Tested:</p>
 * <ul>
 *     <li>Insert a new team.</li>
 *     <li>Update the team's details.</li>
 *     <li>Select the team's details.</li>
 *     <li>Delete the team.</li>
 * </ul>
 *
 * <p>Each operation checks for errors and outputs the result using DBMS_OUTPUT.</p>
 *
 * @note This procedure is intended for testing and demonstration purposes and assumes the presence of
 *       the spTeamsInsert, spTeamsUpdate, spTeamsSelect, and spTeamsDelete procedures.
 *
 * @exception OTHERS Catches all unexpected errors and displays a message.
 */

CREATE OR REPLACE PROCEDURE spTeamsTestOperations IS 
    v_team_id INTEGER;
    v_team_name VARCHAR2(10) := 'Examples';
    v_jersey_colour VARCHAR2(10) := 'Grey';
    v_is_active INTEGER := 1;
    v_error_code INTEGER;
BEGIN 
    spTeamsInsert(v_team_id, v_team_name, v_is_active, v_jersey_colour, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Inserted new team');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEAMS: Error in insert operation: ' || v_error_code);
    END IF;
    
    v_team_name := 'Tests';
    v_jersey_colour := 'Pink';
    spTeamsUpdate(v_team_id, v_team_name, v_is_active, v_jersey_colour, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Updated team: ' || v_team_id || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEAMS: Error in update operation: ' || v_error_code);
    END IF;

    spTeamsSelect(v_team_id, v_team_name, v_is_active, v_jersey_colour, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Selected team: ' || v_jersey_colour || ' ' || v_team_name || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEAMS: Error in select operation: ' || v_error_code);
    END IF;
    
    spTeamsDelete(v_team_id, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Deleted team');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEAMS: Error in delete operation: ' || v_error_code);
    END IF;

    EXCEPTION
    WHEN OTHERS THEN
        v_error_code := -4;
END;
/

/**
 * Validates the existence of a player and a team in the database.
 * 
 * @param p_player_id  The ID of the player to validate.
 * @param p_team_id    The ID of the team to validate.
 * @return Returns TRUE if both the player and the team exist and FALSE otherwise.
 */

CREATE OR REPLACE FUNCTION fnValidatePlayerAndTeam (
    p_player_id IN INTEGER,
    p_team_id IN INTEGER
) RETURN BOOLEAN IS
    v_player_exists INTEGER;
    v_team_exists INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_player_exists FROM PLAYERS WHERE playerid = p_player_id;

    SELECT COUNT(*) INTO v_team_exists FROM TEAMS WHERE teamid = p_team_id;

    RETURN (v_player_exists > 0 AND v_team_exists > 0 AND v_player_exists < 2 AND v_team_exists < 2);
END fnValidatePlayerAndTeam;
/

/**
 * Inserts a new roster record into the ROSTERS table.
 *
 * @param p_roster_id      The ID of the roster (optional). If NULL, a new ID is generated.
 * @param p_player_id      The ID of the player in the roster.
 * @param p_team_id        The ID of the team in the roster.
 * @param p_is_active      Indicates whether the roster is active (1) or not (0).
 * @param p_jersey_number  The jersey number of the player in the roster.
 * @param p_error_code     (OUT) Error code indicating the status of the operation.
 *
 * @exception DUP_VAL_ON_INDEX Raised when a duplicate roster ID is encountered.
 * @exception VALUE_ERROR Raised when there is a mismatch in data types or formats.
 * @exception OTHERS Catches all other exceptions and displays the error message.
 */

CREATE OR REPLACE PROCEDURE spRostersInsert (
    p_roster_id IN INTEGER DEFAULT NULL,
    p_player_id IN INTEGER,
    p_team_id IN INTEGER,
    p_is_active IN INTEGER,
    p_jersey_number IN INTEGER,
    p_error_code OUT INTEGER
) IS
    v_max_id INTEGER := 0;
BEGIN 
    IF p_roster_id IS NULL THEN
        SELECT COALESCE(MAX(rosterid), 0) + 1 INTO v_max_id FROM ROSTERS;
    ELSE
        v_max_id := p_roster_id;
    END IF;

    IF fnValidatePlayerAndTeam(p_player_id, p_team_id) THEN
        INSERT INTO ROSTERS (rosterid, playerid, teamid, isactive, jerseynumber)
        VALUES (v_max_id, p_player_id, p_team_id, p_is_active, p_jersey_number);
    ELSE
        p_error_code := -1;
    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_error_code := -2;
    WHEN VALUE_ERROR THEN
        p_error_code := -3;
    WHEN OTHERS THEN
        p_error_code := -4;
END spRostersInsert;
/

/**
 * Updates an existing roster record in the ROSTERS table.
 *
 * @param p_roster_id      The ID of the roster to be updated.
 * @param p_player_id      The new player ID for the roster.
 * @param p_team_id        The new team ID for the roster.
 * @param p_is_active      The new active status of the roster (1 for active, 0 for inactive).
 * @param p_jersey_number  The new jersey number of the player in the roster.
 * @param p_error_code     (OUT) Error code indicating the status of the operation.
 *
 * @note If no roster is found with the provided ID, an error code is returned.
 *
 * @exception VALUE_ERROR Raised when there is a mismatch in data types or formats.
 * @exception OTHERS Catches all other exceptions and displays the error message.
 */

CREATE OR REPLACE PROCEDURE spRostersUpdate (
    p_roster_id IN INTEGER,
    p_player_id IN INTEGER,
    p_team_id IN INTEGER,
    p_is_active IN INTEGER,
    p_jersey_number IN INTEGER,
    p_error_code OUT INTEGER
) IS 
BEGIN    
    IF fnValidatePlayerAndTeam(p_player_id, p_team_id) THEN
        UPDATE ROSTERS
            SET playerid = p_player_id,
                teamid = p_team_id,
                isactive = p_is_active,
                jerseynumber = p_jersey_number
            WHERE rosterid = p_roster_id;

        IF SQL%ROWCOUNT = 0 THEN
            p_error_code := -1;
        ELSE
            p_error_code := 0;
        END IF;
    ELSE
        p_error_code := -1;
    END IF;
EXCEPTION
    WHEN VALUE_ERROR THEN
        p_error_code := -3;
    WHEN OTHERS THEN
        p_error_code := -4;
END spRostersUpdate;
/

/**
 * Deletes a roster record from the ROSTERS table based on the provided roster ID.
 *
 * @param p_roster_id    The ID of the roster to be deleted.
 * @param p_error_code   (OUT) Error code indicating the status of the operation.
 *
 * @note If no roster is found with the provided ID, an error code is returned.
 *
 * @exception OTHERS Catches all exceptions and displays the error message.
 */


CREATE OR REPLACE PROCEDURE spRostersDelete (
    p_roster_id IN INTEGER,
    p_error_code OUT INTEGER
) 
IS BEGIN
    DELETE FROM ROSTERS WHERE rosterid = p_roster_id;

    IF SQL%ROWCOUNT = 0 THEN
        p_error_code := -1; 
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_error_code := -4;
END spRostersDelete;
/

/**
 * Selects and returns details of a roster from the ROSTERS table based on the provided roster ID.
 *
 * @param p_roster_id        The ID of the roster to be selected.
 * @param p_player_id        (OUT) The player ID in the roster.
 * @param p_team_id          (OUT) The team ID in the roster.
 * @param p_is_active        (OUT) Indicates whether the roster is active (1) or not (0).
 * @param p_jersey_number    (OUT) The jersey number of the player in the roster.
 * @param p_error_code       (OUT) Error code indicating the status of the operation.
 *
 * @note If no roster is found with the provided ID, an error code is returned.
 *
 * @exception NO_DATA_FOUND Raised when no roster is found with the provided ID.
 * @exception TOO_MANY_ROWS Raised when multiple rosters are found with the provided ID.
 * @exception OTHERS Catches all other exceptions and displays the error message.
 */

CREATE OR REPLACE PROCEDURE spRostersSelect (
    p_roster_id IN INTEGER,
    p_player_id OUT INTEGER,
    p_team_id OUT INTEGER,
    p_is_active OUT INTEGER,
    p_jersey_number OUT INTEGER,
    p_error_code OUT INTEGER
) IS BEGIN 

SELECT playerid, teamid, isactive, jerseynumber INTO p_player_id, p_team_id, p_is_active, p_jersey_number
    FROM ROSTERS WHERE rosterid = p_roster_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_error_code := -1;
    WHEN TOO_MANY_ROWS THEN
        p_error_code := -2;
    WHEN OTHERS THEN
        p_error_code := -4;
END;
/

/**
 * Tests all database operations related to the ROSTERS tables.
 *
 * <p>Operations Tested:</p>
 * <ul>
 *     <li>Insert a new roster record.</li>
 *     <li>Update the roster record's details.</li>
 *     <li>Select and display the roster record's details.</li>
 *     <li>Delete the roster record.</li>
 * </ul>
 *
 * <p>Error codes are checked after each operation to confirm successful execution.</p>
 *
 * @note This script is for demonstration and testing purposes and assumes the presence of
 *       the spRostersInsert, spRostersUpdate, spRostersSelect, and spRostersDelete procedures,
 *       along with the fnValidatePlayerAndTeam function.
 */

CREATE OR REPLACE PROCEDURE spRostersTestOperations IS
    v_roster_id INTEGER;
    v_player_id INTEGER := 100; 
    v_team_id INTEGER := 200;  
    v_is_active INTEGER := 1;
    v_jersey_number INTEGER := 10;
    v_error_code INTEGER;
BEGIN
    spRostersInsert(v_roster_id, v_player_id, v_team_id, v_is_active, v_jersey_number, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Inserted new team');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ROSTERS: Error in insert operation: ' || v_error_code);
    END IF;

    v_jersey_number := 11;
    spRostersUpdate(v_roster_id, v_player_id, v_team_id, v_is_active, v_jersey_number, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Updated roster: ' || v_roster_id || ' with jersey number ' || v_jersey_number || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ROSTERS: Error in update operation: ' || v_error_code);
    END IF;

    spRostersSelect(v_roster_id, v_player_id, v_team_id, v_is_active, v_jersey_number, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Selected roster: ' || v_roster_id );
    ELSE
        DBMS_OUTPUT.PUT_LINE('ROSTERS: Error in select operation: ' || v_error_code);
    END IF;

    spRostersDelete(v_roster_id, v_error_code);
    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Deleted roster');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ROSTERS: Error in delete operation: ' || v_error_code);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END spRostersTestOperations;
/

BEGIN
    spPlayersTestOperations;
    spTeamsTestOperations;
    spRostersTestOperations;
END;
/