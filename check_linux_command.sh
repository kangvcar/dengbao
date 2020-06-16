#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Red_background_prefix="\033[41;37m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"

echo "
#=================================================
#	System Required: CentOS 7+
#	Description: 等保2.0现场测评取证记录脚本
#	Version: 1.0
#	Author: kangvcar
#	Email: kangvcar@gmail.com
#       ExecTime: `date "+%Y/%m/%d %H:%M:%S"`
#=================================================
==================== Starting ====================
"


check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请获取ROOT权限。" && exit 1
}
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    else
        echo -e "${Error} 该脚本不支持当前系统发行版；该脚本只支持CentOS 7+" && exit 1
    fi
	bit=`uname -m`
}
check_root
check_sys
subject_title(){
    echo "==================================================="
    echo -e "${Red_background_prefix} $1 ${Font_color_suffix}"
}

item_title(){
    echo "==================================================="
    echo -e "${Green_background_prefix} 查看$1 ${Font_color_suffix}" && echo
}
################################
subject_title 身份鉴别1
item_title /etc/passwd
cat /etc/passwd

item_title /etc/shadow
cat /etc/shadow

item_title /etc/login.defs
cat /etc/login.defs

item_title /etc/pam.d/system-auth
cat /etc/pam.d/system-auth

item_title /etc/ssh/sshd_config
cat /etc/ssh/sshd_config
################################
subject_title 身份鉴别2
item_title /etc/login.defs
cat /etc/login.defs

item_title /etc/pam.d/system-auth
cat /etc/pam.d/system-auth

item_title /etc/profile
cat /etc/profile

item_title /etc/pam.d/system-auth
cat /etc/pam.d/system-auth

item_title /etc/pam.d/login
cat /etc/pam.d/login

item_title /etc/pam.d/password-auth
cat /etc/pam.d/password-auth
################################
subject_title 身份鉴别3
item_title "rpm -qa | grep telnet"
rpm -qa | grep telnet

item_title "systemctl list-unit-files | grep telnet"
systemctl list-unit-files | grep telnet

item_title "ss -tunlp | grep :23"
ss -tunlp | grep :23

item_title "rpm -qa | grep ssh"
rpm -qa | grep ssh

item_title "systemctl list-unit-files | grep sshd"
systemctl list-unit-files | grep sshd

item_title "ss -tunlp | grep :22"
ss -tunlp | grep :22
################################
subject_title 身份鉴别4
item_title "访谈和核查系统管理员在登录操作系统的过程中使用了哪些身份鉴别方法，是否采用了两种或两种以上组合的鉴别技术"
################################
subject_title 访问控制5
item_title /etc/passwd
cat /etc/passwd

item_title /etc/shadow
cat /etc/shadow

item_title "ls -l /etc/passwd"
ls -l /etc/passwd

item_title "ls -l /etc/shadow"
ls -l /etc/shadow

item_title "ls -l /etc//etc/group"
ls -l /etc//etc/group

item_title "ls -l /etc/crontab"
ls -l /etc/crontab

item_title "ls -l /etc/xinetd.conf"
ls -l /etc/xinetd.conf
################################
subject_title 访问控制6
item_title /etc/sshd_config
cat /etc/ssh/sshd_config

item_title "访谈管理员root账户密码长度以及组合"
################################
subject_title 访问控制7
item_title "ls -l /etc/passwd"
cat /etc/passwd

item_title "应访谈网络管理员、安全管理员、系统管理员不同用户是否采用不同账户登录系统"
################################
subject_title 访问控制8
item_title /etc/passwd
cat /etc/passwd

item_title /etc/sudo.conf
cat /etc/sudo.conf

item_title /etc/sudoers
cat /etc/sudoers
################################
subject_title 访问控制9
item_title "访谈系统管理员，是否指定授权人对操作系统访问控制权限进行配置"

