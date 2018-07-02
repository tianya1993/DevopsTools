#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512
# Use network installation
url --url="http://192.168.48.2/cobbler/ks_mirror/Install_CentOS_7_1511/"
# Run the Setup Agent on first boot
firstboot --enable
#ignoredisk --only-use=sda
# Keyboard layouts
#keyboard --vckeymap=us --xlayouts='us'
keyboard us
# System language
lang en_US.UTF-8
# Network information
#network  --hostname=localhost.localdomain
# Root password
rootpw --iscrypted $1$lzd5.Lvw$CKQDqmmi.rllh4FDXYzCV0
# System services
services --enabled="chronyd"
# System timezone
timezone Asia/Shanghai
# System bootloader configuration
bootloader --location=mbr --driveorder=sdm
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot --fstype="xfs" --ondisk=sdm --size=400
part biosboot --fstype=biosboot --ondisk=sdm --size=1
part / --fstype="xfs" --ondisk=sdm --size=1 --grow
part /data01 --fstype="xfs" --ondisk=sda --size=1 --grow
part /data02 --fstype="xfs" --ondisk=sdb --size=1 --grow
part /data03 --fstype="xfs" --ondisk=sdc --size=1 --grow
part /data04 --fstype="xfs" --ondisk=sdd --size=1 --grow
part /data05 --fstype="xfs" --ondisk=sde --size=1 --grow
part /data06 --fstype="xfs" --ondisk=sdf --size=1 --grow
part /data07 --fstype="xfs" --ondisk=sdg --size=1 --grow
part /data08 --fstype="xfs" --ondisk=sdh --size=1 --grow
part /data09 --fstype="xfs" --ondisk=sdi --size=1 --grow
part /data10 --fstype="xfs" --ondisk=sdj --size=1 --grow
part /data11 --fstype="xfs" --ondisk=sdk --size=1 --grow
part /data12 --fstype="xfs" --ondisk=sdl --size=1 --grow

%pre
$SNIPPET('log_ks_pre')
$kickstart_start
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

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
%end

# Start final steps
#$kickstart_done
# End final steps
%post  --interpreter=/bin/bash
(

echo "*.*     @192.168.51.48:1516" >>/etc/rsyslog.conf
echo "*.*     @192.168.65.10:514" >>/etc/rsyslog.conf
cd /etc/
curl http://192.168.48.4/script/motd -O -s
cd /opt/
curl http://192.168.48.4/script/dns.sh -O && sh dns.sh;rm dns.sh
curl http://192.168.48.4/script/system-initialization-hbase.sh -O && sh system-initialization-hbase.sh;rm system-initialization-hbase.sh
curl http://192.168.48.4/script/reinforce_safety.sh -O && sh reinforce_safety.sh;rm reinforce_safety.sh
curl http://192.168.48.4/script/sshd_config.sh -O && sh sshd_config.sh;rm sshd_config.sh
curl http://192.168.48.4/script/nic_bond_config.sh -O && sh nic_bond_config.sh;rm nic_bond_config.sh
curl http://192.168.48.4/script/chrony.sh -O && sh chrony.sh;rm chrony.sh
#curl http://192.168.48.4/script/mkdir_mkfs_fstab.sh -O && sh mkdir_mkfs_fstab.sh;rm mkdir_mkfs_fstab.sh
curl http://192.168.48.4/script/install_salt.sh -O && sh install_salt.sh;rm install_salt.sh
)
%end

reboot

%packages
@compat-libraries
@core
wget
net-tools
chrony
%end
