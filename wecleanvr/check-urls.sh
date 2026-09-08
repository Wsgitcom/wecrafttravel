#!/usr/bin/env bash
# ตรวจว่า URL เดิมของ wecleanvr.com ยังใช้งานได้ครบหลังแก้ไขเว็บ
# รันก่อนแก้ 1 ครั้ง และหลังแก้ทุกครั้ง แล้วเทียบผลกัน
#
#   bash wecleanvr/check-urls.sh              # ตรวจทั้งหมด แสดงเฉพาะที่มีปัญหา
#   bash wecleanvr/check-urls.sh --all        # แสดงทุก URL พร้อมสถานะ
#
# เกณฑ์: 200 = ปกติ, 301/302 = ถูก redirect (ยอมรับได้ ไม่เสีย SEO)
#        404/410 = พัง ต้องแก้ทันที, 5xx = เซิร์ฟเวอร์มีปัญหา

set -uo pipefail
LIST="$(dirname "$0")/seo-url-baseline.txt"
SHOW_ALL="${1:-}"
ok=0; redir=0; broken=0

while IFS= read -r url; do
  [[ -z "$url" || "$url" == \#* ]] && continue
  code=$(curl -sS -o /dev/null -w "%{http_code}" --max-time 20 "$url" 2>/dev/null)
  dest=""
  case "$code" in
    200) ok=$((ok+1)); [[ "$SHOW_ALL" == "--all" ]] && printf "  200  %s\n" "$url" ;;
    301|302|307|308)
      redir=$((redir+1))
      dest=$(curl -sS -o /dev/null -w "%{redirect_url}" --max-time 20 "$url" 2>/dev/null)
      printf "  %s  %s\n         -> %s\n" "$code" "$url" "$dest" ;;
    *) broken=$((broken+1)); printf "  ** %s  %s\n" "$code" "$url" ;;
  esac
done < "$LIST"

echo
echo "ปกติ (200): $ok   ถูก redirect: $redir   พัง: $broken"
[[ "$broken" -gt 0 ]] && { echo "!! มี URL ที่พัง ต้องทำ 301 redirect ไปหน้าที่ใกล้เคียงที่สุด"; exit 1; }
echo "ครบทุก URL ไม่มีลิงก์พัง"
