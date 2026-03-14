Voici l'explication détaillée et enrichie de l'option `--no-hardlinks` dans la commande `git clone` :

## Option `-no-hardlinks` dans `git clone`

## Que fait cette option ?

- Par défaut, lors d'un clonage local (depuis un dépôt sur la même machine), Git tente d'optimiser le clonage en créant des **hardlinks** pour les fichiers dans le dossier `.git/objects`.
- Un **hardlink** est une référence supplémentaire sur le même fichier physique sur le disque, ce qui signifie qu'il n'y a pas de duplication des données, ce qui économise de l'espace disque et accélère le clonage.
- Lorsque tu utilises l'option `-no-hardlinks`, Git **préfère copier complètement ces fichiers** au lieu de créer des hardlinks.
- On utilise cette option généralement pour faire une **sauvegarde complète et indépendante** du dépôt, ou quand tu veux éviter que les modifications dans un clone puissent affecter un autre clone ou le dépôt source (dans le cas rare où tu modifierais directement des fichiers objets, ce qui est déconseillé).

## Que se passe-t-il avec les fichiers source (le code) ?

- Git n'utilise pas de hardlinks pour les fichiers sources dans le répertoire de travail.
- Les fichiers sources sont toujours copiés indépendamment dans chaque clone, sans hardlinks entre clones.
- Les hardlinks sont utilisés uniquement pour les objets Git (fichiers immuables comme commits, blobs, etc.) dans le dossier `.git/objects`.

## Quelles sont les conséquences si tu modifies un fichier lié par hardlink ?

- En théorie, si tu modifies directement un fichier objet Git qui est hardlinké (chose très déconseillée), la modification serait visible dans tous les clones partageant ce hardlink, ce qui peut corrompre les dépôts.
- Heureusement, Git ne modifie jamais ces fichiers objets : ils sont immuables. Lorsqu’un objet change, Git crée un nouveau fichier.
- Ainsi, en pratique, les hardlinks sont sûrs car les objets sont en lecture seule et immuables.

## Exemple d'utilisation

`bashgit clone --no-hardlinks /chemin/vers/depot-local /chemin/vers/nouveau-clone`

- Clone complet avec copie physique des objets, sans hardlinks.
- Utile quand tu veux un clone totalement indépendant du dépôt source.

## Résumé

|Option|Effet|Usage principal|
|---|---|---|
|Sans `--no-hardlinks`|Hardlinks utilisés pour économiser l’espace disque|Clone rapide, léger, clones locaux|
|Avec `--no-hardlinks`|Copie complète des fichiers objets sans hardlinks|Clone autonome, sauvegarde|

Veux-tu que je t’explique comment vérifier si un clone utilise des hardlinks ou comment transformer un clone utilisant des hardlinks en clone autonome ?

1. [https://git-scm.com/docs/git-clone](https://git-scm.com/docs/git-clone)
2. [https://www.developpez.net/forums/d1240154/general-developpement/alm/usine-logicielle/scm/git/clone-no-hardlinks/](https://www.developpez.net/forums/d1240154/general-developpement/alm/usine-logicielle/scm/git/clone-no-hardlinks/)
3. [https://git-scm.com/docs/git-clone/2.11.4](https://git-scm.com/docs/git-clone/2.11.4)
4. [https://git-scm.com/docs/git-clone/fr](https://git-scm.com/docs/git-clone/fr)
5. [https://manpages.ubuntu.com/manpages/jammy/man1/git-clone.1.html](https://manpages.ubuntu.com/manpages/jammy/man1/git-clone.1.html)
6. [https://stackoverflow.com/questions/11331324/git-clone-how-to-clone-local-repo-by-hardlinks](https://stackoverflow.com/questions/11331324/git-clone-how-to-clone-local-repo-by-hardlinks)
7. [https://stackoverflow.com/questions/12501145/local-shallow-git-cloning-with-hard-links](https://stackoverflow.com/questions/12501145/local-shallow-git-cloning-with-hard-links)
8. [https://github.com/git/git/security/advisories/GHSA-3wp6-j8xr-qw85](https://github.com/git/git/security/advisories/GHSA-3wp6-j8xr-qw85)