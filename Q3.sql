-- DBS311NEE Assignment 2 - Task 3
-- Author: Liam Toye (lctoye@myseneca.ca)

/*  Task 3: Repeat Step 2 but returning the table in the output of the SP. 
Use a non-saved procedure to show receiving the data and outputting it to the script window.
  */

-- **************************************************************************************
-- Table-returning stored procedures
-- **************************************************************************************

CREATE OR REPLACE PROCEDURE spDivsSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            divs;
END;
/

CREATE OR REPLACE PROCEDURE spGamesSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            games;
END;
/

CREATE OR REPLACE PROCEDURE spGoalscorersSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            goalscorers;
END;
/

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

CREATE OR REPLACE PROCEDURE spLocationsSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            sllocations;
END;
/

CREATE OR REPLACE PROCEDURE spStandingsSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            standings;
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

CREATE OR REPLACE PROCEDURE spTeamsInDivsSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            teamsindivs;
END;
/

CREATE OR REPLACE PROCEDURE spXPeopleSelectAll(
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            *
        FROM
            xpeople;
END;
/

-- **************************************************************************************
-- Non-saved procedures to show receiving the data and outputting it to the script window
-- **************************************************************************************

-- DIVS
DECLARE
    v_cursor       SYS_REFCURSOR;
    v_divID        NUMBER;
    v_divName      VARCHAR2(50);
    v_isActive     NUMBER;
    v_isDefault    NUMBER;
    v_displayOrder NUMBER;
BEGIN
    spDivsSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_divID, v_divName, v_isActive, v_isDefault, v_displayOrder;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_divID || ' ' || v_divName || ' ' || v_isActive || ' ' || v_isDefault || ' ' || v_displayOrder);
    END LOOP;

    CLOSE v_cursor;
END;
/

-- GAMES
DECLARE
    v_cursor       SYS_REFCURSOR;
    v_gameID       NUMBER;
    v_divID        NUMBER;
    v_gameNum      NUMBER;
    v_gameDateTime DATE;
    v_homeTeam     NUMBER;
    v_homeScore    NUMBER;
    v_visitTeam    NUMBER;
    v_visitScore   NUMBER;
    v_locationID   NUMBER;
    v_isPlayed     NUMBER;
    v_notes        VARCHAR2(100);
BEGIN
    spGamesSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_gameID, v_divID, v_gameNum, v_gameDateTime, v_homeTeam, v_homeScore, v_visitTeam, v_visitScore, v_locationID, v_isPlayed, v_notes;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_gameID || ' ' || v_divID || ' ' || v_gameNum || ' ' || v_gameDateTime || ' ' || v_homeTeam || ' ' || v_homeScore || ' ' || v_visitTeam || ' ' || v_visitScore || ' ' || v_locationID || ' ' || v_isPlayed || ' ' || v_notes);
    END LOOP;

    CLOSE v_cursor;
END;
/

-- GOALSCORERS
DECLARE
    v_cursor     SYS_REFCURSOR;
    v_goalID     NUMBER;
    v_gameID     NUMBER;
    v_playerID   NUMBER;
    v_teamID     NUMBER;
    v_numGoals   NUMBER;
    v_numAssists NUMBER;
BEGIN
    spGoalscorersSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_goalID, v_gameID, v_playerID, v_teamID, v_numGoals, v_numAssists;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_goalID || ' ' || v_gameID || ' ' || v_playerID || ' ' || v_teamID || ' ' || v_numGoals || ' ' || v_numAssists);
    END LOOP;

    CLOSE v_cursor;
END;
/

-- PLAYERS
DECLARE
    v_cursor    SYS_REFCURSOR;
    v_playerID  NUMBER;
    v_regNum    NUMBER;
    v_lastName  VARCHAR2(50);
    v_firstName VARCHAR2(50);
    v_isActive  NUMBER;
BEGIN
    spPlayersSelectAll(SYS_REFCURSOR);
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

-- LOCATIONS
DECLARE
    v_cursor      SYS_REFCURSOR;
    v_locationID  NUMBER;
    v_location    VARCHAR2(50);
    v_fieldLength NUMBER;
    v_isActive    NUMBER;
BEGIN
    spLocationsSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_locationID, v_location, v_fieldLength, v_isActive;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_locationID || ' ' || v_location || ' ' || v_fieldLength || ' ' || v_isActive);
    END LOOP;

    CLOSE v_cursor;
END;
/

-- STANDINGS
DECLARE
    v_cursor   SYS_REFCURSOR;
    v_teamID   NUMBER;
    v_teamName VARCHAR2(50);
    v_gp       NUMBER;
    v_w        NUMBER;
    v_l        NUMBER;
    v_t        NUMBER;
    v_pts      NUMBER;
    v_gf       NUMBER;
    v_ga       NUMBER;
    v_gd       NUMBER;
BEGIN
    spStandingsSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_teamID, v_teamName, v_gp, v_w, v_l, v_t, v_pts, v_gf, v_ga, v_gd;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_teamID || ' ' || v_teamName || ' ' || v_gp || ' ' || v_w || ' ' || v_l || ' ' || v_t || ' ' || v_pts || ' ' || v_gf || ' ' || v_ga || ' ' || v_gd);
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

-- TEAMSINDIVS
DECLARE
    v_cursor SYS_REFCURSOR;
    v_linkID NUMBER;
    v_teamID NUMBER;
    v_divID  NUMBER;
BEGIN
    spTeamsInDivsSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_linkID, v_teamID, v_divID;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_linkID || ' ' || v_teamID || ' ' || v_divID);
    END LOOP;

    CLOSE v_cursor;
END;
/

-- XPEOPLE
DECLARE
    v_cursor    SYS_REFCURSOR;
    v_pid       NUMBER;
    v_firstName VARCHAR2(50);
    v_lastName  VARCHAR2(50);
    v_dob       DATE;
    v_isActive  NUMBER;
    v_favNum    NUMBER;
BEGIN
    spXPeopleSelectAll(v_cursor);
    LOOP
        FETCH v_cursor INTO v_pid, v_firstName, v_lastName, v_dob, v_isActive, v_favNum;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_pid || ' ' || v_firstName || ' ' || v_lastName || ' ' || v_dob || ' ' || v_isActive || ' ' || v_favNum);
    END LOOP;

    CLOSE v_cursor;
END;
/