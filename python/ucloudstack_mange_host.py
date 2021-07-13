#!/usr/bin/env python
# coding=utf-8
import copy
import base64
import hashlib
import  requests
import   sys
import  time

TDCLOUD_IP_HZ = "console.tdcloud.cn"

TDCLOUD_PRIVATE_KEY = "ef70d1947e237de402e2077da6b4bf8822b4f92b"
TDCLOUD_PUBLIC_KEY = "OEQ0/u66zSid/4FtArT7oBAiPErKOMaZqyujU1GdHWznJSUxn5s5m1OzQDeCCib2"


class TDcloudApiClient():
    def __init__(self, *args, **kwargs):
        self.url = 'http://' + TDCLOUD_IP_HZ+"/api"
    def signature(self, params):
        items = params.items()
        # 请求参数串
        items = sorted(items)
        # 将参数串排序

        params_data = b""
        for key, value in items:
            if isinstance(value, bytes):
                params_data += key.encode('utf-8') + value
            elif isinstance(value, int):
                params_data += key.encode('utf-8') + str(value).encode('utf-8')
            else:
                params_data += key.encode('utf-8') + value.encode('utf-8')
        params_data = params_data + TDCLOUD_PRIVATE_KEY.encode('utf-8')

        sign = hashlib.sha1()
        sign.update(params_data)
        signature = sign.hexdigest()

        return signature

    def base64_encode(self, password):
        lens = len(password)
        lenx = lens - (lens % 4 if lens % 4 else 4)
        return base64.b64encode(password[: lenx].encode('utf-8'))


    def read_instance(self,params):
       # """获取机器列表"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'DescribeVMInstance'
        params["Region"] = "cn"
        params["Zone"] = "zone-01"
        params['Signature'] = self.signature(params)
        print("获取主机信息参数=={}".format(params))
        response = requests.get(self.url, params=params)
        # print(response.json())
        if response.json()["RetCode"] == 0 :
            print("获取主机信息成功")
            return response.json()["Infos"]


    def create_instance(self, params):
       # """创建机器"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'CreateVMInstance'
        params["Region"] = "cn"
        params["Zone"] = "zone-01"
        params["VMType"]= "Normal"
        params["BootDiskSetType"] = "Normal"
        params["DataDiskSetType"] = "Normal"

        #params["BootDiskSetType"] = "Taishan"
        #params["DataDiskSetType"] = "Taishan"
       #测试
        # params["VPCID"] = "vpc-0Q3S+wMZU" #vpc-0Q3S+wMZU
        # params["SubnetID"] = "subnet-iSguwm1ZR"  # test
        # params["WANSGID"] = "sg-0Q3S+wMZU"  # test   pro
        #生产
        params["VPCID"] = "vpc-0Q3S+wMZU"   #VPCID
        params["SubnetID"] = "subnet-0Q3S+wMZU"  # 子网信息test subnet-iSguwm1ZR
        params["WANSGID"] = "sg-kdbh-HaZg"  # 安全组

        params["ChargeType"] = "Month"
        params["Password"] = "GoodTongdun@2019"
        params['Signature'] = self.signature(params)
        print("获取TDCLOUD主机信息参数=={}".format(params))
        response = requests.get(self.url,params=params)
        #print(response.url)

        print(response.json())
    def stop_instance(self, params):
       # """停止虚拟机"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        #params['Action'] = 'DeleteVMInstance'
        params['Action'] = 'StopVMInstance'
        params['Signature'] = self.signature(params)
        # print("获取TDCLOUD主机信息参数=={}".format(params))
        response = requests.get(self.url,params=params)
        #print(response.url)
        print(response.json())



    def start_instance(self, params):
        #"""启动虚拟机"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        #params['Action'] = 'DeleteVMInstance'
        params['Action'] = 'StartVMInstance'
        params['Signature'] = self.signature(params)
        # print("获取TDCLOUD主机信息参数=={}".format(params))
        response = requests.get(self.url,params=params)

        print(response.json())

    def delete_instance(self, params):
       # """删除虚拟机"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'DeleteVMInstance'
        # params['Action'] = 'StopVMInstance'
        params['Signature'] = self.signature(params)
        # print("获取TDCLOUD主机信息参数=={}".format(params))
        response = requests.get(self.url,params=params)
        #print(response.url)
        print(response.json())

    def ceate_allocateip(self,params):
        #"""创建EIP"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'AllocateEIP'
        params["Region"] = "cn"
        params["Zone"] = "zone-01"
        params["OperatorName"]="Bgp"
        params["Bandwidth"]=5000
        params["ChargeType"]="Month"
        params['Signature'] = self.signature(params)
        response = requests.get(self.url, params=params)
        # print(response.url)
        print(response.json())
    def  get_describeeip(self,params):
         #"""获取EIP空闲列表"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'DescribeEIP'
        params["Region"] = "cn"
        params["Zone"] = "zone-01"
        params['Signature'] = self.signature(params)
        response = requests.get(self.url, params=params)
        # print(resultinfo["Infos"])
        EIPID = []
        for line in response.json()["Infos"]:
            if line['Status'] == "Free":
                EIPID.append(line["EIPID"])
                # print(line['Status'], line["EIPID"])
            else:
                pass

        return EIPID


    def  get_host_online(self,params):
        """获取未绑定EIP并且运行的机器列表返回一个机器VMIDlist"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'DescribeVMInstance'
        params["Region"] = "cn"
        params["Zone"] = "zone-01"
        params['Signature'] = self.signature(params)
        response = requests.get(self.url, params=params)
        Hostonlie=[]
        for line in response.json()["Infos"]:
            if  line["State"]=='Running' :
                for ip in line["IPInfos"]:
                    if ip['Type']=="Public" and ip["IP"]=="":
                        Hostonlie.append(line["VMID"])
                       # print(line["IPInfos"][1]["IP"], line["IPInfos"][0]["IP"], line["VMID"], line["Name"], line["CPU"], line["Memory"], line["OSName"])
                    else:
                        pass

        return  Hostonlie
    def create_bindEIP(self,params):
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'BindEIP'
        params['ResourceType'] = 'VM'
        params["Region"] = "cn"
        params["Zone"] = "zone-01"
        params['Signature'] = self.signature(params)
        response = requests.get(self.url, params=params)
        print(response.json())

    def  delete_bindEip(self,params):
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'UnBindEIP'
        params['ResourceType'] = 'VM'
        params["Region"] = "cn"
        params["Zone"] = "zone-01"
        params['Signature'] = self.signature(params)
        response = requests.get(self.url, params=params)
        print(response.json())


    def  get_all_describeeip(self,params):
         #"""获取EIP空闲列表"""
        params = copy.deepcopy(params)
        params['PublicKey'] = TDCLOUD_PUBLIC_KEY
        params['Action'] = 'DescribeEIP'
        params["Region"] = "cn"
        params["Zone"] = "zone-01"
        params['Signature'] = self.signature(params)
        response = requests.get(self.url, params=params)
        # print(resultinfo["Infos"])
        EIPID = []
        for line in response.json()["Infos"]:
            if  line["Status"]=="Bound":
                EIPID.append(line["EIPID"]+":+:"+ line["BindResourceID"])
        return  EIPID









"""
逻辑处理函数

