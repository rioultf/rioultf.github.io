<!-------------------------------------------------------------->
<!-------------------------------------------------------------->
<!-------------------------------------------------------------->
# Automatisation des tests de LLM

[Définitions](https://www.deepchecks.com/glossary/llm-testing/)

* [programmation graphique et prompt engineering : ChainForge provides a suite of tools to evaluate and visualize prompt (and model) quality](https://chainforge.ai/)

  Lance une interface web pour design d'un pipeline avec LLM
  On peut mettre un provider local sous la forme d'un script python à coller dans le widget : [compliqué](https://gitlab.hl-dev.de/aichecker/masterarbeit/-/blob/4ec3a667c981c11e052f01baaca9c974918b6e3c/ChainForge/LMStudioProvider.py)

  <https://chainforge.ai/docs/custom_providers/>

* [Analytics sur des LLM](https://app.traceloop.com/)

  Quid de l'intégration LMStudio ? Niet
  OpenLLMetry fournit des indicateurs à des logiciels comme Grafana, chargé de l'observabilité. Les modèles propriétaire sont instrumentés, de même que les databases de vecteurs ou les frameworks (langchain, llamaindex, https://haystack.deepset.ai/, )

* [Literal AI](https://docs.literalai.com/get-started/overview) is the collaborative observability, evaluation and analytics platform for building production-grade LLM apps. Literal AI offers multimodal logging, including vision, audio, and video.

  a l'air très bien mais je n'arrive pas à brancher LMStudio.
  literalai custom configuration test failed 504
  

* [oobabooga A Gradio web UI for Large Language Models.](https://github.com/oobabooga/text-generation-webui)

  installe Torch et propose plein de providers comme transformers

<!--------------------------------------------------------------->
### PromptFoo

[Promptfoo: A Test-Driven Approach to LLM Success](https://medium.com/@fassha08/promptfoo-a-test-driven-approach-to-llm-success-154a444b2669)

Un fichier de configuration `promptfooconfig.yaml` définit :

* une liste de prompts
* une liste de providers
* une configuration par défaut `defaultTest`
* une liste de tests
  * liste de variables
  * test

Il s'agit de la définition d'un template assemblant différents fichiers (tous les constituants peuvent être mis dans des fichiers). Couplé avec un gestionnaire de version, la dépendance forte de `PromptFoo` lui confère une traçabilité optimale.

Deux commandes sont alors disponibles :

* `npx promptfoo eval --no-cache` : pour chaque prompt, exécute les différents configurations de test sur chaque provider. Il faut déactiver le cache pour forcer l'interrogation du modèle.
* `npx promptfoo view` : lance une interface web permettant d'analyser les résultats dans le cache

Le cache est une base de données de prompts / réponses, accompagnés des fichiers de configuration. Ceux peuvent être édités de manière à relancer le test.

On peut définir des [prompts comme des fonctions .py ou .js](https://www.promptfoo.dev/docs/configuration/parameters/#prompt-functions)

De nombreuses métriques sont disponibles, déterministes ou fournies par des LLM : Model-graded metrics. 

llm-rubric is promptfoo's general-purpose grader for "LLM as a judge" evaluation. Propose également de la classification, modération, etc.

#### Cas d'usage

Le système de base construit un tableau test/prompt.

* tester différents prompts : sur différentes formulations d'une tâche, par exemple de traduction ou de rédaction. C'est le cas d'usage par défaut, il suffit pour cela de définir plusieurs prompts.
* tester différents system prompts : il faut définir autant de cas de test que nécessaire (voir ci-dessous)
* tester différents paramètres du modèle : autant de cas de tests

Utilisation du system de template analogue à `jinja2` : [nunjucks](https://www.promptfoo.dev/docs/configuration/parameters/#nunjucks-filters)

#### Prompt pour chat

Certains modèles une interaction sous forme de messages, avec un role et un contenu. On pourra définir les prompts dans des fichiers JSON :

```json
[
    {
      "role": "system",
      "content": "{{systemPrompt}}"
    },
    {
      "role": "user",
      "content": "Tell me about planets"
    }
]
```
#### Fichier de configuration des tests

Interface avec LMStudio comme provider.

* [Détails sur la configuration](https://www.promptfoo.dev/docs/configuration/guide/)


```yaml
# yaml-language-server: $schema=https://promptfoo.dev/config-schema.json
description: "My eval"

prompts:
  - file://personality1.json


providers:
  - id: https
    config:
      url: 'http://0.0.0.0:1234/v1/chat/completions'
      method: 'POST'
      body:
        model: 'smollm2-360m-instruct'
        messages: '{{prompt}}'
      transformResponse: 'json.choices[0].message.content'
      maxTokens: 300

tests:
  - vars:
      systemPrompt: 'Answer in french.'
  - vars:
      systemPrompt: 'Be concise.'
```

<!--------------------------------------------------------------->
### Notes

* [Le postman des llm, mais pas de modèle local](https://www.adaline.ai/get-started)

* [Des exemples dans Postman](https://www.postman.com/manukmcts/llm/overview)
* [Génératon de tests Postman par LLM](https://www.aimodels.fyi/papers/arxiv/automating-rest-api-postman-test-cases-using)

* [An Overview on Testing Frameworks For LLMs](https://llmshowto.com/blog/llm-test-frameworks)
* [Tester avec l’IA générative – Stratégie & Feuille de route réaliste](https://www.smartesting.com/tester-avec-lia-generative-strategie-feuille-de-route-realiste/)
* LLMops [Automated Testing for LLMOps](https://www.deeplearning.ai/short-courses/automated-testing-llmops/)
