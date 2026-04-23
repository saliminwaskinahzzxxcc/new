#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   Autoscript SSH & Xray Multiport Lifetime
#   Android Friendly UI - Full Theme Color Support
#   github.com/saliminwaskinahzzxxcc
# ══════════════════════════════════════════════════════════════════

# ── Load Theme Color Config ────────────────────────────────────────
# File ini dibuat oleh color picker di menu Setting (no 9 > 8)
# Setiap variabel C1-C6 mengontrol bagian UI yang berbeda:
#   C1 = garis double (═══)
#   C2 = garis single (───/━━━)
#   C3 = header background label (◈ JUDUL)
#   C4 = nomor menu
#   C5 = label info kiri (SYSTEM OS, ISP, dll)
#   C6 = teks footer
COLOR_CFG="/etc/xray/.menu_color"
if [ -f "$COLOR_CFG" ]; then
    source "$COLOR_CFG"
else
    # Default theme: Rainbow (5 warna berbeda)
    C1='\e[1;36m'   # garis double  — cyan
    C2='\e[1;33m'   # garis single  — kuning
    C3='\e[1;35m'   # header section — magenta
    C4='\e[1;32m'   # nomor menu    — hijau
    C5='\e[1;34m'   # label kiri    — biru
    C6='\e[1;31m'   # footer        — merah
    THEME_NAME="Default Rainbow"
fi

# ── Base Colors (tetap, tidak berubah) ────────────────────────────
R='\e[0m'
BOLD='\e[1m'
BFWHT='\e[1;37m'
BFGRN='\e[1;32m'
BFYLW='\e[1;33m'
BFRED='\e[1;31m'
BGRED='\e[41m'
BGBBLK='\e[100m'
BGBGRN='\e[102m'
BYLW='\e[93m'
BRED='\e[91m'
BGRN='\e[92m'
WHT='\e[37m'

LINE_W=48

draw_double() {
    printf "${C1}"
    for i in $(seq 1 $LINE_W); do printf "═"; done
    printf "${R}\n"
}

draw_line() {
    local char="${1:-─}"
    printf "${C2}"
    for i in $(seq 1 $LINE_W); do printf "$char"; done
    printf "${R}\n"
}

center_pad() {
    local text="$1" color="$2"
    local len=${#text}
    local pad=$(( (LINE_W - len) / 2 ))
    [ $pad -lt 0 ] && pad=0
    printf "${color}%${pad}s${text}%${pad}s${R}\n" "" ""
}

section_header() {
    echo ""
    printf "${BGBBLK}${C3}  ◈ %-44s${R}\n" "$1"
}

menu_row() {
    local n1="$1" l1="$2" n2="$3" l2="$4"
    printf "  ${BGBBLK}${C4} %-2s ${R} ${BFWHT}%-19s${R}" "$n1" "$l1"
    if [[ -n "$n2" ]]; then
        printf " ${BGBBLK}${C4} %-2s ${R} ${BFWHT}%-16s${R}" "$n2" "$l2"
    fi
    printf "\n"
}

# ── Gather System Info ─────────────────────────────────────────────
MYIP=$(cat /etc/myipvps 2>/dev/null || curl -s --max-time 5 ifconfig.me 2>/dev/null || echo "N/A")
NET_IFACE=$(ip -o -4 route show to default 2>/dev/null | awk '{print $5}' | head -1)
domain=$(cat /etc/xray/domain 2>/dev/null || echo "belum-diset")
OS_NAME=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || echo "Unknown")
UPTIME_VAL=$(uptime -p 2>/dev/null | sed 's/up //' || echo "N/A")
RAM_TOTAL=$(free -m 2>/dev/null | awk 'NR==2 {print $2}')
RAM_USED=$(free -m 2>/dev/null | awk 'NR==2 {print $3}')
RAM_PCT=$(awk "BEGIN{if(${RAM_TOTAL:-1}>0) printf \"%d\",${RAM_USED:-0}*100/${RAM_TOTAL:-1}; else print 0}")
ISP=$(curl -s --max-time 5 "http://ip-api.com/line/?fields=isp" 2>/dev/null || echo "N/A")
DATE_NOW=$(date +"%d %b %Y")
TIME_NOW=$(TZ="Asia/Jakarta" date +"%H:%M:%S WIB" 2>/dev/null || date +"%H:%M:%S")
BW_RX=$(vnstat -i "$NET_IFACE" 2>/dev/null | grep "today" | awk '{print $2" "substr($3,1,1)}' || echo "N/A")
BW_TX=$(vnstat -i "$NET_IFACE" 2>/dev/null | grep "today" | awk '{print $5" "substr($6,1,1)}' || echo "N/A")
BW_TODAY=$(vnstat -i "$NET_IFACE" 2>/dev/null | grep "today" | awk '{print $8" "substr($9,1,1)}' || echo "N/A")

# ── Service Status ─────────────────────────────────────────────────
get_svc() {
    local name="$1"
    local st
    st=$(systemctl is-active "$name" 2>/dev/null)
    echo "$st"
}

ST_SSH=$(get_svc ssh)
[ "$ST_SSH" != "active" ] && ST_SSH=$(get_svc sshd)

ST_DROPBEAR=$(get_svc dropbear)
ST_XRAY=$(get_svc xray)
ST_NGINX=$(get_svc nginx)
ST_STUNNEL=$(get_svc stunnel4)
ST_WSDROP=$(get_svc ws-dropbear)
ST_VNSTAT=$(get_svc vnstat)
ST_CRON=$(get_svc cron)

