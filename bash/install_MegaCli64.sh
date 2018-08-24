#/bin/bash
##lianglab
##install MegaCli64 
HOST=`ip route show | grep src|awk -Fsrc '{print $2}'|awk '{print $1}'|awk 'NR{print}'|grep -v '192.168.122'`
HOSTSERVER=`echo $HOST|awk -F '.' '{ printf $1"."$2}'`
DmesgSum=`dmesg|grep -i kvm |grep -i vmware`

which MegaCli64 >/dev/null 2>&1

if [ "$?" == "0" ];then
  echo -e "========MegaCli Already Installed========\n"
  exit
fi

if [ "$HOSTSERVER" == "192.168" ];then
    HTTPPATH="http://192.168.48.4"
elif [ "$HOSTSERVER" == "10.21" ];then
    HTTPPATH="http://10.21.13.10"
elif [ "$HOSTSERVER" == "10.15" ];then
    HTTPPATH="http://10.21.13.10"
elif [ "$HOSTSERVER" == "10.57" ];then
    HTTPPATH="http://192.168.48.4"
elif [ "$HOSTSERVER" == "172.16" ];then
    HTTPPATH="HTTP://192.168.48.4"
else
    echo ' Unknown network segment, please check the YUM source ....'
    exit 1
fi

cd /usr/install;wget $HTTPPATH/soft/Lib_Utils-1.00-09.noarch.rpm
cd /usr/install;wget $HTTPPATH/soft/MegaCli-8.02.21-1.noarch.rpm

if [ ! -f "Lib_Utils-1.00-09.noarch.rpm" ];then
    echo "Lib_Utils installation file does not exist, please check"
    exit 1
fi
if [ ! -f "MegaCli-8.02.21-1.noarch.rpm" ];then
    echo "MegaCli installation file does not exist, please check"
    exit 1
fi

if [ -z $DmesgSum ];then
cd /usr/install
rpm -Uvh Lib_Utils-1.00-09.noarch.rpm --replacefiles
rpm -Uvh MegaCli-8.02.21-1.noarch.rpm
ln -s /opt/MegaRAID/MegaCli/MegaCli64 /usr/sbin/MegaCli64

fi
