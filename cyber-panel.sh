#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# CYBER SECURITY + CYBER GUARDIAN PANEL
# ============================================
# Safe / educational. Jangan pakai untuk menyerang sistem orang lain.

# Konfigurasi
GIT_REMOTE="https://github.com/rainhacker57-wq/Projek-termux.git"
LOG_DIR="$HOME/cyber_panel_logs"

# Hentikan script kalau ada error
set -e

# Buat direktori log
mkdir -p "$LOG_DIR"

clear
# Tampilkan header jika figlet & lolcat tersedia
if command -v figlet >/dev/null 2>&1 && command -v lolcat >/dev/null 2>&1; then
  figlet "CYBER PANEL" | lolcat
else
  echo "==== CYBER PANEL ===="
fi

echo "======================================"
echo "[+] Creator : Rainhacker57"
echo "[+] Github  : github.com/rainhacker57-wq"
echo "======================================"

# Input data dummy (simulasi)
read -p "[?] Masukkan nomor simulasi (contoh: 089xxxx): " nomor
echo "[OK] Nomor tersimpan: $nomor"
echo "[*] Memulai simulasi panel keamanan..."
sleep 1
echo "[✔] Sistem siap, Rainhacker mode aktif!"
echo

# Tanyakan apakah ingin melanjutkan push
read -p "[?] Lanjut commit & push perubahan ke GitHub? (y/n): " jawab
if [[ "$jawab" != "y" && "$jawab" != "Y" ]]; then
  echo "Dibatalkan. Tidak ada perubahan yang dikirim."
  exit 0
fi

# Pastikan direktori ini adalah repo git; jika belum, inisialisasi dan set remote
if [ ! -d .git ]; then
  echo "[i] Git belum diinisialisasi di folder ini. Menginisialisasi..."
  git init
  # Jika GIT_REMOTE kosong, jangan tambahkan
  if [[ -n "$GIT_REMOTE" ]]; then
    # Jika origin belum ada, tambahkan. Kalau sudah ada, ubah URL.
    if git remote | grep -q '^origin$'; then
      git remote set-url origin "$GIT_REMOTE"
    else
      git remote add origin "$GIT_REMOTE"
    fi
    git branch -M main || true
  fi
fi

# Tambahkan semua perubahan
git add .

# Jika tidak ada perubahan yang staged, keluar dengan pesan
if git diff --cached --quiet; then
  echo "Tidak ada perubahan untuk di-commit."
  exit 0
fi

# Commit dengan pesan timestamp + nomor target (opsional)
commit_msg="update otomatis: $(date '+%Y-%m-%d %H:%M:%S') (target: $nomor)"
git commit -m "$commit_msg"

# Push ke branch main (ubah kalau pakai branch lain)
# Jika remote menggunakan HTTPS, Git akan minta username + token/password
git push -u origin main

echo "[✔] Push selesai!"
