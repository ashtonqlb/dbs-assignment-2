-- DBS311NEE Assignment 2 - Task 3
-- Author: Liam Toye (lctoye@myseneca.ca)

/*  Task 3: Repeat Step 2 but returning the table in the output of the SP. 
Use a non-saved procedure to show receiving the data and outputting it to the script window.
  */

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