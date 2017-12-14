#/usr/bin/env python
#-*-coding:UTF-8 -*-
ips=[]
with open("/home/admin/output/nginx/logs/www.access.log","r")  as  ngfile:
	for line in ngfile:
		ips.append(line.split()[0])
print("PV is {0}".format(len(ips)))
print("UV is {0}".format(len(set(ips))))