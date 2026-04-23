#!/bin/bash
# ============================================================
# VPN Install Script - Ubuntu 24.04
# Cara install:
#   unzip multiport-edited.zip -d /root/
#   cd /root/xray-edited
#   bash setup.sh
# ============================================================
# Suppress semua dialog interaktif apt (Ubuntu 22/24)
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=1
if [ -f /etc/needrestart/needrestart.conf ]; then
    sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
    sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/" /etc/needrestart/needrestart.conf
fi
clear
rm -rf setup.sh
rm -rf /etc/xray/domain
rm -rf /etc/v2ray/domain
rm -rf /etc/xray/scdomain
rm -rf /etc/v2ray/scdomain
rm -rf /var/lib/ipvps.conf
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
# domain random
CDN="https://raw.githubusercontent.com/saliminwaskinahzzxxcc/new/main/ssh"
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi

mkdir -p /etc/xray
mkdir -p /etc/v2ray
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/scdomain
touch /etc/v2ray/scdomain


echo -e "[ ${BBlue}NOTES${NC} ] Before we go.. "
sleep 0.5
echo -e "[ ${BBlue}NOTES${NC} ] I need check your headers first.."
sleep 0.5
echo -e "[ ${BGreen}INFO${NC} ] Checking headers"
sleep 0.5
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG 2>/dev/null|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo -e "[ ${BRed}WARNING${NC} ] Try to install ...."
  apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install $REQUIRED_PKG >/dev/null 2>&1 || true
fi
# Lanjut walau linux-headers tidak tersedia (tidak wajib di cloud VPS)
clear


secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

echo -e "[ ${BGreen}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
apt install python3 python3-pip python3-is-python -y >/dev/null 2>&1
echo -e "[ ${BGreen}INFO${NC} ] Aight good ... installation file is ready"
sleep 0.5
echo -ne "[ ${BGreen}INFO${NC} ] Check permission : "

echo -e "$BGreen Permission Accepted!$NC"
sleep 2

mkdir -p /var/lib/ >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf

echo ""
clear
# Pastikan terminal dalam kondisi normal sebelum input domain (fix Ubuntu 22/24)
stty sane 2>/dev/null || true
# Flush stdin agar tidak ada karakter sisa yang masuk ke read
while read -r -t 0; do read -r; done 2>/dev/null || true

    echo -e "$BBlue                     SETUP DOMAIN VPS     $NC"
    echo -e "$BYellow----------------------------------------------------------$NC"
    echo -e "$BGreen 1. Use Domain Random / Gunakan Domain Random $NC"
    echo -e "$BGreen 2. Choose Your Own Domain / Gunakan Domain Sendiri $NC"
    echo -e "$BYellow----------------------------------------------------------$NC"
    echo ""
    read -rp " Pilih domain yang akan kamu pakai [1/2] : " dns </dev/tty
    dns="${dns//[[:space:]]/}"
    if [[ "$dns" == "1" ]]; then
        clear
        apt-get install -y jq curl >/dev/null 2>&1
        wget -q -O /root/cf "${CDN}/cf"
        chmod +x /root/cf
        bash /root/cf | tee /root/install.log
        echo -e "${BGreen}Domain Random Done${NC}"
    elif [[ "$dns" == "2" ]]; then
        echo ""
        stty sane 2>/dev/null || true
        while read -r -t 0; do read -r; done 2>/dev/null || true
        read -rp " Enter Your Domain (contoh: vpn.namadomain.com) : " dom </dev/tty
        dom="${dom//[[:space:]]/}"
        if [[ -z "$dom" ]]; then
            echo -e "${BRed}Domain tidak boleh kosong! Jalankan ulang script.${NC}"
            exit 1
        fi
        mkdir -p /etc/xray /etc/v2ray
        echo "$dom" > /root/scdomain
        echo "$dom" > /etc/xray/scdomain
        echo "$dom" > /etc/xray/domain
        echo "$dom" > /etc/v2ray/domain
        echo "$dom" > /root/domain
        echo "IP=$dom" > /var/lib/ipvps.conf
        echo -e "${BGreen}Domain disimpan: $dom${NC}"
    else
        echo -e "${BRed}Pilihan tidak valid! Harap masukkan 1 atau 2.${NC}"
        exit 1
    fi
    echo -e "${BGreen}Done!${NC}"
    sleep 2
    clear

#install ssh ovpn
echo -e "\e[33m-----------------------------------\033[0m"
echo -e "$BGreen      Install SSH & Setup VPS         $NC"
echo -e "\e[33m-----------------------------------\033[0m"
sleep 0.5
clear
wget https://raw.githubusercontent.com/saliminwaskinahzzxxcc/new/main/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && bash ssh-vpn.sh
#Instal SSH Websocket dulu sebelum Xray (supaya port 2095 siap, nginx tidak bentrok)
echo -e "\e[33m-----------------------------------\033[0m"
echo -e "$BGreen      Install SSH Websocket           $NC"
echo -e "\e[33m-----------------------------------\033[0m"
sleep 0.5
clear
wget https://raw.githubusercontent.com/saliminwaskinahzzxxcc/new/main/sshws/insshws.sh && chmod +x insshws.sh && bash insshws.sh
#Instal Xray (nginx start setelah ws-dropbear sudah di port 2095)
echo -e "\e[33m-----------------------------------\033[0m"
echo -e "$BGreen          Install XRAY              $NC"
echo -e "\e[33m-----------------------------------\033[0m"
sleep 0.5
clear
wget https://raw.githubusercontent.com/saliminwaskinahzzxxcc/new/main/xray/ins-xray.sh && chmod +x ins-xray.sh && bash ins-xray.sh
clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

