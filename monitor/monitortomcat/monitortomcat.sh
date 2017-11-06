#!/bin/bash
Tomcatstart="/usr/install/tomcat8/bin/startup.sh"
Time=$(date +%F)
while  true
do
	jps > /tmp/ps.txt
	sleep 50
	if grep "Bootstrap" /tmp/ps.txt
	then 
		echo " $Time tomcat  is  healthy" 
	else
		echo " $Time tomcat  is  crash..."  2>>/tmp/tomcaterror.log  
		/bin/sh  ${Tomcatstart}
	fi

	sleep  240
echo " $Time one time is ok" 


done

