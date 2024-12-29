---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Fonctionnement d'un modèle de langue
---

# architecture
# définitions
## dataset
## modèle
## évaluation
## API
## chat template
## system prompt
## évaluation

# 





[Sur les paramètres de la génération](https://cohere.com/blog/llm-parameters-best-outputs-language-ai)

## Modèles

* [tokenizer](https://huggingface.co/google-t5/t5-base)

https://huggingface.co/docs/transformers/model_doc/t5

### Raisonnement

* [QwQ](https://huggingface.co/spaces/Qwen/QwQ-32B-preview)
* [tests de problemes elementaires](https://github.com/cpldcpu/MisguidedAttention)
* [modele qui raisonne en enchainant trois system slot](https://informationism.org/ai2/siriusIIemodel.php)

[details sur le CoT de o1](https://openai.com/index/learning-to-reason-with-llms/)

i'm like 80% this is how o1 works:
>collect a dataset of question/answer pairs
>model to produce reasoning steps (sentences)
>r env where each new reasoning step is an action
>no fancy model; ppo actor-critic is enough
>that's literally

https://www.reddit.com/r/LocalLLaMA/comments/1h1q8h3/alibaba_qwq_32b_model_reportedly_challenges_o1/

https://medium.com/@wadan/what-researchers-need-to-know-about-openais-new-o1-model-cfda50f18d1a

The ARC benchmark (Abstraction and Reasoning Corpus), created by Google engineer François Chollet,

### Tuning

https://github.com/huggingface/smol-course/tree/main
https://github.com/huggingface/smol-course/tree/main/1_instruction_tuning

Tuning de Smollm puis sauvegarde sur le hub


## Model context protocol

https://www.anthropic.com/news/model-context-protocol

# Évaluation

<https://www.promptingguide.ai/fr/models/gpt-4>
blog sur l'évaluation de GPT-4 avec quelques exemples dans le playground

From metrics to insight, Power your metrics and alerting with the leading open-source monitoring solution : https://prometheus.io/

https://opentelemetry.io/docs/what-is-opentelemetry/

* [métriques d'évaluation llm](https://docs.ragas.io/en/latest/concepts/metrics/overview/#different-types-of-metrics)


# Applications

* moteur de recherche amélioré <https://www.perplexity.ai>
* <https://github.com/hf-lin/ChatMusician?tab=readme-ov-file> Je suis pas allé plus loin que la section Limitations qui indique « A large portion of the training data is in the style of Irish music ».
* https://www.reddit.com/r/ChatGPTPromptGenius/comments/1h2uxeh/full_starting_prompt_for_chatgpt/

# NER & IOB

[IOB tagging inside out beginning](https://en.wikipedia.org/wiki/Inside%E2%80%93outside%E2%80%93beginning_(tagging))

## Large Action Model

<https://www.trinetix.com/insights/what-are-large-action-models-and-how-do-they-work>

C’est plutôt dédié à la productivité. Tu programmes des tâches variées.
L’app est à <sellagen.com/nelima>

Voir la source : <https://www.reddit.com/r/ArtificialInteligence/comments/1fzzmr4/psa_you_can_literally_get_a_custom_newsletter_on/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>

* <https://www.salesforce.com/blog/large-action-model-ai-agent/>
* <https://www.instinctools.com/blog/large-action-models/>


https://docs.searxng.org meta moteur de recherche pour alimenter en contexte

[Comment le LLM sait quand s'arrêter de générer](https://www.louisbouchard.ai/how-llms-know-when-to-stop/)

