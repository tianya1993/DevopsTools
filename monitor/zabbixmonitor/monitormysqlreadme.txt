UserParameter=mysql.ping,HOME=/var/lib/zabbix /home/admin/mysql3306/bin/mysqladmin -u zabbix  -p ping | grep -c alive
UserParameter=mysql.version,/home/admin/mysql3306/bin/mysql -V

UserParameter=mysql.status[*],/usr/lib/zabbix/externalscripts/checkmysqlstatus.sh  $1