"""



if __name__=='__main__':
    client = TDcloudApiClient()
    corelist=[1,2,4,8,16]
    memorlist=[2048,4096,8192,16384,32768]
    if sys.argv[1]=="0":
        print("获取所有主机信息")
        serverinfo = client.read_instance({})
        # print(serverinfo)
        for line in serverinfo:

            if line["State"] in ["Restarting","Running","Stopped","WaitReinstall"] :
                print(line["IPInfos"][1]["IP"], line["IPInfos"][0]["IP"], line["VMID"], line["Name"], line["CPU"],line["Memory"], line["OSName"],line["State"])

    elif sys.argv[1]=="1":
        print("创建新的主机参数2为cpu 参数3主机名，参数4为数据盘大小 参数5为镜像id 参数6 机器数量")
        core =int(sys.argv[2])
        hostname=sys.argv[3]
        datadisk=int(sys.argv[4])
        imageid=sys.argv[5]
        servernum = int(sys.argv[6])
        newhost=dict()
        if core in  corelist:
            index=corelist.index(core)
            mem=memorlist[index]
            newhost["Name"]=hostname
            newhost["ImageID"]=imageid
            newhost["CPU"]=core
            newhost["Memory"]=mem
            newhost["DataDiskSpace"]=datadisk
            for num in range(0,servernum):
                newhost["Name"] = hostname+str(num+1)
                client.create_instance(newhost)
        else:

            print("规格不在定义列表中，请自已定义规格")

    elif sys.argv[1]=="3":
        host = dict()
        host["VMID"]=sys.argv[2]
        client.stop_instance(host)
        client.delete_instance(host)

    elif sys.argv[1]=="4":
        ipname= dict()
        ipname["Name"]=sys.argv[2]
        iprnum = int(sys.argv[3])
        for num in range(0, iprnum):
            ipname["Name"] = sys.argv[2]+str(num+1)
            client.ceate_allocateip(ipname)




    elif sys.argv[1]=="5":
        #停止虚拟机 删除虚拟机
        host = dict()
        with  open("hostid2.txt", "r") as file:
            for rindex in file.readlines():
                host["VMID"]=rindex.split()[0]
                client.stop_instance(host)
                time.sleep(3)
                client.delete_instance(host)

    elif sys.argv[1] == "6":
        #启动虚拟机
        host = dict()
        with  open("hostid.txt", "r") as file:
            for rindex in file.readlines():
                host["VMID"] = rindex.split()[0]
                client.start_instance(host)



    elif sys.argv[1] == "7":
        #绑定EIP
        host = dict()
        eipvmid=client.get_describeeip(host)
        hostvmid = client.get_host_online(host)
        print(eipvmid)
        print(hostvmid)
        if len(eipvmid) > len(hostvmid):
            for i in range (0,len(hostvmid)):
                hostinfo=dict()
                hostinfo["ResourceID"]=hostvmid[i]
                hostinfo["EIPID"]=eipvmid[i]
                client.create_bindEIP(hostinfo)

        else:
            newinfos=dict()
            for i in range(0,len(hostvmid)-len(eipvmid)):
                newinfos["Name"]="NewEIP" +str(i)
                client.ceate_allocateip(newinfos)
                eipvmid = client.get_describeeip(host)
                hostvmid = client.get_host_online(host)
                for i in range(0, len(eipvmid)):
                    hostinfo = dict()
                    hostinfo["ResourceID"] = hostvmid[i]
                    hostinfo["EIPID"] = eipvmid[i]
                    client.create_bindEIP(hostinfo)



    elif sys.argv[1]=="8":
        host =dict()
        eiplist=[]
        hostvmid=client.get_all_describeeip(host)
        print(hostvmid)
        with  open("hostid2.txt", "r") as file:
            for rindex in file.readlines():
                deletehostid= rindex.split()[0]
                for  line  in  hostvmid:
                    if line.split(":+:")[1]==deletehostid:
                        host["ResourceID"]=line.split(":+:")[1]
                        host["EIPID"]=line.split(":+:")[0]
                        client.delete_bindEip(host)
                    else:
                        pass





