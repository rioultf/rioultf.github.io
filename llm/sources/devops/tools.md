---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Outils - appel de fonction
---

<https://blog.christoolivier.com/p/llms-and-functiontool-calling>

<img src="https://cloud.google.com/static/vertex-ai/generative-ai/docs/multimodal/images/function-calling.png?hl=fr">

Le choix de l'action et des paramètres est effectué par le modèle à partir du prompt.

Testé sur `smollm2:1.7b` avec `ollama` :

```python
import ollama

response = ollama.chat(
    model='smollm2:1.7b',
    messages=[{'role': 'user', 'content':
        'What is the weather in Toronto?'}],

		# provide a weather checking tool to the model
    tools=[{
      'type': 'function',
      'function': {
        'name': 'get_current_weather',
        'description': 'Get the current weather for a city',
        'parameters': {
          'type': 'object',
          'properties': {
            'city': {
              'type': 'string',
              'description': 'The name of the city',
            },
          },
          'required': ['city'],
        },
      },
    },
  ],
)

print(response['message']['tool_calls'])
```

```
[ToolCall(function=Function(name='get_current_weather', arguments={'city': 'Toronto'}))]
```

`ollama` fait tourner un serveur compatible avec l'API d'OpenAI :

```bash
MODEL='smollm2:1.7b'
tools=tools.json
messages='[{"role": "user", "content": "What is the temperature at the location 51.5074/-0.1278?"}]'

cmd="curl http://localhost:11434/v1/chat/completions \
  -H \"Content-Type: application/json\" \
  -d '{\"model\": \"$MODEL\", \"messages\": $messages, \"tools\": $(jq . $tools)}'"

echo $cmd >&2

eval $cmd
```

Liste d'outils :

```json
[
    {
        "type": "function",
        "function": {
            "name": "get_current_weather",
            "description": "Get the current weather, in particular the temperature, at a given location",
            "parameters": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "The city and state, e.g. San Francisco, CA"
                    }
                },
                "required": [
                    "location"
                ]
            }
        }
    },
    ...
]
```

Résultat :

```json
{
  "id": "chatcmpl-484",
  "object": "chat.completion",
  "created": 1736531003,
  "model": "smollm2:1.7b",
  "system_fingerprint": "fp_ollama",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "",
        "tool_calls": [
          {
            "id": "call_ktfdd662",
            "index": 0,
            "type": "function",
            "function": {
              "name": "get_current_weather",
              "arguments": "{\"location\":\"51.5074,-0.1278\"}"
            }
          }
        ]
      },
      "finish_reason": "tool_calls"
    }
  ],
  "usage": {
    "prompt_tokens": 441,
    "completion_tokens": 46,
    "total_tokens": 487
  }
}
```

Le repository est à `/usr/share/ollama/.ollama/models`.

*Ne fonctionne pas avec LMStudio* (ils parlent de béta sur inscription).

<https://cookbook.openai.com/examples/how_to_call_functions_with_chat_models>

# Model context protocol

Pour interfacer un LLM avec un serveur externe faisant office de source de connaissance, on utilise le principe des outils : le LLM est interrogé avec le prompt utilisateur accompagné des outils et indique si un appel d'outil est nécessaire. On lui soumet à nouveau le prompt avec les données retournées par l'outil.

La conception d'un serveur externe doit être simple, le principe est d'interfacer à moindre frais un service local existant (API, base de données, calculateur). De plus, le serveur doit être capable de fournir la liste des outils qu'il propose (`Processing request of type ListToolsRequest`).

MCP est une spécification de serveurs généralistes permettant d'interfacer une API avec les modèles d'Anthropic. C'est en train de devenir un standard *de fait*, qui concurrence [OpenAPI](https://swagger.io/specification/).

Anthropic fournit un environnement de développement complet de serveurs MCP, avec des SDK dans tous les langages. Les moyens de communication sont frustres : 

Deux protocoles de transport :

* STDIO : par entrée/sortie standard, pour encapsuler des scripts de ligne de commande.
* SSE : Server-Sent Events est une technologie de push pour envoyer des notifications à un client via HTTP.

Le développement d'un serveur consiste en l'écriture de code, par ex. Python + annotations. La librairie fournit un inspecteur du serveur :

    # active le service
    uvx mcp run server.py 
    # active et inspecte
    uvx mcp dev server.py 

```bash
# installation uv
curl -LsSf https://astral.sh/uv/install.sh | sh
uv init mcp-server-demo
cd mcp-server-demo/
uv add "mcp[cli]"
uvx run mcp  # échec
source .venv/bin/activate
uvx run mcp  # échec
mcp dev server.py 
Need to install the following packages:
@modelcontextprotocol/inspector@0.9.0
Ok to proceed? (y) y

Starting MCP inspector...
⚙️ Proxy server listening on port 6277
🔍 MCP Inspector is up and running at http://127.0.0.1:6274 🚀

```


