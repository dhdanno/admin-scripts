#!/bin/bash
# Daniel Korel
# September 2015
# execute command on all databases matching a name prefix
# on a multitennant postgres system. Use with caution

if [ -z "$1" ]; then
        echo "Usage: db_update.sh [database prefix] [command with tailing ;]"
        exit
fi
if [ -z "$2" ]; then
        echo "Usage: db_update.sh [database prefix] [command with tailing ;]"
        exit
fi

# force a prefix after the first argument
SEARCH=$1
SEARCH+="_"

# get the command
COMMAND=$2

# assign output to an array
arr=($(psql -U postgres -c "\list" | grep $SEARCH | awk '{print $1}'))

# check for empty array
if [ -z "${arr[0]}" ]; then
        echo "no databases found with that prefix"
        exit
fi

#confirm run
read -r -p "Are you sure you want to continue? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
        ;;
    *)
        exit
        ;;
esac

# loop array
for i in "${!arr[@]}"
do
        echo "Processing command on ${arr[i]}"
        psql -U postgres ${arr[i]} -c "$COMMAND"
done
