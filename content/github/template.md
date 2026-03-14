L’option `--template=<répertoire>` lors d’un `git clone` permet d’indiquer un **répertoire contenant des fichiers modèles (templates)** qui seront utilisés lors de la création du dépôt cloné.

## À quoi sert l’option `-template` ?

- Lors de la création d’un nouveau dépôt (local ou clone), Git utilise par défaut un répertoire de templates qui contient des fichiers par défaut :
    - hooks (scripts qui s’exécutent à certains événements Git),
    - fichiers d’exclusion (`exclude`),
    - configurations par défaut, etc.
- Avec `-template=chemin`, tu peux **spécifier un répertoire personnalisé** où tu as placé tes propres hooks, fichiers d’exclusion, ou autres configurations à copier automatiquement dans le nouveau dépôt.
- Cette option est principalement utilisée pour **initialiser les nouveaux dépôts clonés avec des hooks personnalisés** ou des configurations spécifiques à ton équipe ou projet.

## Exemple d’utilisation

`bashgit clone --template=/chemin/vers/mon-template <https://github.com/user/projet.git`>

- Le dépôt cloné aura, dès le départ, les scripts hooks et les fichiers par défaut placés dans le répertoire `/chemin/vers/mon-template`.
- Cela évite d’avoir à copier manuellement ces fichiers à chaque nouveau clone.

## En résumé

- `-template` sert à **appliquer un modèle de configuration pré-défini** lors de la création d’un dépôt Git cloné.
- Utile pour standardiser les hooks ou règles d’exclusion dans tous les clones d’une équipe.
- Par défaut, Git utilise un répertoire système (par exemple `/usr/share/git-core/templates` sous Linux) si tu ne précises rien.

Veux-tu un exemple de ce que contient un répertoire template ou comment créer tes propres hooks pour ce cas ?

1. [https://git-scm.com/docs/git-clone](https://git-scm.com/docs/git-clone)
2. [https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-clone](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-clone)
3. [https://git-scm.com/docs/git-clone/fr](https://git-scm.com/docs/git-clone/fr)
4. [https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
5. [https://www.ionos.com/digitalguide/websites/web-development/git-clone/](https://www.ionos.com/digitalguide/websites/web-development/git-clone/)
6. [https://www.darrik.dev/writing/custom-git-template/](https://www.darrik.dev/writing/custom-git-template/)
7. [https://www.youtube.com/watch?v=3ZLoapBD01w](https://www.youtube.com/watch?v=3ZLoapBD01w)
8. [https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)
9. [https://stackoverflow.com/questions/5572772/how-can-i-use-git-for-projects-templates](https://stackoverflow.com/questions/5572772/how-can-i-use-git-for-projects-templates)