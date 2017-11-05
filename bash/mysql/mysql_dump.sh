#!/bin/bash
# 此脚本为mysql备份脚本
# 支持完全备份, 增量备份, 单数据库, 所有数据库, 周一至周六增量备份, 周日完全备份.
# 更改datadir, bakdir路径, 添加任务计划即可

datadir="/var/lib/mysql"
bakdir="/tmp"
filename=`date +%Y%m%d%H%M%S`
username="root"
databasename="stu"
week=`date +%w`

# full backup
function full_backup (){
# one databases backup
	mysqldump -u$username --events --ignore-table=mysql.events --master-data=2 --flush-logs --databases $databasename > "$bakdir/full_$filename.sql"
# all databases backup 
# mysqldump -u$username --events --ignore-table=mysql.events --master-data=2 --flush-logs --all-databases > "$bakdir/all_$filename.sql"
}

# increnment backup 
function increment_backup (){
	cd $datadir
	inc_data=`tail -n 1 mysql-bin.index`
	cmd=`which mysqlbinlog`
	$cmd $inc_data > $bakdir/$filename.sql
	mysql -e "FLUSH LOGS;"
}

# write log ok
function write_log_ok(){

	logfile=$bakdir/mysqldump.log
	log_date=`date "+%Y-%m-%d %H:%M:%S"`

	if [ ! -e $logfile ];then
		touch $logfile
		`echo $log_date backup is OK!  >> $logfile`
	else
		`echo $log_date backup is OK!  >> $logfile`
	fi		
}

# write log failed
function write_log_failed(){

	logfile=$bakdir/mysqldump.log
	log_date=`date "+%Y-%m-%d %H:%M:%S"`

	if [ ! -e $logfile ];then
		touch $logfile
		`echo $log_date backup is Failed!  >> $logfile`
	else
		`echo $log_date backup is Failed!  >> $logfile`
	fi		
}

# check log
function log_check (){
	if [ $? -eq 0 ];then
		write_log_ok
	else
		write_log_failed
	fi
}

case $week in
1)
	increment_backup
	log_check;;
2)
	increment_backup
	log_check;;
3)
	increment_backup
	log_check;;
4)
	increment_backup
	log_check;;
5)
	increment_backup
	log_check;;
6)
	increment_backup
	log_check;;
0)
	full_backup
	log_check;;
esac

