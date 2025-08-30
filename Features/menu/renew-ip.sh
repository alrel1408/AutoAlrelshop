#!/bin/bash
export HOME=/root
export TERM=xterm

NC='\e[0m'
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=$(date +"%Y-%m-%d" -d "$dateFromServer")
ipsaya=$(wget -qO- ipinfo.io/ip)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")

clear
Repo1="https://raw.githubusercontent.com/xyzval/VVIP/refs/heads/main/REGIST
SELLER=$(curl -sS ${Repo1}ip | grep $MYIP | awk '{print $2}')
Exp=$(curl -sS ${Repo1}ip | grep $MYIP | awk '{print $3}')
data_ip="https://raw.githubusercontent.com/xyzval/VVIP/refs/heads/main/REGIST
d2=$(date -d "$date_list" +"+%s")
d1=$(date -d "$Exp" +"+%s")
dayleft=$(( ($d1 - $d2) / 86400 ))

#########################
[[ ! -f /usr/bin/git ]] && apt install git -y &> /dev/null
# COLOR VALIDATION
clear
RED='\033[0;31m'
NC='\e[0m'
gray="\e[1;30m"
Blue="\033[1;36m"
GREEN='\033[0;32m'
grenbo="\033[1;95m"
YELL='\033[1;33m'
BGX="\033[42m"
END='\e[0m'
AKTIF="VERIFIED"
REPO="https://github.com/bowowiwendi/ipvps.git"
REPO2="https://raw.githubusercontent.com/xyzval/VVIP/refs/heads/main/REGIST
EMAIL="bowowiwendi@gmail.com"
USER="bowowiwendi"


TIMES="10"
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
URL="https://api.telegram.org/bot$KEY/sendMessage"


   
    rm -rf /root/ipvps
    mkdir /root/ipvps
    touch /root/ipvps/ip
    wget -q -O /root/ipvps/ip "${REPO2}" &> /dev/null
    read -p "  Input IP Address To Renew : " ip
    read -p "  Input Days  : " days
    name=$(curl -sS https://raw.githubusercontent.com/xyzval/VVIP/main/REGIST | grep $ip | awk '{print $2}')
    exp=$(curl -sS https://raw.githubusercontent.com/xyzval/VVIP/main/REGIST | grep $ip | awk '{print $3}')
    now=$(date +%Y-%m-%d)
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    exp2=$(( (d1 - d2) / 86400 ))
    exp3=$(($exp2 + $days))
    exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
    sed -i "s/### $name $exp $ip/### $name $exp4 $ip/g" /root/ipvps/ip
    cd /root/ipvps
    git config --global user.email "${EMAIL}" &> /dev/null
    git config --global user.name "${USER}" &> /dev/null
    rm -rf .git &> /dev/null
    git init &> /dev/null
    git add . &> /dev/null
    git commit -m "update file" &> /dev/null
    git branch -M main &> /dev/null
    git remote add origin git@github.com:bowowiwendi/ipvps.git
    git push -f origin main &> /dev/null
    TEXT2="
<code>───────────────────────────</code>
✨SUCCES RENEW  IP VPS✨
<code>───────────────────────────</code>
USERNAME       : <code>$name</code>
IP Address     : $ip
Expired On     : $exp4
<code>───────────────────────────</code>
"
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL >/dev/null
    rm -rf /root/ipvps