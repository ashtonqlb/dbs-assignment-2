-- DBS311NEE Assignment 2 - Task 9
-- Author: Ashton Lunken (abennet@myseneca.ca)

CREATE OR REPLACE VIEW vwSchedule AS
    SELECT
        g.gamenum,
        g.gamedatetime,
        g.hometeam,
        ht.teamname as HomeTeamName,
        g.visitteam,
        vt.teamname as VisitTeamName,
        l.locationname
    FROM 
        GAMES g
    INNER JOIN SLLOCATIONS l ON g.locationid = l.locationid
    INNER JOIN TEAMS ht ON g.hometeam = ht.teamid
    INNER JOIN TEAMS vt ON g.visitteam = vt.teamid
    ORDER BY g.gamedatetime;