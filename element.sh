PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [ "$#" -eq 0 ]
then
  echo "Please provide an element as an argument."
  exit 0
fi


res="$($PSQL "SELECT elements.atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius  FROM elements JOIN properties on elements.atomic_number=properties.atomic_number JOIN types on types.type_id=properties.type_id where elements.atomic_number=$(($1)) or elements.name='$1' or elements.symbol='$1'")"

if [ -z "$res" ]
then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|'
read -ra newarr <<< "$res"
echo "The element with atomic number ${newarr[0]} is ${newarr[1]} (${newarr[2]}). It's a ${newarr[3]}, with a mass of ${newarr[4]} amu. ${newarr[1]} has a melting point of ${newarr[5]} celsius and a boiling point of ${newarr[6]} celsius."