#!/bin/bash
#file variables
file=/home/dyandra/praktikum1/syslog.log
errorFile=error_message.csv
userFile=user_statistic.csv

#SOAL A
#buat error
errLog="(ERROR.)(.*)" #regex
log=$(grep -P -o "$errLog" $file)
# echo $log

#buat info
infLog="(INFO.)(.*)" #regex
log2=$(grep -P -o "$infLog" $file)
#echo $log2


# SOAL B
errorType="(?<=ERROR.)(.*)((?<![)])(?=.[(]))" #regex 
# errorList=$(grep -P -o "$errortype" $file)
errorCount=$(grep -P -o "$errorType" $file | sort -V | uniq -c | sort -n)
errorList=$(grep -P -o "$errorType" $file | uniq)
# echo $errorCount
# echo $errorList


#SOAL C
user="(?<=[(])(.*)(?=[)])" #regex 
userCount=$(grep -P -o "$user" $file | sort -n | uniq -c) 
userList=$(grep -P -o "$user" $file | sort -u)
# echo $userCount
# echo $userList


# SOAL D
printf "Error, Count\n" > $errorFile
echo "$errorCount" | sort -nr | \
while read count
do
    name=$(echo $count | cut -d " " -f 2-)
    sum=$(echo $count | cut -d " " -f 1 )
    echo "$name, $sum" 
done >> $errorFile


# SOAL E
printf "USERNAME, INFO, ERROR\n" > $userFile
echo "$userList" | \
while read username
do 
    info_user=$(echo $username | grep -c -P "$infLog.*((?<=[(])($username)(?=[)]))" $file)
    error_user=$(echo $username | grep -c -P "$errLog.*((?<=[(])($username)(?=[)]))" $file)
    echo "$username,$info_user, $error_user" 
done >> $userFile