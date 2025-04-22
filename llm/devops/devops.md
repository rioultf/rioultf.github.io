---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Mise en production
---

On veillera à différencier : 

1. **Orchestration Framework** : Système permettant de gérer à la fois l'origine des modèles (comme Hugging Face ou des registres personnalisés) et leur exécution. Il optimise les performances en déléguant l'inférence à divers fournisseurs de modèles.  

2. **Registre/Source de modèles** :  Ensemble des plateformes et outils permettant de télécharger, ajouter ou intégrer des modèles. Par exemple, Ollama et LM Studio s'appuient sur Hugging Face, tandis qu'AnythingLLM supporte des modèles locaux et cloud via plusieurs fournisseurs.

3. **Interfaces de manipulation de LLM** : effectuent des requêtes API sur des services LLM, locaux ou externes

<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
# Orchestration Framework

<!---------------------------------------------------------------->
## Llama.cpp

Fournit une API utilisable en Python et des scripts d'inférence, tokenisation, etc.

Permet de convertir de Hugging Face vers GGUF avec l'API Python.

<!---------------------------------------------------------------->
### Server

* sert une API OpenAI
* multi-user et parallel decoding
* speculative decoding
* reranking model
* outputs grammar

### llama-perplexity

Métriques de qualité
divergence KL

### llama-bench

<!---------------------------------------------------------------->
### CLI

A CLI tool for accessing and experimenting with most of llama.cpp's functionality.
Run simple text completion

llama-cli -m model.gguf -p "I believe the meaning of life is" -n 128

 I believe the meaning of life is to find your own truth and to live in accordance with it. For me, this means being true to myself and following my passions, even if they don't align with societal expectations. I think that's what I love about yoga – it's not just a physical practice, but a spiritual one too. It's about connecting with yourself, listening to your inner voice, and honoring your own unique journey.

Run in conversation mode

llama-cli -m model.gguf -p "You are a helpful assistant" -cnv

 > hi, who are you?
 Hi there! I'm your helpful assistant! I'm an AI-powered chatbot designed to assist and provide information to users like you. I'm here to help answer your questions, provide guidance, and offer support on a wide range of topics. I'm a friendly and knowledgeable AI, and I'm always happy to help with anything you need. What's on your mind, and how can I assist you today?
 > what is 1+1?
 Easy peasy! The answer to 1+1 is... 2!

Run with custom chat template

 use the "chatml" template
 use a custom template
llama-cli -m model.gguf -p "You are a helpful assistant" -cnv --in-prefix 'User: ' --reverse-prompt 'User:'

Supported templates
Constrain the output with a custom grammar

llama-cli -m model.gguf -n 256 --grammar-file grammars/json.gbnf -p 'Request: schedule a call at 8pm; Command:'

 {"appointmentTime": "8pm", "appointmentDetails": "schedule a a call"}

### Génération selon une grammaire

Par exemple, générer du JSON.

GBNF (GGML BNF) is a format for defining formal grammars to constrain model outputs in llama.cpp

<!---------------------------------------------------------------->
## Ollama

Permet de faire tourner en local une large variété de modèles.
Pour l'installation `curl | sh`, cela a marché directement en GPU, malgré [une erreur](https://github.com/ollama/ollama/issues/7929). Fournit également une web UI.


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
# Interface Utilisateur 

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

