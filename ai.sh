#!/bin/sh
# Optimized for LEDE 17.01 routers with limited RAM (4/32 MB)
# Eliminates temporary files to save precious RAM

# Set environment variables (only if not already set)
[ -z "$PATH" ] || export PATH="/tmp/usr/bin:/tmp/bin:$PATH"
[ -z "$LD_LIBRARY_PATH" ] || export LD_LIBRARY_PATH="/tmp/usr/lib:/tmp/lib:$LD_LIBRARY_PATH"
[ -z "$SSL_CERT_FILE" ] || export SSL_CERT_FILE="/tmp/etc/ssl/certs/ca-certificates.crt"

# Configuration
GEMINI_API_KEY="KEY_HERE"
MODEL_ID="gemma-3-27b-it"

# Validate input
[ -n "$1" ] || {
    echo "Use: $0 \"prompt\""
    echo "Example: $0 \"Hello, how are you?\""
    exit 1
}

# Make API call without temporary files - pipe JSON directly to curl
printf '{"contents":[{"role":"user","parts":[{"text":"%s"}]}],"generationConfig":{}}' "$*" | \
curl -s -X POST \
  -H "Content-Type: application/json" \
  "https://generativelanguage.googleapis.com/v1beta/models/${MODEL_ID}:streamGenerateContent?key=${GEMINI_API_KEY}" \
  -d @- 2>/dev/null | \
  sed -n 's/.*"text"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | \
  tr -d '\n'

# Print newline for clean output
echo ""