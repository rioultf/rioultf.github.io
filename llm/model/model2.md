<!---------------------------------------------------------------->
## Paramètres de la génération

[Source](https://cohere.com/blog/llm-parameters-best-outputs-language-ai)

### Température

Contrôle la créativité du modèle. Une température de 0 rend le modèle *déterministe*.

### Top-k

Indique au modèle de choisir des token parmi les $k$ meilleurs.

### Top-p

C'est un seuil de probabilité pour filtrer les tokens.


<!---------------------------------------------------------------->
## Tokenizer

[Introduction à la tokenisation]<https://www.geeksforgeeks.org/introduction-of-lexical-analysis/>

### Exemple de Smollm 

[600B tokens from Smollm-Corpus](https://huggingface.co/datasets/HuggingFaceTB/smollm-corpus)

tokenizer trained on the Smollm Corpus with a vocab size of 49152

* token de dialogue :

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
* les mots de plus de quatre lettres. [Les plus longs](script/capital.txt)

```bash
grep -E '^[A-Z]{4,}$' words.txt | awk '{ print length(), $0 | "sort -rn" }' | cut -d" " -f2- > capital.txt
```

### Enseignement important 

* la ponctuation est prise en compte
* le modèle fait la différence entre majuscules et minuscules



* [tokenizer](https://huggingface.co/google-t5/t5-base)

https://huggingface.co/docs/transformers/model_doc/t5

<!---------------------------------------------------------------->
## Raisonnement

* [QwQ](https://huggingface.co/spaces/Qwen/QwQ-32B-preview)
* [tests de problemes elementaires](https://github.com/cpldcpu/MisguidedAttention)
* [modele qui raisonne en enchainant trois system slot](https://informationism.org/ai2/siriusIIemodel.php)
* [details sur le CoT de o1](https://openai.com/index/learning-to-reason-with-llms/)

i'm like 80% this is how o1 works:
>collect a dataset of question/answer pairs
>model to produce reasoning steps (sentences)
>r env where each new reasoning step is an action
>no fancy model; ppo actor-critic is enough
>that's literally

* https://www.reddit.com/r/LocalLLaMA/comments/1h1q8h3/alibaba_qwq_32b_model_reportedly_challenges_o1/

* https://medium.com/@wadan/what-researchers-need-to-know-about-openais-new-o1-model-cfda50f18d1a

The ARC benchmark (Abstraction and Reasoning Corpus), created by Google engineer François Chollet,

## Tuning

https://github.com/huggingface/smol-course/tree/main
https://github.com/huggingface/smol-course/tree/main/1_instruction_tuning

Tuning de Smollm puis sauvegarde sur le hub

## Model context protocol

https://www.anthropic.com/news/model-context-protocol

## Évaluation

* [blog sur l'évaluation de GPT-4 avec quelques exemples dans le playground](https://www.promptingguide.ai/fr/models/gpt-4)
* [From metrics to insight, Power your metrics and alerting with the leading open-source monitoring solution](https://prometheus.io/)
* [Télémétrie](https://opentelemetry.io/docs/what-is-opentelemetry/)
* [métriques d'évaluation llm](https://docs.ragas.io/en/latest/concepts/metrics/overview/#different-types-of-metrics)



# NER & IOB

[IOB tagging inside out beginning](https://en.wikipedia.org/wiki/Inside%E2%80%93outside%E2%80%93beginning_(tagging))

## Large Action Model

<https://www.trinetix.com/insights/what-are-large-action-models-and-how-do-they-work>

C’est plutôt dédié à la productivité. Tu programmes des tâches variées.
L’app est à <sellagen.com/nelima>

Voir la source : <https://www.reddit.com/r/ArtificialInteligence/comments/1fzzmr4/psa_you_can_literally_get_a_custom_newsletter_on/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>

* <https://www.salesforce.com/blog/large-action-model-ai-agent/>
* <https://www.instinctools.com/blog/large-action-models/>


* [meta moteur de recherche pour alimenter en contexte](https://docs.searxng.org)



