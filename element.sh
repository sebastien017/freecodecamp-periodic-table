#!/bin/bash

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  PARAM=$1
  REQUEST="select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from properties inner join elements using(atomic_number) inner join types using(type_id)"

  if [[ $PARAM =~ ^[0-9]*$ ]]
  then
    REQUEST+=" where atomic_number='$PARAM';"
  else
    REQUEST+=" where symbol='$PARAM' or name='$PARAM';"
  fi

  SELECT_ELEMENTS=$($PSQL "$REQUEST")

  if [[ -z $SELECT_ELEMENTS ]]
  then
    echo "I could not find that element in the database."
  else

    echo $SELECT_ELEMENTS | while IFS=\| read atomic_number symbol name type atomic_mass melting_point_celsius boiling_point_celsius
    do
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    done

  fi
  
fi
