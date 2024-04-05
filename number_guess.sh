#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=number_guess -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
fi

random_number=$((1 + RANDOM % 10))

echo "Enter your username:"
read username

res="$($PSQL "SELECT username FROM users WHERE username='$username'")"

if [ -z "$res" ]
then
  res="$($PSQL "insert into users (username) values ('$username')")"
  echo "Welcome, $username! It looks like this is your first time here."
else
  count_games="$($PSQL "SELECT count(*) FROM games WHERE username='$username'")"
  number="$($PSQL "SELECT MAX(number) FROM games WHERE username='$username'")"
  echo "Welcome back, $username! You have played $count_games games, and your best game took $number guesses."
fi

echo "Guess the secret number between 1 and 1000:"

count=0
for (( ; ; ))
do
  count=$((count+1))
  read input_number
  if ! [[ $input_number =~ ^[0-9]+$ ]]
  then 
    echo "That is not an integer, guess again:" 
  elif [[ $input_number -gt $random_number ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $input_number -lt $random_number ]]
  then
    echo "It's higher than that, guess again:"
  else
    res="$($PSQL "insert into games (number, username) values ($count, '$username')")"
    echo "You guessed it in $count tries. The secret number was $random_number. Nice job!"
    break
  fi
done
