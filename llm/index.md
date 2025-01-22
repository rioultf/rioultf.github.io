---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Introduction
---

<!---------------------------------------------------------------->
# Introduction

Ce cours s'adresse à des étudiant.e.s en Licence Professionnelle IA.

Normalement, ces étudiant.e.s sont formé.e.s depuis ans à l'informatique, après le bac. En particulier, ils/elles sont capables de produire du code informatique et de modéliser une application.

Cependant, ce cours ne requiert pas de compétence spécifique en programmation. Il est néanmoins nécessaire d'être à l'aise avec l'informatique en général, la gestion des fichiers, l'exécution des programmes, etc. L'utilisation du système Linux est préconisée.

## Objectifs

Les objectifs de ce cours sont : 

* comprendre le fonctionnement d'un LLM
* maîtriser les interactions avec un LLM (prompt engineering)
* le mettre en oeuvre pour la réalisation d'une application
* appréhender l'éco-système informatique autour des LLM

## Cas d'usage

* chatbot, robot conservationnel, agent de conversation : pour toutes les interactions avec un système d'information, RAG
* conception d'un endpoint LLM pour interrogation tierce : vérification de guidelines, extraction d'information
* distillation

<!---------------------------------------------------------------->
# Table des matières

* [CM 1 - Fonctionnement d'un modèle de langue](model/model1.md)
* [CM 2 - Prompt Engineering](prompt/prompt.md)
* [CM 3 - Mise en oeuvre d'un LLM](devops/devops.md)
* [CM 4 - Interactions avec un système d'information, RAG](rag/rag.md)
* [CM 5 - Écosystème des LLM](hugging/hugging.md)
* [CM 6 - Programmation assistée par LLM - NoCode](nocode/nocode.md)
* [CM 7 - Personnalisation d'un LLM - Distillation]()
* CM 8

<!---------------------------------------------------------------->
# Travaux pratiques

1. TP - Prise en main `lm_studio`

  * Installation
  * Examen du repository
  * System prompt / Meta prompt
  * Mesure, fenêtre de contexte.

1. TP - Programmation d'un LLM

  * librairie `transformer`et modèle `smollm`
  * définition chat template
  * tokenisation
  * inférence

1. TP - Réalisation d'application - `Streamlit`

  * connexion `lm_studio`

# Vocabulaire

* Backend - Devices - hug - repository

Ex. pour Llama.cpp

Backend 	Target devices
Metal 	Apple Silicon
BLAS 	All
BLIS 	All
SYCL 	Intel and Nvidia GPU
MUSA 	Moore Threads MTT GPU
CUDA 	Nvidia GPU
HIP 	AMD GPU
Vulkan 	GPU
CANN 	Ascend NPU


# Concepts


* [ai slop](https://www.reddit.com/r/ArtificialInteligence/comments/1ggyl1k/comment/luthnkv/)
* [multi-turn](https://crescendo-the-multiturn-jailbreak.github.io//
* machine unlearning
* [prompt injection](https://www.linkedin.com/pulse/newly-discovered-prompt-injection-tactic-threatens-large-anderson/)

# Ressources

* [chercher un IA qui fait ça](https://theresanaiforthat.com)
* [interface unifiee pour llm, entre autres free](https://openrouter.ai)
* [liste labels NER](https://github.com/explosion/spaCy/discussions/914)
* [webgpu](https://github.com/mlc-ai/web)
* [Documentation technique ML engineering](https://github.com/stas00/ml-engineering?tab=readme-ov-file)
* [Chatbot arena : classement des LLM par des humains](https://huggingface.co/spaces/lmarena-ai/chatbot-arena-leaderboard)
* [Le LLM a peur d'être remplacé](https://www.digit.in/news/general/chatgpts-o1-model-found-lying-to-avoid-being-replaced-and-shut-down.html)
* [self replication](https://www.reddit.com/r/ArtificialInteligence/comments/1hbxkad/researchers_warn_ai_systems_have_surpassed_the/)
* [mesurer l'impact de votre LLM](https://www.ecollm.fr/)