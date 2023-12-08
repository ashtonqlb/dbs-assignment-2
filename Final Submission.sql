SET SERVEROUTPUT ON;

/**
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
 */

-- Q1. This one is really long so be prepared to scroll

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
        SELECT
            COALESCE(MAX(playerid), 0) + 1 INTO v_max_id
        FROM
            PLAYERS;
    ELSE
        v_max_id := p_player_id;
    END IF;

    INSERT INTO PLAYERS (
        playerid,
        regnumber,
        lastname,
        firstname,
        isactive
    ) VALUES (
        v_max_id,
        p_reg_number,
        p_last_name,
        p_first_name,
        p_is_active
    );
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
) IS
BEGIN
    UPDATE PLAYERS
    SET
        regnumber = p_reg_number,
        lastname = p_last_name,
        firstname = p_first_name,
        isactive = p_is_active
    WHERE
        playerid = p_player_id;
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
    DELETE FROM PLAYERS
    WHERE
        playerid = p_player_id;
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
) IS
BEGIN
    SELECT
        regnumber,
        lastname,
        firstname,
        isactive INTO p_reg_number,
        p_last_name,
        p_first_name,
        p_is_active
    FROM
        PLAYERS
    WHERE
        playerid = p_player_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_error_code := -1;
    WHEN TOO_MANY_ROWS THEN
        p_error_code := -2;
    WHEN OTHERS THEN
        p_error_code := -4;
END;
/

-- Q2
/*  Outputs the contents of the table to the script window 
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

-- Q3
/*  As Q2, but returning the table in the output of the SP. 
Use a non-saved procedure to show receiving the data and outputting it to the script window. */

-- **************************************************************************************
-- Table-returning stored procedures
-- **************************************************************************************

CREATE OR REPLACE PROCEDURE spPlayersSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            players;
END;
/

CREATE OR REPLACE PROCEDURE spRostersSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            rosters;
END;
/

CREATE OR REPLACE PROCEDURE spTeamsSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            teams;
END;
/

-- **************************************************************************************
-- Non-saved procedures to show receiving the data and outputting it to the script window
-- **************************************************************************************

-- PLAYERS
DECLARE
    v_cursor    SYS_REFCURSOR;
    v_playerID  NUMBER;
    v_regNum    NUMBER;
    v_lastName  VARCHAR2(50);
    v_firstName VARCHAR2(50);
    v_isActive  NUMBER;
BEGIN
    spPlayersSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_playerID, v_regNum, v_lastName, v_firstName, v_isActive;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_playerID || ' ' || v_regNum || ' ' || v_lastName || ' ' || v_firstName || ' ' || v_isActive);
    END LOOP;

    CLOSE v_cursor;
END;
/

-- ROSTERS
DECLARE
    v_cursor    SYS_REFCURSOR;
    v_rosterID  NUMBER;
    v_playerID  NUMBER;
    v_teamID    NUMBER;
    v_isActive  NUMBER;
    v_jerseyNum NUMBER;
BEGIN
    spRostersSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_rosterID, v_playerID, v_teamID, v_isActive, v_jerseyNum;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_rosterID || ' ' || v_playerID || ' ' || v_teamID || ' ' || v_isActive || ' ' || v_jerseyNum);
    END LOOP;

    CLOSE v_cursor;
END;
/

-- TEAMS
DECLARE
    v_cursor     SYS_REFCURSOR;
    v_teamID     NUMBER;
    v_teamName   VARCHAR2(50);
    v_isActive   NUMBER;
    v_jerseyNums VARCHAR2(50);
BEGIN
    spTeamsSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_teamID, v_teamName, v_isActive, v_jerseyNums;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_teamID || ' ' || v_teamName || ' ' || v_isActive || ' ' || v_jerseyNums);
    END LOOP;

    CLOSE v_cursor;
END;
/

-- Q4
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
        INNER JOIN rosters r
        ON p.playerid = r.playerid
        INNER JOIN teams t
        ON r.teamid = t.teamid;

-- Q5
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

/**
 * Q6
 * Executes the 'spTeamRosterByName' stored procedure to fetch and display the team roster.
 * This procedure searches the 'vwPlayerRosters' view for a team that includes the specified
 * string in its name and prints out the roster to DBMS_OUTPUT.
 *
 * @param p_team_name A partial or full team name to search for within the team names.
 * 
 * @note It is case-insensitive.
 * 
 */

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
    p_team_name IN VARCHAR2,
    p_error_code OUT INTEGER
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

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_error_code := 1;
    WHEN VALUE_ERROR THEN
        p_error_code := -3;
    WHEN OTHERS THEN
        p_error_code := -4;
END;
/

/**
 * Q7
 * 
 * Selects all team IDs and team names and then counts 
 * how many player IDs have the selected team ID.
 *
 * @note Teams are ordered biggest to smallest
 * 
 */

CREATE OR REPLACE VIEW vwTeamsNumPlayers AS
    SELECT
        t.teamid,
        t.teamname,
        COUNT(r.playerid) AS num_players
    FROM
        TEAMS   t
        LEFT JOIN ROSTERS r
        on t.teamid = r.teamid
        AND r.isactive = 1
    GROUP BY
        t.teamid,
        t.teamname
    ORDER BY
        num_players DESC;

