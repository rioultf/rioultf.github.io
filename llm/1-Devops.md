---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Devops - Stack minimale pour un agent
---

Ce cours présente le résultat de nombreuses recherches de produits jusqu'à mi 2025. 
Le produit central choisi pour mettre en oeuvre un agent est `AnythingLLM` qui permet :

* d'interroger une API `chat_competions` avec exécution d'outil
* faire tourner l'outil en local
* assembler la réponse.

Il existe de multiples moyens de mettre en oeuvre ces fonctionnalités, voir entre autre `OpenWebUI` et `LMStudio`.

# Introduction

On veillera à différencier : 

1. **Interfaces de manipulation de LLM** : effectuent des requêtes API sur des services LLM, locaux ou externes
1. **Registre/Source de modèles** :  Ensemble des plateformes et outils permettant de télécharger, ajouter ou intégrer des modèles. Par exemple, Ollama et LM Studio s'appuient sur Hugging Face, tandis qu'AnythingLLM supporte des modèles locaux et cloud via plusieurs fournisseurs.
1. **Orchestration Framework** : Système permettant de gérer à la fois l'origine des modèles (comme Hugging Face ou des registres personnalisés) et leur exécution. Il optimise les performances en déléguant l'inférence à divers fournisseurs de modèles.  



<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
<!---------------------------------------------------------------->
# Interface Utilisateur 

* [AnythingLLM](tp/2-AnythingLLM.md)

* OpenWebUI : offre le meilleur contrôle sur l'exécution de modèles, avec tout un éco-système d'outils et de workflows. C'est réservé à des organisations importantes et hors de propos.

# Registres

* [LM Studio](tp/22-LMStudio.md)

<!---------------------------------------------------------------->
# Orchestration Framework

Dans ce cours, nous n'utilisons pas de système d'orchestration pour la mise en oeuvre du modèle car nous n'avons pas besoin de ce niveau d'exécution.

Pour nos besoins d'inférence, nous privilégions l'appel à des API avec des modèles robustes.

Les éléments ci-dessous sont peu détaillés.

## Ollama

Permet de faire tourner en local une large variété de modèles.
Pour l'installation `curl | sh`, cela a marché directement en GPU, malgré [une erreur](https://github.com/ollama/ollama/issues/7929). Fournit également une web UI.

### Llama.cpp
<!---------------------------------------------------------------->

Fournit une API utilisable en Python et des scripts d'inférence, tokenisation, etc.
Permet de convertir de Hugging Face vers GGUF avec l'API Python.
