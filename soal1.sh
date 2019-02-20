#!/bin/bash
unzip /home/durianpeople/Downloads/nature.zip -d /home/durianpeople/Downloads
mkdir /home/durianpeople/Downloads/nature2
for i in `ls /home/durianpeople/Downloads/nature/`; do 
base64 -d /home/durianpeople/Downloads/nature/$i | 
xxd -r > /home/durianpeople/Downloads/nature2/$i; 
done