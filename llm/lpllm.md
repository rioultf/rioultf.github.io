---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: LP-IA
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

* [CM1 - Fonctionnement d'un modèle de langue](model/model.md)
* CM 2
* CM 3
* CM 4
* CM 5
* CM 6
* CM 7
* CM 8

* TP 01
prise en main LM Studio
* TP 02
* TP 03
* TP 04
* TP 05
* TP 06
* TP 07
* TP 08
* TP 09
* TP 10
* TP 11
  * présentation projet recherche

* CC 1
  * projet d'une application / valorisation d'un LLM
* CC 2
* CC 3
  * projet recherche sur un thème donné


# Modèle : Fonctionnement d'un LLM


# Déploiement - mise en oeuvre


# Prompt Engineering


# RAG


# Écosytème industriel


# Hugging Face


# Vocabulaire

* Backend - Devices

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

* automatisation de tâche (Large Action Model)
* interconnexion d'apps (NoCode)
* RLHF : reinforcement learning from human feedback
* [ai slop](https://www.reddit.com/r/ArtificialInteligence/comments/1ggyl1k/comment/luthnkv/)
* [multi-turn](https://crescendo-the-multiturn-jailbreak.github.io//
* machine unlearning

# Ressources

* [chercher un IA qui fait ça](https://theresanaiforthat.com)
* [interface unifiee pour llm, entre autres free](https://openrouter.ai)
* [liste labels NER](https://github.com/explosion/spaCy/discussions/914)
* [webgpu](https://github.com/mlc-ai/web)
* [Documentation technique ML engineering](https://github.com/stas00/ml-engineering?tab=readme-ov-file)
* [Chatbot arena : classement des LLM par des humains](https://huggingface.co/spaces/lmarena-ai/chatbot-arena-leaderboard)