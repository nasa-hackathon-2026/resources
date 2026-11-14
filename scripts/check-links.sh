#!/usr/bin/env bash
# 檢查 README.md 與 docs/resources/*.md 裡的 http(s) 連結是否可連上。
# 用法：scripts/check-links.sh            # 全部
#       scripts/check-links.sh <檔案...>  # 指定檔案
#
# 不檢查的：``` 程式區塊與 `行內程式碼` 裡的 URL（多半是 API 範例，需要 token 或參數）、
#           含 {} 或 <> 佔位符的 URL。
# 列為 WARN、不算失敗的：
#   - 401/403/429：網站擋機器請求或需要登入（Medium、Microsoft、需 token 的 API）。
#   - curl 結束碼 35/60：TLS 握手或憑證鏈問題。spaceappschallenge.org 的憑證鏈指向
#     已被移除的 Comodo root，curl 驗證失敗但瀏覽器能開；CSA 網站會重設 TLS 連線。
# 有任何 FAIL 就以非零狀態結束。
set -uo pipefail

cd "$(dirname "$0")/.."
files=("$@")
if [ ${#files[@]} -eq 0 ]; then
  files=(README.md docs/resources/*.md)
fi

urls=$(
  for f in "${files[@]}"; do
    awk '/^```/{c=!c; next} !c' "$f" | sed -E 's/`[^`]*`//g'
  done | grep -oE "https?://[A-Za-z0-9._~:/?#@!$&'*+,;=%()-]+" \
       | sed -E 's/[.,;:)]+$//' | grep -vE '[{}<>]' | sort -u
)

fail=0
warn=0
total=0
for u in $urls; do
  total=$((total+1))
  code=$(curl -s -o /dev/null -L --max-time 20 -A "Mozilla/5.0 (link-check)" -w '%{http_code}' "$u")
  rc=$?
  if [ "$rc" -eq 35 ] || [ "$rc" -eq 60 ]; then
    echo "WARN tls(curl $rc) $u"; warn=$((warn+1)); continue
  fi
  case "$code" in
    2??|3??) ;;
    401|403|429) echo "WARN $code $u"; warn=$((warn+1)) ;;
    *) echo "FAIL $code(curl $rc) $u"; fail=$((fail+1)) ;;
  esac
done
echo "檢查 $total 個連結：失敗 $fail，警告 $warn"
[ "$fail" -eq 0 ]
