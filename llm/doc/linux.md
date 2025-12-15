---
author:
- François Rioult
lang: fr
title: Application des LLM
subtitle: Environnement informatique Linux
---
# Linux

Linux est une implémentation libre des standards commerciaux Unix des années
70 pour les systèmes d'exploitation. Le noyau est le cœur du système, et
contient les primitives nécessaire pour la gestion du processeur, en
terme d'allocation des ressources et d'ordonnancement des différents
processus.

# Le terminal, la ligne de commande, le shell 

À ce jour et en dépit des interfaces graphiques, une majorité
d'informaticien s'accorde sur le fait que l'interaction principale avec
la machine passe par le clavier, au travers de commandes à exécuter
saisies par l'utilisateur. On utilisera pour cela un programme nommé
*terminal*, généralement pourvu d'une interface graphique pour
copier/coller et ouvrir d'autre terminaux mais pas plus. Le mot
*terminal* date des années lointaines où plusieurs consoles (clavier +
écran) étaient branchées sur une même machine avec laquelle elles
échangeaient de simples caractères.

En réalité, le terminal fait tourner un interprêteur de commande, en
particulier `bash` qui est le plus répandu sur les systèmes Linux. Cet
interprêteur exécute le programme suivant :

1.  afficher l'invite de commande ou *prompt*
2.  donner le contrôle du clavier à l'utilisateur, jusqu'à ce qu'il
    presse la touche Entrée
3.  analyser le texte fourni par l'utilisateur et le transformer en une
    commande à exécuter par le système
4.  demander au système l'exécution de la commande
5.  afficher le résultat de la commande
6.  retourner en ligne 1.

`bash` peut exécuter des commandes qui sont disponibles dans des fichiers
(programmes, scripts) mais contient également ses propres commandes,
dites *builtin* : déplacement dans l'arborescence de fichier, gestion
des alias, des variables, de l'interaction avec l'utilisateur.

Le notion de déplacement dans l'arborescence est une abstraction de la
gestion du *répertoire courant*, dont vont dépendre le nom des
fichiers relatifs (voir section suivante). L'une des tâches de base
consiste donc à modifier ce répertoire courant (en *changer*) à l'aide
de la commande `cd`. On se repère dans la navigation en contrôlant le
répertoire indiqué par le prompt puis visualisant la liste des
fichiers du répertoire courant avec la commande `ls`.

Le terminal est très efficace pour manipuler des fichiers, lancer des
programmes, automatiser des tâches : c'est la base de l'organisation des
tâches. En outre, dans les contextes d'informatique dématérialisée, le
seul moyen de piloter une machine à distance est d'utiliser un terminal
sous `bash`.

`bash` fournit de puissant outils pour oublier la souris et rendre les
interactions claviers performantes en limitant la saisie au strict
minimum (entre une ou trois lettres pour chaque mot) :

-   gestion de l'historique : on y navigue avec les flèches bas/haut, à
    l'intérieur d'une ligne, on peut également y effectuer une recherche

-   la complétion : lorsque quelques lettres sont saisies, l'appui de la
    touche `Tab` déclenche la recherche de toutes les solutions possibles. Si
    une seule solution existe, elle vient compléter la commande. Si
    plusieurs solutions existent, un deuxième appui sur `Tab` les affiche et
    il suffit de taper d'autres lettres pour affiner.

`bash` est un langage complet avec gestion des variables, boucles, fonctions.
Ce n'est pas pour cela qu'il faut programmer avec, car il n'est pas très
performant pour faire du calcul. Son usage doit être limité à la gestion
de tâches, des itérations, de courts scripts, des enrobeurs (*wrapper*)
pour convertir des formats.

En outre, sa syntaxe est assez horrible et exigeante, archaïque par
rapport aux langages actuels, mais ce n'est pas une raison suffisante
pour faire l'impasse\ :

-   on a besoin de peu d'éléments du langage pour se sortir de la grande
    majorité des situations
-   c'est souvent l'un des seuls langages disponibles sur les
    distributions de base
-   il permet de faire en très peu de temps des manipulations très
    puissantes d'architectures informatiques, indispensables en milieu
    professionnel
-   il est très performant pour effectuer les tâches pour lesquelles il
    est conçu, c'est à dire lancer des processus
-   il faut arrêter de faire des scripts PHP ou Python pour manipuler
    des fichiers et lancer des tâches, `bash` est là pour cela.

