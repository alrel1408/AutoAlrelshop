#!/bin/bash
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
clear
echo -e ""
echo -e "\033[96;1m============================\033[0m"
echo -e "\033[93;1m  INPUT DOMAIN N SUB/WILCARD "
echo -e "\033[96;1m============================\033[0m"
echo -e "\033[91;1m contoh domain :\033[0m \033[93sshprem.cloud,itachi.cyou,wendivpn.my.id,tryn.cloud\033[0m"
echo -e "contoh subdomain : vallvpn"
read -p "DOMAIN :  " domain
read -p "SUBDOMAIN    :  " sub
read -p "IP     :  " IP
echo -e ""
dns=${sub}.${domain}
wilcard=*.${dns}
CF_KEY=e54ac7edea27dbef7cc1fdb13025d47da45c2
CF_ID=nvatryn@gmail.com
set -euo pipefail
#domain
echo "Updating DNS for ${dns}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${domain}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${dns}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}')
#wilcard
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${domain}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${wilcard}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${wilcard}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${wilcard}'","content":"'${IP}'","ttl":120,"proxied":false}')

# Menyalin output ke clipboard
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "🍀SUCCESSFULLY POINTING🍀"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "🌹SUBDOMAIN   : $dns" 
echo -e "🏵️WILCARD    : $wilcard" 
echo -e "🌺IP SERVER  : $IP" 
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
function notif_poin() {
CHATID="$CHATID"
KEY="$KEY"
TIME="$TIME"
URL="$URL"
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>   ⚠️POINTING NOTIF⚠️ </b>
<b>     Add Domain New  </b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>IP VPS :</b> <code>$IP </code>
<b>DOMAIN :</b> <code>$dns </code>
<b>WILCARD :</b> <code>$wilcard </code>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>NEW ADD DOMAIN</code>
<code>BY BOT : @WENDIVPN_BOT</code>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
}
notif_poin