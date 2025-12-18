## LM Studio

LMStudio est un *registre* : il sert de l'inférence à partir de modèle locaux.

* télécharge un modèle GGUF
* chaque modèle peut être paramétré :

  * load

    * taille du contexte
    * GPU / CPU
    * seed

  * prompt
    
    * *jinja* template
    * system prompt

  * inférence 

    * température 
    * sortie structurée (JSON)
    * top K
    * min P
    * top P

* permet d'instancier un *serveur* pour l'inférence (Developer -> Server Settings)

  * serveur local : `LMStudio` propose une API `chat_completions` et peut être utilisé par AnythingLLM
  * accepte les requêtes MCP 
  * positionne CORS (pour pouvoir assembler la requête dans un navigateur)

* la section `Developer` permet d'interagir avec les modèles (élucider si le paramétrage surcharge celui du modèle):

  * liste des end-points supportés 

  * onglets
    
    *information (quantisation, architecture, taille)
    * system prompt 
    * inférence 

        * température 
        * sortie structurée (JSON)
        * top K
        * min P
        * top P

  * paramétrer le système de log


# Installation

* créer un dossier `~/software` destiné à stocker les logiciels utilisés dans ce TP
* y télécharger l'[AppImage](https://lmstudio.ai/download/latest/linux/x64)

        chmod +x LM-Studio-0.3.35-1-x64.AppImage 
        ./LM-Studio-0.3.35-1-x64.AppImage
        LM-Studio-0.3.17-11-x64.AppImage --no-sandbox

* on installe un premier modèle (onglet vertical)

  * rechercher https://model.lmstudio.ai/download/lmstudio-community/SmolLM2-1.7B-Instruct-GGUF

  
Les modèles sont stockés au format GGUF dans `ˇ/.lmstudio/models`.

# Exercices

1. effectuer des requêtes sur `smollm2-1.7b-instruct:2`

                hi

1. analyser les statistiques (survol de l'ampoule) :
```
"stats": {
    "stopReason": "eosFound",
    "tokensPerSecond": 2.039456782601547,
    "numGpuLayers": -1,
    "timeToFirstTokenSec": 15.076,
    "totalTimeSec": 4.903,
    "promptTokensCount": 31,
    "predictedTokensCount": 10,
    "totalTokensCount": 41
  }
```

1. découvrir les modes d'interaction avec le chatbot

  * regénérer la réponse
  * continuer la discussion
  * brancher

1. dans `Developper`, découvrir la requête `cURL` à exécuter : 

```bash
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "smollm2-1.7b-instruct",
    "messages": [
        {
            "role": "system",
            "content": "Always answer in rhymes. Today is Thursday"
        },
        {
            "role": "user",
            "content": "What day is it today?"
        }
    ],
    "temperature": 0.7,
    "max_tokens": -1,
    "stream": false
}'
```

```json
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "smollm2-1.7b-instruct",
    "messages": [
        {
            "role": "system",
            "content": "Always answer in rhymes. Today is Thursday"
        },
        {
            "role": "user",
            "content": "What day is it today?"
        }
    ],
    "temperature": 0.7,
    "max_tokens": -1,
    "stream": false
}'
```

* [script d'interrogation de LMStudio](script/chatCompletions-LMS.sh), basé sur [le script d'interrogation d'OpenRouter](script/chatCompletions.sh)

