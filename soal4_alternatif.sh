#!/bin/bash

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

hour=`date +"%H"`
syslog=`cat /var/log/syslog`
max=${#syslog}
counter=0
outputfile=
IFS=
while read -N1 c; do 
    counter=$(( counter+1 ))
    progress=$(( counter/max ))
    echo -ne "$counter of $max \r" 
    ascii=`ord $c`
    output=$c
    # echo "$ascii"
    if [ "$ascii" -ge 65 -a "$ascii" -le 90 ] 
    then
        output=`chr $(( (ascii - 64 + hour) % 26 + 64 ))`
    elif [ "$ascii" -ge 97 -a "$ascii" -le 122 ] 
    then
        output=`chr $(( (ascii - 96 + hour) % 26 + 96 ))`
    fi
    outputfile=$outputfile+$output
done < /var/log/syslog
echo -ne "\n"
echo "$outputfile" > /home/durianpeople/Documents/sisop_playground/`date +"%H:%M %d-%m-%Y"`.txt