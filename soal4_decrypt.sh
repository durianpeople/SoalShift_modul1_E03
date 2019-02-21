#!/bin/bash
echo "Ketik path ke file"
read path
hour=`echo $path | awk -F/ '{print $NF}' | awk -F: '{print $1}'`

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

echo "${dest[*]}"
echo "${source[*]}"

filename=`echo $path | awk -F/ '{print $NF}' | awk -F "'" '{print $1}' | awk -F. '{print $1}'`


tr "${dest[*]}" "${source[*]}" < "$path" > "/home/durianpeople/Documents/Notes/SISOP/$filename.decrypted"

