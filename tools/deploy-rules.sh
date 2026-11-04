#!/usr/bin/env bash
# Publica firestore.rules en el proyecto de Firebase usando la API de Firebase Rules.
# Pensado para ejecutarse en Google Cloud Shell (ya autenticado):
#   git clone https://github.com/erickmercadosoliz503/diario-entrenamiento && bash diario-entrenamiento/tools/deploy-rules.sh
set -euo pipefail
PROJECT="${1:-diario-entrenamiento-59424}"
DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOKEN="$(gcloud auth print-access-token)"
API="https://firebaserules.googleapis.com/v1/projects/$PROJECT"
BODY="$(python3 -c 'import json,sys;print(json.dumps({"source":{"files":[{"name":"firestore.rules","content":open(sys.argv[1]).read()}]}}))' "$DIR/firestore.rules")"
RS="$(curl -sS -X POST "$API/rulesets" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -H "X-Goog-User-Project: $PROJECT" -d "$BODY")"
NAME="$(echo "$RS" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("name") or "")')"
if [ -z "$NAME" ]; then echo "ERROR creando ruleset: $RS"; exit 1; fi
REL="$(curl -sS -X PATCH "$API/releases/cloud.firestore" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -H "X-Goog-User-Project: $PROJECT" \
  -d "{\"release\":{\"name\":\"projects/$PROJECT/releases/cloud.firestore\",\"rulesetName\":\"$NAME\"}}")"
echo "$REL" | grep -q rulesetName && echo "REGLAS_PUBLICADAS_OK $NAME" || { echo "ERROR publicando: $REL"; exit 1; }
