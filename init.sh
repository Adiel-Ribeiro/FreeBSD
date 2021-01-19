#!/bin/sh 
##########################################################################
su -m root -c "/usr/sbin/chown -R ec2-user /home/ec2-user" 
su -m root -c "/bin/chmod 700 /home/ec2-user"
#########################################################################
su -m root -c "echo umask 077 >> /home/ec2-user/.shrc"
su -m root -c "echo umask 077 >> /root/.cshrc"
#######################################################################
su -m root -c "/usr/sbin/pw groupadd ssh"
su -m root -c "/usr/sbin/pw groupadd sudo"
su -m root -c "/usr/sbin/pw usermod ec2-user -G ssh,wheel,sudo"
###############################################################################################################
/usr/bin/fetch -q --no-verify-peer https://raw.githubusercontent.com/Adiel-Ribeiro/FreeBSD/master/sshd_config
/usr/bin/fetch http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key
###############################################################################################################
su -m root -c "/bin/cat openssh-key >> /usr/home/ec2-user/.ssh/authorized_keys"
#########################################################################################################
su -m root -c "/bin/mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp"
su -m root -c "/bin/mv sshd_config /etc/ssh/sshd_config"
######################################################################################################
su -m root -c "/bin/chmod 400 /etc/ssh/sshd_config"
#########################################################################################################
su -m root -c "/usr/sbin/service sshd restart"
#############################################################################################################################
/usr/bin/fetch -q --no-verify-peer https://github.com/Adiel-Ribeiro/FreeBSD/raw/master/nuvym-freebsd-hardened-kernel.tar.xz
su -m root -c "/usr/bin/tar xvzf nuvym-freebsd-hardened-kernel.tar.xz -C /"
###############################################################################################################################
su -m root -c "/bin/chmod 600 /etc/rc.conf" 
su -m root -c "/bin/chmod 600 /etc/fstab" 
su -m root -c "/bin/chmod 600 /etc/syslog.conf" 
################################################################################################################################
su -m root -c "/bin/chflags -R schg /boot/kernel" 
#################################################################################################################################
su -m root -c "echo security.bsd.see_other_uids=0 >> /etc/sysctl.conf" 
su -m root -c "echo security.bsd.see_other_gids=0 >> /etc/sysctl.conf" 
su -m root -c "echo security.bsd.unprivileged_read_msgbuf=0 >> /etc/sysctl.conf" 
su -m root -c "echo security.bsd.unprivileged_proc_debug=0 >> /etc/sysctl.conf" 
su -m root -c "echo kern.randompid=1 >> /etc/sysctl.conf" 
su -m root -c "echo security.bsd.stack_guard_page=1 >> /etc/sysctl.conf" 
su -m root -c "echo syslogd_flags="-ss" >> /etc/rc.conf" 
su -m root -c "echo sendmail_enable="NONE" >> /etc/rc.conf" 
su -m root -c "echo ntpd_enable="NO" >> /etc/rc.conf" 
#############################################################################################################################
su -m root -c "/sbin/gpart create -s GPT nvd1"
su -m root -c "/sbin/gpart add -t freebsd-ufs -a 1M -s 5g nvd1"
su -m root -c "/sbin/gpart add -t freebsd-ufs -a 1M -s 2g nvd1"
su -m root -c "/sbin/gpart add -t freebsd-ufs -a 1M -s 3g nvd1"
su -m root -c "/sbin/gpart add -t freebsd-ufs -a 1M -s 3g nvd1"
su -m root -c "/sbin/gpart add -t freebsd-ufs -a 1M -s 1g nvd1"
#########################################################################
su -m root -c "/sbin/newfs -j -U /dev/nvd1p1"
su -m root -c "/sbin/newfs -j -U /dev/nvd1p2"
su -m root -c "/sbin/newfs -j -U /dev/nvd1p3"
su -m root -c "/sbin/newfs -j -U /dev/nvd1p4"
su -m root -c "/sbin/newfs -j -U /dev/nvd1p5"
#########################################################################
su -m root -c "/usr/sbin/pkg install -y sudo"
su -m root -c 'echo "%sudo ALL= ( ALL:ALL ) NOPASSWD: ALL" >> /usr/local/etc/sudoers'
#############################################################################################
su -m root -c "/sbin/mount /dev/nvd1p1 /mnt"
su -m root -c "/bin/cp -Rp /usr/local/ /mnt/"
su -m root -c "umount /mnt" 
su -m root -c "/sbin/mount /dev/nvd1p2 /mnt"
su -m root -c "/bin/cp -Rp /home/ /mnt/"
su -m root -c "/bin/cp -Rp /home/ec2-user/.ssh/ /mnt/ec2-user/.ssh"
su -m root -c "umount /mnt" 
su -m root -c "/bin/chmod 600 /var/log/auth.log"
su -m root -c "/bin/chmod 600 /var/log/security"
su -m root -c "/bin/chflags sappend /var/log/auth.log"
su -m root -c "/bin/chflags sappend /var/log/security"
su -m root -c "/sbin/mount /dev/nvd1p3 /mnt"
su -m root -c "/bin/cp -Rp /var/ /mnt/"
su -m root -c "umount /mnt" 
###########################################################################
su -m root -c "echo /dev/nvd1p1 /usr/local ufs rw 1 1 >> /etc/fstab"
su -m root -c "echo /dev/nvd1p2 /home ufs rw,nosuid 1 1 >> /etc/fstab"
su -m root -c "echo /dev/nvd1p3 /var ufs rw,noexec 1 1 >> /etc/fstab"
su -m root -c "echo /dev/nvd1p4 /var/log ufs rw,noexec 1 1 >> /etc/fstab"
su -m root -c "echo /dev/nvd1p5 /tmp ufs rw,noexec 1 1 >> /etc/fstab"
########################################################################################
su -m root -c "echo kern_securelevel_enable="YES" >> /etc/rc.conf"
su -m root -c "echo kern_securelevel="2" >> /etc/rc.conf" 
##########################################################################################
su -m root -c "/bin/chflags -R schg /usr/bin"
su -m root -c "/bin/chflags -R schg /usr/sbin"
su -m root -c "/bin/chflags -R schg /usr/lib*"
#######################################################################################
su -m root -c "/sbin/reboot"
#######################################################################################