`open-webui` ne propose pas l'intégration de MCP. À la place, il propose `mcpo`, un wrapper de MCP qui fournit une interface OpenAPI à un excécutables de serveur MCP. `mcpo` peut lancer plusieurs MCP :

    uvx mcpo --config /path/to/config.json

Ci-dessous une pile testée avec `open-webui` :

* le serveur de temps issu du [catalogue](https://github.com/modelcontextprotocol/servers)
* un gestionnaire de graphe
* des tests du [quickStart](https://github.com/modelcontextprotocol/python-sdk?tab=readme-ov-file#quickstart)

```json
{
    "mcpServers": {
        "time": {
            "command": "uvx",
            "args": [
                "mcp-server-time",
                "--local-timezone=America/New_York"
            ]
        },
        "memory": {
            "command": "npx",
            "args": [
                "-y",
                "@modelcontextprotocol/server-memory"
            ]
        },
        "mcp": {
            "command": "mcp",
            "args": [
                "run",
                "mcp-server-demo.py"
            ]
        }
    }
}
```

Chaque outil aura sa propre route :

    http://localhost:8000/memory
    http://localhost:8000/time
    http://localhost:8000/mcp





## Mise au point d'un serveur MCP avec `open-webui`

1. développer le MCP et tester la correction du code avec :

    mcp dev mcp-server-demo.py

1. exposer à l'aide de `mcpo`


## Développement d'outil

On utilise le [SDK Python]().

Il faut que l'outil retourne un dictionnaire si on veut que le LLM interprète le résultat.

```python
@mcp.tool()
def level(sensor: int) -> str:
    """Returns the level at given sensor"""
    if sensor == 1:
        return {"level":10.0}
    return {"level":25.0}
```

### Concepts

#### Resources

Pour fournir des données requérant peu de calcul : éléments de configuration, findOne, etc.

### Tools

Effectuent un calcul ou des effets de bord.

# Questions

* en quelle langue rédiger les outils et leurs commentaires ?
* expérimenter sur la manipulation de la réponse.



# Références

The MCP protocol defines three core primitives that servers can implement:

| Primitive | Control               | Description                                         | Example Use                  |
|-----------|-----------------------|-----------------------------------------------------|------------------------------|
| Prompts   | User-controlled       | Interactive templates invoked by user choice        | Slash commands, menu options |
| Resources | Application-controlled| Contextual data managed by the client application   | File contents, API responses |
| Tools     | Model-controlled      | Functions exposed to the LLM to take actions        | API calls, data updates      |

Prompts are reusable templates that help LLMs interact with your server effectively.

Utilise 
Asynchronous Server Gateway Interface
L'interface de passerelle de serveur asynchrone est une convention d'appel permettant aux serveurs Web de transférer des requêtes vers des frameworks et des applications Python asynchrones. Il est conçu pour succéder à l'interface Web Server Gateway.

uvicorn. An ASGI web server, for Python





swagger pour la documentation

open-webui recommande mcpo, qui affiche une doc d'api

uvx mcpo --port 8000 -- uvx mcp-server-time --local-timezone=America/New_York

Normalement on lance le serveur MCP par :

    uvx -v mcp-server-time --local-timezone=America/New_York

`open-webui` propose `mcpo`, un *wrapper* de serveur MCP. Il s'agit d'une conversion MCP (STDIO) vers OpenAPI. Cela génère aussi une documentation `swagger` :

    uvx mcpo --port 8000 -- uvx mcp-server-time --local-timezone=America/New_York

Pour installer l'outil dans `open-webui`, saisir l'URL <http://host.docker.internal:8000>.



https://github.com/open-webui/openapi-servers/discussions/5

https://www.youtube.com/watch?v=rI7yLB7CSYY





### Server Capabilities

MCP servers declare capabilities during initialization:

| Capability  | Feature Flag                 | Description                        |
|-------------|------------------------------|------------------------------------|
| `prompts`   | `listChanged`                | Prompt template management         |
| `resources` | `subscribe`<br/>`listChanged`| Resource exposure and updates      |
| `tools`     | `listChanged`                | Tool discovery and execution       |
| `logging`   | -                            | Server logging configuration       |
| `completion`| -                            | Argument completion suggestions    |


* un modèle qui fonctionne bien sur les appels d'outil : https://ollama.com/library/mistral-small3.1:24b-instruct-2503-fp16
* pour le monitoring des services, on peut utiliser [uptime-kuma](https://github.com/louislam/uptime-kuma)
* <https://github.com/TheR1D/shell_gpt>