# Système de fichiers

Une tâche importante qui incombe à l'utilisateur du terminal est
d'arriver à se forger une représentation mentale de l'arborescence des
fichiers. Ce n'est pas une démarche naturelle quand on a l'habitude de
travailler avec des explorateurs de fichier utilisant des
représentations graphiques à l'aide d'icônes, mais cela vient vite
quand on fait l'effort de pratiquer régulièrement.

D'autre part, il est illusoire de considérer qu'on peut se passer du
terminal pour travailler et qu'on va pouvoir conserver ses petites
habitudes à base d'icône et de souris. En particulier, lorsque l'on
dialoguera avec une machine distante comme un serveur web ou de base
de données, on ne disposera pas d'interface graphique mais d'un
interpréteur de commande.

En tout cas, dans ce cours de méthodologie de la programmation, les
explorateurs de fichier seront **interdits** et l'usage de la souris
fortement découragé.

## Noms de fichiers

Il est **vivement** déconseillé d'utiliser des caractères spéciaux dans les noms de fichiers\ :

* espaces : préférer le *camel case*, qui consiste à lier des mots sans espace, en utilisant une majuscule pour chaque début de mot.  Par exemple\ : `monNomDeFichier`
* caractères accentués
* caractères exotiques (type `ç`, `*`, etc.)

On peut donc utiliser des lettres, des chiffres, des tirets `-`, des caractères *souligné* (*underscore*) `_`, et c'est tout\ !

Éviter également les majuscules pour démarrer vos noms de fichiers, même si c'est plus joli.

## Architecture

Linux travaille sur un système arborescent de fichier dont la racine
est `/`, le `/` étant le séparateur qui permet de marquer les niveaux
hiérarchiques. 

Cette arborescence est virtuelle ou *logique*, car elle ne correspond
pas à une hiérarchie physique. Certains de ses éléments sont montés à
une adresse précise, grâce au informations du fichier `/etc/fstab`.

## Noms et chemins de fichiers

Il existe deux *chemins* pour référencer un fichier :

1.  le chemin *absolu*, qui commence à la racine, par exemple `/etc/fstab`

2.  le chemin *relatif* où `.` représente le répertoire courant et
    `..` représente le répertoire parent. À partir du répertoire `/users/2006`, le
    nom relatif de `/etc/fstab` est `../../etc/fstab`.

Le nom d'un fichier (ex. `index.html`) comporte généralement une *extension* (ici `.html`).
Elle permet d'indiquer le type de contenu, même si cela n'est pas
obligatoire.

Le répertoire d'accueil de l'utilisateur, est noté `~`. Il s'agit du répertoire dans lequel est positionné le terminal à son lancement.

## Manipulations de fichiers

Le `shell` utilise la notion de répertoire courant, qui spécifie l'adresse dans
l'arborescence où les commandes seront exécutées.

Lorsque l'on décrit une commande, on écrit en général :

* le prompt, la plupart du temps un simple caractère dollar `$`, qui
  introduit la commande et indique qu'elle doit être saisie dans un
  terminal. On pourra trouver différents prompts, selon les contextes
  et les interpréteurs de commande, par ex. `#` est le prompt du
  super-utilisateur

* entre chevrons les paramètres obligatoires. Ex.

        cp <source> <destination>

* entre crochets les paramètres optionnels. Ex.

        ls [adresse]

* des options/paramètres de commande, introduites par un tiret `-`
  suivi d'une lettre (ex. `-l`) ou introduites par deux tirets `--`
  suivis d'un mot (ex. `ls --all` est équivalent à `ls -a`). En
  général, les options suivent le nom de la commande mais souvent on
  peut les mettre où on veut.

Il est bien évident que les commandes indiquées dans les supports par
les enseignants doivent être adaptées pour être effectives. Entre
autres, il faudra retirer les chevrons et crochet et remplacer les
indications fournies par les valeurs adéquates.

## Commandes indispensables

Ces commandes sont à connaître **par coeur**. Elles sont peu
nombreuses et seront d'autant plus rapidement apprises qu'elles seront
pratiquées régulièrement.

