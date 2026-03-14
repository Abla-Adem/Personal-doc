L’option `--recursive` dans la commande `git clone` sert à gérer automatiquement les **sous-modules** du dépôt que tu clones.

## Qu’est-ce qu’un sous-module Git ?

- Un **sous-module** est un dépôt Git imbriqué dans un autre dépôt Git.
- Cela permet d’inclure un projet Git dans un autre, tout en conservant son historique et sa gestion indépendamment.

## Que fait `git clone --recursive` ?

- Cette option va **cloner le dépôt principal** **et** initialiser automatiquement tous ses sous-modules,
- Elle les met à jour pour qu’ils soient à la bonne version référencée par le dépôt principal,
- Le clonage est donc plus complet et prêt à être utilisé tel quel, sans que tu aies à faire de commandes supplémentaires.

## Sans `-recursive`

- Si tu fais un `git clone` classique sur un dépôt qui contient des sous-modules,
    
- le dépôt sera cloné, mais les dossiers des sous-modules seront vides, manquants ou non initialisés,
    
- tu devras ensuite lancer manuellement :
    
    `bashgit submodule update --init --recursive`
    
    pour récupérer les sous-modules.
    

## Exemple de commande

`bashgit clone --recursive <https://github.com/monutilisateur/monprojet.git`>

- Clone la totalité du dépôt avec tous ses sous-modules initialisés et mis à jour.

## Pourquoi utiliser cette option ?

- Gagne du temps à l’installation initiale,
- Évite les problèmes où un projet ne fonctionne pas car ses dépendances en sous-modules ne sont pas chargées,
- Facilite la gestion des projets complexes avec plusieurs dépendances Git.

Si tu veux, je peux te détailler comment ajouter, mettre à jour, ou supprimer des sous-modules dans un dépôt Git.L’option `--recursive` dans la commande `git clone` sert à cloner automatiquement un dépôt **et tous ses sous-modules**.

## Qu’est-ce que ça signifie ?

- Un **sous-module** est un dépôt Git imbriqué dans un autre dépôt Git.
- Sans `-recursive`, quand tu clones un dépôt qui contient des sous-modules, ces derniers ne sont pas clonés automatiquement, tu dois les initialiser et les mettre à jour manuellement.
- Avec `-recursive`, Git clone à la fois le dépôt principal **et tous les sous-modules**, même ceux imbriqués dans d'autres sous-modules (récursivement).

## Exemple d’utilisation

`bashgit clone --recursive <https://github.com/ton-projet/monrepo.git`>

- Cette commande va cloner le dépôt principal
- Puis initialiser et cloner tous ses sous-modules

## Pourquoi c’est utile ?

- Cela garantit que tu as toutes les dépendances externes (sous-modules) prêtes à l’emploi immédiatement.
- Évite d’avoir des dossiers vides ou manquants pour les sous-modules.
- Simplifie la gestion des projets avec plusieurs sous-projets intégrés.

## Si tu as déjà cloné sans `-recursive`

Tu peux récupérer les sous-modules ensuite avec :

`bashgit submodule update --init --recursive`

Si tu souhaites, je peux te guider aussi pour ajouter ou mettre à jour des sous-modules dans un dépôt existant.

1. [https://graphite.dev/guides/git-clone-recursively](https://graphite.dev/guides/git-clone-recursively)
2. [https://stackoverflow.com/questions/3796927/how-do-i-git-clone-a-repo-including-its-submodules](https://stackoverflow.com/questions/3796927/how-do-i-git-clone-a-repo-including-its-submodules)
3. [https://git-scm.com/docs/git-clone](https://git-scm.com/docs/git-clone)
4. [https://git-scm.com/book/fr/v2/Utilitaires-Git-Sous-modules](https://git-scm.com/book/fr/v2/Utilitaires-Git-Sous-modules)
5. [https://betterstack.com/community/questions/git-clone-repo-and-submodules/](https://betterstack.com/community/questions/git-clone-repo-and-submodules/)
6. [https://www.geeksforgeeks.org/git/how-to-clone-git-repositories-including-submodules/](https://www.geeksforgeeks.org/git/how-to-clone-git-repositories-including-submodules/)
7. [https://www.reddit.com/r/git/comments/f26qmf/difference_between_recursive_and_recursesubmodules/](https://www.reddit.com/r/git/comments/f26qmf/difference_between_recursive_and_recursesubmodules/)
8. [https://stackoverflow.com/questions/6474847/how-do-i-git-clone-recursive-and-checkout-master-on-all-submodules-in-a-single](https://stackoverflow.com/questions/6474847/how-do-i-git-clone-recursive-and-checkout-master-on-all-submodules-in-a-single)
9. [https://git-scm.com/docs/git-clone/fr](https://git-scm.com/docs/git-clone/fr)
10. [https://jon.sprig.gs/blog/post/1883](https://jon.sprig.gs/blog/post/1883)