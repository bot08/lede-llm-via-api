#!/bin/sh

export PATH="/tmp/usr/bin:/tmp/bin:$PATH"
export LD_LIBRARY_PATH="/tmp/usr/lib:/tmp/lib:$LD_LIBRARY_PATH"
export SSL_CERT_FILE="/tmp/etc/ssl/certs/ca-certificates.crt"

GEMINI_API_KEY="KEY_HERE"
MODEL_ID="gemma-3-27b-it"

if [ -z "$1" ]; then
    echo "Use: $0 \"prompt\""
    echo "Example: $0 \"Hello, how are you?\""
    exit 1
fi

PROMPT="$*"

cat > /tmp/request.json << ENDJSON
{
  "contents": [{
    "role": "user",
    "parts": [{"text": "$PROMPT"}]
  }],
  "generationConfig": {}
}
ENDJSON

curl -s -X POST \
  -H "Content-Type: application/json" \
  "https://generativelanguage.googleapis.com/v1beta/models/${MODEL_ID}:streamGenerateContent?key=${GEMINI_API_KEY}" \
  -d @/tmp/request.json | \
  grep -o '"text"[[:space:]]*:[[:space:]]*"[^"]*"' | \
  sed 's/"text"[[:space:]]*:[[:space:]]*"\(.*\)"/\1/' | \
  tr -d '\n'

echo ""

rm /tmp/request.json