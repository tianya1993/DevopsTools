#!/bin/bash
#lianglab
VER=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//|cut -b 1`
ChronySum=$(cat /etc/chrony.conf | grep 10.21.13.13 | wc -l)
if [ "$VER" == "7" ]; then
if [[ $ChronySum -eq 0 ]]; then
  echo "Chrony修改完成"
cat >/etc/chrony.conf<<EOF
server 192.168.48.4 prefer
server 10.21.13.13 prefer
server 10.21.13.14 iburst
server 0.cn.pool.ntp.org iburst minpoll 3 maxpoll 4
stratumweight 0
driftfile /var/lib/chrony/drift
rtcsync
makestep 10 3
bindcmdaddress 127.0.0.1
bindcmdaddress ::1
keyfile /etc/chrony.keys
commandkey 1
generatecommandkey
noclientlog
logchange 0.5
logdir /var/log/chrony
EOF
systemctl start chronyd
systemctl enable chronyd
echo ">>>>>>>>>> chronyd server open; <<<<<<<<<<"
systemctl stop ntpd
systemctl disable ntpd
echo ">>>>>>>>>> ntpd server close; <<<<<<<<<<"
  else
  echo "不需要修改"
fi
fi
[root@spark-nn-bdp-p-040154 ~]# curl http://10.21.13.10/script/chrony.sh   |bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   856  100   856    0     0   398k      0 --:--:-- --:--:-- --:--:--  835k
Chrony修改完成
>>>>>>>>>> chronyd server open; <<<<<<<<<<
>>>>>>>>>> ntpd server close; <<<<<<<<<<
[root@spark-nn-bdp-p-040154 ~]# ls
anaconda-ks.cfg  install-java.sh  ks-post.log  ks-pre.log  system-initialization-hbase.sh
[root@spark-nn-bdp-p-040154 ~]# rm install-java.sh
rm: remove regular file ‘install-java.sh’? y
[root@spark-nn-bdp-p-040154 ~]# cat  system-initialization-hbase.sh
#!/bin/bash
#=========================
#system initialization hbase
#lianglab
#=========================

HOST=`ip route show | grep src|awk -Fsrc '{print $2}'|awk '{print $1}'|awk 'NR{print}'|grep -v '192.168.122'`
HOSTSERVER=`echo $HOST|awk -F '.' '{ printf $1"."$2}'`
SOURCE=`curl -s  http://10.21.13.10/service-list|bash`
VER=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//|cut -b 1`

## Update the machine YUM source ##
curl -s http://$SOURCE/repo.sh|bash


## Installation of commonly used tools ##
yum -y install libselinux-python openssh-clients ntpdate telnet sysstat gcc iotop iftop htop ftp iptraf screen lsof traceroute tcpdump >/dev/null 2>&1

## Update on the warning message ##
curl -s http://$SOURCE/scripts/motd -o /etc/motd

## Install updates local NTP clock service ##
curl -s http://$SOURCE/scripts/ntp.sh|bash

##-------------------------------------------------------------------------
## Set up the system operation log output to the message ##
PROMPT_COMMAND=`grep PROMPT_COMMAND /etc/profile`
if [ "$PROMPT_COMMAND" == "" ];then
cat >>/etc/profile <<EOF
export HISTTIMEFORMAT='%F %T '
export PROMPT_COMMAND='logger -p local0.info "\$(ifconfig | grep -E "eth|em" -A 1 | grep "10.0" | grep -oP "(?<=addr:)[\d\.]+") \$(who am i |awk "{print \\\$1\" \\"\\\$2\" \\"\\\$3\" \\"\\\$4\" \\"\\\$5}") [\`pwd\`] \$(history 1 | { read x cmd; echo "\$cmd"; })"'
EOF
source /etc/profile
fi
##-------------------------------------------------------------------------

