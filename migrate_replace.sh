#!/bin/bash
# Daniel Korel
# July 2015
# replace one argument with another on all files in dir

#declare -A array
#array[97.107.178.65]=104.255.8.207


## reversed
#array[$2]=$1


#for i in "${!array[@]}"
#do
#       echo "Key : $i"
#       echo "value: ${array[$i]}"

S=$2
R=$1


find . -type f -exec sed -i --follow-symlinks "s/$S/$R/g" {} \;


#done
