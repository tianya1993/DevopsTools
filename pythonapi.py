#/usr/bin/env python
#_*_coding:utf-8_*_
import json
import  urllib
import requests
import  urllib.parse
url='http://api.k780.com:88'
def  msgdata(send_msg):  #定义一个简单的函数
    msg = {}
    msg['app'] = "qr.get"
    msg['data'] = send_msg
    msg['level'] = 'L'
    msg["size"] = 6
    data = urllib.parse.urlencode(msg).encode("utf-8")
    response = urllib.request.urlopen(url, data)
    result = response.read()
    with open(send_msg+ "s.jpg", "wb") as  f:
        f.write(result)
list2=["mysqlDBA","docker运维开发工程师","外滩征信上海","redis","Centos","mongodb","swarm"]
for   i in list2:
    msgdata(i)
