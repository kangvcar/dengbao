#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo "
#=================================================
#	System Required: CentOS 7+
#	Description: 等保2.0现场测评取证记录脚本
#	Version: 1.0
#	Author: 何康健
#	Email: kangvcar@gmail.com
#       ExecTime: `date "+%Y/%m/%d %H:%M:%S"`
#=================================================
==================== Starting ====================
"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Red_background_prefix="\033[41;37m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Fail="${Red_font_prefix}[FAIL]${Font_color_suffix}"
Pass="${Green_font_prefix}[PASS]${Font_color_suffix}"
check_root(){
	[[ $EUID != 0 ]] && echo -e "${Fail} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请获取ROOT权限。" && exit 1
}
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    else
        echo -e "${Fail} 该脚本不支持当前系统发行版；该脚本只支持CentOS 7+" && exit 1
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
    echo -e "${Green_background_prefix} 检查$1 ${Font_color_suffix}" && echo
}

################################
subject_title 身份鉴别1
item_title "/etc/passwd"
cat /etc/passwd

item_title "是否有空口令用户"
isNullUser=`awk -F: 'length($2)==0 {print $1}' /etc/shadow`
if [[ -z $isNullUser ]]; then
    echo -e "${Pass}不存在空口令用户"
else
    echo -e "${Fail}存在空口令用户"
fi
################################
subject_title 身份鉴别2
item_title "是否设置密码长度和定期更换要求"
grep '^PASS_MIN_DAYS' /etc/login.defs || echo -e "${Fail}未设置 PASS_MIN_DAYS"
grep '^PASS_WARN_AGE' /etc/login.defs || echo -e "${Fail}未设置 PASS_WARN_AGE"
grep '^PASS_MIN_LEN' /etc/login.defs || echo -e "${Fail}未设置 PASS_MIN_LEN"
grep '^PASSWORD_LIFE_TIME' /etc/login.defs || echo -e "${Fail}未设置 PASSWORD_LIFE_TIME"

item_title "密码长度和复杂度要求"
cat /etc/pam.d/system-auth | grep 'account' | grep 'required' | grep 'pam_cracklib.so' | grep 'minlen=8' | grep 'ucredit=-2' | grep 'lcredit=-1' | grep 'dcredit=-4' | grep 'ocredit=-1' || echo -e "${Fail}密码复杂度设置不符合要求"

item_title "是否开启认证PasswordAuthentication yes"
grep -e '^[ ]*PasswordAuthentication yes' /etc/ssh/sshd_config > /dev/null || echo -e "${Fail}未开启SSH密码登录认证" && echo -e "${Pass}已开启SSH密码登录认证"

item_title "是否设置登录超时"
grep '^LOGIN_RETRIES' /etc/login.defs || echo -e "${Fail}未设置 LOGIN_RETRIES"
grep '^LOGIN_TIMEOUT' /etc/login.defs || echo -e "${Fail}未设置 LOGIN_TIMEOUT"

item_title "/etc/pam.d/system-auth是否设置登录超时"
cat /etc/pam.d/system-auth | grep 'account' | grep 'required' | grep 'pam_tally.so' | grep 'deny=5' | grep 'no_magic_root' | grep 'reset' || echo -e "${Fail}/etc/pam.d/system-auth未设置登录超时"

item_title "/etc/profile是否设置TMOUT"
grep 'TMOUT=300s' /etc/profile || echo -e "${Fail}/etc/profile未设置TMOUT"
################################
subject_title 身份鉴别3
item_title "是否安装telnet"
rpm -qa | grep telnet > /dev/null || echo -e "${Pass}未安装telnet"

item_title "是否启用telnet"
ss -tlunp | grep :23 > /dev/null || echo -e "${Pass}未启用telnet" && echo -e "${Fail}已启用telnet"

item_title "是否已安装openssh"
rpm -qa | grep openssh > /dev/null || echo -e "${Fail}未安装Openssh" && echo -e "${Pass}已安装Openssh"

item_title "是否已启动sshd"
ss -tlunp | grep :22 > /dev/null || echo -e "${Fail}未启用telnet" && echo -e "${Pass}已启用SSHD"
################################
subject_title 身份鉴别4
item_title "访谈"
