#!/bin/bash
#sendmail  zabbbix  mailx


#echo "$3" | mail -s "$2" $1


export LANG=zh_CN.UTF-8

FILE=/tmp/mailtmp.txt
echo "$3" >$FILE
dos2unix -k $FILE           
/bin/mail -s "$2" $1 < $FILE

