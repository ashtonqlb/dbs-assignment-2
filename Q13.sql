-- DBS311NEE Assignment 2 - Task 13
-- Author: Liam Toye (lctoye@myseneca.ca)

/* Trigger in the system to automate the execution of the spRunStandings SP when any row in the games table is updated. 
Essentially meaning that software can run SELECT * FROM tempStandings; and always have up to date standings. */

CREATE OR REPLACE TRIGGER trRunStandings AFTER
    UPDATE ON games
BEGIN
    spRunStandings;
END;
/