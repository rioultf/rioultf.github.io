---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Environnement de développement
---

On construit un environnement de développement minimal :

* requêtes HTTP sur une API compatible
* formalisation par `bash`

# Pré-recquis

* un terminal Linux 
* `jq` est un utilitaire qui permet de manipuler de la donnée JSON
* un compte alimenté en tokens, par exemple chez OpenRouter. Le résultat, la clé d'API, doit être stocké dans un fichier texte `.env` d'accès restreint\ :

```bash
$ cat .env
export OPENROUTER_API_KEY=sk-or-v1-6a8...8a7
```

Ce fichier ne doit pas être poussé dans le dépôt :

```bash
$ echo ".env" >> .gitignore
```

Dans un terminal, pour prendre en compte la clé, il faut :

* soit copier la ligne ci-dessous directement dans le terminal

* soit lire le fichier avec `source`, qui agit comme si le contenu du fichier avait été copié dans le terminal :

```bash
$ source .env
```

* soit exécuter les scripts et les commandes en les préfixant par la définition des variables :

```bash
$ OPENROUTER_API_KEY=sk-or-v1-6a8...a7 VERBOSE=1 ./chatCompletions.sh hi
```

# Script d'interrogation d'API

Le script ci-dessous :

* définit l'URL de l'API et le nom du modèle
* teste si la clé est disponible
* récupère le prompt fourni en argument
* construit un fragment JSON qui constitue les paramètres de la requête (la charge)
* effectue la requête HTTP
* affiche la réponse en utilisant `jq`

```bash
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

API_URL="${API_URL:-https://openrouter.ai/api/v1/chat/completions}"
MODEL="${MODEL:-openai/gpt-3.5-turbo}"

if [ -z "$OPENROUTER_API_KEY" ]; then
  echo "Erreur : la variable d'environnement OPENROUTER_API_KEY n'est pas définie." >&2
  exit 1
fi

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

# Appel API
RESPONSE=$(curl -s "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -d "$JSON_PAYLOAD")

# Afficher JSON brut si demandé, ou message
if [ "$VERBOSE" = "1" ]; then
  echo "Réponse complète JSON:"
  echo "$RESPONSE" | jq .
else
  # Extraire la réponse texte (first choice)
  echo "$RESPONSE" | jq -r '.choices[0].message.content'
fi
```

Répondez aux questions suivantes :

1. copier le script dans un fichier texte nommé `chatCompletions.sh`
2. autorisez son exécution :

        chmod +x chatCompletions.sh

3. exécutez une requête :

        OPENROUTER_API_KEY=sk-or-v1-6a8...a7 VERBOSE=1 ./chatCompletions.sh hi

4. expliquez le fonctionnement du script :

  1. comment sont gérés les paramètres par défaut ?
  3. Quelle commande permet d’exécuter le script avec une clé API et en mode verbeux (verbose) ?
  5. Comment le script vérifie-t-il que la clé d’API est bien définie avant d’envoyer la requête ?
  6. Que se passe-t-il si l’on n’a pas passé de prompt (c’est-à-dire aucun argument) au script ?
  7. Quelle requête HTTP (méthode + endpoint) le script utilise-t-il pour interroger l’API ?
  8. Quel format de données (type de payload) est envoyé dans la requête ?
  9. Comment le script extrait-il la réponse utile (le contenu textuel de l’IA) dans le JSON renvoyé ?
  10. Quelles sont les données principales (métadonnées + contenu + usage) renvoyées par l’API, que l’on peut observer dans la réponse JSON ?
  11. Pourquoi ces données renvoyées peuvent-elles être utiles (dans un contexte de développement / facturation / audit) ?

