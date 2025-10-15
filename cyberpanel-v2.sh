#!/data/data/com.termux/files/usr/bin/bash
clear

# ===========================================
#  CYBER PANEL v2.0 - Rainhacker57 (Auto Push)
# ===========================================
echo -e "\e[1;35m"
echo "   ██████╗██╗   ██╗██████╗ ███████╗██████╗ "
echo "  ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗"
echo "  ██║     ██║   ██║██║  ██║█████╗  ██████╔╝"
echo "  ██║     ██║   ██║██║  ██║██╔══╝  ██╔══██╗"
echo "  ╚██████╗╚██████╔╝██████╔╝███████╗██║  ██║"
echo "   ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝"
echo -e "\e[1;36m==============================================="
echo -e "[+] Creator : Rainhacker57"
echo -e "[+] Github  : github.com/rainhacker57-wq"
echo -e "===============================================\e[0m"

# ===========================================
# Input nomor target
# ===========================================
read -p $'\e[1;33m[?]\e[0m Masukkan nomor target (contoh: 089xxxx): ' nomor
echo -e "\e[1;32m[OK]\e[0m Nomor tersimpan: $nomor"
sleep 1

echo -e "\e[1;34m[*]\e[0m Menyiapkan sistem..."
sleep 1

# ===========================================
# Auto Commit & Push ke GitHub
# ===========================================
echo -e "\e[1;36m[>]\e[0m Melakukan auto commit & push ke GitHub..."
cd ~/projek-termux
git add .
git commit -m "Auto update: $(date '+%Y-%m-%d %H:%M:%S') (Target: $nomor)" >/dev/null 2>&1
git push >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "\e[1;32m[✓]\e[0m Push berhasil ke GitHub!"
else
    echo -e "\e[1;31m[x]\e[0m Gagal push. Periksa koneksi atau izin repo."
fi

echo
echo -e "\e[1;36mPanel v2.0 otomatis selesai dijalankan.\e[0m"
