#/usr/bin/env python
#-*-coding:UTF-8 -*-
ips=[]
datelist=[]
ips_once=[] #仅出现一次的IP集合
ipindex_list=[] #IP信息列表
commdatetime=[] #时间信息列表 和IP信息是一一对应
infodict={}    #创建了一个序列号  IP+时间的字典
ip_count_first=[] #仅出现一次的IP+时间集合
ip_count_many = [] #出现多次 IP第一次时间  第二次时间的集合
from   datetime  import  datetime
print("欢迎使用NGINX日志分析小工具！！！！")
print("功能一：统计每个IP访问的次数")
"""
with open("newlog.txt","r")  as  ngfile:
	for line in ngfile:
		iptime=line.split(' ')[0]
		ip =iptime.split('-')[0]
		time  = iptime.split('[')[1]
		time2  = da
		print(ip,time)"""
with open("nginxlog.txt","r")  as  ngfile:
	for line in ngfile:
		ips.append(line.split()[0])
		datelist.append(line.split()[1])
		for i  in range(0,int(len(ips))):
			infodict[i]= "IP:"+ips[i]+" 访问时间："+datelist[i]
	for ip in set(ips):
		ip_count = str(ips).count(ip)
		print("IP地址： "+ip+" 访问书次数："+ str(ip_count))
		if ip_count == 1:
			ip_index = ips.index(ip)
			ip_count_first.append(infodict[ip_index])
			ips_once.append(ip)
			
		
		else:
			first_index = ips.index(ip)
			first_time = datelist[first_index]
			ips_reverse= ips[::-1]
			last_index = ips_reverse.index(ip)
			datelist_reverse = datelist[::-1]
			last_time = datelist_reverse[last_index]
			ip_count_many.append('ip:'+ip+" 第一次访问时间: "+first_time+' 最后一次访问时间:'+last_time)
			
#print(ip_count_first)
#多次记录


print('功能二：统计只访问1次的IP地址和时间:'.format('*',3))
for  ip_time in ip_count_first:
	print(ip_time)
	
print('功能三：访问多次的IP地址,第一次时间和最后一次时间:')
for  j in  ip_count_many:
	print(j)

				
