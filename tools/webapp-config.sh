#!/usr/bin/env bash
# Crea (si no existe) la app web de Firebase y muestra su configuración. Para Google Cloud Shell.
set -euo pipefail
PROJECT="${1:-diario-entrenamiento}"
TOKEN="$(gcloud auth print-access-token)"
API="https://firebase.googleapis.com/v1beta1/projects/$PROJECT"
H=(-H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -H "X-Goog-User-Project: $PROJECT")
appid() { curl -sS "${H[@]}" "$API/webApps" | python3 -c 'import json,sys;a=json.load(sys.stdin).get("apps",[]);print(a[0]["appId"] if a else "")'; }
ID="$(appid)"
if [ -z "$ID" ]; then
  curl -sS -X POST "${H[@]}" "$API/webApps" -d '{"displayName":"Diario de entrenamiento"}' >/dev/null
  for i in $(seq 1 20); do sleep 3; ID="$(appid)"; [ -n "$ID" ] && break; done
fi
echo "APPID=$ID"
curl -sS "${H[@]}" "$API/webApps/$ID/config" | python3 -c 'import json,sys;print("CONFIG_JSON="+json.dumps(json.load(sys.stdin),separators=(",",":")))'
