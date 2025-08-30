#!/bin/bash
now=$(date +"%Y-%m-%d")
MYIP=$(wget -qO- ipinfo.io/ip);
clear
function notif-exp(){
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>────────────────────</code>
<b>⚠️ NOTIF EXP VMESS LOCKED ⚠️</b>
<code>────────────────────</code>
Username  : $user
Expaired  : $now
<code>────────────────────</code>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null 
}
function notif-exp2(){
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>────────────────────</code>
<b>⚠️ NOTIF EXP SSH LOCKED ⚠️</b>
<code>────────────────────</code>
Username  : $username
Expaired  : $now
<code>────────────────────</code>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null  
}
function notif-exp3(){
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>────────────────────</code>
<b>⚠️ NOTIF EXP VLESS LOCKED ⚠️</b>
<code>────────────────────</code>
Username  : $user
Expaired  : $now
<code>────────────────────</code>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null 
}
function notif-exp4(){
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>────────────────────</code>
<b>⚠️ NOTIF EXP TROJAN LOCKED ⚠️</b>
<code>────────────────────</code>
Username  : $user
Expaired  : $now
<code>────────────────────</code>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null 
}
function notif-exp5(){
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>────────────────────</code>
<b>⚠️ NOTIF EXP SHADOWSOCKS LOCKED ⚠️</b>
<code>────────────────────</code>
Username  : $user
Expaired  : $now
<code>────────────────────</code>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null 
}
##----- Auto Remove Vmess
data=($(cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq))
now=$(date +"%Y-%m-%d")
for user in "${data[@]}"; do
    exp=$(grep -w "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    exp2=$(((d1 - d2) / 86400))
    if [[ "$exp2" -le "0" ]]; then
        uuid=$(grep -E "^},{" "/etc/xray/config.json" |  grep -wE '"'"${user}"'"' | cut -d " " -f 2 | cut -d '"' -f 2 | uniq )
        sed -i '/#vmess$/a\### '"$user $exp $uuid"'' /etc/xray/.lock.db
        sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
        sed -i "/^## $user $exp/,/^},{/d" /etc/xray/config.json
        systemctl restart xray > /dev/null 2>&1
        echo "Akun Vmess $user telah dikunci karena kadaluarsa pada $exp"
        notif-exp
    fi
done

#----- Auto Remove Vless
data=($(cat /etc/xray/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq))
now=$(date +"%Y-%m-%d")
for user in "${data[@]}"; do
    exp=$(grep -w "^#& $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    exp2=$(((d1 - d2) / 86400))
    if [[ "$exp2" -le "0" ]]; then
        uuid=$(grep -E "^},{" "/etc/xray/config.json" |  grep -wE '"'"${user}"'"' | cut -d " " -f 2 | cut -d '"' -f 2 | uniq )
        sed -i '/#vless$/a\#& '"$user $exp $uuid"'' /etc/xray/.lock.db
        sed -i "/^#& $user $exp/,/^},{/d" /etc/xray/config.json
        sed -i "/^#&& $user $exp/,/^},{/d" /etc/xray/config.json
        systemctl restart xray > /dev/null 2>&1
        echo "Akun Vless $user telah dikunci karena kadaluarsa pada $exp"
        notif-exp3
    fi
done

#----- Auto Remove Trojan
data=($(cat /etc/xray/config.json | grep '^#!' | cut -d ' ' -f 2 | sort | uniq))
now=$(date +"%Y-%m-%d")
for user in "${data[@]}"; do
    exp=$(grep -w "^#! $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    exp2=$(((d1 - d2) / 86400))
    if [[ "$exp2" -le "0" ]]; then
        uuid=$(grep -E "^},{" "/etc/xray/config.json" |  grep -wE '"'"${user}"'"' | cut -d " " -f 2 | cut -d '"' -f 2 | uniq )
        sed -i '/#trojan$/a\#! '"$user $exp $uuid"'' /etc/xray/.lock.db
        sed -i "/^#! $user $exp/,/^},{/d" /etc/xray/config.json
        sed -i "/^#!# $user $exp/,/^},{/d" /etc/xray/config.json
        systemctl restart xray > /dev/null 2>&1
        echo "Akun Trojan $user telah dikunci karena kadaluarsa pada $exp"
        notif-exp4
    fi
done

#----- Auto Remove SS
data=($(cat /etc/xray/config.json | grep '^#!!' | cut -d ' ' -f 2 | sort | uniq))
now=$(date +"%Y-%m-%d")
for user in "${data[@]}"; do
    exp=$(grep -w "^#!! $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    exp2=$(((d1 - d2) / 86400))
    if [[ "$exp2" -le "0" ]]; then
        uuid=$(grep -E "^},{" "/etc/xray/config.json" |  grep -wE '"'"${user}"'"' | cut -d " " -f 2 | cut -d '"' -f 2 | uniq )
        sed -i '/#ss$/a\#!! '"$user $exp $uuid"'' /etc/xray/.lock.db
        sed -i "/^#!! $user $exp/,/^},{/d" /etc/xray/config.json
        sed -i "/^#&! $user $exp/,/^},{/d" /etc/xray/config.json
        systemctl restart xray > /dev/null 2>&1
        echo "Akun Shadowsocks $user telah dikunci karena kadaluarsa pada $exp"
        notif-exp5
    fi
done
systemctl restart xray
##------ Auto Remove SSH
hariini=$(date +%d-%m-%Y)
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d >/tmp/expirelist.txt
totalaccounts=$(cat /tmp/expirelist.txt | wc -l)
for ((i = 1; i <= $totalaccounts; i++)); do
    tuserval=$(head -n $i /tmp/expirelist.txt | tail -n 1)
    username=$(echo $tuserval | cut -f1 -d:)
    userexp=$(echo $tuserval | cut -f2 -d:)
    userexpireinseconds=$(($userexp * 86400))
    tglexp=$(date -d @$userexpireinseconds)
    tgl=$(echo $tglexp | awk -F" " '{print $3}')
    while [ ${#tgl} -lt 2 ]; do
        tgl="0"$tgl
    done
    while [ ${#username} -lt 15 ]; do
        username=$username" "
    done
    bulantahun=$(echo $tglexp | awk -F" " '{print $2,$6}')
    todaystime=$(date +%s)
    if [ $userexpireinseconds -ge $todaystime ]; then
        :
    else
        passwd -l $username > /dev/null  
        echo "Akun SSH $username telah dikunci karena kadaluarsa pada $bulantahun"
        notif-exp2
    fi
done
systemctl reload ssh
