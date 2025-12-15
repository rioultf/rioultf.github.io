---
author:
- François Rioult
lang: fr
title: Méthodologie de la programmation
subtitle: TP 0 - Environnement informatique
---
# TP1 - Environnement informatique
[Version en ligne : https://dev-rioultf.users.greyc.fr/python/tp1.html](https://dev-rioultf.users.greyc.fr/python/tp1.html)

## Connexion à une machine

* ouvrir une session avec votre *login* auquel vous ajoutez `@campus`
* saisissez votre mot de passe

## Organisation de l'espace de travail

Coupez votre écran en deux parties gauche/droite. D'un côté le terminal, de l'autre le navigateur. Pour cela, cliquez sur le bandeau de la fenêtre et positionnez-le à mi-hauteur du côté souhaité.

## Manipulations de fichiers

La suite des opérations est à effectuer dans le terminal.

1. Tapez `pwd`. Vous voyez s'afficher le nom complet du
  répertoire dans lequel vous vous trouvez, lequel est votre répertoire personnel.
1. Tapez  `cd Documents`, puis  `pwd`. Vous êtes maintenant dans le
  répertoire `Documents`
1. Tapez `cd` puis `pwd` : dans quel répertoire êtes-vous ?
1. Tapez `cd -` puis `pwd` : dans quel répertoire êtes-vous ?
1. Retournez dans le répertoire `~/Documents`.
1. Tapez  `cd .`, puis  `pwd` : dans quel répertoire êtes-vous ? 
1. Tapez  `cd ..`, puis  `pwd` : dans quel répertoire êtes-vous ?
1. Retournez dans le répertoire `~/Documents`.
1. à l'aide de `mkdir`, créer un répertoire
  `~/Documents/l3/llm/tp1`. Vous pouvez procéder en trois temps :
  depuis le répertoire `~/Documents`, créer un répertoire `l1`, s'y
  rendre à l'aide de `cd` puis créer un répertoire `methodo`, s'y
  rendre puis y créer un répertoire `tp1`. Vous pouvez aussi procéder
  en un seul temps, en effectuant `mkdir -p ~/Documents/l3/llm`\ :
  vérifiez avec `man mkdir` quel est le rôle de l'option `-p` de
  `mkdir`.

Dans toute la suite il faudra impérativement se placer dans
votre répertoire `tp1` (en utilisant la commande `cd ~/Documents/l3/llm/tp1`).

Une astuce : il peut être fastidieux ou source d'erreur, de taper à la
main le nom d'un fichier, d'un répertoire, etc, qui existe déjà. Pour
pallier cela, vous pouvez utiliser la complétion automatique. Par
exemple, pour vous placer dans le répertoire
`~/Documents/l3/llm/tp1` en partant du répertoire `~` : tapez `cd
Do` puis appuyez sur la touche `tab` du clavier pour compléter la
commande en `cd Documents/`, appuyez ensuite sur `l` et compléter avec
`tab`, etc.

## Édition/visualisation d'un fichier

1. lancer `nano signature.txt` et éditez un fichier avec votre
  signature (nom, prénom, numéro d'étudiant, formation).
1. explorer les fonctionnalités de `nano` pour enregistrer votre
  fichier et quitter l'éditeur (se référer à l'aide en bas d'écran).
1. il est vital de savoir se servir de `nano` pour modifier rapidement
  un fichier, l'enregistrer puis quitter. Cela sera utile dans le
  cadre d'une connexion à une machine distante qui refuse les
  interfaces graphiques.
1. afficher le contenu du fichier à l'aide de `less` (`q` pour quitter).
1. afficher le contenu du fichier à l'aide de `cat` : quelle est la différence avec la commande `less` ?

## Manipulations de fichiers / répertoires

Exécutez les tâches suivantes en contrôlant leur résultat avec la commande `ls`, qui affiche les fichiers du répertoire courant. Les commandes doivent être saisies à la main (et non copiées/collées) pour en prendre l'habitude et complétées à l'aide de la touche de tabulation.

Toutes les commandes peuvent être effectuées à la main, pas à pas, ou automatisées. Si vous choisissez l'automatisation, faites l'effort de comprendre comment elle fonctionne en vous aidant des pages de manuel.

On peut également utiliser la commande `tree` pour visualiser l'arborescence du répertoire courant.

1. copier le fichier `signature.txt` dans un fichier `signature.back`

        cp signature.txt signature.back

1. détruire le fichier `signature.txt`

        rm signature.txt

1. restaurer le fichier `signature.txt` en renommant le fichier `signature.back`

        mv signature.back signature.txt

1. créer 5 fichiers vides (à l'aide de `touch <fichier>`
1. créer 5 fichiers vides `a1.`, `a2`, etc. On pourra faire une boucle\ :

        for i in $(seq 5); do touch $i; done

1. créer 5 fichiers vides dont le nom ne commence pas par `a`
1. créer 5 fichiers dont le contenu est leur nom.
    - on peut écrire dans le terminal à l'aide d'`echo`
```bash
echo bonjour
echo -e "bonjour\nbonsoir"
```

    - on peut rediriger la sortie d'une commande vers un fichier

        echo bonjour > bonjour   # écrit "bonjour" dans le fichier "bonjour"

    - on peut itérer sur une énumération

        for i in bonjour bonsoir auRevoir aPlus ciao; do echo $i > $i; done

1. créer 5 fichiers dont le nom commence par un point `.`, par exemple

        touch .a .b .c .d .e

1. utilisez `ls` pour lister les fichiers dont le nom commence par `a` et seulement ceux-là
1. lister les fichiers commençant par un point

1. créer les répertoires `A`, `autres`, `.Point`.
1. copier tous les fichiers commençant par un `a` dans le répertoire `autres`

        cp a* autres

1. que s'est-il passé ? L'erreur signalée est-elle gênante ? Pouvait-on (fallait-il) l'éviter ?

1. déplacer tous les fichiers ne commençant pas par un `a` dans le répertoire `A` (utiliser `mv`)

1. déplacez le répertoire `A` dans le répertoire `autres`
1. recopiez l'intégralité du répertoire `tp1.` dans un répertoire `tp2` situé au même niveau.
1. détruire l'intégralité du répertoire `tp2`

1. archivez le répertoire `tp1` dans un fichier `tp1.tgz`
1. déplacer le fichier `tp1.tgz` dans le répertoire `/tmp` puis le désarchiver


## Alias pour les commandes de base

Depuis la rentrée 2021, les étudiants n'ont plus de fichier *~/.bashrc* ni *~/.bash\_profile*. Au passage, les alias pour les commandes standards (*cp, mv, rm*) ont disparu.

On propose les manipulations suivantes, qui permettent d'explorer ces mécanismes :

-   se déplacer dans le répertoire temporaire */tmp*

-   créer un fichier  

        touch toto

-   détruire ce fichier  

        rm toto

    et constater que le système ne demande pas de confirmation

-   interroger le système d'alias et découvrir qu'il est vide  

        alias

-   introduire un alias pour rm :  

        alias rm='rm -i'

-   en reproduisant les opérations précédentes, constater que le système demande maintenant une confirmation

-   cependant, si on ouvre un autre terminal, ces alias ne sont pas disponibles

-   on les enregistre donc dans le fichier ~/.bashrc :  

        alias rm='rm -i'
        alias cp='cp -i'
        alias mv='mv -i'

        alias ll='ls -al'

-   désormais, pour avoir une destruction ou une copie sans confirmation, il faudra utiliser l'option -f  

-   on peut en profiter pour avoir un prompt plus léger en écrivant dans le fichier ~/.bashrc :  

        export PS1='\u@\h:\w\$ '

-   pour que les modifications dans le fichier ~/.bashrc soient prises en compte, il faut :  
    -   relancer un bash :

            bash

    -   simuler une copie du fichier dans la console:

            . ~/.bashrc

        ou

            source ~/.bashrc

  

