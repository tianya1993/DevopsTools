#!/bin/bash
Tomcatstart="/usr/install/tomcat8/bin/startup.sh"  #tomcat启动脚本
Time=$(date +%F)
while  true
do
	jps > /tmp/ps.txt   #将jps输出结果输入到 ps.txt
	sleep 50
	if grep "Bootstrap" /tmp/ps.txt  #过滤Bootstrap 存在则表示tomcat正常
	then 
		echo " $Time tomcat  is  healthy" 
	else
		echo " $Time tomcat  is  crash..."  2>>/tmp/tomcaterror.log  
		/bin/sh  ${Tomcatstart}
	fi

	sleep  240
echo " $Time one time is ok" 


done


#缺点   该脚本不适合多个tomcat实例的情形 也是一种临时解决问题的方案

