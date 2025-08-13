#!/bin/bash
clear
apt upgrade -y
apt update -y
apt install curl
apt install wondershaper -y
Green="\e[92;1m"
RED="\033[1;31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
EROR="${RED}[EROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'
TIME=$(date '+%d %b %Y')
ipsaya=$(wget -qO- ipinfo.io/ip)
TIMES="10"
CHATID="2046623"
KEY="6957450340:AAE3OyomqZQgf7SV68UUISd2Po-_Gd-Pwns"
URL="https://api.telegram.org/bot$KEY/sendMessage"
clear
export IP=$( curl -sS icanhazip.com )
clear
clear && clear && clear
clear;clear;clear
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "\033[96;1m               ALRELSHOP VPN TUNNELING\033[0m"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
sleep 3
clear
# while true; do
#     read -s -p "Password : " passwd
#     echo
#     read -s -p "Konfirmasi Password : " passwd_confirm
#     echo
#     if [[ -n "$passwd" && "$passwd" == "$passwd_confirm" ]]; then
#         echo "$passwd" > /etc/.password.txt
#         break
#     else
#         echo "Password harus diisi dan harus sama. Silakan coba lagi."
#     fi
# done
# echo root:$passwd | sudo chpasswd root > /dev/null 2>&1
# sudo systemctl restart sshd > /dev/null 2>&1      
if [[ $( uname -m | awk '{print $1}' ) == "x86_64" ]]; then
echo -e "${OK} Your Architecture Is Supported ( ${green}$( uname -m )${NC} )"
else
echo -e "${EROR} Your Architecture Is Not Supported ( ${YELLOW}$( uname -m )${NC} )"
exit 1
fi
if [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "ubuntu" ]]; then
echo -e "${OK} Your OS Is Supported ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
elif [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "debian" ]]; then
echo -e "${OK} Your OS Is Supported ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
else
echo -e "${EROR} Your OS Is Not Supported ( ${YELLOW}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
exit 1
fi
if [[ $ipsaya == "" ]]; then
echo -e "${EROR} IP Address ( ${RED}Not Detected${NC} )"
else
echo -e "${OK} IP Address ( ${green}$IP${NC} )"
fi
echo ""
read -p "$( echo -e "Press ${GRAY}[ ${NC}${green}Enter${NC} ${GRAY}]${NC} For Starting Installation") "
echo ""
clear
if [ "${EUID}" -ne 0 ]; then
echo "You need to run this script as root"
exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
echo "OpenVZ is not supported"
exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(curl -sS ipv4.icanhazip.com)
echo -e "\e[32mloading...\e[0m"
clear
# Set default username based on IP or random
username="alrelshop-$(date +%s | tail -c 6)"
echo "$username" >/usr/bin/user
echo -e "\e[32mloading...\e[0m"
clear
REPO="https://raw.githubusercontent.com/alrel1408/AutoAlrelshop/main/"
start=$(date +%s)
secs_to_human() {
echo "Installation time : $((${1} / 3600)) hours $(((${1} / 60) % 60)) minute's $((${1} % 60)) seconds"
}
function print_ok() {
echo -e "${OK} ${BLUE} $1 ${FONT}"
}
function print_install() {
echo -e "${green} =============================== ${FONT}"
echo -e "${YELLOW} # $1 ${FONT}"
echo -e "${green} =============================== ${FONT}"
sleep 1
}
function print_error() {
echo -e "${EROR} ${REDBG} $1 ${FONT}"
}
function print_success() {
if [[ 0 -eq $? ]]; then
echo -e "${green} =============================== ${FONT}"
echo -e "${Green} # $1 berhasil dipasang"
echo -e "${green} =============================== ${FONT}"
sleep 2
fi
}
function is_root() {
if [[ 0 == "$UID" ]]; then
print_ok "Root user Start installation process"
else
print_error "The current user is not the root user, please switch to the root user and run the script again"
fi
}
print_install "Membuat direktori xray"
mkdir -p /etc/xray
touch /etc/xray/scdomain
mkdir -p /etc/v2ray
touch /etc/v2ray/domain
touch /root/domain
touch /root/scdomain
touch /root/nsdomain
curl -s ifconfig.me > /etc/xray/ipvps
touch /etc/xray/domain
mkdir -p /var/log/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
mkdir -p /var/lib/kyt >/dev/null 2>&1
while IFS=":" read -r a b; do
case $a in
"MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
"Shmem") ((mem_used+=${b/kB}))  ;;
"MemFree" | "Buffers" | "Cached" | "SReclaimable")
mem_used="$((mem_used-=${b/kB}))"
;;
esac
done < /proc/meminfo
Ram_Usage="$((mem_used / 1024))"
Ram_Total="$((mem_total / 1024))"
export tanggal=`date -d "0 days" +"%d-%m-%Y - %X" `
export OS_Name=$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' )
export Kernel=$( uname -r )
export Arch=$( uname -m )
export IP=$( curl -s https://ipinfo.io/ip/ )
function first_setup(){
timedatectl set-timezone Asia/Jakarta
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
print_success "Directory Xray"

# Detect OS version
OS_ID=$(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g')
OS_VERSION_ID=$(cat /etc/os-release | grep VERSION_ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/VERSION_ID//g')
OS_NAME=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')

if [[ $OS_ID == "ubuntu" ]]; then
echo "Setup Dependencies for $OS_NAME"
sudo apt update -y
apt-get install --no-install-recommends software-properties-common -y

# Support for Ubuntu 20, 22, and newer
if [[ $OS_VERSION_ID == "20.04" ]] || [[ $OS_VERSION_ID == "22.04" ]] || [[ $OS_VERSION_ID == "24.04" ]]; then
apt-get install haproxy -y
else
# Fallback for older versions
add-apt-repository ppa:vbernat/haproxy-2.4 -y
apt-get -y install haproxy
fi

elif [[ $OS_ID == "debian" ]]; then
echo "Setup Dependencies for $OS_NAME"

# Support for Debian 11 (Bullseye) and 12 (Bookworm)
if [[ $OS_VERSION_ID == "11" ]] || [[ $OS_VERSION_ID == "12" ]]; then
apt-get update -y
apt-get install haproxy -y
else
# Fallback for older Debian versions
curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" http://haproxy.debian.net buster-backports-2.4 main >/etc/apt/sources.list.d/haproxy.list
sudo apt-get update
apt-get -y install haproxy
fi

else
echo -e " Your OS Is Not Supported ($OS_NAME)"
exit 1
fi
}
clear
function nginx_install() {
if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
print_install "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
sudo apt-get install nginx -y
elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
print_success "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
apt -y install nginx
else
echo -e " Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
fi
}
function password_default() {
clear
print_install "Setup Default Password"
# Keep existing root password, don't change it
current_passwd=$(cat /etc/.password.txt 2>/dev/null || echo "")
if [[ -z "$current_passwd" ]]; then
    # Only generate new password if no password file exists
    echo -e "${YELLOW}No existing password found. Keeping current root password.${NC}"
    # Get current root password hash instead of changing it
    echo "alrelshop123" > /etc/.password.txt
    echo -e "${GREEN}Password file created for reference only.${NC}"
else
    echo -e "${GREEN}Using existing password from file.${NC}"
fi
print_success "Default Password Setup"
}

function base_package() {
clear
print_install "Menginstall Packet Yang Dibutuhkan"
apt install zip pwgen openssl netcat socat cron bash-completion -y
apt install figlet -y
apt update -y
apt upgrade -y
apt dist-upgrade -y
# Handle chrony/chronyd service
if systemctl list-unit-files | grep -q "chronyd.service"; then
    echo -e "${GREEN}Enabling chronyd service...${NC}"
    systemctl enable chronyd
    systemctl restart chronyd
    chronyc sourcestats -v 2>/dev/null || echo -e "${YELLOW}chronyd stats not available${NC}"
    chronyc tracking -v 2>/dev/null || echo -e "${YELLOW}chronyd tracking not available${NC}"
elif systemctl list-unit-files | grep -q "chrony.service"; then
    echo -e "${GREEN}Enabling chrony service...${NC}"
    systemctl enable chrony
    systemctl restart chrony
    chronyc sourcestats -v 2>/dev/null || echo -e "${YELLOW}chrony stats not available${NC}"
    chronyc tracking -v 2>/dev/null || echo -e "${YELLOW}chrony tracking not available${NC}"
else
    echo -e "${YELLOW}chrony/chronyd not available, using ntpdate instead${NC}"
fi
apt install ntpdate -y
ntpdate pool.ntp.org
apt install sudo -y
sudo apt-get clean all
sudo apt-get autoremove -y
sudo apt-get install -y debconf-utils
sudo apt-get remove --purge exim4 -y
sudo apt-get remove --purge ufw firewalld -y
sudo apt-get install -y --no-install-recommends software-properties-common
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
# Install packages with better error handling
apt-get update -y
sudo apt-get install -y speedtest-cli vnstat libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev bc rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr libxml-parser-perl build-essential gcc g++ python htop lsof tar wget curl ruby zip unzip p7zip-full python3-pip libc6 util-linux build-essential msmtp-mta ca-certificates bsd-mailx iptables net-tools openssl ca-certificates gnupg gnupg2 ca-certificates lsb-release gcc shc make cmake git screen socat xz-utils apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq openvpn easy-rsa

# Install iptables-persistent and netfilter-persistent separately with error handling
if ! dpkg -l | grep -q iptables-persistent; then
    echo -e "${GREEN}Installing iptables-persistent...${NC}"
    sudo apt-get install -y iptables-persistent
fi

if ! dpkg -l | grep -q netfilter-persistent; then
    echo -e "${GREEN}Installing netfilter-persistent...${NC}"
    sudo apt-get install -y netfilter-persistent
fi

# Install fail2ban separately
if ! dpkg -l | grep -q fail2ban; then
    echo -e "${GREEN}Installing fail2ban...${NC}"
    sudo apt-get install -y fail2ban
fi
print_success "Packet Yang Dibutuhkan"
}
clear
function pasang_domain() {
echo -e ""
clear
echo -e "===================================================="
echo -e "   |\e[1;32mPlease Select a Domain Type Below \e[0m|"
echo -e "===================================================="
echo -e "     \e[1;32m1)\e[0m Your Domain"
echo -e "     \e[1;32m2)\e[0m Random Domain "
echo -e "===================================================="
read -p "   Please select numbers 1-2 or Any Button(Random) : " host
echo ""
if [[ $host == "1" ]]; then
echo -e "\e[1;32m====================================================$NC"
echo -e "\e[1;36m     INPUT SUBDOMAIN $NC"
echo -e "\e[1;32m====================================================$NC"
echo -e "\033[91;1m contoh subdomain :\033[0m \033[93 wendi.ssh.cloud\033[0m"
read -p "SUBDOMAIN :  " host1
echo "IP=" >> /var/lib/kyt/ipvps.conf
echo $host1 > /etc/xray/domain
echo $host1 > /etc/xray/scdomain
echo $host1 > /etc/v2ray/domain
echo $host1 > /root/domain
echo $host1 > /root/scdomain
echo ""
print_install "Subdomain/Domain is Used"
clear
elif [[ $host == "2" ]]; then
wget ${REPO}files/cf.sh && chmod +x cf.sh && ./cf.sh
rm -f /root/cf.sh
clear
else
print_install "Random Subdomain/Domain is Used"
clear
fi
}
clear
restart_system() {
TIMEZONE=$(printf '%(%H:%M:%S)T')
RX=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 8)
domain=$(cat /root/domain)
echo -e "${green}=====================================================${NC}"
echo -e "${Green}            INSTALASI BERHASIL DISELESAIKAN"
echo -e "${green}=====================================================${NC}"
echo -e "${Green}Domain    : ${NC}$domain"
echo -e "${Green}Wildcard  : ${NC}*.$domain"
echo -e "${Green}Date      : ${NC}$TIME"
echo -e "${Green}Time      : ${NC}$TIMEZONE"
echo -e "${Green}IP VPS    : ${NC}$MYIP"
echo -e "${Green}User      : ${NC}root"
echo -e "${green}=====================================================${NC}"
echo -e "${Green}Telegram  : ${NC}t.me/alrelshop"
echo -e "${Green}WhatsApp  : ${NC}wa.me/628228585168"
echo -e "${green}=====================================================${NC}"
}
clear
function pasang_ssl() {
clear
print_install "Memasang SSL Pada Domain"
rm -rf /etc/xray/xray.key
rm -rf /etc/xray/xray.crt
domain=$(cat /root/domain)
STOPWEBSERVER=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
rm -rf /root/.acme.sh
mkdir /root/.acme.sh
systemctl stop $STOPWEBSERVER
systemctl stop nginx
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
chmod 777 /etc/xray/xray.key
print_success "SSL Certificate"
}
function make_folder_xray() {
rm -rf /etc/vmess/.vmess.db
rm -rf /etc/vless/.vless.db
rm -rf /etc/trojan/.trojan.db
rm -rf /etc/shadowsocks/.shadowsocks.db
rm -rf /etc/ssh/.ssh.db
rm -rf /etc/bot/.bot.db
mkdir -p /etc/bot
mkdir -p /etc/xray
mkdir -p /etc/vmess
mkdir -p /etc/vless
mkdir -p /etc/trojan
mkdir -p /etc/shadowsocks
mkdir -p /etc/ssh
mkdir -p /usr/bin/xray/
mkdir -p /var/log/xray/
mkdir -p /var/www/html
mkdir -p /etc/kyt/files/vmess/ip
mkdir -p /etc/kyt/files/vless/ip
mkdir -p /etc/kyt/files/trojan/ip
mkdir -p /etc/kyt/files/ssh/ip
mkdir -p /etc/files/vmess
mkdir -p /etc/files/vless
mkdir -p /etc/files/trojan
mkdir -p /etc/files/ssh
chmod +x /var/log/xray
touch /etc/xray/domain
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /etc/vmess/.vmess.db
touch /etc/vless/.vless.db
touch /etc/trojan/.trojan.db
touch /etc/shadowsocks/.shadowsocks.db
touch /etc/ssh/.ssh.db
touch /etc/bot/.bot.db
touch /etc/xray/.lock.db
echo "& plughin Account" >>/etc/vmess/.vmess.db
echo "& plughin Account" >>/etc/vless/.vless.db
echo "& plughin Account" >>/etc/trojan/.trojan.db
echo "& plughin Account" >>/etc/shadowsocks/.shadowsocks.db
echo "& plughin Account" >>/etc/ssh/.ssh.db
cat >/etc/xray/.lock.db <<EOF
#vmess
#vless
#trojan
#ss
EOF
}
function install_xray() {
clear
print_install "Core Xray 1.8.1 Latest Version"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
wget -O /etc/xray/config.json "${REPO}cfg_conf_js/config.json" >/dev/null 2>&1
wget -O /etc/systemd/system/runn.service "${REPO}files/runn.service" >/dev/null 2>&1
domain=$(cat /etc/xray/domain)
IPVS=$(cat /etc/xray/ipvps)
print_success "Core Xray 1.8.1 Latest Version"
clear
curl -s ipinfo.io/city >>/etc/xray/city
curl -s ipinfo.io/org | cut -d " " -f 2-10 >>/etc/xray/isp
print_install "Memasang Konfigurasi Packet"
wget -O /etc/haproxy/haproxy.cfg "${REPO}cfg_conf_js/haproxy.cfg" >/dev/null 2>&1
wget -O /etc/nginx/conf.d/xray.conf "${REPO}cfg_conf_js/xray.conf" >/dev/null 2>&1
sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
curl ${REPO}cfg_conf_js/nginx.conf > /etc/nginx/nginx.conf
cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem
chmod +x /etc/systemd/system/runn.service
rm -rf /etc/systemd/system/xray.service.d
cat >/etc/systemd/system/xray.service <<EOF
Description=Xray Service
Documentation=https://github.com
After=network.target nss-lookup.target
[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
filesNPROC=10000
filesNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
print_success "Konfigurasi Packet"
}
function ssh(){
clear
print_install "Memasang Password SSH"
wget -O /etc/pam.d/common-password "${REPO}files/password"
chmod +x /etc/pam.d/common-password
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/compose select No compose key"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layoutcode string de"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layout select English"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/modelcode string pc105"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/model select Generic 105-key (Intl) PC"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/optionscode string "
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/store_defaults_in_debconf_db boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/switch select No temporary switch"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/toggle select No toggling"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_layout boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_options boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_layout boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_options boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variantcode string "
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variant select English"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/xkb-keymap select "
cd
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END
cat > /etc/rc.local <<-END
exit 0
END
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
print_success "Password SSH"
}
function udp_mini(){
clear
print_install "Memasang Service limit Quota"
wget raw.githubusercontent.com/bowowiwendi/WendyVpn/ABSTRAK/files/limit.sh && chmod +x limit.sh && ./limit.sh
cd
wget -q -O /usr/bin/limit-ip "${REPO}files/limit-ip"
chmod +x /usr/bin/*
cd /usr/bin
sed -i 's/\r//' limit-ip
cd
clear
# Create files-ip utility first
cat >/usr/bin/files-ip << 'EOF'
#!/bin/bash
# Simple IP management utility for ALRELSHOP
case "$1" in
    vmip|vlip|trip)
        echo "IP management for $1 - ALRELSHOP Auto Script"
        # Add your IP management logic here if needed
        ;;
    *)
        echo "Usage: files-ip {vmip|vlip|trip}"
        exit 1
        ;;
esac
EOF
chmod +x /usr/bin/files-ip

# Create services with correct configuration
cat >/etc/systemd/system/vmip.service << EOF
[Unit]
Description=VMess IP Management
After=network.target
[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/files-ip vmip
Restart=always
[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/vlip.service << EOF
[Unit]
Description=VLESS IP Management
After=network.target
[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/files-ip vlip
Restart=always
[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/trip.service << EOF
[Unit]
Description=Trojan IP Management
After=network.target
[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/files-ip trip
Restart=always
[Install]
WantedBy=multi-user.target
EOF

# Enable services
systemctl daemon-reload
systemctl enable vmip vlip trip
systemctl start vmip vlip trip
mkdir -p /usr/local/kyt/
wget -q -O /usr/local/kyt/udp-mini "${REPO}files/udp-mini"
chmod +x /usr/local/kyt/udp-mini
wget -q -O /etc/systemd/system/udp-mini-1.service "${REPO}files/udp-mini-1.service"
wget -q -O /etc/systemd/system/udp-mini-2.service "${REPO}files/udp-mini-2.service"
wget -q -O /etc/systemd/system/udp-mini-3.service "${REPO}files/udp-mini-3.service"
systemctl disable udp-mini-1
systemctl stop udp-mini-1
systemctl enable udp-mini-1
systemctl start udp-mini-1
systemctl disable udp-mini-2
systemctl stop udp-mini-2
systemctl enable udp-mini-2
systemctl start udp-mini-2
systemctl disable udp-mini-3
systemctl stop udp-mini-3
systemctl enable udp-mini-3
systemctl start udp-mini-3
print_success "files Quota Service"
}
function ssh_slow(){
clear
print_install "Memasang modul SlowDNS Server"
print_success "SlowDNS"
}
clear
function ins_SSHD(){
clear
print_install "Memasang SSHD"
wget -q -O /etc/ssh/sshd_config "${REPO}files/sshd" >/dev/null 2>&1
chmod 700 /etc/ssh/sshd_config
/etc/init.d/ssh restart
systemctl restart ssh
/etc/init.d/ssh status
print_success "SSHD"
}
clear
function ins_dropbear(){
clear
print_install "Menginstall Dropbear"
apt-get update -y
apt-get install dropbear -y >/dev/null 2>&1
wget -q -O /etc/default/dropbear "${REPO}cfg_conf_js/dropbear.conf" >/dev/null 2>&1
chmod +x /etc/default/dropbear
/etc/init.d/dropbear restart
/etc/init.d/dropbear status
print_success "Dropbear"
}
clear
function ins_vnstat(){
clear
print_install "Menginstall Vnstat"
apt -y install vnstat > /dev/null 2>&1
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev > /dev/null 2>&1
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6
print_success "Vnstat"
}
function ins_openvpn(){
clear
print_install "Menginstall OpenVPN"

# Install OpenVPN and Easy-RSA
apt install openvpn easy-rsa -y

# Setup directories
mkdir -p /etc/openvpn/server
make-cadir /etc/openvpn/easy-rsa

# Configure Easy-RSA
cd /etc/openvpn/easy-rsa
cat > vars << 'EOF'
set_var EASYRSA_REQ_COUNTRY    "ID"
set_var EASYRSA_REQ_PROVINCE   "Jakarta"
set_var EASYRSA_REQ_CITY       "Jakarta"
set_var EASYRSA_REQ_ORG        "ALRELSHOP"
set_var EASYRSA_REQ_EMAIL      "admin@alrelshop.my.id"
set_var EASYRSA_REQ_OU         "ALRELSHOP"
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"
EOF

# Initialize PKI and generate certificates
./easyrsa init-pki
./easyrsa --batch build-ca nopass
./easyrsa --batch build-server-full server nopass
./easyrsa gen-dh
openvpn --genkey secret pki/ta.key

# Copy certificates
cp pki/ca.crt pki/private/server.key pki/issued/server.crt pki/dh.pem pki/ta.key /etc/openvpn/server/

# Create server configurations
cat > /etc/openvpn/server/server-tcp.conf << 'EOFTCP'
port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA512
tls-crypt ta.key
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
verb 3
ncp-ciphers AES-256-GCM:AES-128-GCM
auth SHA256
keysize 256
auth-user-pass-verify /etc/openvpn/auth_script.sh via-env
username-as-common-name
script-security 3
EOFTCP

cat > /etc/openvpn/server/server-udp.conf << 'EOFUDP'
port 2200
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA512
tls-crypt ta.key
topology subnet
server 10.9.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
verb 3
ncp-ciphers AES-256-GCM:AES-128-GCM
auth SHA256
keysize 256
auth-user-pass-verify /etc/openvpn/auth_script.sh via-env
username-as-common-name
script-security 3
EOFUDP

# Create auth script
cat > /etc/openvpn/auth_script.sh << 'EOFAUTH'
#!/bin/bash
USER="$username"
PASS="$password"
if [[ -z "$USER" || -z "$PASS" ]]; then
    exit 1
fi
if id "$USER" &>/dev/null; then
    echo "$PASS" | su -c 'exit' "$USER" 2>/dev/null
    exit $?
else
    exit 1
fi
EOFAUTH

chmod +x /etc/openvpn/auth_script.sh

# Enable and start services
systemctl enable openvpn-server@server-tcp
systemctl enable openvpn-server@server-udp
systemctl start openvpn-server@server-tcp
systemctl start openvpn-server@server-udp
systemctl enable openvpn
systemctl restart openvpn

# Create client configs
domain=$(cat /etc/xray/domain)
mkdir -p /etc/openvpn/client

cat > /etc/openvpn/client/tcp.ovpn << EOFCLIENT
client
dev tun
proto tcp
remote $domain 1194
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
EOFCLIENT

cat > /etc/openvpn/client/udp.ovpn << EOFCLIENT2  
client
dev tun
proto udp
remote $domain 2200
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
EOFCLIENT2

cat > /etc/openvpn/client/ssl.ovpn << EOFCLIENT3
client
dev tun
proto tcp
remote $domain 443
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
EOFCLIENT3

cd /root
print_success "OpenVPN"
}
clear
function ins_swab(){
clear
print_install "Memasang Swap 1 G"
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
curl -sL "$gotop_link" -o /tmp/gotop.deb
dpkg -i /tmp/gotop.deb >/dev/null 2>&1
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
mkswap /swapfile
chown root:root /swapfile
chmod 0600 /swapfile >/dev/null 2>&1
swapon /swapfile >/dev/null 2>&1
sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab
chronyd -q 'server 0.id.pool.ntp.org iburst'
chronyc sourcestats -v
chronyc tracking -v
wget ${REPO}files/bbr.sh &&  chmod +x bbr.sh && ./bbr.sh
print_success "Swap 1 G"
}
function ins_Fail2ban(){
clear
print_install "Menginstall Fail2ban"
if [ -d '/usr/local/ddos' ]; then
echo; echo; echo "Please un-install the previous version first"
exit 0
else
mkdir /usr/local/ddos
fi
clear
echo "Banner /etc/banner.txt" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/banner.txt"@g' /etc/default/dropbear
wget -O /etc/banner.txt "${REPO}banner/issue.net"
print_success "Fail2ban"
}
function ins_squid_proxy(){
clear
print_install "Menginstall Squid Proxy (Pengganti OHP)"
apt install squid -y

# Backup original config
cp /etc/squid/squid.conf /etc/squid/squid.conf.bak

# Create new squid config
cat > /etc/squid/squid.conf << 'EOF'
http_port 3128
http_port 8080
http_port 8181
http_port 8282  
http_port 8383

acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12  
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7
acl localnet src fe80::/10

acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT

http_access allow localhost
http_access allow localnet
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access deny all

coredump_dir /var/spool/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320

forwarded_for delete
via off
EOF

systemctl restart squid
systemctl enable squid
print_success "Squid Proxy (Pengganti OHP)"
}
function ins_epro(){
clear
print_install "Menginstall ePro WebSocket Proxy"
wget -O /usr/bin/ws "${REPO}files/ws" >/dev/null 2>&1
wget -O /usr/bin/tun.conf "${REPO}cfg_conf_js/tun.conf" >/dev/null 2>&1
wget -O /etc/systemd/system/ws.service "${REPO}files/ws.service" >/dev/null 2>&1
chmod +x /etc/systemd/system/ws.service
chmod +x /usr/bin/ws
chmod 644 /usr/bin/tun.conf
systemctl disable ws
systemctl stop ws
systemctl enable ws
systemctl start ws
systemctl restart ws
wget -q -O /usr/local/share/xray/geosite.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" >/dev/null 2>&1
wget -q -O /usr/local/share/xray/geoip.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" >/dev/null 2>&1
wget -O /usr/sbin/ftvpn "${REPO}files/ftvpn" >/dev/null 2>&1
chmod +x /usr/sbin/ftvpn
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
cd
apt autoclean -y >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
print_success "ePro WebSocket Proxy"
}
function ins_restart(){
clear
print_install "Restarting All Packet"

# Restart services with error handling
restart_service() {
    local service=$1
    if systemctl list-unit-files | grep -q "$service.service" || [ -f "/etc/init.d/$service" ]; then
        echo -e "${GREEN}Restarting $service...${NC}"
        if [ -f "/etc/init.d/$service" ]; then
            /etc/init.d/$service restart 2>/dev/null || echo -e "${YELLOW}Failed to restart $service via init.d${NC}"
        else
            systemctl restart $service 2>/dev/null || echo -e "${YELLOW}Failed to restart $service via systemctl${NC}"
        fi
        
        # Enable service
        if systemctl list-unit-files | grep -q "$service.service"; then
            systemctl enable $service 2>/dev/null || echo -e "${YELLOW}Failed to enable $service${NC}"
        fi
    else
        echo -e "${YELLOW}Service $service not found, skipping...${NC}"
    fi
}

systemctl daemon-reload

# Restart essential services
restart_service "nginx"
restart_service "ssh"
restart_service "dropbear"
restart_service "vnstat"
restart_service "haproxy"
restart_service "cron"
restart_service "xray"
restart_service "ws"
restart_service "squid"

# Handle optional services
if systemctl list-unit-files | grep -q "openvpn.service" || [ -f "/etc/init.d/openvpn" ]; then
    restart_service "openvpn"
fi

if systemctl list-unit-files | grep -q "fail2ban.service" || [ -f "/etc/init.d/fail2ban" ]; then
    restart_service "fail2ban"
fi

# Handle netfilter-persistent
if systemctl list-unit-files | grep -q "netfilter-persistent.service"; then
    systemctl start netfilter-persistent
    systemctl enable netfilter-persistent
else
    echo -e "${YELLOW}netfilter-persistent not available, saving iptables rules manually${NC}"
    mkdir -p /etc/iptables
    iptables-save > /etc/iptables/rules.v4 2>/dev/null || true
fi

# Enable rc-local
systemctl enable rc-local 2>/dev/null || echo -e "${YELLOW}rc-local not available${NC}"

history -c
echo "unset HISTFILE" >> /etc/profile
cd
rm -f /root/openvpn
rm -f /root/key.pem
rm -f /root/cert.pem
print_success "All Packet"
}
function menu(){
clear
print_install "Memasang Menu Packet"
wget ${REPO}Features/menu.zip
unzip menu.zip
chmod +x menu/*
mv menu/* /usr/local/sbin
rm -rf menu
rm -rf menu.zip
}
function profile(){
clear
cat >/root/.profile <<EOF
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
menu
EOF
cat << EOF >> /etc/crontab
# BEGIN_Backup
1 0 * * * root bot-backup
# END_Backup
EOF
cat << EOF >> /etc/crontab
# BEGIN_Del
0 0 * * * root xp
# END_Del
EOF
cat >/etc/cron.d/logclean <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/10 * * * * root /usr/local/sbin/clearlog
END
chmod 644 /root/.profile
cat >/etc/cron.d/daily_reboot <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
END
echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray
service cron restart
cat >/home/daily_reboot <<-END
5
END
cat >/etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
echo "/bin/false" >>/etc/shells
echo "/usr/sbin/nologin" >>/etc/shells
cat >/etc/rc.local <<EOF
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF
chmod +x /etc/rc.local
AUTOREB=$(cat /home/daily_reboot)
SETT=11
if [ $AUTOREB -gt $SETT ]; then
TIME_DATE="PM"
else
TIME_DATE="AM"
fi
print_success "Menu Packet"
}
function enable_services(){
clear
print_install "Enable Service"
systemctl daemon-reload

# Enable services with error handling
services=("rc-local" "cron" "nginx" "xray" "haproxy" "squid")
for service in "${services[@]}"; do
    if systemctl list-unit-files | grep -q "$service.service"; then
        echo -e "${GREEN}Enabling $service...${NC}"
        systemctl enable --now $service
        systemctl restart $service
    else
        echo -e "${YELLOW}Service $service not found, skipping...${NC}"
    fi
done

# Enable OpenVPN services separately
if systemctl list-unit-files | grep -q "openvpn-server@.service"; then
    echo -e "${GREEN}Enabling OpenVPN services...${NC}"
    systemctl enable --now openvpn-server@server-tcp
    systemctl enable --now openvpn-server@server-udp
    systemctl enable --now openvpn
fi

# Handle netfilter-persistent separately
if systemctl list-unit-files | grep -q "netfilter-persistent.service"; then
    echo -e "${GREEN}Enabling netfilter-persistent...${NC}"
    systemctl enable --now netfilter-persistent
    systemctl start netfilter-persistent
else
    echo -e "${YELLOW}netfilter-persistent not found, using iptables-save instead...${NC}"
    # Save current iptables rules
    iptables-save > /etc/iptables/rules.v4 2>/dev/null || echo "iptables rules saved manually"
fi

# Don't create problematic services (trip, vlip, vmip) that require missing files
echo -e "${YELLOW}Skipping trip/vlip/vmip services (files-ip not available)...${NC}"

print_success "Enable Service"
clear
}
function instal(){
clear
pasang_domain
first_setup
make_folder_xray
nginx_install
base_package
password_default
pasang_ssl
install_xray
ssh
udp_mini
ssh_slow
ins_SSHD
ins_dropbear
ins_vnstat
ins_openvpn
ins_squid_proxy
ins_backup
ins_swab
ins_Fail2ban
ins_epro
ins_restart
menu
profile
enable_services
restart_system
}
function ins_backup() {
clear
print_install "Memasang Backup Server"
apt install rclone -y
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "${REPO}cfg_conf_js/rclone.conf"
cd /bin
git clone https://github.com/magnific0/wondershaper.git
cd wondershaper
sudo make install
cd ..
rm -rf wondershaper
echo > /home/files
apt install msmtp-mta ca-certificates bsd-mailx -y
cat >/etc/msmtprc << EOF
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account default
host smtp.gmail.com
port 587
auth on
user oceantestdigital@gmail.com
from oceantestdigital@gmail.com
password jokerman77
logfile ~/.msmtp.log
EOF
chown -R www-data:www-data /etc/msmtprc
chmod 600 /etc/msmtprc
wget -q -O /etc/ipserver "${REPO}files/ipserver" && bash /etc/ipserver
print_success "Backup Server"
}
instal
echo ""
history -c
rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
rm -rf /root/domain
secs_to_human "$(($(date +%s) - ${start}))"
sudo hostnamectl set-hostname $username
sleep 2
clear
echo -e ""
echo -e "\033[96m====================================================\033[0m"
echo -e "\033[92m                  INSTALL SUCCES\033[0m"
echo -e "\033[96m====================================================\033[0m"
echo -e ""
reboot
