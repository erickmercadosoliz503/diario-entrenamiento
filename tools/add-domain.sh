#!/usr/bin/env bash
# Añade un dominio autorizado a Firebase Authentication. Para Google Cloud Shell.
#   bash diario-entrenamiento/tools/add-domain.sh erickmercadosoliz503.github.io
set -euo pipefail
DOMAIN="$1"; PROJECT="${2:-diario-entrenamiento}"
TOKEN="$(gcloud auth print-access-token)"
URL="https://identitytoolkit.googleapis.com/admin/v2/projects/$PROJECT/config"
H=(-H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -H "X-Goog-User-Project: $PROJECT")
CUR="$(curl -sS "${H[@]}" "$URL")"
BODY="$(echo "$CUR" | python3 -c 'import json,sys;d=json.load(sys.stdin).get("authorizedDomains",[]);n=sys.argv[1];d=d if n in d else d+[n];print(json.dumps({"authorizedDomains":d}))' "$DOMAIN")"
curl -sS -X PATCH "${H[@]}" "$URL?updateMask=authorizedDomains" -d "$BODY" | python3 -c 'import json,sys;print("DOMINIOS_OK", json.load(sys.stdin).get("authorizedDomains"))'
