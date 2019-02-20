#!/bin/bash

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

hour=`date +"%H"`
IFS=
while read -N1 c; do 
    ascii=`ord $c`
    output=$c
    # echo "$ascii"
    if [ "$ascii" -ge 65 -a "$ascii" -le 90 ] 
    then
        output=`chr $(( (ascii - 65 + hour) % 26 + 65 ))`
    elif [ "$ascii" -ge 97 -a "$ascii" -le 122 ] 
    then
        output=`chr $(( (ascii - 97 + hour) % 26 + 97 ))`
    fi
    printf "%c" $output
done < /var/log/syslog
# > /home/durianpeople/Documents/sisop_playground/`date +"%H:%M %d-%m-%Y"`.txt