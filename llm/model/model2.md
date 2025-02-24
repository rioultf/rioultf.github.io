---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Mise en oeuvre d'un modèle de langue
---

L'application la plus connue d'un LLM est le chatbot. Cependant, il s'agit d'un usage bien particulier des capacités génératives d'un LLM\ : répondre à un tour de parole.

Il faut donc distinguer deux usages d'un LLM\ :

* générer du *texte* à partir d'un autre texte
* répondre à un tour de parole formaté en [en ChatML](https://gist.github.com/edwardzjl/8df07c1f7140c9a3e2f48d33a8032090) avec les *jetons adéquats* : 

```
<|im_start|>system
You are ChatGPT, a large language model trained by OpenAI. Answer as concisely as possible.<|im_end|>
<|im_start|>user
How are you<|im_end|>
<|im_start|>assistant
I am doing well!<|im_end|>
<|im_start|>user
How are you now?<|im_end|>
```

Noter la définition du *rôle* : 

* `system` (qui évolue vers `developer`)

Une forme plus moderne, ci-dessous, mais sachez qu'au final le modèle ingère du texte et reconnaît les tokens\ :

*
[
        {"role": "developer", "content": "You are a helpful assistant."},
        {
            "role": "user",
            "content": "Write a haiku about recursion in programming."
        }
    ]


<!---------------------------------------------------------------->
# Génération de texte par complétion

## Paramètres de la génération

logit : sorties brutes du dernier bloc de la couche de prédiction d'un modèle de transformer, avant l'application de la fonction softmax

Les logits sont utilisés pour sélectionner le token suivant, en prenant celui avec la probabilité maximale (mode greedy), ou en échantillonnant une distribution basée sur les probabilités (mode sampling, température, top-k, top-p). On trouve aussi beam search.

Pour attaquer un réseau de neurones, on ne peut pas lui fournir les tokens sous la forme de leur identifiant : un neurone prend en entrée un signal généralement compris entre -1 et 1. Or les identifiants de token peuvent monter très haut (50 000) ; il serait illusoire de vouloir ramener tout ce monde entre -1 et 1. Il faut donc plus de dimensions. 

C'est le rôle de l'*embedding* : projeter un one-hot vecteur vers un espace de dimension choisie.

Par exemple, la documentation de `torch` indique, pour encoder 10 tokens en dimension 3 :

```python
>>> embedding = nn.Embedding(10, 3)
>>> # a batch of 2 samples of 4 indices each
>>> input = torch.LongTensor([[1, 2, 4, 5], [4, 3, 2, 9]])
>>> embedding(input)
tensor([[[-0.0251, -1.6902,  0.7172],
         [-0.6431,  0.0748,  0.6969],
         [ 1.4970,  1.3448, -0.9685],
         [-0.3677, -2.7265, -0.1685]],

        [[ 1.4970,  1.3448, -0.9685],
         [ 0.4362, -0.4004,  0.9400],
         [-0.6431,  0.0748,  0.6969],
         [ 0.9124, -2.3616,  1.1151]]])
```

Ainsi, 1 est encodé [-0.0251, -1.6902,  0.7172], 2 est encodé [-0.6431,  0.0748,  0.6969]. Ces valeurs sont tirées au hasard dans $N(0,1)$.

**Important :** L'embedding est *aléatoire* et sera *optimisé*.





* [Source](https://jaketae.github.io/study/gpt2/#setup)
Beaucoup de détails sur les paramètres de la NLG avec la librairie `transformers`

NLG with GPT-2

    Setup
    Tokenization
        Byte Pair Encoding
        HuggingFace Tokenizers
    Generation
        Greedy Generation
        Beam Search
        N-gram Penalty
        Multiple Generation
        Random Sampling
        Softmax Temperature
        Top-K Sampling
        Top-P Sampling

* [paramétrage technique, quantisation, mémoire](https://www.reddit.com/r/LocalLLM/comments/1hm3x30/finally_understanding_llms_what_actually_matters/)

* [beaucoup de schéma et d'explications](https://www.reddit.com/r/LocalLLaMA/comments/17vonjo/your_settings_are_probably_hurting_your_model_why/)

[Source](https://cohere.com/blog/llm-parameters-best-outputs-language-ai)

### Température

Contrôle la créativité du modèle. Une température de 0 rend le modèle *déterministe*.

### Top-k

Indique au modèle de choisir des token parmi les $k$ meilleurs.

### Top-p

C'est un seuil de probabilité pour filtrer les tokens.

<!---------------------------------------------------------------->
## Quantization

La quantisation consiste à compresser les poids du modèle, en changeant le type de valeur, par exemple en passant de FP32 à INT4.

Deux méthodes :

* Quantization-Aware Training (QAT) : intègre la conversion de poids (calibration, estimation de domaine de variation, clipping, rouding) pendant l'apprentissage. Le modèle obtenu est de meilleure qualité, mais plus coûteux.
* Post-Training Quantization (PTQ) : la compression est effectuée *après* l'entrainement.

[Source](https://symbl.ai/developers/blog/a-guide-to-quantization-in-llms/).

<!---------------------------------------------------------------->
## Tokenizer

[Introduction à la tokenisation]<https://www.geeksforgeeks.org/introduction-of-lexical-analysis/>

### Exemple de Smollm 

* [600B tokens from Smollm-Corpus](https://huggingface.co/datasets/HuggingFaceTB/smollm-corpus)
* 49152 tokens
* [architecture reprise sur MobileLLM](https://arxiv.org/pdf/2402.14905)
  * section G : distillation
  * beaucoup de détails techniques, considérations sur le nombre de têtes d'attention. Partage de layer. Un bloc trasformer contient le MHSA (multi-head self attention) et un feed-forward (FFN)

#### Analyse des tokens

[La liste des tokens](https://huggingface.co/HuggingFaceTB/cosmo2-tokenizer/raw/main/tokenizer.json)

* tokens de dialogue :

```
<|endoftext|>
<|im_start|>
<|im_end|>
<repo_name>
<reponame>
<file_sep>
<filename>
<gh_stars>
<issue_start>
<issue_comment>
<issue_closed>
<jupyter_start>
<jupyter_text>
<jupyter_code>
<jupyter_output>
<jupyter_script>
<empty_output>
```

* 760 combinaisons de signes de ponctuation
* 235 caractères uniques

```python
from transformers import AutoModelForCausalLM, AutoTokenizer

model_name = "HuggingFaceTB/SmolLM2-360M-Instruct"

tokenizer = AutoTokenizer.from_pretrained(pretrained_model_name_or_path=model_name)

for i in range(49152):
    print(tokenizer.convert_tokens_to_string(tokenizer.convert_ids_to_tokens([i])))
```

Les tokens commençant par un espace (codé `Ġ`) sont des débuts de mots. Les autres peuvent compléter d'autres tokens.

```bash
awk 'NR>=254{print}' token.txt | sed -n 's/^ //p' | sort > words.txt
awk 'NR>=254{print}' token.txt | grep -v "^ " | sort > suffixes.txt
```

#### Mots en majuscule

* toutes les lettres
* la moitié des combinaisons de deux lettres. Vérifier s'il y a les pays
* 400 triplets
* [Les plus longs](script/capital.txt)
* 10 000 mots commencent par une majuscule
* [22 000 mots commencent par une minuscule](script/lower.txt)

* 3800 suffixes commencent par une majuscule


```bash
grep -E '^[A-Z]{4,}$' words.txt | awk '{ print length(), $0 | "sort -rn" }' | cut -d" " -f2- > capital.txt
```

### Enseignement important 

* la ponctuation est prise en compte
* le modèle fait la différence entre majuscules et minuscules
* certains tokens sont *très* longs : les mots longs ne sont pas découpés lorsqu'ils sont porteurs de sens répandu dans le corpus.

### Notes

* [tokenizer](https://huggingface.co/google-t5/t5-base)
* <https://huggingface.co/docs/transformers/model_doc/t5>

<!---------------------------------------------------------------->
## Embedding

L'*embedding* transforme le token en un vecteur, qui peut être utilisé dans un RNN. C'est le résultat d'un apprentissage à base de blocs transformers propageant de la self attention pour prédire la cible.

[modèle renvoyant un embedding (par exemple avec LMStudio) : text-embedding-nomic-embed-text-v1.5](https://huggingface.co/nomic-ai/nomic-embed-text-v1.5)

[atlas nomique des embeddings](https://atlas.nomic.ai/map/nomic-text-embed-v1-5m-sample)

```python
def calculate_average_distance(responses):
    """
    This function calculates the average distance between the embeddings of the responses.
    The distance between embeddings is a measure of how similar the responses are.
    """
    # Calculate embeddings for each response
    response_embeddings = [get_embedding(response) for response in responses]

    # Compute distances between the first response and the rest
    distances = distances_from_embeddings(response_embeddings[0], response_embeddings[1:])

    # Calculate the average distance
    average_distance = sum(distances) / len(distances)

    # Return the average distance
    return average_distance
```

### GPT - generative pre-trained transformer

On ajoute un embedding positionnel sur la *sequence*.

* [Encodage de la position](https://jaketae.github.io/study/relative-positional-encoding/)

### BERT - (Bidirectional Encoder Representations from Transformers)

Utilise également un embedding positionnel.

Ajoute un embedding de *segment* pour différencier les séquences.

### Word2vec

Il utilise deux architectures principales pour générer des embeddings : Skip-gram et CBOW (Continuous Bag of Words). Skip-gram prédit le contexte à partir d'un mot donné, tandis que CBOW prédit un mot à partir des mots du contexte.

La couche cachée contient quelques centaines de neurones et constitue, à l'issue de la représentation, le plongement lexical (embedding) permettant de représenter un mot.

<a title="Aelu013, CC BY-SA 4.0 &lt;https://creativecommons.org/licenses/by-sa/4.0&gt;, via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:CBOW_eta_Skipgram.png"><img width="512" alt="CBOW eta Skipgram" src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/CBOW_eta_Skipgram.png/512px-CBOW_eta_Skipgram.png?20180225191115"></a>

### FastText

Ces modèles ont été entraînés à l'aide de CBOW avec des poids de position, dans la dimension 300, avec des n-grammes de caractères de longueur 5, une fenêtre de taille 5 et 10 négatifs.

* [Encodage de la position](https://jaketae.github.io/study/relative-positional-encoding/)



<!---------------------------------------------------------------->
## Raisonnement

* [QwQ](https://huggingface.co/spaces/Qwen/QwQ-32B-preview)
* [tests de problemes elementaires](https://github.com/cpldcpu/MisguidedAttention)
* [modele qui raisonne en enchainant trois system slot](https://informationism.org/ai2/siriusIIemodel.php)
* [details sur le CoT de o1](https://openai.com/index/learning-to-reason-with-llms/)
* i'm like 80% this is how o1 works:
>collect a dataset of question/answer pairs
>model to produce reasoning steps (sentences)
>r env where each new reasoning step is an action
>no fancy model; ppo actor-critic is enough
>that's literally
* https://www.reddit.com/r/LocalLLaMA/comments/1h1q8h3/alibaba_qwq_32b_model_reportedly_challenges_o1/
* https://medium.com/@wadan/what-researchers-need-to-know-about-openais-new-o1-model-cfda50f18d1a
* deepseek 3 COT https://www.reddit.com/r/LocalLLaMA/comments/1hnbgtu/deep_seek_v3_has_a_deep_think_option_it_shows_the/
* The ARC benchmark (Abstraction and Reasoning Corpus), created by Google engineer François Chollet,

sur le fonctionnement de o3 :
My mental model for LLMs is that they work as a repository of vector programs. When prompted, they will fetch the program that your prompt maps to and "execute" it on the input at hand. LLMs are a way to store and operationalize millions of useful mini-programs via passive exposure to human-generated content.

This "memorize, fetch, apply" paradigm can achieve arbitrary levels of skills at arbitrary tasks given appropriate training data, but it cannot adapt to novelty or pick up new skills on the fly (which is to say that there is no fluid intelligence at play here.
https://arcprize.org/blog/oai-o3-pub-breakthrough

source How I think about LLM prompt engineering
Prompting as searching through a space of vector programs
FRANÇOIS CHOLLET
https://fchollet.substack.com/p/how-i-think-about-llm-prompt-engineering

prompt interminable pour faire raisonner :
https://www.reddit.com/r/ChatGPTPromptGenius/comments/1h5iv86/i_give_you_the_perfected_system_copypaste_prompt/
réponse : I will give since you gave ot should save you some tokens
Outline procedures for the 4O System (Observe, Optimize, Operate, Organize) and Recursive Validation, including accuracy, logic, and context filters. Detail speculative reasoning, solution-oriented, and creative adaptability processes, emphasizing user interactivity (tone, depth, and perspective settings) and failure analytics (detection, crash reporting, and self-healing). Highlight continuous evolution via adaptive learning, performance monitoring, and resource optimization


## Fine-Tuning / Distillation

https://github.com/huggingface/smol-course/tree/main
https://github.com/huggingface/smol-course/tree/main/1_instruction_tuning
cours de fine tuning https://github.com/huggingface/smol-course

Tuning de Smollm puis sauvegarde sur le hub

[Parameter-Efficient Fine-Tuning](https://huggingface.co/docs/peft/index)

[Red teaming](https://www.promptfoo.dev/docs/red-team/)

## Évaluation

* [blog sur l'évaluation de GPT-4 avec quelques exemples dans le playground](https://www.promptingguide.ai/fr/models/gpt-4)

Une part importante des solutions consistent à capter des mesures de télémétrie, générée lors de l'éxécution du LLM (qu'il faut *sonder*), puis à les analyser.


* [From metrics to insight, Power your metrics and alerting with the leading open-source monitoring solution](https://prometheus.io/)
* [Télémétrie](https://opentelemetry.io/docs/what-is-opentelemetry/)

* [métriques d'évaluation llm](https://docs.ragas.io/en/latest/concepts/metrics/overview/#different-types-of-metrics)


([Framework d'évaluation](https://www.deepchecks.com/best-llm-evaluation-tools/#post-item-2)



### Poenix - Arive

[Capte de la télémétrie](https://docs.arize.com/phoenix)



# NER & IOB

[IOB tagging inside out beginning](https://en.wikipedia.org/wiki/Inside%E2%80%93outside%E2%80%93beginning_(tagging))

## Large Action Model

https://github.com/tatsu-lab/stanford_alpaca

<https://www.trinetix.com/insights/what-are-large-action-models-and-how-do-they-work>

C’est plutôt dédié à la productivité. Tu programmes des tâches variées.
L’app est à <sellagen.com/nelima>

Voir la source : <https://www.reddit.com/r/ArtificialInteligence/comments/1fzzmr4/psa_you_can_literally_get_a_custom_newsletter_on/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>

* <https://www.salesforce.com/blog/large-action-model-ai-agent/>
* <https://www.instinctools.com/blog/large-action-models/>
* [appel de fonctions](https://gist.github.com/zackangelo/8862ec433eaf419122a5dc69e9f228d9)

* [meta moteur de recherche pour alimenter en contexte](https://docs.searxng.org)

[autogen + lmstudio](https://medium.com/@LakshmiNarayana_U/a-beginners-guide-to-agents-using-autogen-studio-and-lm-studio-0e5da8aea17e)

