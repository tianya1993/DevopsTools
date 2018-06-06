#！/usr/bin/env python
# -*-coding:UTF-8 -*-
import os

memdict = dict()
memditail = dict()

#os.popen()
os.system(' dmidecode -t memory >./mem2.txt ')
memstr=os.popen('cat ./mem.txt')
mem_count=os.popen("cat  ./mem.txt  |grep 'Number Of Devices' |awk -F':'  '{print $2}'").read()

#mem_count = memstr.read().count("Memory Device")
#mem_count = os.popen(" dmidecode -t 17").read()

Device_info = memstr.read().splitlines()  #("Memory Device")
print(Device_info)
for i in range(0, int(mem_count) + 1):
	
	# print("Memory Device"+str(i),Device_info[i])
	print(i, Device_info[i])
	
	for eachline in Device_info[i].split("\n"):
		print(eachline)
		
		count = eachline.count(":")
		
		if count == 1:
			memditail[eachline.split(':')[0].strip()] = eachline.split(':')[1]
			memdict[i] = dict(memditail)
		
		else:
			pass
print(memdict)

"""
# 总的内存信息
Mem_max_capacity = memdict[0]["Maximum Capacity"]
Devices_count = memdict[0]["Number Of Devices"]
print("1、统计每个插槽内存信息：")
Memorysum = 0
for i in range(1, int(mem_count) + 1):
	Device_name = "Memory Device" + str(memdict[i]["Locator"])
	Device_slot = memdict[i]["Locator"]
	Device_width = memdict[i]["Data Width"]
	Device_size = memdict[i]["Size"]
	Device_factor = memdict[i]["Form Factor"]
	Device_type = memdict[i]["Type"]
	Device_speed = memdict[i]["Speed"]
	Device_sn = memdict[i]["Serial Number"]
	Device_clock_speed = memdict[i]["Configured Clock Speed"]
	Device_min_voltage = memdict[i]["Minimum Voltage"]
	Device_max_voltage = memdict[i]["Maximum Voltage"]
	Memorysum += int(Device_size.split("MB")[0])
	print("设备名称%s:".center(80, "-") % Device_name)
	print("\n内存插槽：%s    内存大小：%s 内存类型：%s   内存SN编号：%s   主频：%s\n" % (
	Device_slot, Device_size, Device_type, Device_sn, Device_clock_speed))
Memorysum = Memorysum / 1024

print("2、信息汇总:\n此主机可安装内存的最大容量为:%s \n主机安装的内存数量为:%s根 目前内存容量为：%s  \n" % (Mem_max_capacity, Devices_count, Memorysum))



"""

# print(eachline, count,eachline.split(':')[0])


# memdict["Memory Device"+str(i)][eachline.split(':')[0]]= eachline.split(':')[1]

#00CE00B300CE 三星
# cat file.txt | awk 'BEGIN{RS="--\n";FS="\n"}{print $6,$9,$15}' | grep -v 'No' | awk 'OFS="---" {print $2" "$3,$5,$8}'



#!/usr/bin/env python
# -*-coding:UTF-8 -*-
import os

memdict = dict()
memditail = dict()

#os.popen()
os.system(' dmidecode -t memory >./mem.txt ')
memstr=os.popen('cat ./mem.txt')
mem_count=os.popen("cat  ./mem.txt  |grep 'Number Of Devices' |awk -F':'  '{print $2}'").read()

#mem_count = memstr.read().count("Memory Device")
#mem_count = os.popen(" dmidecode -t 17").read()

Device_info = memstr.read().split("Memory Device")
for  i    in range(0, len(Device_info) ):

        # print("Memory Device"+str(i),Device_info[i])
#        print(i, Device_info[i].strip())

        for eachline in Device_info[i].split("\n"):

                count = eachline.count(":")

                if count == 1:
                        memditail[eachline.split(':')[0].strip()] = eachline.split(':')[1]
                        memdict[i] = dict(memditail)

                else:
                        pass
print(memdict)
# 总的内存信息
Mem_max_capacity = memdict[0]["Maximum Capacity"]
Devices_count = memdict[0]["Number Of Devices"]
print("1、统计每个插槽内存信息：")
Memorysum = 0
for i in range(1, int(mem_count) + 1):
	Device_name = "Memory Device" + str(memdict[i]["Locator"])
	Device_slot = memdict[i]["Locator"]
	Device_width = memdict[i]["Data Width"]
	Device_size = memdict[i]["Size"]
	Device_factor = memdict[i]["Form Factor"]
	Device_type = memdict[i]["Type"]
	Device_speed = memdict[i]["Speed"]
	Device_sn = memdict[i]["Serial Number"]
	Device_clock_speed = memdict[i]["Configured Clock Speed"]
	Device_min_voltage = memdict[i]["Minimum Voltage"]
	Device_max_voltage = memdict[i]["Maximum Voltage"]
	Memorysum += int(Device_size.split("MB")[0])
	print("设备名称%s:".center(80, "-") % Device_name)
	print("\n内存插槽：%s    内存大小：%s 内存类型：%s   内存SN编号：%s   主频：%s\n" % (
	Device_slot, Device_size, Device_type, Device_sn, Device_clock_speed))
Memorysum = Memorysum / 1024

print("2、信息汇总:\n此主机可安装内存的最大容量为:%s \n主机安装的内存数量为:%s根 目前内存容量为：%s  \n" % (Mem_max_capacity, Devices_count, Memorysum))

