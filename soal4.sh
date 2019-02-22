#!/bin/bash

hour=`date +"%-H"`
sourcelower=({a..z})
sourceupper=({A..Z})
offset=$(($hour % 26))
if [ "$offset" -lt 0 ]; then
    offset=0
fi
destlower=(${sourcelower[*]:$offset} ${sourcelower[*]:0:$offset})
destupper=(${sourceupper[*]:$offset} ${sourceupper[*]:0:$offset})

source=(${sourcelower[*]} ${sourceupper[*]})
dest=(${destlower[*]} ${destupper[*]})

echo "${source[*]}"
echo "${dest[*]}"

cat /var/log/syslog | 
tr "${source[*]}" "${dest[*]}" > "/home/durianpeople/Documents/Notes/SISOP/`date +"%H:%M %d-%m-%Y"`.encrypted"