**TODO:**
Add error checking to functions and add the expected error codes to this user guide.

---

### User's Guide for Sports League Stored Procedures (WIP)

#### Procedure Q1: spPlayersInsert

- **Purpose**: Inserts a new player into the PLAYERS table, generating a new ID if not provided.
- **Input Parameters**:
  - `p_player_id` (INTEGER, optional): Player ID. If NULL, a new ID is generated.
  - `p_reg_number` (VARCHAR2): Unique registration number of the player.
  - `p_last_name` (VARCHAR2): Last name of the player.
  - `p_first_name` (VARCHAR2): First name of the player.
  - `p_is_active` (INTEGER): Indicates active (1) or inactive (0) status of the player.
  - `p_error_code` (OUT, INTEGER): Output parameter for potential error codes.
- **Expected Output**: None directly. Errors indicated through `p_error_code`.
- **Error Codes**:
  - `-2`: Duplicate player ID or registration number.
  - `-3`: Data type/format mismatch.
  - `-4`: Generic/unexpected error.
- **Example**:
  ```sql
  DECLARE
    v_error_code INTEGER;
  BEGIN
    spPlayersInsert(NULL, '12345', 'Doe', 'John', 1, v_error_code);
    IF v_error_code <> 0 THEN
      -- Handle error
    END IF;
  END;
  ```

#### Procedure Q2: spPlayersSelectAll, spRostersSelectAll, spTeamsSelectAll

- **Purpose**: Outputs all records from the respective tables (PLAYERS, ROSTERS, TEAMS) using `DBMS_OUTPUT`.
- **Input Parameters**: None.
- **Expected Output**: All records from the respective table displayed in the script window.
- **Potential Errors**:
  - 'Unable to retrieve player data.'
  - 'Unable to retrieve roster data.'
  - 'Unable to retrieve team data.'
- **Example**:
  ```sql
  BEGIN
    spPlayersSelectAll; -- Replace with respective procedure for ROSTERS or TEAMS
  END;
  ```

#### Procedure Q3: spPlayersSelectAll, spRostersSelectAll, spTeamsSelectAll (Cursor Version)

- **Purpose**: Returns a cursor with all records from the respective tables.
- **Input Parameters**: `p_cursor` (OUT, SYS_REFCURSOR): Output cursor containing table records.
- **Expected Output**: Cursor with all records.
- **Potential Errors**:
  - 'Unable to retrieve player data.'
  - 'Unable to retrieve roster data.'
  - 'Unable to retrieve team data.'
- **Example**:
  ```sql
  DECLARE
    v_cursor SYS_REFCURSOR;
  BEGIN
    spPlayersSelectAll(v_cursor);
    -- Process cursor data
    CLOSE v_cursor;
  END;
  ```

#### Procedure Q4: vwPlayerRosters (View Creation)

- **Purpose**: Creates a view combining players, rosters, and teams data.
- **Input Parameters**: None (View creation).
- **Expected Output**: A new view `vwPlayerRosters` is created.

#### Procedure Q5: spTeamRosterByID

- **Purpose**: Displays the team roster for a specified team ID.
- **Input Parameters**: `v_teamid` (NUMBER): Team ID to query.
- **Expected Output**: Roster information of the specified team.
- **Error Codes**: None.
- **Example**:
  ```sql
  BEGIN
    spteamrosterbyid(123); -- Replace with the desired team ID
  END;
  ```

#### Procedure Q6: spTeamRosterByName

- **Purpose**: Searches and displays team roster by a partial/full team name.
- **Input Parameters**: `p_team_name` (VARCHAR2): Partial or full team name.
- **Expected Output**: Roster information of teams matching the name.
- **Error Codes**:
  - `1`: No data found.
  - `-3`: Data type/format mismatch.
  - `-4`: Generic/unexpected error.
- **Example**:
  ```sql
  BEGIN
    spTeamRosterByName('Noobs'); -- Replace with the team name to search
  END;
  ```

#### Procedure Q7: vwTeamsNumPlayers (View Creation)

- **Purpose**: Creates a view that lists teams along with the number of active players.
- **Input Parameters**: None (View creation).
- **Expected Output**: A new view `vwTeamsNumPlayers` is created.

#### Function Q8: fncNumPlayersByTeamID

- **Purpose**: Retrieves the number of active players in a team based on team ID.
- **Input Parameters**: `p_team_id` (NUMBER): Team ID.
- **Expected Output**: Number representing count of active players.
- **Error Codes**:
  - `-1`: No team found with given ID.
  - `-4`: Generic/unexpected error.
- **Example**:

```sql
  DECLARE
    v_num_players NUMBER;
  BEGIN
    v_num_players := fncNumPlayersByTeamID(123); -- Replace with the desired team ID
-- Display or use v_num_players
END;
```

#### Procedure Q9: vwSchedule (View Creation)

- **Purpose**: Creates a view for game schedules.
- **Input Parameters**: None (View creation).
- **Expected Output**: A new view `vwSchedule` is created.

#### Procedure Q10: spSchedUpcomingGames

- **Purpose**: Retrieves and displays upcoming games within 'n' days.
- **Input Parameters**: `n` (INTEGER): Number of days ahead to retrieve games.
- **Expected Output**: Information about upcoming games.
- **Potential Errors**:
  - 'Error: Invalid number of days.'
    - Solution: Must pass a valid integer.
  - 'Error: Unable to retrieve upcoming games.'
    - Generic error; double-check command.
- **Example**:

```sql
BEGIN
  spSchedUpcomingGames(7); -- Replace with the number of days ahead
END;
```

#### Procedure Q11: spSchedPastGames

- **Purpose**: Displays games played in the past 'n' days.
- **Input Parameters**: `n` (NUMBER): Number of past days to query.
- **Expected Output**: Game records from the past 'n' days.
- **Potential Errors**:
  - 'Error: Invalid number of days.'
    - Solution: Must pass a valid integer.
  - 'Error: Unable to retrieve upcoming games.'
    - Generic error; double-check command.
- **Example**:
  ```sql
  BEGIN
    spSchedPastGames(30); -- Replace with the number of past days
  END;
  ```

#### Procedure Q12: spRunStandings

- **Purpose**: Updates the `tempStandings` table with current standings data.
- **Input Parameters**: None.
- **Expected Output**: Updated `tempStandings` table.
- **Error Codes**: None.
- **Example**:
  ```sql
  BEGIN
    spRunStandings;
  END;
  ```

#### Trigger Q13: trRunStandings

- **Purpose**: Automates the execution of `spRunStandings` on updates in the games table.
- **Input Parameters**: Triggered by update on games table.
- **Expected Output**: Automatic update of standings upon any change in the games table.
- **Error Codes**: None.
- **Example**: User can take advantage of this trigger to run the following query at any time for up-to-date league standings:

```sql
SELECT * FROM tempStandings
```

#### Procedure Q14: spGetAllStars

- **Purpose**: Identifies and displays the all-star lineup of players with the most goals for their team in the current season.
- **Input Parameters**: None.
- **Expected Output**: A list of all-star players, with each player's team name, player name, and total goals scored in the season.
- **Potential Errors**:
  - 'Error: Unable to retrieve all star players.'
    - Generic error messages; double-check command.
- **Example**:
  ```sql
  BEGIN
    spGetAllStars;
  END;
  ```
