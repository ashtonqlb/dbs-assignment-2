-- DBS311NEE Assignment 2 - Task 7
-- Author: Ashton Lunken (abennet@myseneca.ca)

/**
 * 
 * Selects all team IDs and team names and then counts how many player IDs have the selected team ID.
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
        TEAMS t
    LEFT JOIN ROSTERS r on t.teamid = r.teamid AND r.isactive = 1
    GROUP BY
        t.teamid,
        t.teamname
    ORDER BY
        num_players DESC;