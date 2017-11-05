#!/bin/bash

DBName=mysql
DBUser=user
DBPasswd=passwd
BackupPath=/var/
LogFile=/var/log/db.log
DBPath=/var/lib/mysql/mysql

NewFile="$BackupPath"db$(date +%Y%m%d).tgz
DumpFile="$BackupPath"db$(date +%Y%m%d)
OldFile="$BackupPath"db$(date +%Y%m%d --date='5 days ago').tgz

echo "---------------------------------" >> $LogFile
echo $(date +"%y-%m-%d %H:%M:%S") >> $LogFile
echo "---------------------------------" >> $LogFile

if [ -f $OldFile ]
then
	rm -rf $OldFile >> $LogFile 2>&1
	echo "[$OldFile]Delete old file succes!" >> $LogFile
else
	echo "[$OldFile]no old backup file" >> $LogFile
fi

if [ -f $NewFile ]
then
	echo "[$NewFile]the backup file is exists,  can't backup!" >> $LogFile
else
	read -p "input your choice: " BackupMethod
	case $BackupMethod in
		mysqldump)
		mysqldump -u$DBUser -p$DBPasswd $DBName > $DumpFile
		tar -cvzf $NewFile $DumpFile >> $LogFile 2>&1 
		echo "[$NewFile]backup succes" >> $LogFile
		rm -rf $DumpFile
		;;
		mysqlhotcopy)
		rm -rf $DumpFile
		mkdir $DumpFile
		mysqlhotcopy -u$DBUser -p$DBPasswd $DBName $DumpFile >> $LogFile 2>&1 
		tar -czvf $NewFile $DumpFile >> $LogFile 2>&1 
		echo "[$NewFile]backup succes" >> $LogFile
		rm -rf $DumpFile
		;;
		*)
		/etc/init.d/mysqld stop >/dev/null 2>&1 
		tar czvf $NewFile $DBPath$DBName >> $LogFile 2>&1 
		/etc/init.d/mysqld start > /dev/null 2>&1 
		echo "[$NewFile]backup succes" >> $LogFile
		;;
	esac
fi
	
echo "--------------------------------------" >> $LogFile