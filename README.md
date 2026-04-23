# 🚀 SCRIPT AUTO INSTALL SSH & XRAY MULTIPORT

**Base Script by:** eddyme23  
**Modified by:** Fahri Alimudin

---

## 📢 PERHATIAN
Mohon baca sampai selesai sebelum melakukan instalasi!

---

## 💻 OS SUPPORT & SPESIFIKASI

<p align="center">
  <img src="https://assets.ubuntu.com/v1/29985a98-ubuntu-logo32.png" alt="Ubuntu Logo" width="180"/>
  <br/>
  <img src="https://img.shields.io/badge/Ubuntu-22.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white"/>
  <img src="https://img.shields.io/badge/Ubuntu-24.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white"/>
</p>

⚡ **CPU:** Minimal 1 Core  
🧠 **RAM:** Minimal 1GB  
🌐 **Domain:** Wajib Pointing ke IP VPS  

### SETTING DOMAIN DI CLOUDFLARE
- SSL/TLS : **FULL**
- SSL/TLS Recommender : **OFF**
- GRPC : **ON**
- WEBSOCKET : **ON**
- Always Use HTTPS : **OFF**
- UNDER ATTACK MODE : **OFF**

---

## 📊 DAFTAR SERVICE & PORT LENGKAP

| Nama Service                   | Port / Keterangan                                |
|-------------------------------|--------------------------------------------------|
| 🔑 OpenSSH                    | **22**, **9696**                                 |
| 🛡️ Dropbear                  | **109**, **143**                                 |
| 🔒 Stunnel4 → SSH             | **222** → port 22                                |
| 🔒 Stunnel4 → Dropbear        | **777** → port 109                               |
| 🔒 Stunnel4 → WS-SSL          | **2096** → port 700 (ws-stunnel internal)        |
| 🌐 SSH WS HTTP                | **80** via Nginx → ws-dropbear:2095              |
| 🔐 SSH WS HTTPS               | **443** via Nginx → ws-stunnel:700               |
| 🚀 Xray Vmess WS              | **80** (HTTP) / **443** (TLS) path:/vmess        |
| 🚀 Xray Vless WS              | **80** (HTTP) / **443** (TLS) path:/vless        |
| 🚀 Xray Trojan WS             | **80** (HTTP) / **443** (TLS) path:/trojan-ws    |
| 🚀 Xray Shadowsocks WS        | **80** (HTTP) / **443** (TLS) path:/ss-ws        |
| 🧬 Xray Vmess gRPC            | **443** svc:/vmess-grpc                          |
| 🧬 Xray Vless gRPC            | **443** svc:/vless-grpc                          |
| 🧬 Xray Trojan gRPC           | **443** svc:/trojan-grpc                         |
| 🧬 Xray Shadowsocks gRPC      | **443** svc:/ss-grpc                             |
| ⚙️ Nginx Web                  | **81**                                           |
| 🎮 Badvpn UDPGW               | **7100, 7200, 7300, 7400** (127.0.0.1)           |

---

## 🛠️ CARA INSTALLASI (BASH SCRIPT)

Login ke VPS Anda sebagai **root** (`sudo su`), lalu salin dan jalankan kode berikut:

```bash
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/saliminwaskinahzzxxcc/new/main/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
```

> ✅ Kode di atas bisa langsung di-copy dengan mengklik ikon salin di pojok kanan blok kode.

---

## ✨ FITUR UTAMA

- 💨 Speedtest VPS by Ookla  
- 🔄 Auto Reboot & Restart All Service  
- 🧹 Auto Delete Expired User  
- 📊 Monitoring Bandwidth & Service  
- 🚀 BBRPLUS v1.4.0 (Optimasi Speed)  
- 🌐 DNS Changer  

---

## 📞 KONTAK & BANTUAN

Jika ada pertanyaan atau butuh bantuan, hubungi saya di:

- 🟢 **WhatsApp:** [https://wa.me/6282328013583](https://wa.me/6282328013583)
- 🔵 **Telegram:** [@fahrialimudin](https://t.me/fahrialimudin)

---

## 🙏 PENUTUP & KREDIT

Terima kasih banyak kepada **eddyme23** atas script dasarnya yang luar biasa sehingga saya bisa melakukan modifikasi ini.

Gunakan script ini dengan bijak. Dilarang keras untuk diperjualbelikan karena script ini didapatkan secara gratis.

> © 2026 Fahri Alimudin - MyXray Project
