#!/bin/bash


if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=salon -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
fi

echo "Welcome to My Salon, how can I help you?"

res="$($PSQL "SELECT * FROM services")"

function print_services() 
{
  for s in $res
  do
    IFS='|'
    read -ra service <<< "$s"
    echo "${service[0]}) ${service[1]}"
  done
  unset IFS
}

for (( ; ; ))
do
  print_services
  read SERVICE_ID_SELECTED
  res2="$($PSQL "SELECT service_id FROM services where service_id=$SERVICE_ID_SELECTED")"
  echo $res2
  if [[ $res2 =~ ^[0-9]+$ ]]
  then
    break
  fi
  echo "I could not find that service. What would you like today?"
done


echo "What's your phone number?"
read CUSTOMER_PHONE
res="$($PSQL "SELECT * FROM customers where phone='$CUSTOMER_PHONE'")"
if [ -z "$res" ]
then
  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  res="$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")"
else
  CUSTOMER_NAME="$($PSQL "SELECT name FROM customers where phone='$CUSTOMER_PHONE'")"
  echo $CUSTOMER_NAME
fi

customer_id="$($PSQL "SELECT customer_id FROM customers where phone='$CUSTOMER_PHONE'")"
SERVICE_NAME="$($PSQL "SELECT name FROM services where service_id=$SERVICE_ID_SELECTED")"
echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
res="$($PSQL "insert into appointments (service_id, customer_id, time) values ($SERVICE_ID_SELECTED, '$customer_id', '$SERVICE_TIME')")"

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."