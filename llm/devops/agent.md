---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Développement d'application - Agents
---

Un agent regroupe trois composants :

* un LLM
* des outils, choisis par le LLM
* un framework, qui exécute l'outil

[Systems and Algorithms for Integrating LLMs with Applications, Tools, and Services](https://gorilla.cs.berkeley.edu/)

# MCP

* [Mise à disposition de serveurs MCP](https://mcp.composio.dev/)


## Framework

* llamaindex : *LlamaIndex provides a framework for building agents including the ability to use RAG pipelines as one of many tools to complete a task.*
## LlamaIndex

LlamaIndex is a data framework for your LLM applications 
Use Cases

    Prompting
    Question-Answering (RAG)
    Chatbots
    Structured Data Extraction
    Agents
    Multi-Modal Applications
    Fine-Tuning

[Intégration LMStudio][https://docs.llamaindex.ai/en/stable/examples/llm/lmstudio/]

* [langchain](https://python.langchain.com/docs/concepts/) : librairie pour concevoir des *composants* à base de LLM, `langgraph`pour les orchestrer

* [patterns d'orchestration](https://www.agentrecipes.com/)
* [orchestration](https://www.crewai.com/open-source)

## PocketFlow

* [design pattern d'agent](https://zacharyhuang.substack.com/p/llm-agent-internal-as-a-graph-tutorial)


[Guide de conception d'un agent](https://github.com/The-Pocket/PocketFlow/blob/main/docs/guide.md)

[Cookbook flow](https://github.com/The-Pocket/PocketFlow/blob/main/cookbook/pocketflow_demo.ipynb)

Why not built-in?: I believe it's a bad practice for vendor-specific APIs in a general framework:

    API Volatility: Frequent changes lead to heavy maintenance for hardcoded APIs.
    Flexibility: You may want to switch vendors, use fine-tuned models, or run them locally.
    Optimizations: Prompt caching, batching, and streaming are easier without vendor lock-in.


`pocketFlow`est organisé en 

* noeuds : pre, exec, post. Retourne une action
* flow : enchaînement/organisation de noeud, en fonction des actions
  * transition basique

        node_a >> node_b : 
        if node_a.post() returns "default", go to node_b. (Equivalent to node_a - "default" >> node_b)

    * transition par action nommée : 
    
        node_a - "action_name" >> node_b This means if node_a.post() returns "action_name", go to node_b.


* communications : 
    * share store
    * environnement pour batch, immutable

```python
# Define the flow connections
review - "approved" >> payment        # If approved, process payment
review - "needs_revision" >> revise   # If needs changes, go to revision
review - "rejected" >> finish         # If rejected, finish the process

revise >> review   # After revision, go back for another review
payment >> finish  # After payment, finish the process

flow = Flow(start=review)
```

On peut imbriquer les *flow* :

```python
# Create a sub-flow
node_a >> node_b
subflow = Flow(start=node_a)

# Connect it to another node
subflow >> node_c

# Create the parent flow
parent_flow = Flow(start=subflow)
```

<!------------------------------------------------------------>
# Interfaçage avec le service LLM

## LiteLLM

Rajoute une couche légère de supervision users/model/credits

Fournit une interface avec UI d'administration
https://github.com/BerriAI/litellm

[Doc](https://docs.litellm.ai/docs/)

pip install litellm

[appel de fonction](https://docs.litellm.ai/docs/tutorials/instructor)


<!------------------------------------------------------------>
# LangGraph

low-level orchestration framework for building controllable agents

# Références

* [road map agent](https://www.reddit.com/r/AI_Agents/comments/1jo2nxa/i_spoke_to_100_companies_hiring_ai_agents_heres/)