tty -s && mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-ssh.log" ]; then
echo "Log SSH Account " > /etc/log-create-ssh.log
fi
if [ ! -f "/etc/log-create-vmess.log" ]; then
echo "Log Vmess Account " > /etc/log-create-vmess.log
fi
if [ ! -f "/etc/log-create-vless.log" ]; then
echo "Log Vless Account " > /etc/log-create-vless.log
fi
if [ ! -f "/etc/log-create-trojan.log" ]; then
echo "Log Trojan Account " > /etc/log-create-trojan.log
fi
if [ ! -f "/etc/log-create-shadowsocks.log" ]; then
echo "Log Shadowsocks Account " > /etc/log-create-shadowsocks.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/saliminwaskinahzzxxcc/new/main/menu/versi )
echo $serverV > /opt/.ver
curl -sS ipv4.icanhazip.com > /etc/myipvps
echo ""
echo "=================================================================="  | tee -a log-install.txt
echo "      ___                                    ___         ___      "  | tee -a log-install.txt
echo "     /  /\        ___           ___         /  /\       /__/\     "  | tee -a log-install.txt
echo "    /  /:/_      /  /\         /__/\       /  /::\      \  \:\    "  | tee -a log-install.txt
echo "   /  /:/ /\    /  /:/         \  \:\     /  /:/\:\      \  \:\   "  | tee -a log-install.txt
echo "  /  /:/_/::\  /__/::\          \  \:\   /  /:/~/:/  _____\__\:\  "  | tee -a log-install.txt
echo " /__/:/__\/\:\ \__\/\:\__   ___  \__\:\ /__/:/ /:/  /__/::::::::\ "  | tee -a log-install.txt
echo " \  \:\ /~~/:/    \  \:\/\ /__/\ |  |:| \  \:\/:/   \  \:\~~\~~\/ "  | tee -a log-install.txt
echo "  \  \:\  /:/      \__\::/ \  \:\|  |:|  \  \::/     \  \:\  ~~~  "  | tee -a log-install.txt
echo "   \  \:\/:/       /__/:/   \  \:\__|:|   \  \:\      \  \:\      "  | tee -a log-install.txt
echo "    \  \::/        \__\/     \__\::::/     \  \:\      \  \:\     "  | tee -a log-install.txt
echo "     \__\/                       ~~~~       \__\/       \__\/ 1.0 "  | tee -a log-install.txt
echo "=================================================================="  | tee -a log-install.txt
echo ""
echo "   >>> Service & Port (Public)"  | tee -a log-install.txt
echo "   ─────────────────────────────────────────────────" | tee -a log-install.txt
echo "   [SSH]"  | tee -a log-install.txt
echo "   - OpenSSH                  : 22, 9696" | tee -a log-install.txt
echo "   - Dropbear                 : 109, 143" | tee -a log-install.txt
echo "   - Stunnel4 SSH-SSL         : 222 -> port 22" | tee -a log-install.txt
echo "   - Stunnel4 Dropbear-SSL    : 777 -> port 109" | tee -a log-install.txt
echo "   - Stunnel4 WS-SSL          : 2096 -> port 700" | tee -a log-install.txt
echo "   - SSH Websocket HTTP       : 80 (Nginx->ws-dropbear:2095)" | tee -a log-install.txt
echo "   - SSH Websocket SSL/HTTPS  : 443 (Nginx->ws-stunnel:700)" | tee -a log-install.txt
echo "   ─────────────────────────────────────────────────" | tee -a log-install.txt
echo "   [XRAY - via Nginx port 80/443]" | tee -a log-install.txt
echo "   - Vmess  WS  HTTP/TLS      : 80 / 443  path:/vmess" | tee -a log-install.txt
echo "   - Vless  WS  HTTP/TLS      : 80 / 443  path:/vless" | tee -a log-install.txt
echo "   - Trojan WS  HTTP/TLS      : 80 / 443  path:/trojan-ws" | tee -a log-install.txt
echo "   - SS     WS  HTTP/TLS      : 80 / 443  path:/ss-ws" | tee -a log-install.txt
echo "   - Vmess  gRPC TLS          : 443  svc:/vmess-grpc" | tee -a log-install.txt
echo "   - Vless  gRPC TLS          : 443  svc:/vless-grpc" | tee -a log-install.txt
echo "   - Trojan gRPC TLS          : 443  svc:/trojan-grpc" | tee -a log-install.txt
echo "   - SS     gRPC TLS          : 443  svc:/ss-grpc" | tee -a log-install.txt
echo "   ─────────────────────────────────────────────────" | tee -a log-install.txt
echo "   [OTHER]" | tee -a log-install.txt
echo "   - Nginx Web                : 81" | tee -a log-install.txt
echo "   - Badvpn UDPGW             : 7100, 7200, 7300, 7400" | tee -a log-install.txt
echo ""
echo "=============================Contact==============================" | tee -a log-install.txt
echo "---------------------------t.me/fahrialimudin-----------------------------" | tee -a log-install.txt
echo "==================================================================" | tee -a log-install.txt
echo -e ""
echo ""
echo "" | tee -a log-install.txt
rm /root/setup.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e "
"
echo -ne "[ ${yell}WARNING${NC} ] reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
