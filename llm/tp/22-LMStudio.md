---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Mise en place d'un registre _ LMStudio
---

# Installation

* télécharger l'app sur le site

        cd software/
        mv ~/Téléchargements/LM-Studio-0.3.35-1-x64.ppImage .
        chmod +x LM-Studio-0.3.35-1-x64.AppImage 

        ./LM-Studio-0.3.35-1-x64.AppImage --no-sandbox






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
