#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

# Check if database exists, create if needed
DB_EXISTS=$($PSQL "SELECT 1 FROM information_schema.tables WHERE table_name='users'" 2>/dev/null)
if [[ -z $DB_EXISTS ]]; then
  echo "Setting up database..."
    $PSQL "CREATE TABLE IF NOT EXISTS users(user_id SERIAL PRIMARY KEY, username VARCHAR(22) UNIQUE NOT NULL, games_played INT DEFAULT 0, best_game INT)"
    fi

    SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

    echo "Enter your username:"
    read USERNAME

    USER_INFO=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME'")

    if [[ -z $USER_INFO ]]; then
      echo "Welcome, $USERNAME! It looks like this is your first time here."
        $PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, null)" > /dev/null
        else
          IFS='|' read -r DB_USERNAME GAMES_PLAYED BEST_GAME <<< "$USER_INFO"
            echo "Welcome back, $DB_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
            fi

            echo "Guess the secret number between 1 and 1000:"

            GUESSES=0

            while true; do
              read GUESS

                if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
                    echo "That is not an integer, guess again:"
                        continue
                          fi

                            GUESSES=$(( GUESSES + 1 ))

                              if [[ $GUESS -lt $SECRET_NUMBER ]]; then
                                  echo "It's higher than that, guess again:"
                                    elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
                                        echo "It's lower than that, guess again:"
                                          else
                                              echo "You guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

                                                  # Update user stats
                                                      CURRENT_INFO=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")
                                                          IFS='|' read -r CURRENT_GAMES CURRENT_BEST <<< "$CURRENT_INFO"

                                                              NEW_GAMES=$(( CURRENT_GAMES + 1 ))

                                                                  if [[ -z $CURRENT_BEST ]] || [[ $GUESSES -lt $CURRENT_BEST ]]; then
                                                                        $PSQL "UPDATE users SET games_played=$NEW_GAMES, best_game=$GUESSES WHERE username='$USERNAME'" > /dev/null
                                                                            else
                                                                                  $PSQL "UPDATE users SET games_played=$NEW_GAMES WHERE username='$USERNAME'" > /dev/null
                                                                                      fi

                                                                                          break
                                                                                            fi
                                                                                            done
