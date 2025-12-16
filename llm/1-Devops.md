---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Devops - Stack minimale pour un agent
---

Ce cours présente le résultat de nombreuses recherches de produits jusqu'à mi 2025. 
Le produit central choisi pour mettre en oeuvre un agent est `AnythingLLM` qui permet :

* d'interroger une API `chat_competions` avec exécution d'outil
* faire tourner l'outil en local
* assembler la réponse.

Il existe de multiples moyens de mettre en oeuvre ces fonctionnalités, voir entre autre `OpenWebUI` et `LMStudio`.

# Introduction

On veillera à différencier : 

1. **Interfaces de manipulation de LLM** : effectuent des requêtes API sur des services LLM, locaux ou externes
1. **Registre/Source de modèles** :  Ensemble des plateformes et outils permettant de télécharger, ajouter ou intégrer des modèles. Par exemple, Ollama et LM Studio s'appuient sur Hugging Face, tandis qu'AnythingLLM supporte des modèles locaux et cloud via plusieurs fournisseurs.
1. **Orchestration Framework** : Système permettant de gérer à la fois l'origine des modèles (comme Hugging Face ou des registres personnalisés) et leur exécution. Il optimise les performances en déléguant l'inférence à divers fournisseurs de modèles.  



<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
# Interface Utilisateur 

<!---------------------------------------------------------------->
## AnythingLLM

* permet d'exposer l'API d'un agent, valorisant un provider (instance/admin/pref/enable network discovery)
* gestion de clé d'accès API
* plugin navigateur
* peut définir des agents

### System prompt

Il est paramétrable uniquement dans `Settings/Apparence`.

### Agent : Custom Skill

Appelés au moment du prompt `@agent what is the temperature at what is the température in 48.929557/-0.469883 ?`. Voir [custom skills](https://docs.anythingllm.com/agent/custom/introduction). La programmation s'effectue en JS et requiert de connaître très précisément la documentation de l'API appelée.

All skills must return a string type response - anything else may break the agent invocation.

<https://docs.anythingllm.com/agent/custom/introduction>

```bash
cd .config/anythingllm-desktop/storage/plugins/agent-skills
mkdir my-custom-agent-skill
touch plugin.json handler.js

```

### Notes

Not all LLM Models works well as Agents, you may need to use higher quantization models for better responses. Example: Llama 3 8B 8Bit Quantization gives better responses as an Agent

<!---------------------------------------------------------------->



<!------------------------------------------------------------------->
## OpenWeb-Ui

Image docker développée par la communauté, large documentation user, génère un serveur web (ou python pour en faire un endpoint) :

* gestion / historique de prompt, téléchargeable, importable
* connexion à tout modèle par API ou `ollama`
* gestion des évaluations (*arena models*)
* RAG par embedding au choix
* recherche sur le web 

Cela manque de documentation technique ! https://docs.openwebui.com/tutorials/integrations/apache
Mieux mais ne marche pas (nodejs) : https://docs.openwebui.com/getting-started/advanced-topics/development

* [liste des variables utilisables dans les prompts](https://openwebui.com/features/)
* [cost tracker](https://www.reddit.com/r/OpenWebUI/comments/1jk6gae/enhanced_context_cost_tracker_function/)






<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
# Registres
<!---------------------------------------------------------------->
## LM Studio

* [Peut faire du RAG](https://lmstudio.ai/docs/basics/rag)
* [Intégration dans LlamaIndex](https://github.com/run-llama/llama_index/blob/main/llama-index-integrations/llms/llama-index-llms-lmstudio/README.md)
* [en TypeScript](https://lmstudio.ai/docs/sdk)
* [beaucoup de détails, entre autres l'intégration d'OpenAI](https://pyimagesearch.com/2024/06/24/integrating-local-llm-frameworks-a-deep-dive-into-lm-studio-and-anythingllm/)

Démarrer sans sandbox :

        LM-Studio-0.3.17-11-x64.AppImage --no-sandbow


les models sont dans `/home/rioultf/.cache/lm-studio/models`
fichier gguf

on choisit le runtime Llama.cpp (GPU, CPU) ou Vulkan

la fenêtre de chat peut être améliorée par des configurations (settings) incluant un system prompt

le chat montre

* le nombre de token pour chaque instruction
* le rôle est paramétrable (user, assistant)
* génération : token/sec, temps pour obtenir le premier token, raison pour le stop
* en bas de la fenêtre, le taux de remplissage du contexte

peut instancier un serveur, réglable par l'interface.

```bash
lms -h
```

On peut charger plusieurs fois un même modèle, vierge pour tester le système prompt en chat, ou avec son propre système prompt à partir d'une configuration de chat. Permet de mettre au point un système prompt.

supporte les fonctions

dans le menu Models, on peut éditer la configuration de chaque modèle : paramètres, system prompt, chat template

[On peut ajouter des GGUF](https://github.com/lmstudio-ai/lmstudio.js/issues/21)

        lms import "{filepath}/{modelName}.gguf"

[How to convert HuggingFace model to GGUF](https://github.com/ggerganov/llama.cpp/discussions/2948)
  

Dans l'onglet `developper/code snippets` on trouve des requêtes `curL`. En particulier, on peut forcer une réponse en JSON.
Dans l'onglet inférence, system prompt = méta prompt ?

[On peut analyser les log de ce qui est envoyé au model](https://lmstudio.ai/docs/cli/log-stream#debug-your-prompts-with-lms-log-stream)

### CLI

Install lms by running 
        
        npx lmstudio install-cli


### Fonctions

[Appel à des fonctionnalités externes - Tool use](https://lmstudio.ai/docs/advanced/tool-use)

  beta spéciale avec inscription

Cloud based (un-quantized) models are typically dramatically better at following instructions and forming valid JSON matching the required tool-call.


<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
# Orchestration Framework

Dans ce cours, nous n'utilisons pas de système d'orchestration pour la mise en oeuvre du modèle car nous n'avons pas besoin de ce niveau d'exécution.

Pour nos besoins d'inférence, nous privilégions l'appel à des API avec des modèles robustes.

Les éléments ci-dessous sont peu détaillés.

## Ollama

Permet de faire tourner en local une large variété de modèles.
Pour l'installation `curl | sh`, cela a marché directement en GPU, malgré [une erreur](https://github.com/ollama/ollama/issues/7929). Fournit également une web UI.

### Llama.cpp
<!---------------------------------------------------------------->

Fournit une API utilisable en Python et des scripts d'inférence, tokenisation, etc.
Permet de convertir de Hugging Face vers GGUF avec l'API Python.

#### Server

* sert une API OpenAI
* multi-user et parallel decoding
* speculative decoding
* reranking model
* outputs grammar


<!---------------------------------------------------------------->
### CLI

A CLI tool for accessing and experimenting with most of llama.cpp's functionality.
Run simple text completion

