#!/data/data/com.termux/files/usr/bin/bash
clear
# ======================================================
# 🚀 RAIN HACKER - Multi-Repo Auto Push + WA Notify (Custom Msg & Numbers)
# ======================================================

# ---------- CONFIG (ubah sesuai kebutuhan) ----------
REPO_DIRS=(
  "$HOME/projek-termux"
  # "$HOME/another-repo"
)
REPO_LINKS=(
  "https://github.com/rainhacker57-wq/Projek-termux"
  # "https://github.com/you/another-repo"
)

# default WA if user tekan Enter
DEFAULT_WA="6283856067615"
DEFAULT_HEAD="✅ Push Report dari RAIN HACKER"
# ----------------------------------------------------

# warna & reset
U="\e[1;35m"; B="\e[1;36m"; Y="\e[1;33m"; G="\e[1;32m"; R="\e[1;31m"; X="\e[0m"

# ----------------- Banner RAIN HACKER -----------------
echo -e "${U}"
cat <<'BANNER'
██████╗  █████╗ ██╗███╗   ██╗     ██╗  ██╗ █████╗ ██████╗ ███████╗
██╔══██╗██╔══██╗██║████╗  ██║     ██║  ██║██╔══██╗██╔══██╗██╔════╝
██████╔╝███████║██║██╔██╗ ██║     ███████║███████║██████╔╝█████╗
██╔═══╝ ██╔══██║██║██║╚██╗██║     ██╔══██║██╔══██║██╔══██╗██╔══╝
██║     ██║  ██║██║██║ ╚████║     ██║  ██║██║  ██║██║  ██║███████╗
╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
BANNER
echo -e "${B}================================================${X}"
echo -e "[👑] Creator : ${Y}Rainhacker57${X}"
echo -e "[💾] Github  : ${B}github.com/rainhacker57-wq${X}"
echo -e "${B}================================================${X}"
echo

# -------------- Input nomor target & nomor WA --------------
read -p $'\e[1;33m[?]\e[0m Masukkan nomor target (contoh: 089xxxx): ' nomor
if [[ -z "$nomor" ]]; then
  echo -e "${R}[x] Nomor target kosong. Keluar.${X}"
  exit 1
fi
echo -e "${G}[✓]${X} Nomor target: ${Y}$nomor${X}"
sleep 1

read -p $'\e[1;33m[?]\e[0m Masukkan nomor WA tujuan (pisah koma jika lebih dari 1) [Enter pakai default '"$DEFAULT_WA"']: ' wa_input
if [[ -z "$wa_input" ]]; then
  wa_input="$DEFAULT_WA"
fi
# normalisasi: hapus spasi lalu split koma
wa_input=$(echo "$wa_input" | tr -d ' ')
IFS=',' read -r -a WA_NUMS <<< "$wa_input"
echo -e "${G}[✓]${X} WA tujuan: ${Y}${WA_NUMS[*]}${X}"
sleep 1

# --------------- Input pesan custom atau pakai ringkasan ---------------
echo -e "${B}[?]${X} Ketik pesan yang ingin dikirim ke WA (Enter = pakai ringkasan otomatis):"
read -r custom_msg

# ---------------- urlencode helper (python3 fallback sed) ----------------
urlencode() {
  local s="$1"
  if command -v python3 >/dev/null 2>&1; then
    printf "%s" "$s" | python3 -c "import sys, urllib.parse as u; print(u.quote(sys.stdin.read()))"
  else
    # fallback sederhana
    printf "%s" "$s" | sed -e 's/%/%25/g' -e 's/ /%20/g' -e ':a' -e 'N' -e '$!ba' -e 's/\n/%0A/g' -e 's/&/%26/g' -e 's/+/ %2B/g' -e 's/:/%3A/g' -e 's/,/%2C/g' -e 's/?/%3F/g' -e 's/#/%23/g' -e 's/=/%3D/g' -e 's/\//%2F/g'
  fi
}

# ----------------- Process multi-repo push -----------------
report=""
i=0
for dir in "${REPO_DIRS[@]}"; do
  link="${REPO_LINKS[i]}"
  ((i++))
  if [[ -z "$dir" ]]; then continue; fi

  echo -e "${B}[🔁]${X} Memproses repo: ${Y}$dir${X}"
  if [[ ! -d "$dir" ]]; then
    echo -e "${R}[x]${X} Folder tidak ditemukan: $dir"
    report+="$dir : FAILED (folder not found)\n"
    continue
  fi

  # push (log ke file per-repo)
  LOG="/tmp/gitpush_$(basename "$dir").log"
  rm -f "$LOG"
  cd "$dir" || { report+="$dir : FAILED (cd error)\n"; continue; }

  git add . >/dev/null 2>&1
  git commit -m "🔥 Auto update: $(date '+%Y-%m-%d %H:%M:%S') (🎯 Target: $nomor)" >/dev/null 2>&1 || true
  git push > "$LOG" 2>&1 &
  pid=$!
  wait $pid
  status=$?

  if [[ $status -eq 0 ]]; then
    echo -e "${G}[✓]${X} Push sukses: ${Y}${link}${X}"
    report+="$dir : OK - $link\n"
  else
    echo -e "${R}[x]${X} Push gagal untuk $dir (lihat log $LOG)"
    report+="$dir : FAILED - see log: $LOG\n"
    report+="--- git log for $dir ---\n"
    report+="$(sed -n '1,200p' "$LOG")\n"
    report+="-------------------------\n"
  fi
done

# ----------------- Prepare message -----------------
if [[ -n "$custom_msg" ]]; then
  pesan="$custom_msg"
else
  pesan="$DEFAULT_HEAD
📅 $(date '+%Y-%m-%d %H:%M:%S')
🎯 Target: $nomor

Hasil:
$report

Repo utama:
${REPO_LINKS[0]}"
fi

# urlencode
encoded=$(urlencode "$pesan")

# ----------------- Open WhatsApp chats (one by one) -----------------
echo
echo -e "${B}[📩]${X} Membuka chat WhatsApp untuk mengirim notifikasi..."
for num in "${WA_NUMS[@]}"; do
  # ensure only digits
  targetnum=$(echo "$num" | sed 's/[^0-9]//g')
  if [[ -z "$targetnum" ]]; then
    echo -e "${R}[!]${X} Nomor invalid: $num (skip)"
    continue
  fi
  url="https://wa.me/${targetnum}?text=${encoded}"
  echo -e "${B}-->${X} Membuka: ${Y}$url${X}"
  termux-open-url "$url"
  sleep 1
done

echo
echo -e "${G}[✔️]${X} Selesai. Semua repo telah diproses dan WA chat dibuka."
echo -e "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${X}"
