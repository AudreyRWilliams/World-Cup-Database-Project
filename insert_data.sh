#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS


do
if (( $YEAR != 'year' ))
then
  echo **Year: $YEAR, Round: $ROUND, Winner: $WINNER, Opponent: $OPPONENT, Winner_Goals: $WINNER_GOALS, Opponent_Goals: $OPPONENT_GOALS
  
  COUNT_WINNER=$($PSQL "select count(name) from teams where name='$WINNER'") 
  echo *COUNT_WINNER*: $COUNT_WINNER
  
  if (( $COUNT_WINNER == 0 ))
  then   
    echo winner not in teams table. will insert them here.
    echo $($PSQL "insert into teams(name) values('$WINNER')")   
  fi
  COUNT_OPPONENT=$($PSQL "select count(name) from teams where name='$OPPONENT'")
  echo *COUNT_OPPONENT*: $COUNT_OPPONENT
 
  if (( $COUNT_OPPONENT == 0 ))
  then
    echo opponent not in teams table. will insert them here.
    echo $($PSQL "insert into teams(name) values('$OPPONENT')")
  fi

#vvvvv insert into games table order vvvvvv
#first: get team_id from teams table for winner
#second: that team_id will be the winner_id in the games table
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
#third: get team_id from teams table for opponent
#fourth: that time_id will be the opponent_id in the games table
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
#FINAL: insert values into the games table
  echo $($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")

fi
done