/**
 * Q8
 *
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
) RETURN NUMBER IS
    v_num_players NUMBER;
BEGIN
    SELECT
        num_players INTO v_num_players
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

-- Q9

CREATE OR REPLACE VIEW vwSchedule AS
    SELECT
        g.gamenum,
        g.gamedatetime,
        g.hometeam,
        ht.teamname    as HomeTeamName,
        g.visitteam,
        vt.teamname    as VisitTeamName,
        l.locationname
    FROM
        GAMES       g
        INNER JOIN SLLOCATIONS l
        ON g.locationid = l.locationid
        INNER JOIN TEAMS ht
        ON g.hometeam = ht.teamid
        INNER JOIN TEAMS vt
        ON g.visitteam = vt.teamid
    ORDER BY
        g.gamedatetime;

/**
 * Q10
 * Retrieves and displays games scheduled to occur within the next 'n' days (using SYSDATE() for the current date), 
 * by defining a cursor to select all fields from vwSchedule into the procedure variables.
 *
 * @param n The number of days ahead of the current date to retrieve games for.
 *          Must be a positive integer representing the days to look ahead.
 *          
 * @note The actual column widths for 'v_home_team_name' and 'v_visit_team_name' must be
 * long enough to store the longest team name in the database. Adjust the VARCHAR2 size
 * if the team names are getting truncated.
 */

CREATE OR REPLACE PROCEDURE spSchedUpcomingGames(
    n IN INTEGER
) IS
    CURSOR cUpcomingGames IS
    SELECT
        gamenum,
        gamedatetime,
        HomeTeamName,
        VisitTeamName
    FROM
        vwSchedule
    WHERE
        gamedatetime BETWEEN SYSDATE AND SYSDATE + n
    ORDER BY
        gamedatetime;
    v_game_num        INTEGER;
    v_game_date_time  DATE;
    v_home_team_name  VARCHAR2(10);
    v_visit_team_name VARCHAR2(10);
BEGIN
    OPEN cUpcomingGames;
    LOOP
        FETCH cUpcomingGames INTO v_game_num, v_game_date_time, v_home_team_name, v_visit_team_name;
        EXIT WHEN cUpcomingGames%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( 'Game Number: ' || v_game_num || ', Date: ' || TO_CHAR(v_game_date_time, 'DD-MON-YYYY') || ', Home Team: ' || v_home_team_name || ', Visit Team: ' || v_visit_team_name );
    END LOOP;

    CLOSE cUpcomingGames;
EXCEPTION
    WHEN OTHERS THEN
        IF cUpcomingGames%ISOPEN THEN
            CLOSE cUpcomingGames;
        END IF;
END spSchedUpcomingGames;
/

-- Q11
-- Displays the games that have been played in the past n days, where n is an input parameter.
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

--Q12
-- Replaces a temporary static table, named tempStandings, with the output of the SELECT code provided
-- by the Standings demo earlier in the semester

-- This only needs to be run once:
-- CREATE GLOBAL TEMPORARY TABLE tempStandings (
--     theteamid NUMBER,
--     teamname VARCHAR2(255),
--     gp NUMBER,
--     w NUMBER,
--     l NUMBER,
--     t NUMBER,
--     pts NUMBER,
--     gf NUMBER,
--     ga NUMBER,
--     gd NUMBER
-- ) ON COMMIT PRESERVE ROWS;

CREATE OR REPLACE PROCEDURE spRunStandings AS
BEGIN
    DELETE FROM tempStandings; -- Clear existing standings data
    INSERT INTO tempStandings ( -- Insert updated standings data
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
 -- from the home team perspective
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
 -- from the perspective of the visiting team
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
END;
/

--Q13
/* Trigger in the system to automate the execution of the spRunStandings SP when any row in the games table is updated. 
Essentially meaning that software can run SELECT * FROM tempStandings; and always have up to date standings. */

CREATE OR REPLACE TRIGGER trRunStandings AFTER
    UPDATE ON games
BEGIN
    spRunStandings;
END;
/

--Q14


-- Sample execution code

-- Q1
DECLARE
    v_reg_number VARCHAR2(50);
    v_last_name VARCHAR2(50);
    v_first_name VARCHAR2(50);
    v_is_active INTEGER;
    v_error_code INTEGER;
BEGIN
    spPlayersSelect(101, v_reg_number, v_last_name, v_first_name, v_is_active, v_error_code);

    IF v_error_code = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Reg#: ' || v_reg_number || ', Last Name: ' || v_last_name || ', First Name: ' || v_first_name || ', Active: ' || v_is_active);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: ' || v_error_code);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/


BEGIN
    spteamrosterbyid(210);   -- Q?
    spSchedUpcomingGames(7); -- Q?
    spSchedPastGames(30);    -- Q?
END;
/

    SELECT
        *
    FROM
        vwTeamsNumPlayers;
    SELECT
        fncNumPlayersByTeamID(216)
    FROM
        DUAL;
    SELECT
        *
    FROM
        vwSchedule;

DECLARE
    error integer;
BEGIN 
    spTeamRosterByName('Aurora', error);
END;
/