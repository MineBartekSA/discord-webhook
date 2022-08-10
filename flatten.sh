#!/bin/bash
# Bash script for flattening cursed JSON

JSON=$1
i=0
replace=""
while [ $i -lt ${#JSON} ]
do
    if [ "${JSON:$i:1}" == $'\n' ]
    then
        [ "${JSON:$[i - 1]:1}" == $'\r' ] && cr=1 || cr=0
        JSON="${JSON:0:$[i - cr]}$replace${JSON:$[i + 1]}"
    elif [ "${JSON:$i:1}" == '"' ] && [ "${JSON:$[i - 1]:1}" != '\' ]
    then
        [ "$replace" == '' ] && replace="\\n" || replace=""
    fi
    i=$[i + 1]
done
echo "$JSON"
