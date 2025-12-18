#!/usr/bin/env bash
#
# chat_openrouter.sh — simple interface bash pour OpenRouter API
#
# Usage:
#   export OPENROUTER_API_KEY="ta_cle_openrouter"
#   ./chat_openrouter.sh "Ton message à l'IA"
#
# Optionnel:
#   API_URL : URL de l’API (par défaut https://openrouter.ai/api/v1/chat/completions)
#   MODEL   : modèle à utiliser (ex: openai/gpt-3.5-turbo, anthropic/claude-2, etc.)

set -e

API_URL="${API_URL:-http://localhost:1234/v1/chat/completions}"
MODEL="${MODEL:-smollm2-1.7b-instruct}"

PROMPT="$*"
if [ -z "$PROMPT" ]; then
  echo "Usage : $0 \"Ton message à l'IA\"" >&2
  exit 1
fi

# Construire le JSON de la requête
JSON_PAYLOAD=$(jq -n \
  --arg model "$MODEL" \
  --arg content "$PROMPT" \
  '{
     model: $model,
     messages: [
       { role: "system", content: "You are a helpful assistant." },
       { role: "user",   content: $content }
     ]
   }')

echo $JSON_PAYLOAD

# Appel API
echo curl -s "$API_URL" -H "Content-Type: application/json" -d "$JSON_PAYLOAD"
RESPONSE=$(curl -s "$API_URL" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD")

# Afficher JSON brut si demandé, ou message
if [ "$VERBOSE" = "1" ]; then
  echo "Réponse complète JSON:"
  echo "$RESPONSE" | jq .
else
  # Extraire la réponse texte (first choice)
  echo "$RESPONSE" | jq -r '.choices[0].message.content'
fi
