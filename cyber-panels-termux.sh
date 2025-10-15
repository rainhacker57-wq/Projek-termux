cat > ~/projek-termux/cyber-panel.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# CYBER SECURITY + CYBER GUARDIAN PANEL
# ============================================

# URL repository GitHub
GIT_REMOTE="https://github.com/rainhacker57-wq/Projek-termux.git"
LOG_DIR="$HOME/cyber_panel_logs"

# Hentikan script kalau ada error
set -e

# Instal paket jika belum ada
pkg install figlet lolcat -y

clear
figlet "CYBER PANEL" | lolcat
echo "======================================" | lolcat
echo "[+] Creator : Rainhacker57" | lolcat
echo "[+] Github  : github.com/rainhacker57-wq" | lolcat
echo "======================================" | lolcat

read -p "[?] Masukkan nomor target (contoh: 089xxxx): " nomor
echo "[OK] Nomor tersimpan: $nomor" | lolcat
echo "[*] Memulai simulasi panel keamanan..." | lolcat
sleep 1
echo "[✔] Sistem siap, Rainhacker mode aktif!" | lolcat
echo

# Tanya apakah ingin lanjut commit & push
read -p "[?] Lanjut commit & push perubahan ke GitHub? (y/n): " jawab
if [[ "$jawab" != "y" && "$jawab" != "Y" ]]; then
  echo "Dibatalkan. Tidak ada perubahan yang dikirim." | lolcat
  exit 0
fi

# Tambahkan semua perubahan
git add .

# Cek apakah ada perubahan
if git diff --cached --quiet; then
  echo "Tidak ada perubahan untuk di-commit." | lolcat
  exit 0
fi

# Commit dengan timestamp + nomor target
commit_msg="update otomatis: $(date '+%Y-%m-%d %H:%M:%S') (target: $nomor)"
git commit -m "$commit_msg"

# Push ke GitHub
git push -u origin main

echo "[✔] Push selesai!" | lolcat
EOF