* `pwd` : affiche le répertoire courant
* `ls [option] <adresse>` : affiche les fichiers contenus à l'adresse. L'option `-l` affiche un format long (droits d'accès, propriétaire, taille, date). `-a` affiche tous les fichiers, même ceux qui commencent par le caractère *point*. Par défaut, `ls` n'affiche pas les fichiers commençant par un *point*, c'est comme cela que Linux implémente la notion de fichier caché.
* `cd [repertoire]` : change le répertoire courant. Sans argument, équivaut à `cd ~`. `cd -` retourne au répertoire courant précédent
* `mkdir <repertoire>` : crée un répertoire
* `rmdir <repertoire>` : détruit un répertoire s'il est vide
* `mv <source> <destination>` : déplace ou renomme un fichier ou un répertoire. Deux destinations particulières :
     - `.` : le répertoire courant
     - `..` : le répertoire parent du répertoire courant
* `mv <source1> [<source2> ...] <destination>` : déplace plusieurs sources dans une seule destination, nécessairement un répertoire. Si ce répertoire n'existe pas, il est créé.
* `cp <source> <destination>` : copie un fichier ou un répertoire. Avec l'option `-r` (`--recursive`), la copie est récursive, c'est-à-dire que c'est l'ensemble de l'arborescence source qui est copiée, avec ses sous répertoires
* `cp <source1> [<source2> ...] <destination>` : idem avec plusieurs sources.
* `rm <fichier1> [<fichier2> ...]` : détruit un fichier en demandant éventuellement une confirmation. Pour détruire un répertoire et son contenu, il faudra utiliser les options `-r` (`--recursive`) et `-f` (`--force`) pour outrepasser la demande de confirmation.
* `less <fichier>` : permet de visualiser le contenu d'un fichier. `q` pour quitter\; pour chercher un texte précis, appuyer sur la touche `/` et saisir le texte recherché puis valider,  passer d'un occurrence à l'autre avec `n` ou à la précédente avec `N`\ ; pour obtenir de l'aide, appuyer sur `h`

Bien noter que les commandes ci-dessus sont équivoques : elles peuvent fonctionner avec des sources et des destinations qui sont des fichiers ou des répertoires. Le résultat de la commande dépendra du contexte d'exécution.

## Commandes moins indispensables

* `touch <fichier>` : crée un fichier vide ou le met à l'heure actuelle s'il existe
* `ln -s <source> <cible>` : crée un lien symbolique (*raccourci* dans la dénomination Windows)
* `find . -name "*.txt"` : localise les fichiers dont le nom absolu contient `"*.txt"` à partir du répertoire\ `.`

## Obtenir de l'aide sur une commande

Une aide est disponible pour les commandes classiques en utilisant `man <commande>`. En particulier, ces pages de manuels expliquent les options des commandes.

Une aide souvent plus riche (en hyper-texte, permet la navigation entre les sections) est disponible avec `info <commande>`.

* Pour quitter ces commandes, appuyer sur `q`.
* Pour chercher un texte précis dans les pages de manuel, appuyer sur la touche `/` et saisir le texte recherché puis valider. Passer d'un occurrence à l'autre avec `n` ou à la précédente avec `N`.
* pour obtenir de l'aide, appuyer sur `h`.

# Expressions régulières

Lorsque l'interpréteur de commande analyse la commande de
l'utilisateur, certains caractères ont un rôle particulier et sont
utilisés pour remplacer d'autres caractères en faisant des
généralités. On parle de caractère *joker*, qui permettent de faire
correspondre (on dit également *matcher*) la commande saisie avec les
adresses (fichier ou répertoire) potentielles. Les expressions
utilisant des caractères joker sont appelées des *patrons* ou des
*expressions régulières* (en anglais\ : *pattern* ou *regular expression*) ou *regexp*.

Le principe est le suivant\ : si l'interpréteur détecte des caractères
joker, il va rechercher des correspondances dans les adresses qui lui
sont accessibles. Il remplace alors cette portion de la commande par
la liste des correspondances.

* `*` : remplace tous les caractères
* `?` : remplace un caractère
* `[aeiouy] : indique une voyelle. Les crochets définissent un caractère au choix parmi leur contenu
* `[^aeiouy]` : matche un caractère différent d'une voyelle

Ainsi, la commande `ls [st]?ell.p*[^f]` matchera avec tout fichier
dont le nom commence par `s` ou `t`, dont la troisième lettre est un `e`, les deux
suivantes un `l`, l'extension commence par `p` et ne termine pas par `f`. Le nom
`shell.ps` convient.

Il est important de bien comprendre que l'interpréteur modifie la
commande saisie par l'utilisateur en remplaçant les expressions
régulières par les possibilités de correspondances. S'il n'y a aucune
correspondance, la commande est appelée avec l'expression
régulière. Pour bien comprendre ce mécanisme, on peut préfixer la
commande avec `echo` (qui demande un affichage) pour visualiser les
correspondances considérées par l'interpréteur\ :

```
$ ls -1
cm1.md
exp1.sh
planning.md
td1.html
td1.md
$ ls -1 *
cm1.md
exp1.sh
planning.md
td1.html
td1.md
$ echo ls -1 *
ls -1 cm1.md exp1.sh planning.md td1.html td1.md
```

L'utilisation de guillemets `"..."` ou d'apostrophes (on utilise le mot anglais *quote*) `'...'` désactive la nature *joker* des caractères spéciaux\ :
```
$ ls '*'
ls: impossible d'accéder à '*': Aucun fichier ou dossier de ce type
$ ls "*"
ls: impossible d'accéder à '*': Aucun fichier ou dossier de ce type
```

# Raccourcis clavier

Certaines combinaisons de touches produisent un effet particulier dans l'interpréteur de commandes\ :

* `^A` (ou touche `Orig/Home`) : curseur en début de ligne
* `^C` : interrompt la commande en cours
* `^D` : termine le shell (équivaut à `exit`)
* `^E` (ou touche `End`) : curseur en fin de ligne
* `tab` : complétion de la commande en cours d'édition
* `^L` : efface le terminal
* $\uparrow,~\downarrow$ : commande précédente, suivante
* `^R` : recherche dans l'historique des commandes
* `^S` : gèle l'affichage
* `^Q` : dégèle l'affichage
* `^Z` : stoppe la commande courante. `bg` (*background*) envoie cette tâche en arrière plan, `fg` (*foreground*) la remet au premier plan
* `shift-PgUp/PgDown` : scroller dans la fenêtre du terminal

Noter en particulier le fameux `^S` qui gèle l'affichage. Cela peut
vous arriver de saisir malencontreusement cette combinaison de touches
et de constater que le terminal est inactif\ : il faut saisir `^Q`
pour le réactiver.

La touche de tabulation est la plus utile dans cette liste. L'appui
sur cette touche en cours de saisie d'un nom de commande ou de fichier
déclenche la complétion par l'interpréteur\ : s'il n'y a qu'une
complétion possible, l'interpréteur la remplit, sinon il n'affiche
rien et un second appui sur cette touche affiche la liste des
possibilités. Cette touche, outre de faire gagner du temps, évite de
nombreuses erreurs, en particulier sur les chemins de fichier. Noter
cependant que la complétion dépend de la commande lancée et du type de
fichier attendu\ : on n'obtiendra pas de réponse en complétion pour
ouvrir un fichier `.txt` avec `firefox` par exemple.

# Gestion de l'avant/arrière plan

Lorsque l'interpréteur lance une commande, il attend la fin de cette
commande avant de rendre la main à l'utilisateur. Si la commande est
longue, voire si la commande dépend de l'intervention de l'utilisateur
pour sa terminaison, on risque de paralyser le terminal. C'est par
exemple le cas lorsqu'on lance un éditeur de texte ou un navigateur.

La solution à ce problème est de lancer la commande *en arrière plan*,
en ajoutant le caractère `&` à la fin de la commande. Par exemple\ :

```
$ gedit &
```

Si malgré tout on a oublié le `&`, inutile de fermer le terminal (ce
qui en général interrompt les commandes lancées dans ce terminal), il
suffit d'appuyer sur `^Z` pour stopper la commande puis de la passer
en arrière-plan à l'aide de la commande `bg`.

```
$ gedit
^Z
[3]+  Arrêté                gedit
$ bg
[3]+ gedit &
```

# Usage de la souris

Dans cet environnement exclusivement textuel, la souris ne permet pas
d'indiquer la position du curseur de saisie, il faudra utiliser les
flèches directionnelles. En revanche, la souris peut être utilisée pour réaliser
des sélections (un *drag* en maintenant le bouton gauche appuyé). Sous
Linux, le contenu de cette sélection est *copié* dans le
tampon. L'appui sur le bouton du milieu simule la saisie au clavier du
contenu du *buffer* (équivalent d'un *coller*). Attention au
comportement de ce mécanisme en présence de caractères accentués.

Dans le terminal, on peut également utiliser les raccourci `shift-^C`
pour copier, `shift-^V` pour coller.

# Archivage

Il est souvent nécessaire de rassembler plusieurs fichiers, voire une
arborescence, en un seul fichier. C'est le rôle de la commande `tar`
(*tape archive*).

Une commande `tar` se déroule comme suit\ :

```
$ tar <sous-commande> <argument1> [<argument2> ...]
```

Les *sous-commandes* de `tar` sont (et ne sont pas précédées d'un tiret)\ :

* `c` : création de l'archive
* `x` : extraction de l'archive
* `f` : indique qu'un nom de fichier d'archive est utilisé (c'est quasiment toujours le cas)
* `v` : activer le mode *bavard* (*verbose*) qui fournit des informations sur le processus d'archivage
* `z` : activer la compression
* `t` : afficher le contenu de l'archive

Les conventions veulent qu'un fichier d'archive ait l'extension `.tar`, et `.tar.gz` ou `.tgz` 
lorsqu'il est compressé. 

On se limitera finalement aux cas d'usages suivants\ :

```
## compresser le dossier devoir
$ tar cvfz devoir.tgz devoir
## compresser les dossier devoir1 et devoir2
$ tar cvfz devoir.tgz devoir1 devoir2
## extraire l'archive contenue dans devoir.tgz
$ tar xvfz devoir.tgz
```

La compression utilise l'utilitaire `gzip` :
```
$ tar cf md.tar *md
$ gzip md.tar 
md.tar:	 68.8% -- replaced with md.tar.gz
$ gunzip md.tar.gz
md.tar.gz:	 68.8% -- replaced with md.tar
```

# Prompt

Le prompt est le texte affiché par le terminal avant le curseur de saisie de la commande. La variable `PS1` définit le texte du prompt.
Par exemple :

```
N302L-G17P05:[l1-methodo]$ pwd
/export/home/rioultf/svn/l1-methodo
N302L-G17P05:[l1-methodo]$ echo $PS1
\h:[\W]$
N302L-G17P05:[l1-methodo]$ $ export PS1='\u@\h:[\w]$ '
rioultf@N302L-G17P05:[~/svn/l1-methodo]$ 
```

Ce prompt indique en général :

- le login de l'utilisateur\ : `\u`
- le nom de la machine sur laquelle tourne le terminal\ : `\h`
- le répertoire courant\ : `\W` pour le nom du répertoire, `\w` pour le chemin absolu 
- un caractère `$` termine traditionnellement le prompt lorsqu'on est un utilisateur standard, pour le super-utilisateur `root`, c'est traditionnellement un dièse `#`.

# Gestion de l'environnement graphique

Pour être à l'aise sur un écran, on prendra l'habitude de le séparer
en deux parties gauche et droite. L'une de ces parties contiendra
l'éditeur de code ou le sujet du travail, l'autre partie contiendra
une fenêtre permettant de visualiser le résultat de son travail, par
exemple un terminal ou un navigateur.

On passe d'une fenêtre à l'autre en naviguant dans la pile de fenêtres
à l'aide de la combinaison de touches `alt-Tab`.

Il est aisé de caler une fenêtre sur la moitié de l'écran\ : à l'aide
de la souris, on déplace la barre de fenêtre à mi-hauteur sur le côté
désiré. Le gestionnaire de fenêtre fait le reste. Cela marche
également pour obtenir le quart d'un écran\ : on déplace la barre de
fenêtre sur un coin de l'écran.

# Éditeur de texte

Il existe de nombreux éditeurs de code. Je conseille personnellement
`codium`, disponible sur les machines de l'université, qui prend en
charge la majorité des fonctionnalités\ : coloration syntaxique et
navigateur de fichier.

Pour des usages plus spécifiques (Java et C++), on pourra préférer `netbeans` ou `eclipse`.

Ces éditeurs graphiques ne dispensent pas de savoir utiliser les
éditeurs qui se contentent d'un terminal\ :

* `nano` : disponible sur tous les systèmes
* `vi` : disponible sur tous les systèmes mais à réserver aux plus aguéris
* `emacs` : pas disponible en standard mais éditeur historique classique très complet
* `jed` : un `emacs` léger