svc_stat() {
    local st="$1"
    if [[ "$st" == "active" || "$st" == "running" ]]; then
        printf "${BFGRN}ON${R}"
    else
        printf "${BRED}OFF${R}"
    fi
}

svc_row() {
    local n1="$1" s1="$2" n2="$3" s2="$4"
    printf "  ${C5}%-10s${R}: $(svc_stat $s1)" "$n1"
    if [[ -n "$n2" ]]; then
        printf "    ${C5}%-10s${R}: $(svc_stat $s2)" "$n2"
    fi
    printf "\n"
}

# ══════════════════════════════════════════════════════════════════
clear

# ─ HEADER ─────────────────────────────────────────────────────────
draw_double
printf "${BGBBLK}${BOLD}%-${LINE_W}s${R}\r\n" ""
center_pad "✦ Autoscript SSH & Xray Multiport ✦" "${BGBBLK}${BOLD}${C3}"
center_pad "Lifetime · saliminwaskinahzzxxcc" "${BGBBLK}${C6}"
printf "${BGBBLK}${BOLD}%-${LINE_W}s${R}\n" ""
draw_double

# ─ VPS INFO ───────────────────────────────────────────────────────
section_header "VPS INFORMATION"
draw_line "─"
printf "  ${C5}%-12s${R}: ${BFWHT}%s${R}\n"  "SYSTEM OS"  "$OS_NAME"
printf "  ${C5}%-12s${R}: ${BFWHT}%s${R}\n"  "ISP"        "$ISP"
printf "  ${C5}%-12s${R}: ${BGRN}%s MB${R}/${WHT}%s MB${R} ${BRED}[${RAM_PCT}%%]${R}\n" "RAM" "$RAM_USED" "$RAM_TOTAL"
printf "  ${C5}%-12s${R}: ${BFWHT}%s${R}\n"  "UPTIME"     "$UPTIME_VAL"
printf "  ${C5}%-12s${R}: ${C3}%s${R}\n"     "DATE"       "$DATE_NOW"
printf "  ${C5}%-12s${R}: ${C4}%s${R}\n"     "TIME"       "$TIME_NOW"
printf "  ${C5}%-12s${R}: ${BFYLW}%s${R}\n"  "IP VPS"     "$MYIP"
printf "  ${C5}%-12s${R}: ${C1}%s${R}\n"     "DOMAIN"     "$domain"
draw_line "─"
printf "  ${C5}BW${R}: ${BGRN}↓%s${R}  ${BRED}↑%s${R}  ${C3}Tot:%s${R}\n" "$BW_RX" "$BW_TX" "$BW_TODAY"
draw_line "─"

# ─ SERVICE STATUS ─────────────────────────────────────────────────
section_header "SERVICE STATUS"
draw_line "─"
echo ""
svc_row "SSH"       "$ST_SSH"      "DROPBEAR"  "$ST_DROPBEAR"
svc_row "XRAY"      "$ST_XRAY"     "NGINX"     "$ST_NGINX"
svc_row "STUNNEL4"  "$ST_STUNNEL"  "SSH-WS"    "$ST_WSDROP"
svc_row "VNSTAT"    "$ST_VNSTAT"   "CRON"      "$ST_CRON"
echo ""
draw_line "─"

# ─ MAIN MENU ──────────────────────────────────────────────────────
section_header "MAIN MENU"
draw_line "━"
echo ""
menu_row "1"  "SSH / OpenVPN"    "8"  "Speedtest"
menu_row "2"  "Vmess WS/GRPC"    "9"  "Setting & Domain"
menu_row "3"  "Vless WS/GRPC"    "10" "Bandwidth Monitor"
menu_row "4"  "Trojan WS/GRPC"   "11" "Auto Reboot"
menu_row "5"  "Shadowsocks"       "12" "Restart Services"
menu_row "6"  "Status Service"    "13" "Clear RAM Cache"
menu_row "7"  "VPS Info"          "14" "Reboot VPS"
printf "  ${BGRED}${BOLD}${BFWHT}  X  ${R} ${BRED}Exit${R}\n"
echo ""
draw_line "━"

# ─ FOOTER ─────────────────────────────────────────────────────────
printf "${BGBBLK}%-${LINE_W}s${R}\r\n" ""
center_pad "github.com/saliminwaskinahzzxxcc" "${BGBBLK}${C6}"
center_pad "Tema: ${THEME_NAME}" "${BGBBLK}${C2}"
printf "${BGBBLK}%-${LINE_W}s${R}\n" ""
draw_double
printf "\n"

# ─ INPUT ──────────────────────────────────────────────────────────
read -p "$(printf "${C2} ❯ Select menu : ${R}")" opt
echo ""

case $opt in
    1)  clear; m-sshovpn ;;
    2)  clear; m-vmess ;;
    3)  clear; m-vless ;;
    4)  clear; m-trojan ;;
    5)  clear; m-ssws ;;
    6)  clear; running ;;
    7)  clear; neofetch 2>/dev/null || (echo ""; hostnamectl; echo ""; free -h; echo ""; df -h /) ;;
    8)  clear; speedtest ;;
    9)  clear; m-system ;;
    10) clear; bw ;;
    11) clear; auto-reboot ;;
    12) clear; restart ;;
    13) clear; clearcache ;;
    14) clear
        printf "${BFRED}Yakin ingin reboot VPS? [y/N]: ${R}"
        read -r confirm
        [[ "$confirm" =~ ^[Yy]$ ]] && reboot || menu
        ;;
    x)  printf "${BFGRN}Terima kasih! Sampai jumpa.${R}\n\n"; exit 0 ;;
    *)  printf "${BRED}  Pilihan tidak valid.${R}\n"
        sleep 1; menu ;;
esac
