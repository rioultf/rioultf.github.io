---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Configuration de la VDI
---

# Comment s'en passer ?

Si vous n’avez pas accès à une VDI fournie par votre université, il existe plusieurs solutions gratuites ou presque gratuites pour disposer d’un terminal Linux ou d’une machine virtuelle accessible depuis internet ou sur votre propre machine :

* Cloud avec offre gratuite
* Environnements Linux dans le navigateur
* Virtualisation locale

# VDI Unicaen

La VDI, Virtual Desktop Infrastructure, est mise en place à l'Université de Caen Normandie. Elle permet d'accéder à des machines virtuelles sous Linux, avec GPU et Docker.

Vous pouvez vous connecter depuis chez vous (et depuis une machine de TP, sous Linux ou Windows)\ :

* si besoin, installer le client `VMware Horizon`
* lancer le client `VMware Horizon` (`vmware-view` en console) ou se rendre à l'URL <https://bureau-distant.unicaen.fr/> avec le navigateur
* l'adresse du serveur est <https://bureau-distant.unicaen.fr/>
* depuis chez vous ou depuis le réseau `eduroam`, il peut vous être nécessaire de procéder à une double authentification. Voir [ici pour les détails](https://docenstock.unicaen.fr/bureau-distant/co/UtiliserDoubleAuthentification.html)
* se connecter au serveur
* rentrer ses coordonnées de *persopass*
* choisir la machine virtuelle `Pédagagie IA Ubuntu 24 H100-AMD-HP`.

**Attention** Lorsque vous fermez la session de la VDI, le contenu de votre répertoire HOME est effacé, sauf le dossier `~/Documents`. Il ne faut donc rien y stocker, et les paramètres des logiciels (entre autres l'historique et les identités gérés par le navigateur, mais également le fichier ~/.bashrc seront systématiquement effacés).


# Mise en place de l'environnement initial

## Gestion du client de la VDI

Une fois connecté, il ne faut pas éteindre la machine par le dialogue système la machine. Il faut se déconnecter du client. 

Les machines inactives pendant 15mn sont éteintes : si vous souhaitez interrompre votre travail pour une durée plus courte, vous pouvez retrouver la machine dans un état correct.

## Définition de l'environnement `bash`

On définit un environnement qui sera mis en place automatiquement au démarrage de la VDI ou à la demande :

1. rédaction d'un script `bash` : [script/init.sh]

  1. *optionnel mais recommandé* : définition du dossier `~/.ssh`
  1. définition d'un texte destiné à être ajouté au `~/.bashrc` installé par la machine :

    1. modifier la taille de l'historique
    1. simplifier le prompt
    1. définir des alias confortables et sécurisants
    1. activer la complétion
    1. activer le passage automatique dans le groupe `docker` pour lancer une commande
    1. ajouter d'autres personnalisations.
    
1. autoriser l'exécution du script :

        $ chmod +x init.sh

1. exécution à la demande :

        $ ./init.sh

1. [exécution automatique au démarrage de la VDI](https://faq-etu.unicaen.fr/x11_user_startup) :

        $ cp init.sh ~/Documents/x11_user_startup_${USER_STARTUP_SUFFIX}.sh

Attention\ : lorsqu'on se déconnecte de la VDI, la machine n'est détruite que 15 mn après déconnexion. Le temps que le fichier `~/Documents/x11_user_startup_24v.sh`, lancez vous-même ` init.sh`.

### (Optionnel) Containers `docker`

Nous utilisons `docker`, une technologie de virtualisation. La notion
de base est celle de `container`, qui font tourner une machine
virtuelle qui utilise les ressources de la machine hôte.

## `docker` sur la VDI

Pour exécuter `docker` sur la VDI, vous devez être dans le groupe `docker`.
Chaque commande `docker` ou `docker-compose` qui suit doit donc être précédée de `sudo -g docker` (demander des privilèges consistant à être membre du groupe `docker`).

Par exemple, pour faire tourner le container de test `hello-world`\ :

```
sudo -g docker docker run hello-world
```

C'est quand-même très fastidieux de faire précéder toutes vos commandes `docker` de `sudo -g docker`, donc je recommande de créer un *alias*\ :

```
$ alias docker='sudo -g docker docker'
$ alias docker-compose='sudo -g docker docker-compose'
```

**Attention** : les alias ne fonctionnent pas dans les scripts ! dans un script, `bash` n'interroge pas sa liste d'alias pour exécuter une commande. En revanche, les alias peuvent être paramétrés dans certains scripts.

# Sauvegarde de l'environnement

On définit un script `exit.sh` qui :

1. crée un dossier de sauvegarde 
1. y sauvegarde l'historique `~/.bash_history`
1. ferme et sauvegarde le dossier de configuration de `Firefox`.
1. activer le script

                chmod +x exit.sh

1. en fin de session de travail

                ./exist.sh


                