#Encrypted password is to use #opessl passwd -1
useradd admin
echo "admin:\$1\$1yTVC0CK\$x.V95a2BuHOJ0janu9yJv/"|chpasswd -e
useradd -g users tdops
useradd -g users tdsec
useradd -g users tddev
echo "tdops:\$6\$sV7AgmZs\$150uTWwuePXVM2GPlr7GlHyxm4ODfHO3UCQxP.8w.y7CsrGSgTgPp.vqrj9G81wa3kO8hBOtxFT91jE1l2Xcr0"|chpasswd -e
echo "tdsec:\$6\$sV7AgmZs\$150uTWwuePXVM2GPlr7GlHyxm4ODfHO3UCQxP.8w.y7CsrGSgTgPp.vqrj9G81wa3kO8hBOtxFT91jE1l2Xcr0"|chpasswd -e
echo "tddev:\$6\$sV7AgmZs\$150uTWwuePXVM2GPlr7GlHyxm4ODfHO3UCQxP.8w.y7CsrGSgTgPp.vqrj9G81wa3kO8hBOtxFT91jE1l2Xcr0"|chpasswd -e
chmod 755 /home/admin

##install JDK Tomcat tool
curl -s http://$SOURCE/scripts/install-java.sh|bash

## add system limits config ##
LIMITS=`grep "The parameters of the additional" /etc/security/limits.conf`
if [ "$LIMITS" == "" ];then
cat >>/etc/security/limits.conf<<EOF
## The parameters of the additional ##
* hard nofile 1000000
* soft nofile 1000000
* soft core unlimited
* soft stack 10240
EOF
fi
if [ "$VER" == "6" ]; then
cat >/etc/security/limits.d/90-nproc.conf<<EOF
# Default limit for number of user's processes to prevent
# accidental fork bombs.
# See rhbz #432903 for reasoning.

root       soft    nproc     unlimited
*          soft    nproc      1000000
EOF
elif [ "$VER" == "7" ]; then
cat >/etc/security/limits.d/20-nproc.conf<<EOF
# Default limit for number of user's processes to prevent
# accidental fork bombs.
# See rhbz #432903 for reasoning.

root       soft    nproc     unlimited
*          soft    nproc      1000000
EOF
fi

cat >>/etc/sysctl.conf<<EOF
## add
net.ipv4.tcp_mem = 3097431 4129911 6194862
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_max_tw_buckets = 262144
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse  = 1
net.ipv4.tcp_syncookies  = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_max_syn_backlog = 655350
net.core.somaxconn  = 65535
net.core.netdev_max_backlog  = 200000
vm.max_map_count = 1048575
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.core.optmem_max = 40960
net.ipv4.tcp_keepalive_time=60
net.ipv4.tcp_keepalive_probes=3
net.ipv4.tcp_keepalive_intvl=10
vm.swappiness=0
vm.min_free_kbytes=1048576
vm.dirty_background_ratio=5
vm.dirty_ratio=10
EOF

##Disable large memory pages
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 'echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local


##------------------------------------------------------------------
## Control - Alt - delete restart system is forbidden ##
if [ "$VER" == "6" ]; then
    sed -i 's/^exec/#&/' /etc/init/control-alt-delete.conf
elif [ "$VER" == "7" ]; then
    ln -sf /dev/null /etc/systemd/system/ctrl-alt-del.target
else
    echo -e "\tControl - Alt - delete restart failure is prohibited"
fi

## Closed UseDNS SSHD configuration ##
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
sed -i 's/GSSAPIAuthentication yes/#&/g' /etc/ssh/sshd_config

## Close the firewall and the SElinux policy  ##
if [ "$VER" == "6" ]; then
    service iptables stop
    chkconfig iptables off
elif [ "$VER" == "7" ]; then
    systemctl stop firewalld.service
    systemctl disable firewalld.service
else
    echo -e "\tUnknown type of operating system firewall close failure"
fi
##------------------------------------------------------------------

exit
