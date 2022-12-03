#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"
echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-6]+$ ]]
then
  echo -e "\nI could not find that service. What would you like today?"
  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  GET_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $GET_PHONE_NUMBER ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, phone, name, time, customer_id) VALUES($SERVICE_ID_SELECTED, '$CUSTOMER_PHONE', '$CUSTOMER_NAME', '$SERVICE_TIME', $CUSTOMER_ID)")
    if [[ $INSERT_APPOINTMENT == "INSERT 0 1" ]]
    then 
      echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi
fi


