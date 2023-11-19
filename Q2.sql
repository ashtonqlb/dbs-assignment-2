-- DBS311NEE Assignment 2 - Task 2
-- Author: Liam Toye (lctoye@myseneca.ca)

/*  For each table in (Players, Teams, Rosters), create an additional Stored Procedure, 
    called spTableNameSelectAll that outputs the contents of the table to the script window 
    (using DBMS_OUTPUT) for the standard SELECT * FROM <tablename> statement.   */


-- DIVS
CREATE OR REPLACE PROCEDURE spdivsselectall IS
BEGIN
    dbms_output.put_line('DivID DivName IsActive IsDefault DisplayOrder');
    dbms_output.put_line('----- ------- -------- --------- ------------');
    FOR i IN (
        SELECT
            *
        FROM
            divs
    ) LOOP
        dbms_output.put_line(i.divid || ' ' || i.divname || ' ' || i.isactive || ' ' || i.isdefault || ' ' || i.displayorder);
    END LOOP;
END;
/

-- GAMES
CREATE OR REPLACE PROCEDURE spgamesselectall IS
BEGIN
    dbms_output.put_line('GameID DivID GameNum GameDateTime HomeTeam HomeScore VisitTeam VisitScore LocationID IsPlayed Notes');
    dbms_output.put_line('------ ----- -------- ----------- -------- --------- --------- ---------- -------- -----');
    FOR i IN (
        SELECT
            *
        FROM
            games
    ) LOOP
        dbms_output.put_line(i.gameid || ' ' || i.divid || ' ' || i.gamenum || ' ' || i.gamedatetime || ' ' || i.hometeam || ' ' || i.homescore|| ' ' || i.visitteam || ' ' || i.visitscore || ' ' || i.locationid || ' ' || i.isplayed || ' ' || i.notes);
    END LOOP;
END;
/

-- GOALSCORERS
CREATE OR REPLACE PROCEDURE spgoalscorersselectall IS
BEGIN
    dbms_output.put_line('GoalID GameID PlayerID TeamID NumGoals NumAssists');
    dbms_output.put_line('------ ------ -------- ------ -------- ----------');
    FOR i IN (
        SELECT
            *
        FROM
            goalscorers
    ) LOOP
        dbms_output.put_line(i.goalid || ' ' || i.gameid || ' ' || i.playerid || ' ' || i.teamid || ' ' || i.numgoals || ' ' || i.numassists);
    END LOOP;
END;
/

-- PLAYERS
CREATE OR REPLACE PROCEDURE spplayersselectall IS
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
CREATE OR REPLACE PROCEDURE sprostersselectall IS
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

-- SLLOCATIONS
CREATE OR REPLACE PROCEDURE splocationsselectall IS
BEGIN
    dbms_output.put_line('LocationID LocationName FieldLength IsActive');
    dbms_output.put_line('---------- ------------ ----------- --------');
    FOR i IN (
        SELECT
            *
        FROM
            sllocations
    ) LOOP
        dbms_output.put_line(i.locationid|| ' ' || i.locationname|| ' ' || i.fieldlength|| ' ' || i.isactive);
    END LOOP;
END;
/

-- STANDINGS
CREATE OR REPLACE PROCEDURE spstandingsselectall IS
BEGIN
    dbms_output.put_line('TeamID TeamName GP W L T PTS GF GA GD');
    dbms_output.put_line('------ -------- -- - - - --- -- -- --');
    FOR i IN (
        SELECT
            *
        FROM
            standings
    ) LOOP
        dbms_output.put_line(i.theteamid|| ' ' || i.teamname|| ' ' || i.gp|| ' ' || i.w|| ' ' || i.l|| ' ' || i.t|| ' ' || i.pts|| ' ' || i.gf|| ' ' || i.ga|| ' ' || i.gd);
    END LOOP;
END;
/

-- TEAMS
CREATE OR REPLACE PROCEDURE spteamsselectall IS
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

-- TEAMSINDIVS
CREATE OR REPLACE PROCEDURE spteamsindivsselectall IS
BEGIN
    dbms_output.put_line('LinkID TeamID DivID');
    dbms_output.put_line('------ ------ -----');
    FOR i IN (
        SELECT
            *
        FROM
            teamsindivs
    ) LOOP
        dbms_output.put_line(i.linkid || ' ' || i.teamid || ' ' || i.divid);
    END LOOP;
END;
/

-- XPEOPLE
CREATE OR REPLACE PROCEDURE spxpeopleselectall IS
BEGIN
    dbms_output.put_line('PID FirstName LastName DOB IsActive FavNum');
    dbms_output.put_line('--- --------- -------- --- -------- ------');
    FOR i IN (
        SELECT
            *
        FROM
            xpeople
    ) LOOP
        dbms_output.put_line(i.pid || ' ' || i.firstname || ' ' || i.lastname || ' ' || i.dob || ' ' || i.isactive || ' ' || i.favnum);
    END LOOP;
END;
/