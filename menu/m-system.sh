#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   System & Setting Menu - Full UI Theme Color Support
# ══════════════════════════════════════════════════════════════════

COLOR_CFG="/etc/xray/.menu_color"

load_color() {
    if [ -f "$COLOR_CFG" ]; then
        source "$COLOR_CFG"
    else
        C1='\e[1;36m'; C2='\e[1;33m'; C3='\e[1;35m'
        C4='\e[1;32m'; C5='\e[1;34m'; C6='\e[1;32m'
        THEME_NAME="Default Rainbow"
    fi
}
load_color

R='\e[0m'
BOLD='\e[1m'
BFWHT='\e[1;37m'
BFGRN='\e[1;32m'
BFYLW='\e[1;33m'
BRED='\e[91m'
BGRED='\e[41m'
BGBBLK='\e[100m'
BYLW='\e[93m'
LINE_W=45

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
menu_item_sys() {
    printf "  ${BGBBLK}${C4} %-2s ${R} ${BFWHT}%-30s${R}\n" "$1" "$2"
}

show_system_menu() {
    load_color
    clear
    draw_double
    printf "${BGBBLK}${BOLD}"
    for i in $(seq 1 $LINE_W); do printf " "; done; printf "\r"
    center_pad "⚙  SYSTEM & SETTING MENU  ⚙" "${BGBBLK}${BOLD}${BYLW}"
    for i in $(seq 1 $LINE_W); do printf " "; done; printf "\n${R}"
    draw_double
    echo ""
    printf "${BGBBLK}${C3}  ◈ MANAGEMENT                              ${R}\n"
    draw_line "─"
    echo ""
    menu_item_sys "1"  "Panel Domain"
    menu_item_sys "2"  "Speedtest VPS"
    menu_item_sys "3"  "Set Auto Reboot"
    menu_item_sys "4"  "Restart All Service"
    menu_item_sys "5"  "Cek Bandwidth"
    menu_item_sys "6"  "Install TCP BBR"
    menu_item_sys "7"  "DNS Changer"
    echo ""
    draw_line "─"
    printf "${BGBBLK}${C3}  ◈ APPEARANCE / TEMA UI                    ${R}\n"
    draw_line "─"
    echo ""
    menu_item_sys "8"  "🎨 Ubah Tema Warna UI"
    echo ""
    printf "  ${BGBBLK}${C3}  Tema Aktif${R}: ${C1}■${R}${C2}■${R}${C3}■${R}${C4}■${R}${C5}■${R} ${BFWHT}%s${R}\n" "$THEME_NAME"
    echo ""
    draw_line "─"
    echo ""
    printf "  ${BGRED}${BOLD}${BFWHT} 0 ${R} ${BRED}Kembali ke Menu Utama${R}\n"
    echo ""
    draw_line "━"
    echo ""
    read -p "$(printf "${C2} ❯ Select menu : ${R}")" opt
    echo ""

    case $opt in
        1) clear; m-domain; exit ;;
        2) clear; speedtest; exit ;;
        3) clear; auto-reboot; exit ;;
        4) clear; restart; exit ;;
        5) clear; bw; exit ;;
        6) clear; m-tcp; exit ;;
        7) clear; m-dns; exit ;;
        8) color_picker ;;
        0) clear; menu; exit ;;
        x) exit ;;
        *) printf "${BRED}  Pilihan tidak valid.${R}\n"; sleep 1; show_system_menu ;;
    esac
}

