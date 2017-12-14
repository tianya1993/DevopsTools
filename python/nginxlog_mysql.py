#!/usr/bin/python
# -*- coding:utf-8 -*-
import re
import datetime
import time
import MySQLdb as mdb
import json
import urllib
import sys 
log = "/root/access_" + (datetime.datetime.now() - datetime.timedelta(days=1)).strftime('%Y-%m-%d')  + ".log"
line = open(log,'r')
con = mdb.connect('localhost','','','database',charset="utf8")
cur = con.cursor()
 
try:
    for i in line:
        matchObj = re.match(r'(.*)  \[(.*)\] \"(.*) (\/.*) (.*)\" (.*) (.*) (.*) \"(.*)\" \"(.*)\"', i, re.I)
        if matchObj != None:
            ip = matchObj.group(1)
            API = "http://ip.taobao.com/service/getIpInfo.php?ip=" + ip
            jsondata = json.loads(urllib.urlopen(API).read())
            address = jsondata['data']['country'] + jsondata['data']['region'] + jsondata['data']['city'] + jsondata['data']['isp']
            time = matchObj.group(2)
            method = matchObj.group(3)
            request = matchObj.group(4)
            status = int(matchObj.group(6))
            bytesSent = int(matchObj.group(7))
            request_time = float(matchObj.group(8))
            refer = matchObj.group(9)
            agent = matchObj.group(10)
            cur.execute('insert into nginx_access_log values("%s","%s","%s","%s","%s",%d,%d,%f,"%s","%s")' % (ip,address,time,method,request,status,bytesSent,request_time,refer,agent))
finally:
    line.close()
    cur.close()