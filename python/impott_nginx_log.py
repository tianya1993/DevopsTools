#/usr/bin/env python
#-*-coding:UTF-8 -*-
from  datetime  import  datetime

stat_days = []
import   pymysql
#print(datetime.now().strftime("%Y-%m-%d %H:%M:%S")) #2018-05-25 22:23:44
#print(datetime.now().strftime("%d/%b-%Y %H:%M:%S")) #25/May-2018 22:23:44格式
#print(datetime.strptime('17/Jun/2017:12:11:16',"%d/%b/%Y:%H:%M:%S")) #格式转换
connect=pymysql.connect(
	host='127.0.0.1',
	port=3306,
	user='root',
	password='',
	database='nginxlog',
	charset="utf8"

)
cur = connect.cursor()
sql= "insert into nginxlog(ip,time,methods,source,protocol,status) values(%s,%s,%s,%s,%s,%s)"

with open("portal_ssl.access.log","r")  as  ngfile:
	try:
		for line in ngfile:
			_nodes = line.split()
			IP= _nodes[0]
			Time= _nodes[3][1:-1].replace(":"," ",1) #将时间转换为17/Jun/2017 12:43:4格式
			Time = datetime.strptime(Time,"%d/%b/%Y %H:%M:%S")#将时间格式化为2017-06-17 12:43:04
			Methods = _nodes[5][1:]
			Source = _nodes[6][0:599]
			Protocol = _nodes[7][:-1]
			Status = _nodes[8]
			#print(IP,Time,Methods,Source,Protocol,Status)
			cur.execute(sql,(IP,Time,Methods,Source,Protocol,Status))
			connect.commit()
		connect.close()
	except BaseException as e:
		print("数据写入数据库异常log error:%s",line)
	
	
	
	"""try:
			
			#跳过错误字段
			if len(_nodes) <12:
				continue
				print(_nodes)
			#IP   datetime   methods  url   status  bytes
			#print(_nodes[0],_nodes[3][1:],_nodes[5][1:],_nodes[6],_nodes[8],_nodes[9])
			_day = datetime.strptime(_nodes[3][1:],"%d/%b-%Y %H:%M:%S").strftime("Y-%m-%d")
			#设置每天的默认值
			stat_days.setdefault(_day,{'hits':0,'vistors':{},'status':{},'bytes':0})
			#设置没出现的IP的访问次数 默认为0
			stat_days[_days]['vistors'].setdefault(_nodes[0],0)
			#设置每天出现的状态码默认为0
			stat_days[_days]['status'].setdefault(_nodes[0], 0)
			
			#统计数据
			stat_days[_days]['hits'] += 1
			stat_days[_days]['vistors'][_nodes[0]] +=1
			stat_days[_days]['status'][_nodes[0]] += 1
			stat_days[_days]['bytes'] += int(_nodes[0]) if _nodes[9].isdigit() else 0
		except BaseException as e:
			print('log error:%s' %line)
		#总的数据
			
	"""
			
