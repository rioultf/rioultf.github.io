---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Fonctionnement d'un modèle de langue
---

# Architecture

Les LLM fonctionnent grâce à des réseaux de neurones récurrents, qui ont *appris* à prédire le prochain jeton selon les jetons qu'il a lus précédemment. 

C'est le même fonctionnement que votre application de rédaction de MMS qui vous propose des mots probables selon les mots précédents dans votre message en cours d'écriture. 

<!---------------------------------------------------------------->
## Apprentissage par réseau de neurone

Un réseau de neurones est une structure informatique qui apprend à mettre en relation une *entrée* et une *sortie*. On fournit au réseau des paires $(entree, sortie)$ qu'il doit appairer fonctionnellement.

Entrée comme sortie peuvent être quasiment n'importe quel type de donnée : numérique, texte, image, vidéo, etc. Tout finira par être transformé en vecteurs de nombre, par une opération d'*embedding* (intégration en français).

### Neurone 

Un *neurone* est un objet informatique, qui possède\ :

* une valeur (généralement entre -1 et 1)
* des connexions *entrantes* pondérées avec d'autres neurones : un ensemble de poids $w_i$ tels que $h_i = \sum_j w_j h_j$
* des connexions *sortantes* avec d'autres neurones

Un neurone reçoit des informations, à sa manière, et transmet une information.

### Réseau de neurones

Un réseau de neurones structure la transformation\ :

* de l'entrée : multi-dimensionnelle, donne initie le réseau par autant de neurones que de dimensions
* en la sortie (multi-dimensionnelle, autant de neurones que de dimension) 
* en intercalant des couches de neurones

### Redescription de l'espace

Il faut voir une couche de neurones comme étant une *projection* de son entrée vers un espace de redescription où la *similarité* entre les objets étudiés sera plus *discriminante* que celle de l'espace initial.

La notion de discrimination est définie ici par le contexte d'appariement fourni au cours de l'apprentissage. 

### Entraînement d'un réseau de neurones

La tâche d'entraînement d'un réseau de neurones, appelée *apprentissage*, consiste sur un réseau *vierge* à présenter un exemple d'entrée et de mesurer la sortie obtenue. Cette sortie est comparée à la *sortie attendue* ou *vérité*, selon une mesure de *perte* définie, qui sert d'indication au réseau pour être modifié.

La modification des poids du réseau procède par *rétro-propagation de gradient*. Le *gradient* est le mot physique pour *variation*. De la sortie à l'entrée, on propage la variation entre la sortie obtenue et la vérité - dans la pratique, on fait des groupes d'instances (*batch*) et on rétro-propage la moyenne.

<!---------------------------------------------------------------->
## Réseau de neurones récurrent

Lorsque les données sont de nature *séquentielle*, c'est-à-dire concerne une évolution temporelle ou spatiale, il faut un réseau capable de traiter des entrées séquentielles\ : un réseau de neurones récurrent. Les applications sont nombreuses : texte, vidéo, audio, trajectoires.

Un réseau récurrent est constitué de *cellules* égrénant le temps, reliées aux autres cellules par des mécanismes d'*attention*. La largeur de la fenêtre d'attention définit la taille du *contexte*.

## Définition d'un LLM

Un LLM (ou *large language model*) est un modèle de langue constitué par un réseau de neurones récurrent entraîné à prédire des tokens de texte à partir d'un contexte de tokens, sur des *corpus* de textes proportionnels à sa *taille*.

La façon de *tokenizer* le texte est importante. Cette fonctionnalité peut elle-même être fournie par un LLM.



# définitions
## dataset
## modèle
## évaluation
## API
## chat template
comment le modèle s'arrête-til de produire des jetons
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

