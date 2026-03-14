L’option `--no-single-branch` dans `git clone` agit sur le comportement du clonage lié aux branches récupérées lorsque l’on utilise aussi l’option `--depth` (clone superficiel).

## Explication claire de `-no-single-branch`

- Par défaut, quand on fait un clone normal, Git récupère **toutes les branches** du dépôt distant et crée une référence pour chacune.
- Quand on utilise `-depth` (shallow clone), Git active aussi implicitement `-single-branch`, ce qui fait que **seule la branche principale clonée est récupérée**, et les autres branches ne sont pas téléchargées.
- En mettant l’option `-no-single-branch` avec un clone shallow (`-depth`), tu dis à Git de récupérer **les N derniers commits** de **toutes les branches**, pas seulement de la branche principale.
- Cela permet d’avoir un clone « léger » (peu profond, limité en historique), mais avec toutes les branches principales accessibles et mises à jour.

## Exemple d’utilisation

`bashgit clone --depth 10 --no-single-branch <https://github.com/user/repo.git`>

- Clone les 10 derniers commits des **toutes les branches** du dépôt.
- Sans `-no-single-branch`, uniquement la branche principale serait clonée avec les 10 derniers commits.

## Pourquoi c’est utile ?

- Ça t’offre un compromis entre :
    - un clone léger en historique (-depth),
    - et la possibilité d’avoir toutes les branches disponibles pour exploration ou travail.

## Résumé

|Option|Effet|
|---|---|
|`--single-branch` (par défaut avec `--depth`)|Clone peu profond, mais **seulement 1 branche**|
|`--no-single-branch` + `--depth`|Clone peu profond, mais **toutes les branches**|

Si tu souhaites, je peux te montrer des cas concrets avec plusieurs branches et l’impact des options sur la récupération.

1. [https://git-scm.com/docs/git-clone](https://git-scm.com/docs/git-clone)
2. [https://stackoverflow.com/questions/48868396/purpose-of-single-branch-in-git-clone](https://stackoverflow.com/questions/48868396/purpose-of-single-branch-in-git-clone)
3. [https://git-scm.com/docs/git-clone/2.21.0](https://git-scm.com/docs/git-clone/2.21.0)
4. [https://github.blog/open-source/git/get-up-to-speed-with-partial-clone-and-shallow-clone/](https://github.blog/open-source/git/get-up-to-speed-with-partial-clone-and-shallow-clone/)
5. [https://manpages.debian.org/testing/git-man/git-clone.1.en.html](https://manpages.debian.org/testing/git-man/git-clone.1.en.html)
6. [https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-clone](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-clone)
7. [https://github.com/travis-ci/travis-ci/issues/4806](https://github.com/travis-ci/travis-ci/issues/4806)
8. [https://github.com/go-git/go-git/issues/249](https://github.com/go-git/go-git/issues/249)
9. [https://git-scm.com/docs/git-clone/fr](https://git-scm.com/docs/git-clone/fr)