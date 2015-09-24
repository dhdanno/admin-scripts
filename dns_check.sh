#!/bin/bash
# Daniel Korel
# July 2015
# compare data inside a tinydns 'data' file with live DNS data to
# determine if live dns reflects this server's


mapfile -t domain < <(cat data | awk -F':' '{ print $1 }' | awk -F"'" '{ print $3 }')


for (( i=0; i<${#domain[@]}; i++ )); do

        #printf "\t";
        # the IP
        ONE=$(nslookup ${domain[i]} | grep -v '#' | grep Address | awk '{print $2}')
        # the domain

        TWO=$(nslookup ${domain[i]} | grep Name | awk '{print $2}')

        printf "%s %s\n" $ONE $TWO

done
