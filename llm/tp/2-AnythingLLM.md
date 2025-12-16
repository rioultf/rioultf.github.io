---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Environnement de développement
---

# Installation

<https://docs.anythingllm.com/installation-desktop/linux#install-using-the-installer-script>


-rwxr-xr-x 1 1600844359 1600800513 2,3G déc.  16 18:22 AnythingLLMDesktop.AppImage
2.3G

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
