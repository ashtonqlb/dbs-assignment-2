-- DBS311NEE Assignment 2 - Task 10
-- Author: Ashton Lunken (abennet@myseneca.ca)

/**
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
      SELECT gamenum, gamedatetime, HomeTeamName, VisitTeamName
      FROM vwSchedule
      WHERE gamedatetime BETWEEN SYSDATE AND SYSDATE + n
      ORDER BY gamedatetime;
  v_game_num INTEGER;
  v_game_date_time DATE;
  v_home_team_name VARCHAR2(10);
  v_visit_team_name VARCHAR2(10);
BEGIN
  OPEN cUpcomingGames;

  LOOP
    FETCH cUpcomingGames INTO v_game_num, v_game_date_time, v_home_team_name, v_visit_team_name;
    EXIT WHEN cUpcomingGames%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
        'Game Number: ' || v_game_num || 
        ', Date: ' || TO_CHAR(v_game_date_time, 'DD-MON-YYYY') || 
        ', Home Team: ' || v_home_team_name || 
        ', Visit Team: ' || v_visit_team_name
    );
  END LOOP;
  CLOSE cUpcomingGames;
EXCEPTION
  WHEN OTHERS THEN
    IF cUpcomingGames%ISOPEN THEN
      CLOSE cUpcomingGames;
    END IF;
END spSchedUpcomingGames;
/
