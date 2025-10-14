#!/bin/bash

# Pastikan script berhenti saat ada error
set -e

# Optional: pasang paket kalau belum ada (komentar kalau sudah terpasang)
# pkg install figlet lolcat -y

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

# Tanyakan apakah ingin melanjutkan push
read -p "[?] Lanjut commit & push perubahan ke GitHub? (y/n): " jawab
if [[ "$jawab" != "y" && "$jawab" != "Y" ]]; then
  echo "Dibatalkan. Tidak ada perubahan yang dikirim." | lolcat
  exit 0
fi

# Tambahkan semua perubahan
git add .

# Jika tidak ada perubahan yang staged, keluar dengan pesan
if git diff --cached --quiet; then
  echo "Tidak ada perubahan untuk di-commit." | lolcat
  exit 0
fi

# Commit dengan pesan timestamp + nomor target (opsional)
commit_msg="update otomatis: $(date '+%Y-%m-%d %H:%M:%S') (target: $nomor)"
git commit -m "$commit_msg"

# Push ke branch main (ubah kalau pakai branch lain)
git push -u origin main

echo "[✔] Push selesai!" | lolcat