[liste des variables utilisables dans les prompts](https://openwebui.com/features/)

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




<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
# Application intégrant un LLM

* [Mélange markdown et JSX](https://github.com/puzzlet-ai/agentmark)
Alternative to n8n?
* streamlit
* gradio

## Architecture

<img src="https://raw.githubusercontent.com/Arize-ai/phoenix-assets/main/images/blog/llm_app_architecture.png">

<img src="https://www.timescale.com/_next/image?url=https%3A%2F%2Ftimescale.ghost.io%2Fblog%2Fcontent%2Fimages%2F2024%2F12%2FThe-Emerging-Open-Source-AI-Stack_stack.png&w=1080&q=75"/>

Resource Request
I’m looking to completely replace my n8n workflows by chaining multiple ai agents, is there any production ready tools or framework that are capable?

Some interesting ones are Flowise, Wordware, Autogen and Crewai but i’m not sure. Can they communicate and do task by connecting my backend and server side business logic etc?

* [fait tourner des promts en arriere plan](https://www.agenticworkers.com/)
* [workflow de connexion](https://n8n.io/)


<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
### Reranking model

[alternative au RAG](https://github.com/ggerganov/llama.cpp)

## Notes

[overview of deploying Hugging Face models sur huggingface](https://medium.com/technology-nineleaps/how-to-deploy-your-own-llm-large-language-models-22687257d781
https://hatchworks.com/blog/gen-ai/how-to-deploy-llm/

[pour gérer son llm](https://github.com/meta-llama/llama-stack)

# Prestataires

* https://render.com/ deploiement d'appli
* https://www.heroku.com/home


## Fournisseurs de leurs propres modèles

* alibaba : QwQ, Qwen
* anthropic : Claude
* azure : GPT
* google : Gemini
* groq : Gemma
* mistral
* openai
* xai : Grok

[Source](https://glama.ai/model-prices/json)

Après, on trouve des hubs/ back end, qui font tourner des modèles open-source :

* replicate
* perplexity : llma
* vertex_ai : Claude
* glama : What is Glama? Glama gives you access to every leading AI model through a single account, with powerful features like document analysis and team collaboration. It eliminates the hassle of managing multiple AI subscriptions while keeping your data secure. 1$ de crédit...

### Replicate

Replicate is a platform that enables developers to deploy, fine tune, and access open source AI models via a CLI, API, or SDK. The platform makes it easy to programmatically integrate AI capabilities into software applications.

* [streamlit et replicate](https://blog.streamlit.io/how-to-create-an-ai-chatbot-llm-api-replicate-streamlit/)
* [demo streamlit](https://medium.com/nerd-for-tech/how-to-create-an-ai-app-to-generate-crontabs-using-openai-and-streamlit-23aacbf20a9c)

### Divers

* [ai en CLI aNd Editor](https://github.com/cline/cline)
* [The AI Horde is a service that generates text using crowdsourced GPUs run by independent volunteer workers](https://lite.koboldai.net/#)


<!-------------------------------------------------------------->
<!-------------------------------------------------------------->
<!-------------------------------------------------------------->



### Pinokio

* dans un navigateur maison
* fait tourner sur un noyau isolé
* connecté au filesystem local
* des scripts AI décrits dans un JSON

automation scripting language with features like memory, dynamic templating, and extensible low level APIs.

installe 

* conda
* python
* sqlite
* perl, git -> conda-forge 
* nodejs
* ffmpeg
* un kernel ! + gcc
* cuda et les outils de monitoring nsight
* playwright

-> 12 GB

Un script est précédé de la déclaration d'un environnement.
Une commande peut être lancée en mode *daemon*, utile pour un serveur par exemple.

Les applis lancées tournent dans un venv

On peut appeler des scripts .js en ligne, qui contiennent la description des actions. Voir [ici](https://github.com/cocktailpeanutlabs/moondream2/blob/main/install.js)

#### Fonctionnalités

* fs.download
* script.start (call d'un script)
* script.return

#### UI

* shortcut : affiché sur la page d'accueil
* app : le layout

Il y a un `open-webui` qui installe torch et cuda pour python 3.11





## LLM Compiler

https://github.com/SqueezeAILab/LLMCompiler
LLMCompiler is a framework that enables an efficient and effective *orchestration* of parallel function calling with LLMs, including both open-source and close-source models, by automatically identifying which tasks can be performed in parallel and which ones are interdependent.

### OpenAI

[Un GPT est disponible pour concevoir les actions](https://chatgpt.com/g/g-TYEliDU6A-actionsgpt) et aider à la rédaction des schémas. Sur [cet exemple](https://platform.openai.com/docs/actions/getting-started), on demande au GPT d'aller lire la documentation de l'API d'un service et de produire la spécification `yaml` de l'action. Les informations de description sont interprétées pour décider, à partir du prompt, quelle action appeler et avec quels paramètres.

Une action est définie par le schémas.

Il vaut mieux éviter de multiplier les actions, une vingtaine au max.

Le modèle intervient à de nombreux niveaux :

* conception du schéma à partir d'une documentation externe
* choix de l'action et des paramètres à partir du prompt
* exécution de la requête sur le service externe, correctement formatée
* formatage de la réponse

Un schéma définit plusieurs actions, que l'on peut tester. Le modèle génère alors un prompt, effectue la requête http, et fournit la réponse, le tout avec des traces qui montrent l'implication du modèle dans la reformulation.

#### GPT Actions

Que l'on trouve dans les GPT-plus

[exemple de la météo](https://platform.openai.com/docs/actions/getting-started)

#### Chat completion API

Les appels de fonction consistent à associer à un prompt la spécification de la fonction qui va nourrir la réponse. On définit pour cela un répertoire de fonction. L'exécution est à la charge du client.

Functions are the only type of tools supported in the Chat Completions API, but the Assistants API also supports built-in tools.

#### Assistant API

The Assistants API allows you to build AI assistants within your own applications. An Assistant has instructions and can leverage models, tools, and files to respond to user queries. The Assistants API currently supports three types of *tools*: Code Interpreter, File Search, and Function calling.

## Streamlit

*[voir aussi](https://github.com/Chainlit/chainlit)

* [Streamlit avec llmstudio, utilise une quantisation 2bit d'un modèle mistral](https://medium.com/@ingridwickstevens/streaming-local-llm-responses-with-lm-studio-inference-server-cce3f78b2522)

```python
    prompt = ChatPromptTemplate.from_template(template)

    # Using LM Studio Local Inference Server
    llm = ChatOpenAI(base_url="http://localhost:1234/v1")

    chain = prompt | llm | StrOutputParser()
    
    return chain.stream({
        "chat_history": chat_history,
        "user_question": user_query,
    })
```

* [avec OpenAI et LLaMaIndex](https://blog.streamlit.io/build-a-chatbot-with-custom-data-sources-powered-by-llamaindex/)

Streamlit is an open-source Python framework to build highly interactive apps – in only a few lines of code. Streamlit integrates with all the latest tools in generative AI, such as any LLM, vector database, or various AI frameworks like LangChain, LlamaIndex, or Weights & Biases. Streamlit’s chat elements make it especially easy to interact with AI so you can build chatbots that “talk to your data.”

* [Tutoriel d'utilisation de Streamlit dans `codespaces` de GitHub](https://discuss.streamlit.io/t/streamlit-101-the-fundamentals-of-a-python-data-app/75557)

Les apps tournent en local. Une colonne à gauche pour les pages, une zone centrale, par exemple un chat.

[Exemple streamit + replicate](https://github.com/tonykipkemboi/streamlit-replicate-img-app/blob/main/streamlit_app.py#L121)

## Divers

* [API de recherche sur le web, par ex. pour alimenter en RAG](https://docs.tavily.com/)



# ToDos

* streamlit est-il vraiment utile autrement qu'avec un back-end en ligne (voir avec Replicate) ? LLM en local ?
* modèle local smollm avec openllm ? -> bento pour déployer
* LMstudio n'est pas prévu pour utiliser une autre API que celle qu'il met en place.
