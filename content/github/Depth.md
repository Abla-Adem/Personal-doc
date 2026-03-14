L’option `--depth` avec `git clone` permet de faire ce qu’on appelle un **shallow clone** (clone peu profond) :

tu limites la quantité d’historique téléchargé.

## À quoi sert `-depth` ?

- **Par défaut** :
    
    `git clone` télécharge tout l’historique du repo (tous les commits depuis le début).
    
- **Avec `-depth N`** :
    
    Git **ne télécharge que les N derniers commits** de la branche clonée.
    
- **Très utilisé pour** :
    
    - Accélérer le clonage d’un gros repo,
    - Gagner de l’espace disque,
    - Les pipelines CI/CD ou les scripts où seul l’état actuel du projet compte, pas tout l’historique[1](https://stackoverflow.com/questions/53683896/what-does-depth-for-git-clone-mean)[2](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-and-when-to-perform-a-depth-1-git-clone).

## Exemple :

`bashgit clone --depth 1 <https://github.com/monuser/projet.git`>

- Cela va rapatrier UNIQUEMENT le dernier commit de la branche principale et les fichiers à ce moment-là.
- Impossible de naviguer dans l’historique profond ou de changer facilement de branche sans refaire une synchronisation plus complète.

## Fonctionnement et limites

- Tu obtiens **une copie “superficielle”** du repo, sans le passé complet :
    - Tu peux modifier, commit, push comme d’habitude,
    - Mais tu ne peux pas lire l’historique complet (`git log` sera limité),
    - Les opérations sur d’autres branches ou commits “anciens” sont inaccessibles.
- Si tu veux plus de commits plus tard, tu peux “prolonger” le clône avec `git fetch --unshallow` ou augmenter la profondeur.

## Résumé

|Commande|Comportement|Cas d’usage|
|---|---|---|
|`git clone`|Clone TOUT l’historique du repo|Développement normal|
|`git clone --depth 1`|Clone SEULEMENT le dernier commit|CI, build rapide, test|
|`git clone --depth N`|Clone les N derniers commits|Optimisation, anciens projets volumineux|

**En résumé** :

L’option `--depth` sert à cloner rapidement un repo en ne prenant que les N derniers états, ce qui est utile pour tester, construire ou explorer un projet sans s’intéresser à tout son passé[1](https://stackoverflow.com/questions/53683896/what-does-depth-for-git-clone-mean)[2](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-and-when-to-perform-a-depth-1-git-clone)[3](https://labex.io/tutorials/git-how-to-clone-git-repo-with-depth-419164)[4](https://forums.freebsd.org/threads/git-deep-clone-vs-shallow-clone.80002/).

1. [https://stackoverflow.com/questions/53683896/what-does-depth-for-git-clone-mean](https://stackoverflow.com/questions/53683896/what-does-depth-for-git-clone-mean)
2. [https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-and-when-to-perform-a-depth-1-git-clone](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-and-when-to-perform-a-depth-1-git-clone)
3. [https://labex.io/tutorials/git-how-to-clone-git-repo-with-depth-419164](https://labex.io/tutorials/git-how-to-clone-git-repo-with-depth-419164)
4. [https://forums.freebsd.org/threads/git-deep-clone-vs-shallow-clone.80002/](https://forums.freebsd.org/threads/git-deep-clone-vs-shallow-clone.80002/)
5. [https://git-scm.com/docs/git-clone](https://git-scm.com/docs/git-clone)
6. [https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-clone](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-clone)
7. [https://git-scm.com/docs/git-clone/fr](https://git-scm.com/docs/git-clone/fr)
8. [https://www.youtube.com/watch?v=HnQCcri5hLc](https://www.youtube.com/watch?v=HnQCcri5hLc)