#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=freecodecamp --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.



cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	if [[ $ROUND == 'Eighth-Final' ]]
	then
		COMPARACION=$($PSQL "SELECT name FROM teams")
		for i in $COMPARACION
		do
			if [[ $i == $WINNER ]]
			then
				COINCIDENCIA=1
			fi

		done
		if [[ $COINCIDENCIA != 1 ]]
		then 
			INSERT_WINNER=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
			
			if [[ $INSERT_WINNER =~ INSERT.* ]]
			then
				echo $WINNER adentro
			fi
		fi
		COINCIDENCIA=0
		
		for y in $COMPARACION
		do
			if [[ $y == $OPPONENT ]]
			then 
				COINCIDENCIA=2
			fi
		done

		if [[ $COINCIDENCIA != 2 ]]
		then
			INSERT_OPPONENT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")

			if [[ $INSERT_OPPONENT =~ INSERT.* ]]
			then 
				echo $OPPONENT adentro
			fi
		fi

	fi


done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	if [[ $YEAR != 'year' ]]
	then
		WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")


		INSERT_DATA=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

		if [[ $INSERT_DATA =~ INSERT.* ]]
		then
			echo Datos insertados
		fi
		


	fi
done

