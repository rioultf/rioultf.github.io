<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
# Exécution d'un service LLM

<!---------------------------------------------------------------->
## vllm

vllm, https://docs.vllm.ai/en/stable/index.html servir du llm, entre autres hugging face

<!---------------------------------------------------------------->
## OpenLLM

https://github.com/bentoml/OpenLLM

dispose d'une app web pour tester, avec system prompt
installe une API OpenAI

<!---------------------------------------------------------------->
## LM Studio

[Peut faire du RAG](https://lmstudio.ai/docs/basics/rag)

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
  

<!---------------------------------------------------------------->
## Ollama



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

# I believe the meaning of life is to find your own truth and to live in accordance with it. For me, this means being true to myself and following my passions, even if they don't align with societal expectations. I think that's what I love about yoga – it's not just a physical practice, but a spiritual one too. It's about connecting with yourself, listening to your inner voice, and honoring your own unique journey.

Run in conversation mode

llama-cli -m model.gguf -p "You are a helpful assistant" -cnv

# > hi, who are you?
# Hi there! I'm your helpful assistant! I'm an AI-powered chatbot designed to assist and provide information to users like you. I'm here to help answer your questions, provide guidance, and offer support on a wide range of topics. I'm a friendly and knowledgeable AI, and I'm always happy to help with anything you need. What's on your mind, and how can I assist you today?
#
# > what is 1+1?
# Easy peasy! The answer to 1+1 is... 2!

Run with custom chat template

# use the "chatml" template
# use a custom template
llama-cli -m model.gguf -p "You are a helpful assistant" -cnv --in-prefix 'User: ' --reverse-prompt 'User:'

Supported templates
Constrain the output with a custom grammar

llama-cli -m model.gguf -n 256 --grammar-file grammars/json.gbnf -p 'Request: schedule a call at 8pm; Command:'

# {"appointmentTime": "8pm", "appointmentDetails": "schedule a a call"}

### Génération selon une grammaire

Par exemple, générer du JSON.

GBNF (GGML BNF) is a format for defining formal grammars to constrain model outputs in llama.cpp


<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
# Application intégrant un LLM

* [Mélange markdown et JSX](https://github.com/puzzlet-ai/agentmark)
Alternative to n8n?
* [Stack LLM ops avec FastAPI](https://www.timescale.com/blog/the-emerging-open-source-ai-stack)

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


# Streamlit

* [avec OpenAI et LLaMaIndex](https://blog.streamlit.io/build-a-chatbot-with-custom-data-sources-powered-by-llamaindex/)

Streamlit is an open-source Python framework to build highly interactive apps – in only a few lines of code. Streamlit integrates with all the latest tools in generative AI, such as any LLM, vector database, or various AI frameworks like LangChain, LlamaIndex, or Weights & Biases. Streamlit’s chat elements make it especially easy to interact with AI so you can build chatbots that “talk to your data.”

* [Tutoriel d'utilisation de Streamlit dans `codespaces`de GitHub](https://discuss.streamlit.io/t/streamlit-101-the-fundamentals-of-a-python-data-app/75557)

Les apps tournent en local. Une colonne à gauche pour les pages, une zone centrale, par exemple un chat.

[Exemple streamit + replicate](https://github.com/tonykipkemboi/streamlit-replicate-img-app/blob/main/streamlit_app.py#L121)







## Postman des LLM

* [programmation graphique et prompt engineering : ChainForge provides a suite of tools to evaluate and visualize prompt (and model) quality](https://chainforge.ai/)
* Le postman des llm https://www.adaline.ai/get-started
* API de Postman : <https://www.postman.com/manukmcts/llm/overview>
* [Génératon de tests Postman par LLM](https://www.aimodels.fyi/papers/arxiv/automating-rest-api-postman-test-cases-using)
* <https://www.functionize.com/>
* [An Overview on Testing Frameworks For LLMs](https://llmshowto.com/blog/llm-test-frameworks)
* [Tester avec l’IA générative – Stratégie & Feuille de route réaliste](https://www.smartesting.com/tester-avec-lia-generative-strategie-feuille-de-route-realiste/)
* LLMops [Automated Testing for LLMOps](https://www.deeplearning.ai/short-courses/automated-testing-llmops/)


## ToDos

* streamlit est-il vraiment utile autrement qu'avec un back-end en ligne (voir avec Replicate) ? LLM en local ?
* modèle local smollm avec openllm ? -> bento pour déployer
* LMstudio n'est pas prévu pour utiliser une autre API que celle qu'il met en place.