# ── Color Picker — 40 Tema dengan 5 warna berbeda per tema ─────────
# C1=garis═  C2=garis─━  C3=header◈  C4=nomor  C5=label  C6=footer
color_picker() {
    load_color
    clear
    draw_double
    printf "${BGBBLK}${BOLD}"
    for i in $(seq 1 $LINE_W); do printf " "; done; printf "\r"
    center_pad "🎨  PILIH TEMA WARNA UI  🎨" "${BGBBLK}${BOLD}${BYLW}"
    for i in $(seq 1 $LINE_W); do printf " "; done; printf "\n${R}"
    draw_double
    echo ""
    printf "${BGBBLK}${C3}  ◈ PILIHAN TEMA (40 Tema, 5 Warna Tiap Tema) ${R}\n"
    draw_line "─"
    echo ""

    # _row: no  c1 c2 c3 c4 c5  no  c1 c2 c3 c4 c5
    # Emoji preview: 🔴🟣🟡🟢🟤 sesuai warna dominan tiap slot
    _row() {
        local n1="$1" e1="$2" n2="$3" e2="$4"
        printf "  \e[100m\e[1;37m %-2s \e[0m %-22s  \e[100m\e[1;37m %-2s \e[0m %-22s\n" \
            "$n1" "$e1" "$n2" "$e2"
    }

    _row  "1"  "🔴🟣🟡🟢🟤"   "2"  "🟡🔴🟢🟣🔵"
    _row  "3"  "🟢🟡🔴🔵🟣"   "4"  "🟣🟢🔵🔴🟡"
    _row  "5"  "🔵🟤🟣🟡🔴"   "6"  "🟤🔵🔴🟢🟡"
    _row  "7"  "🔴🟢🔵🟡🟣"   "8"  "🟣🔴🟤🟢🔵"
    _row  "9"  "🟡🟣🔴🔵🟢"   "10" "🟢🔵🟡🔴🟣"
    _row  "11" "🔵🟡🟢🟣🔴"   "12" "🔴🟤🟣🟡🟢"
    _row  "13" "🟣🟢🟡🔴🔵"   "14" "🟢🔴🟣🔵🟡"
    _row  "15" "🟡🔵🔴🟢🟣"   "16" "🔵🟣🟡🔴🟢"
    _row  "17" "🟤🟡🔵🟣🔴"   "18" "🔴🟢🟤🔵🟣"
    _row  "19" "🟣🔴🟢🟡🔵"   "20" "🟢🟣🔴🟤🟡"
    _row  "21" "🔴🔵🟣🟢🟡"   "22" "🟡🟤🔴🟣🔵"
    _row  "23" "🟣🟡🟢🔴🔵"   "24" "🔵🔴🟤🟡🟢"
    _row  "25" "🟢🟣🔵🔴🟡"   "26" "🔴🟡🟢🟣🔵"
    _row  "27" "🟡🔴🟣🟢🔵"   "28" "🔵🟢🔴🟡🟣"
    _row  "29" "🟤🟣🟡🔵🔴"   "30" "🟢🔴🟡🟣🔵"
    _row  "31" "🔴🟢🟣🔵🟡"   "32" "🟣🔵🔴🟢🟤"
    _row  "33" "🟡🟢🔵🔴🟣"   "34" "🔵🟤🟣🔴🟢"
    _row  "35" "🟢🔵🟡🟣🔴"   "36" "🔴🟣🟤🟡🟢"
    _row  "37" "🟣🟡🔴🟢🔵"   "38" "🟡🔴🟣🔵🟢"
    _row  "39" "🔵🟢🔴🟣🟡"   "40" "🟤🔴🟢🔵🟣"

    echo ""
    draw_line "─"
    printf "  \e[100m\e[1;37m 0  \e[0m \e[91mBatal / Kembali\e[0m\n"
    echo ""
    draw_line "━"
    echo ""
    printf "  ${BGBBLK}${C3}  Tema Sekarang${R}: ${C1}■${R}${C2}■${R}${C3}■${R}${C4}■${R}${C5}■${R} ${BFWHT}%s${R}\n" "$THEME_NAME"
    echo ""
    read -p "$(printf "${C2} ❯ Pilih nomor tema (1-40) : ${R}")" pick
    echo ""

    # ── Definisi 40 tema: setiap tema punya 5 warna (C1..C5) + C6 + nama ──
    case "$pick" in
    1)  T_C1='\e[1;31m'      T_C2='\e[1;35m'      T_C3='\e[1;33m'
        T_C4='\e[1;32m'      T_C5='\e[1;36m'      T_C6='\e[1;32m'
        T_NAME="Pelangi Merah" ;;
    2)  T_C1='\e[1;33m'      T_C2='\e[1;31m'      T_C3='\e[1;32m'
        T_C4='\e[1;35m'      T_C5='\e[1;34m'      T_C6='\e[1;33m'
        T_NAME="Senja Kuning" ;;
    3)  T_C1='\e[1;32m'      T_C2='\e[1;33m'      T_C3='\e[1;31m'
        T_C4='\e[1;34m'      T_C5='\e[1;35m'      T_C6='\e[1;32m'
        T_NAME="Hutan Tropis" ;;
    4)  T_C1='\e[1;35m'      T_C2='\e[1;32m'      T_C3='\e[1;34m'
        T_C4='\e[1;31m'      T_C5='\e[1;33m'      T_C6='\e[1;35m'
        T_NAME="Aurora Ungu" ;;
    5)  T_C1='\e[1;34m'      T_C2='\e[38;5;208m'  T_C3='\e[1;35m'
        T_C4='\e[1;33m'      T_C5='\e[1;31m'      T_C6='\e[1;34m'
        T_NAME="Laut Biru" ;;
    6)  T_C1='\e[38;5;208m'  T_C2='\e[1;34m'      T_C3='\e[1;31m'
        T_C4='\e[1;32m'      T_C5='\e[1;33m'      T_C6='\e[38;5;208m'
        T_NAME="Api Orange" ;;
    7)  T_C1='\e[1;31m'      T_C2='\e[1;32m'      T_C3='\e[1;34m'
        T_C4='\e[1;33m'      T_C5='\e[1;35m'      T_C6='\e[1;31m'
        T_NAME="Merah Festive" ;;
    8)  T_C1='\e[1;35m'      T_C2='\e[1;31m'      T_C3='\e[38;5;208m'
        T_C4='\e[1;32m'      T_C5='\e[1;34m'      T_C6='\e[1;35m'
        T_NAME="Magenta Glow" ;;
    9)  T_C1='\e[1;33m'      T_C2='\e[1;35m'      T_C3='\e[1;31m'
        T_C4='\e[1;34m'      T_C5='\e[1;32m'      T_C6='\e[1;33m'
        T_NAME="Emas Kuning" ;;
    10) T_C1='\e[1;32m'      T_C2='\e[1;34m'      T_C3='\e[1;33m'
        T_C4='\e[1;31m'      T_C5='\e[1;35m'      T_C6='\e[1;32m'
        T_NAME="Hijau Segar" ;;
    11) T_C1='\e[1;34m'      T_C2='\e[1;33m'      T_C3='\e[1;32m'
        T_C4='\e[1;35m'      T_C5='\e[1;31m'      T_C6='\e[1;34m'
        T_NAME="Biru Elektrik" ;;
    12) T_C1='\e[1;31m'      T_C2='\e[38;5;208m'  T_C3='\e[1;35m'
        T_C4='\e[1;33m'      T_C5='\e[1;32m'      T_C6='\e[1;31m'
        T_NAME="Merah Merona" ;;
    13) T_C1='\e[1;35m'      T_C2='\e[1;32m'      T_C3='\e[1;33m'
        T_C4='\e[1;31m'      T_C5='\e[1;34m'      T_C6='\e[1;35m'
        T_NAME="Violet Dream" ;;
    14) T_C1='\e[1;32m'      T_C2='\e[1;31m'      T_C3='\e[1;35m'
        T_C4='\e[1;34m'      T_C5='\e[1;33m'      T_C6='\e[1;32m'
        T_NAME="Emerald Glow" ;;
    15) T_C1='\e[1;33m'      T_C2='\e[1;34m'      T_C3='\e[1;31m'
        T_C4='\e[1;32m'      T_C5='\e[1;35m'      T_C6='\e[1;33m'
        T_NAME="Kuning Neon" ;;
    16) T_C1='\e[1;34m'      T_C2='\e[1;35m'      T_C3='\e[1;33m'
        T_C4='\e[1;31m'      T_C5='\e[1;32m'      T_C6='\e[1;34m'
        T_NAME="Deep Ocean" ;;
    17) T_C1='\e[38;5;208m'  T_C2='\e[1;33m'      T_C3='\e[1;34m'
        T_C4='\e[1;35m'      T_C5='\e[1;31m'      T_C6='\e[38;5;208m'
        T_NAME="Sunrise Warm" ;;
    18) T_C1='\e[1;31m'      T_C2='\e[1;32m'      T_C3='\e[38;5;208m'
        T_C4='\e[1;34m'      T_C5='\e[1;35m'      T_C6='\e[1;31m'
        T_NAME="Cherry Pop" ;;
    19) T_C1='\e[1;35m'      T_C2='\e[1;31m'      T_C3='\e[1;32m'
        T_C4='\e[1;33m'      T_C5='\e[1;34m'      T_C6='\e[1;35m'
        T_NAME="Galaxy Purple" ;;
    20) T_C1='\e[1;32m'      T_C2='\e[1;35m'      T_C3='\e[1;31m'
        T_C4='\e[38;5;208m'  T_C5='\e[1;33m'      T_C6='\e[1;32m'
        T_NAME="Tropical Mix" ;;
    21) T_C1='\e[1;31m'      T_C2='\e[1;34m'      T_C3='\e[1;35m'
        T_C4='\e[1;32m'      T_C5='\e[1;33m'      T_C6='\e[1;31m'
        T_NAME="Volcano Red" ;;
    22) T_C1='\e[1;33m'      T_C2='\e[38;5;208m'  T_C3='\e[1;31m'
        T_C4='\e[1;35m'      T_C5='\e[1;34m'      T_C6='\e[1;33m'
        T_NAME="Desert Gold" ;;
    23) T_C1='\e[1;35m'      T_C2='\e[1;33m'      T_C3='\e[1;32m'
        T_C4='\e[1;31m'      T_C5='\e[1;34m'      T_C6='\e[1;35m'
        T_NAME="Orchid Bloom" ;;
    24) T_C1='\e[1;34m'      T_C2='\e[1;31m'      T_C3='\e[38;5;208m'
        T_C4='\e[1;33m'      T_C5='\e[1;32m'      T_C6='\e[1;34m'
        T_NAME="Sky Tangerine" ;;
    25) T_C1='\e[1;32m'      T_C2='\e[1;35m'      T_C3='\e[1;34m'
        T_C4='\e[1;31m'      T_C5='\e[1;33m'      T_C6='\e[1;32m'
        T_NAME="Jade Neon" ;;
    26) T_C1='\e[1;31m'      T_C2='\e[1;33m'      T_C3='\e[1;32m'
        T_C4='\e[1;35m'      T_C5='\e[1;34m'      T_C6='\e[1;31m'
        T_NAME="Flamingo Fire" ;;
    27) T_C1='\e[1;33m'      T_C2='\e[1;31m'      T_C3='\e[1;35m'
        T_C4='\e[1;32m'      T_C5='\e[1;34m'      T_C6='\e[1;33m'
        T_NAME="Citrus Burst" ;;
    28) T_C1='\e[1;34m'      T_C2='\e[1;32m'      T_C3='\e[1;31m'
        T_C4='\e[1;33m'      T_C5='\e[1;35m'      T_C6='\e[1;34m'
        T_NAME="Cobalt Dream" ;;
    29) T_C1='\e[38;5;208m'  T_C2='\e[1;35m'      T_C3='\e[1;33m'
        T_C4='\e[1;34m'      T_C5='\e[1;31m'      T_C6='\e[38;5;208m'
        T_NAME="Amber Glow" ;;
    30) T_C1='\e[1;32m'      T_C2='\e[1;31m'      T_C3='\e[1;33m'
        T_C4='\e[1;35m'      T_C5='\e[1;34m'      T_C6='\e[1;32m'
        T_NAME="Rainforest" ;;
    31) T_C1='\e[1;31m'      T_C2='\e[1;32m'      T_C3='\e[1;35m'
        T_C4='\e[1;34m'      T_C5='\e[1;33m'      T_C6='\e[1;31m'
        T_NAME="Ruby Vivid" ;;
    32) T_C1='\e[1;35m'      T_C2='\e[1;34m'      T_C3='\e[1;31m'
        T_C4='\e[1;32m'      T_C5='\e[38;5;208m'  T_C6='\e[1;35m'
        T_NAME="Royal Night" ;;
    33) T_C1='\e[1;33m'      T_C2='\e[1;32m'      T_C3='\e[1;34m'
        T_C4='\e[1;31m'      T_C5='\e[1;35m'      T_C6='\e[1;33m'
        T_NAME="Minty Fresh" ;;
    34) T_C1='\e[1;34m'      T_C2='\e[38;5;208m'  T_C3='\e[1;35m'
        T_C4='\e[1;31m'      T_C5='\e[1;32m'      T_C6='\e[1;34m'
        T_NAME="Ocean Spice" ;;
    35) T_C1='\e[1;32m'      T_C2='\e[1;34m'      T_C3='\e[1;33m'
        T_C4='\e[1;35m'      T_C5='\e[1;31m'      T_C6='\e[1;32m'
        T_NAME="Forest Violet" ;;
    36) T_C1='\e[1;31m'      T_C2='\e[1;35m'      T_C3='\e[38;5;208m'
        T_C4='\e[1;33m'      T_C5='\e[1;32m'      T_C6='\e[1;31m'
        T_NAME="Crimson Sky" ;;
    37) T_C1='\e[1;35m'      T_C2='\e[1;33m'      T_C3='\e[1;31m'
        T_C4='\e[1;32m'      T_C5='\e[1;34m'      T_C6='\e[1;35m'
        T_NAME="Lavender Sun" ;;
    38) T_C1='\e[1;33m'      T_C2='\e[1;31m'      T_C3='\e[1;35m'
        T_C4='\e[1;34m'      T_C5='\e[1;32m'      T_C6='\e[1;33m'
        T_NAME="Golden Hour" ;;
    39) T_C1='\e[1;34m'      T_C2='\e[1;32m'      T_C3='\e[1;33m'
        T_C4='\e[1;35m'      T_C5='\e[1;31m'      T_C6='\e[1;34m'
        T_NAME="Twilight Blue" ;;
    40) T_C1='\e[38;5;208m'  T_C2='\e[1;31m'      T_C3='\e[1;32m'
        T_C4='\e[1;34m'      T_C5='\e[1;35m'      T_C6='\e[38;5;208m'
        T_NAME="Full Spectrum" ;;
    0)  show_system_menu; return ;;
    *)  printf "${BRED}  Pilihan tidak valid. Masukkan angka 1-40.${R}\n"
        sleep 1; color_picker; return ;;
    esac

    mkdir -p /etc/xray
    cat > "$COLOR_CFG" << COLOREOF
C1='${T_C1}'
C2='${T_C2}'
C3='${T_C3}'
C4='${T_C4}'
C5='${T_C5}'
C6='${T_C6}'
THEME_NAME="${T_NAME}"
COLOREOF

    printf "\n"
    printf "  ${T_C1}■${R}${T_C2}■${R}${T_C3}■${R}${T_C4}■${R}${T_C5}■${R} ${BFWHT}Tema${R} ${BFGRN}\"${T_NAME}\"${R} ${BFGRN}berhasil diterapkan!${R}\n"
    printf "  ${BFGRN}Seluruh UI menu akan menggunakan 5 warna tema ini.${R}\n"
    sleep 2
    show_system_menu
}

show_system_menu
