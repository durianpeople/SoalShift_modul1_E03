#!/bin/bash
choose() { echo ${1:RANDOM%${#1}:1} $RANDOM; }
pass="$({   choose '0123456789'
  choose 'abcdefghijklmnopqrstuvwxyz'
  choose 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  for i in $( seq 1 $(( 9 )) )
     do
        choose '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
     done
 } | sort -R | awk '{printf "%s",$1}')"

flag=1
while true
do
if [ ! -f /home/akmal/Documents/Password$flag.txt ]
then
	echo $pass > /home/akmal/Documents/Password$flag.txt
	break
else	
	flag=$((flag + 1))
fi
done
