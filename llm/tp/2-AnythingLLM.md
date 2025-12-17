---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Environnement de développement
---

[AnythingLLM](https://docs.anythingllm.com/) :

* permet d'exposer l'API d'un agent, valorisant un provider (instance/admin/pref/enable network discovery)
* gestion de clé d'accès API
* plugin navigateur
* peut définir agents en appelant des serveurs MCP.

On ne l'utilisera pas pour interroger de façon critique un modèle personnalisé, l'interface n'est pas faite pour cela. Pour cet usage, on préférera `LMStudio` ou `OpenWebUi`.

# Installation

<https://docs.anythingllm.com/installation-desktop/linux#install-using-the-installer-script>

2.3G

## Log installation

```
#########################################################
 Welcome to the AnythingLLM Desktop Installer
 by Mintplex Labs Inc (team@mintplexlabs.com)
 Architecture: x86_64
#########################################################
Downloading latest AnythingLLM Desktop (https://cdn.anythingllm.com/latest/AnythingLLMDesktop.AppImage)
################################################################################################# 100.0%
AnythingLLM Desktop is ready to run!
./home/rioultf/AnythingLLMDesktop.AppImage to start AnythingLLMDesktop
Heads up! You can rerun this installer anytime to get the latest version of AnythingLLM without effecting your existing data.
Documentation: https://docs.anythingllm.com
Issues: https://github.com/Mintplex-Labs/anything-llm
Thanks for using AnythingLLM!


Next, we will create a desktop profile and AppArmor profile for AnythingLLMDesktop.
This is required for the AppImage to be able to run without SUID requirements.
You can manually create these profiles if you prefer.
Desktop profile not found. Creating...
Desktop profile created!
AppArmor is enabled on this system.
[Warning] You will get an error about SUID permission issues when running the AppImage without creating an AppArmor profile.
This requires sudo privileges. If you are unsure, you can create an AppArmor profile manually.
Do you want to auto-create an AppArmor profile for AnythingLLM now? (y/n): y
Checking for sudo privileges...
[sudo] Mot de passe de rioultf : 
Creating AppArmor profile for AnythingLLM...
Reloading AppArmor service...
AppArmor profile created - you can now run AnythingLLMDesktop without SUID requirements.
Do you want to start AnythingLLMDesktop now? (y/n): y
[Preferences] preference config stored at /home/rioultf/.config/anythingllm-desktop/config.json
[PrismaHelper: Linux] Setting Prisma Client output directory to production build. {
  clientOutputPath: '/home/rioultf/.config/anythingllm-desktop/storage/.prisma/client'
}
[PrismaHelper] Pulling query_engine for debian-openssl-3.0.x from remote. {
  remote: 'https://binaries.prisma.sh/all_commits/61e140623197a131c2a6189271ffee05a7aa9a59/debian-openssl-3.0.x/libquery_engine.so.node.gz'
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 6745k  100 6745k    0     0  4277k      0  0:00:01  0:00:01 --:--:-- 4277k
[PrismaHelper] Downloaded query engine for debian-openssl-3.0.x!
[PrismaHelper] Pulling schema-engine for debian-openssl-3.0.x from remote. {
  remote: 'https://binaries.prisma.sh/all_commits/61e140623197a131c2a6189271ffee05a7aa9a59/debian-openssl-3.0.x/schema-engine.gz'
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 7662k  100 7662k    0     0  5709k      0  0:00:01  0:00:01 --:--:-- 5710k
[PrismaHelper] Downloaded schema engine for debian-openssl-3.0.x!
[27371:1216/184641.156860:ERROR:gl_surface_presentation_helper.cc(260)] GetVSyncParametersIfAvailable() failed for 1 times!
Prisma schema loaded from prisma/schema.prisma
Datasource "db": SQLite database "anythingllm.db" at "file:/home/rioultf/.config/anythingllm-desktop/storage/anythingllm.db"

Applying migration `20250506214129_init`
Applying migration `20250709230835_init`
Applying migration `20250725194841_init`
Applying migration `20250808171557_init`

The following migration(s) have been applied:

migrations/
  └─ 20250506214129_init/
    └─ migration.sql
  └─ 20250709230835_init/
    └─ migration.sql
  └─ 20250725194841_init/
    └─ migration.sql
  └─ 20250808171557_init/
    └─ migration.sql

Your database is now in sync with your schema.

✔ Generated Prisma Client (v5.3.1) to ./../../../../home/rioultf/.config/anythingllm-desktop/storage/.pr
isma/client in 418ms


Prisma schema loaded from prisma/schema.prisma

✔ Generated Prisma Client (v5.3.1) to ./../../../../home/rioultf/.config/anythingllm-desktop/storage/.prisma/client in 304ms

Start using Prisma Client in Node.js (See: https://pris.ly/d/client)
```
import { PrismaClient } from '../../../../home/rioultf/.config/anythingllm-desktop/storage/.prisma/client'
const prisma = new PrismaClient()
```
or start using Prisma Client at the edge (See: https://pris.ly/d/accelerate)
```
import { PrismaClient } from '../../../../home/rioultf/.config/anythingllm-desktop/storage/.prisma/client/edge'
const prisma = new PrismaClient()
```

See other ways of importing Prisma Client: http://pris.ly/d/importing-client

[OllamaProcessManager] Ollama will bind on port 11434 when booted.
[ManualBrowser] Listening for IPC messages from main renderer process!
[Preferences] Will load window with last know bounds.
[27371:1216/184644.411322:ERROR:gl_surface_presentation_helper.cc(260)] GetVSyncParametersIfAvailable() failed for 2 times!
[27371:1216/184644.412588:ERROR:gl_surface_presentation_helper.cc(260)] GetVSyncParametersIfAvailable() failed for 3 times!

```





# Paramétrage

## Fournisseur d'IA

* Generic OpenAI : permet d'interroger toute API `chat_completions` dont on connaît l'URL. Utile pour inférer sur un modèle local, servi par le *registre* adéquat.
* OpenRouter : copier la clé d'API

Les autre paramètres concernent la fourniture d'autres IA : base de données documentaires, embedding, chunking, voix, modèle de transcription de parole.

## Admin

* activer `Enable network discovery` pour que l'API mise en place par `AnythingLLM` soit visible sur le réseau

* définition du *system prompt*, langage de template

## Compétences de l'agent

* Agent Skills : RAG, résumé, scrape, generate, search, SQL connector
* Custom Skills : 
* Agent Flows
* MCP Servers

## Outils

* générer des clés d'API. C'est ici qu'on peut tester l'API avec une interface `swagger`
* variables du système prompt

# Espace de travail

C'est assez pauvre et peu paramétrable.


### Notes

Not all LLM Models works well as Agents, you may need to use higher quantization models for better responses. Example: Llama 3 8B 8Bit Quantization gives better responses as an Agent

