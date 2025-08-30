#!/bin/bash
export HOME=/root
export TERM=xterm
REPO="https://raw.githubusercontent.com/xyzval/VVIP/refs/heads/main/REGIST"
EMAIL="nvatryn@gmail.com"
USER="nvtryn"
function notif-exp(){
TIME="10"
CHATID="2043946623"
KEY="6957450340:AAE3OyomqZQgf7SV68UUISd2Po-_Gd-Pwns"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="<code>──────────────────────────────────</code>
<b>⚠️ YOUR VPS EXPIRED ⚠️</b>
<code>──────────────────────────────────</code>
USER        : $user
VPS IP      : $ip
DATE        : $exp
<code>──────────────────────────────────</code>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
}
data=($(curl -sS https://raw.githubusercontent.com/xyzval/VVIP/refs/heads/main/REGIST | grep '^###' | awk '{print $2}'))  # Mengubah menjadi array
now=$(date +"%Y-%m-%d")
for user in "${data[@]}"; do
    exp=$(curl -sS https://raw.githubusercontent.com/xyzval/VVIP/refs/heads/main/REGIST | grep -w "^### $user" | awk '{print $3}')
    # Tambahkan kondisi untuk melewati pengguna dengan status "lifetime"
    if [[ "$exp" == "lifetime" ]]; then
        continue
    fi
    ip=$(curl -sS https://raw.githubusercontent.com/xyzval/VVIP/refs/heads/main/REGIST | grep -w "^### $user" | awk '{print $4}')
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    exp2=$(((d1 - d2) / 86400))
    if [[ "$exp2" -le "2" || "$exp2" -le "1" || "$exp2" -eq "0" ]]; then  # Ubah dari 0 menjadi 1
        notif-exp
    fi
done
