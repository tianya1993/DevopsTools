# kickstart template for Fedora 8 and later.
# (includes %end blocks)
# do not use with earlier distros

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
part /boot --fstype="ext4" --size=200 --ondisk=sda
#part swap --fstype="swap" --size=4096 --ondisk=sda
part / --fstype="ext4" --size=1 --grow --ondisk=sda
part /data01 --fstype="ext4" --size=1 --grow --ondisk=sdb
part /data02 --fstype="ext4" --size=1 --grow --ondisk=sdc
part /data03 --fstype="ext4" --size=1 --grow --ondisk=sdd
part /data04 --fstype="ext4" --size=1 --grow --ondisk=sde
part /data05 --fstype="ext4" --size=1 --grow --ondisk=sdf
part /data06 --fstype="ext4" --size=1 --grow --ondisk=sdg
part /data07 --fstype="ext4" --size=1 --grow --ondisk=sdh
part /data08 --fstype="ext4" --size=1 --grow --ondisk=sdi
part /data09 --fstype="ext4" --size=1 --grow --ondisk=sdj
part /data10 --fstype="ext4" --size=1 --grow --ondisk=sdk
part /data11 --fstype="ext4" --size=1 --grow --ondisk=sdl
part /data12 --fstype="ext4" --size=1 --grow --ondisk=sdm
# Use text mode install
text
# Firewall configuration
firewall --disable
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url="http://192.168.48.2/cobbler/ks_mirror/Install_CentOS_6.6/"
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
#$yum_repo_stanza
# Network information
#$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $1$random-p$l2/BEKD93yk15Ik6e2mF//
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone  Asia/Shanghai
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
#autopart

%pre
$SNIPPET('log_ks_pre')
$kickstart_start
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')


%post

$SNIPPET('log_ks_post')
# Start yum configuration
#$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')

%post  --interpreter=/bin/bash
(

echo "*.*     @192.168.51.48:1516" >>/etc/rsyslog.conf
echo "*.*     @192.168.65.10:514" >>/etc/rsyslog.conf
cd /opt/
sed -i "s/ext4     defaults/ext4     noatime,defaults/g" /etc/fstab
curl http://192.168.48.4/script/system-initialization.sh -O && sh system-initialization.sh;rm system-initialization.sh
curl http://192.168.48.4/script/reinforce_safety.sh -O && sh reinforce_safety.sh;rm reinforce_safety.sh
curl http://192.168.48.4/script/sshd_config.sh -O && sh sshd_config.sh;rm sshd_config.sh
)

# Start final steps
$kickstart_done
# End final steps

%packages --nobase
@core
acpid
lsof
vim
wget
openssh-clients
ntpdate
telnet
sysstat
gcc
iotop
tree
nmap
iptraf
screen
traceroute
tcpdump
%end
