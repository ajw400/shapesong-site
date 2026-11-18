#!/bin/bash
# Overnight: wait for GitHub's certificate until a deadline; if none, switch DNS to the Hetzner fallback.
cd "$(dirname "$0")"
source ~/.shapesong-deploy.env
deadline=$(( $(date +%s) + ${1:-4500} ))
while [ "$(date +%s)" -lt "$deadline" ]; do
  st=$(gh api repos/ajw400/shapesong-site/pages --jq '.https_certificate.state // "none"' 2>/dev/null)
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 15 --resolve shapesong.com:443:185.199.108.153 https://shapesong.com/)
  echo "$(date +%H:%M) github cert: $st, https: $code"
  if [ "$code" = 200 ]; then
    gh api -X PUT repos/ajw400/shapesong-site/pages -F https_enforced=true && echo "RESULT github-ok"; exit 0
  fi
  sleep 900
done
if [ ! -f ~/.shapesong-ovh.env ]; then echo "RESULT no-ovh-keys"; exit 2; fi
echo "$(date +%H:%M) switching DNS to Hetzner"
./switch-dns-to-hetzner.sh || { echo "RESULT switch-failed"; exit 3; }
for i in $(seq 1 20); do
  sleep 120
  a=$(dig +short shapesong.com A @dns103.ovh.net | tr '\n' ' ')
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 --resolve shapesong.com:443:$SHAPESONG_SERVER_IP https://shapesong.com/privacy/)
  echo "$(date +%H:%M) ovh A: $a https via hetzner: $code"
  [ "$code" = 200 ] && { echo "RESULT hetzner-ok"; exit 0; }
done
echo "RESULT hetzner-no-cert"; exit 4
