#!/bin/bash
# Points shapesong.com and www at the Hetzner server instead of GitHub Pages. Leaves MX, SPF, TXT, app, staging, ftp alone.
set -euo pipefail
cd "$(dirname "$0")"
source ~/.shapesong-deploy.env
IP=$SHAPESONG_SERVER_IP
Z=/domain/zone/shapesong.com
out=~/code/ajw400/play-assets/dns-backup/shapesong.com-$(date +%Y-%m-%d-%H%M)-before-hetzner.zone
./ovh.sh GET $Z/export | python3 -c 'import json,sys; print(json.load(sys.stdin))' > "$out"
grep -q 'improvmx' "$out" || { echo "backup looks wrong, stopping"; exit 1; }
del() { for id in $(./ovh.sh GET "$Z/record?fieldType=$1&subDomain=$2" | tr -d '[]' | tr ',' ' '); do ./ovh.sh DELETE "$Z/record/$id" >/dev/null; echo "deleted $1 '$2' $id"; done; }
del A ""; del AAAA ""; del CNAME www; del A www
./ovh.sh POST $Z/record "{\"fieldType\":\"A\",\"subDomain\":\"\",\"target\":\"$IP\",\"ttl\":300}"; echo
./ovh.sh POST $Z/record "{\"fieldType\":\"A\",\"subDomain\":\"www\",\"target\":\"$IP\",\"ttl\":300}"; echo
./ovh.sh POST $Z/refresh; echo "refreshed"
