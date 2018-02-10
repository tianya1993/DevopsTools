#!/bin/bash

NET_CONF="/etc/sysconfig/network-scripts"

if [ -f /etc/sysconfig/network-scripts/ifcfg-bond0 ];then
  echo "The existing Bond configuration"
  exit 1
fi
if [ -f /etc/sysconfig/network-scripts/ifcfg-em1 ];then
  DEVICE_I="em1"
elif [ -f /etc/sysconfig/network-scripts/ifcfg-p1p1 ];then
  DEVICE_I="p1p1"
elif [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ];then
  DEVICE_I="eth0"
elif [ -f /etc/sysconfig/network-scripts/ifcfg-enp7s0f0 ];then
  DEVICE_I="enp7s0f0"
else
  echo -e "No use of the network adapter\n"
  exit
fi
if [ -f /etc/sysconfig/network-scripts/ifcfg-em2 ];then
  DEVICE_II="em2"
elif [ -f /etc/sysconfig/network-scripts/ifcfg-p1p2 ];then
  DEVICE_II="p1p2"
elif [ -f /etc/sysconfig/network-scripts/ifcfg-eth1 ];then
  DEVICE_II="eth1"
elif [ -f /etc/sysconfig/network-scripts/ifcfg-enp7s0f1 ];then
  DEVICE_II="enp7s0f1"
else
  echo -e "A second network card does not exist\n"
  exit
fi

cp $NET_CONF/ifcfg-$DEVICE_I $NET_CONF/ifcfg-$DEVICE_I.bak
cp $NET_CONF/ifcfg-$DEVICE_I $NET_CONF/ifcfg-bond0
cp $NET_CONF/ifcfg-$DEVICE_II $NET_CONF/ifcfg-$DEVICE_II.bak

cat >/etc/sysconfig/network-scripts/ifcfg-$DEVICE_I<<EOF
DEVICE=$DEVICE_I
MASTER=bond0
SLAVE=yes
USERCTL=no
BOOTPROTO=none
ONBOOT=yes
EOF
cat >/etc/sysconfig/network-scripts/ifcfg-$DEVICE_II<<EOF
DEVICE=$DEVICE_II
MASTER=bond0
SLAVE=yes
USERCTL=no
BOOTPROTO=none
ONBOOT=yes
EOF
sed -i 's/DEVICE='$DEVICE_I'/DEVICE=bond0/g' $NET_CONF/ifcfg-bond0
#sed -i  '/^NAME=/d'  $NET_CONF/ifcfg-bond0
sed -i '/^HWADDR/d' $NET_CONF/ifcfg-bond0
sed -i '/^UUID/d' $NET_CONF/ifcfg-bond0
sed -i '/^TYPE/d' $NET_CONF/ifcfg-bond0
cat >>/etc/sysconfig/network-scripts/ifcfg-bond0<<EOF
USERCTL=no
BONDING_MASTER=yes
BONDING_OPTS="mode=4 miimon=100"
EOF

cat >/etc/modprobe.d/modprobe.conf<<EOF
alias bond0 bonding
EOF

service network restart
