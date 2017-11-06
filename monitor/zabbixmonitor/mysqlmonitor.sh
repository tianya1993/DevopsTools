[admin@bund-mysql-m-020010 ~]$ cat   /usr/lib/zabbix/externalscripts/checkmysqlstatus.sh 
#!/bin/bash 
#Create 20170705

# 用户名
#MYSQL_USER='zabbixagent' 
MYSQL_USER='root' 
# 密码
#MYSQL_PWD='zabbixagent@2017' 
MYSQL_PWD=
# 主机地址/IP
MYSQL_HOST='127.0.0.1'
 
# 端口
MYSQL_PORT='3306'
#sock
MYSQL_SOCK=/data/data3306/data/mysql.sock
  
# 数据连接
#MYSQL_CONN="/home/admin/mysql3306/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -P${MYSQL_PORT} -S{NYSQL_SOCK}"
MYSQL_CONN="/home/admin/mysql3306/bin/mysqladmin -u${MYSQL_USER}   -h ${MYSQL_HOST} -P${MYSQL_PORT} -S{NYSQL_SOCK}"

ARGS=1 
if [ $# -ne "$ARGS" ];then 
    echo "Please input one arguement:" 
fi 
#获取数据
case $1 in 
    Uptime) 
        result=`$MYSQL_CONN  status|cut -f2 -d":"|cut -f1 -d"T"` 
            echo $result 
            ;; 
	Com_update) 
        result=`$MYSQL_CONN  extended-status |grep -w "Com_update"|cut -d"|" -f3` 
           echo $result 
           ;; 
    Slow_queries) 
        result=`$MYSQL_CONN  status |cut -f5 -d":"|cut -f1 -d"O"` 
                echo $result 
                ;; 
    Com_select) 
        result=`$MYSQL_CONN  extended-status |grep -w "Com_select"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_rollback) 
        result=`$MYSQL_CONN  extended-status |grep -w "Com_rollback"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Questions) 
        result=`$MYSQL_CONN status|cut -f4 -d":"|cut -f1 -d"S"` 
                echo $result 
                ;; 
    Com_insert) 
        result=`$MYSQL_CONN  extended-status |grep -w "Com_insert"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_delete) 
        result=`$MYSQL_CONN extended-status |grep -w "Com_delete"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_commit) 
        result=`$MYSQL_CONN  extended-status |grep -w "Com_commit"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_sent) 
        result=`$MYSQL_CONN extended-status |grep -w "Bytes_sent" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_received) 
        result=`$MYSQL_CONN extended-status |grep -w "Bytes_received" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_begin) 
        result=`$MYSQL_CONN extended-status |grep -w "Com_begin"|cut -d"|" -f3` 
                echo $result 
               ;; 
                        
        *) 
        echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions)" 
        ;; 
esac