item_title "核查用户授权表，尝试其他非授权文件权限访问，是否依据安全策略配置各账户的访问规则"
################################
subject_title 访问控制10
item_title "ls -l /etc/passwd"
ls -l /etc/passwd
################################
subject_title 访问控制11
item_title /etc/selinux/config
cat /etc/selinux/config
################################
subject_title 安全审计12
item_title "ps -ef|grep auditd"
ps -ef|grep auditd

item_title "/etc/rsyslog.conf"
cat /etc/rsyslog.conf

item_title "sudo auditctl -l"
sudo auditctl -l

item_title "ausearch -f /etc/passwd"
ausearch -f /etc/passwd
################################
subject_title 安全审计13
item_title "ausearch-ts today"
ausearch-ts today

item_title "/etc/ntp.conf"
cat /etc/ntp.conf
################################
subject_title 安全审计14
item_title "/etc/rsyslog.conf"
cat /etc/rsyslog.conf
################################
subject_title 安全审计15
item_title "访谈对审计进程监控和保护的措施"

################################
subject_title 入侵防范16
item_title "yum list installed"
yum list installed

item_title "rpm -qa"
rpm -qa
################################
subject_title 入侵防范17
item_title "systemctl list-units | grep running"
systemctl list-units | grep running

item_title "ss -tlunp"
ss -tlunp
################################
subject_title 入侵防范18
item_title "/etc/hosts.deny"
cat /etc/hosts.deny

item_title "/etc/hosts.allow"
cat /etc/hosts.allow

item_title "/etc/sysconfig/iptables"
cat /etc/sysconfig/iptables

item_title "firewalld-cmd --list-all"
firewall-cmd --list-all
################################
subject_title 入侵防范19
item_title "根据《GBT28448-2019信息安全技术 网络安全等级保护测评要求》，此项测评对象不包含操作设备，此项不适用。"

################################
subject_title 入侵防范20
item_title "rpm -qa |grep patch"
rpm -qa |grep patch

################################
subject_title 入侵防范21
item_title "访谈并查看入侵检测的措施"

################################
subject_title 恶意代码防范22
item_title "访谈管理员病毒库是否经常更新，核查病毒库最新版本，更新日期是否超过一个星期"

################################
subject_title 可信验证23
item_title "核查服务器的启动，是否实现可信验证的检测过程"

################################
subject_title 数据完整性24
item_title "ps -ef | grep sshd"
ps -ef | grep sshd

################################
subject_title 数据完整性25
item_title "/etc/passwd"
cat /etc/passwd

item_title "/etc/shadow"
cat /etc/shadow

################################
subject_title 数据保密性26
item_title "systemctl list-unit-files | grep telnet"
systemctl list-unit-files | grep telnet

item_title "ps -aux|grep sshd"
ps -aux|grep sshd

item_title "rpm -qa openssl"
rpm -qa openssl

item_title "rpm -qa |grep openssh"
rpm -qa |grep openssh

################################
subject_title 数据保密性27
item_title "/etc/shadow"
cat /etc/shadow

################################
subject_title 数据备份恢复28
item_title "操作系统是否有进行备份，是否有定期（周期）进行备份数据的恢复性测试。"

################################
subject_title 数据备份恢复29
item_title "询问运维人员是否提供异地备份功能"

################################
subject_title 数据备份恢复30
item_title "核查设备列表，重要数据处理系统是否采用热备服务器"

################################
subject_title 剩余信息保护31
item_title "crontab -l"

item_title "/var/log/wtmp"
last

item_title "/var/log/btmp"
lastb

item_title "/var/run/utmp"
w

item_title "/var/log/lastlog"
lastlog

################################
subject_title 剩余信息保护32
item_title "crontab -l"
crontab -l

item_title "history"
history | head -10

################################
subject_title 个人信息保护33
item_title "根据《GBT28448-2019信息安全技术 网络安全等级保护测评要求》，此项测评对象不包含操作设备，此项不适用。"

echo -e "Finish."
