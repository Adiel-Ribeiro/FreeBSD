#!/bin/sh 
su -m root -c "/usr/sbin/pw groupadd ssh"
su -m root -c "/usr/sbin/pw usermod ec2-user -G ssh,wheel"
/usr/bin/fetch -q --no-verify-peer https://raw.githubusercontent.com/Adiel-Ribeiro/FreeBSD/master/sshd_config
/usr/bin/fetch http://169.254.169.254/latest/meta-data/local-ipv4
/usr/bin/fetch http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key
su -m root -c "/bin/cat openssh-key >> /usr/home/ec2-user/.ssh/authorized_keys"
su -m root -c "/bin/cat local-ipv4 | /usr/sbin/pw mod user ec2-user -h 0"
su -m root -c "/bin/mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp"
su -m root -c "/bin/mv sshd_config /etc/ssh/sshd_config"
su -m root -c "/bin/chmod 400 /etc/ssh/sshd_config"
su -m root -c "/usr/sbin/service sshd restart"
/usr/bin/fetch -q --no-verify-peer https://github.com/Adiel-Ribeiro/FreeBSD/raw/master/nuvym-freebsd-hardened-kernel.tar.xz
su -m root -c "/usr/bin/tar xvzf nuvym-freebsd-hardened-kernel.tar.xz -C /"
su -m root -c "/bin/chmod 600 /etc/rc.conf" 
su -m root -c "/bin/chmod 600 /etc/fstab" 
su -m root -c "/bin/chmod 600 /etc/syslog.conf" 
su -m root -c "/bin/chmod 600 /var/log/auth.log"
su -m root -c "/bin/chmod 600 /var/log/security" 
su -m root -c "/bin/chflags sappend /var/log/auth.log"
su -m root -c "/bin/chflags sappend /var/log/security"
su -m root -c "/bin/chflags -R schg /boot/kernel" 
su -m root -c "echo security.bsd.see_other_uids=0 >> /etc/sysctl.conf" 
su -m root -c "echo security.bsd.see_other_gids=0 >> /etc/sysctl.conf" 
su -m root -c "echo security.bsd.unprivileged_read_msgbuf=0 >> /etc/sysctl.conf" 
su -m root -c "echo security.bsd.unprivileged_proc_debug=0 >> /etc/sysctl.conf" 
su -m root -c "echo kern.randompid=1 >> /etc/sysctl.conf" 
su -m root -c "echo security.bsd.stack_guard_page=1 >> /etc/sysctl.conf" 
su -m root -c "echo syslogd_flags="-ss" >> /etc/rc.conf" 
su -m root -c "echo sendmail_enable="NONE" >> /etc/rc.conf" 
su -m root -c "echo ntpd_enable="NO" >> /etc/rc.conf" 
su -m root -c "/bin/cat local-ipv4 | /usr/sbin/pw mod user root -h 0"
exit 0