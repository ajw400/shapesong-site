#!/bin/bash
# Signed calls to the OVH API for the shapesong.com zone. Usage: ovh.sh METHOD /path [json-body]
set -euo pipefail
source ~/.shapesong-ovh.env
m=$1; url="https://eu.api.ovh.com/1.0$2"; body=${3:-}
ts=$(curl -s https://eu.api.ovh.com/1.0/auth/time)
sig='$1$'$(printf '%s' "$OVH_AS+$OVH_CK+$m+$url+$body+$ts" | shasum -a 1 | cut -d' ' -f1)
args=(-s -X "$m" -H "Content-Type: application/json" -H "X-Ovh-Application: $OVH_AK" -H "X-Ovh-Consumer: $OVH_CK" -H "X-Ovh-Timestamp: $ts" -H "X-Ovh-Signature: $sig")
[ -n "$body" ] && args+=(--data "$body")
curl "${args[@]}" "$url"
