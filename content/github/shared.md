## Qu’est-ce que ça fait ?

- Quand tu clones un dépôt avec l’option `-shared`, Git ne copiera **pas tous les objets** (commits, fichiers, etc.) dans ton nouveau dépôt local.
- À la place, il utilise un mécanisme appelé **alternates**, qui fait en sorte que ton nouveau dépôt va **référencer et partager (cacher) les objets existants** dans le dépôt source.
- Cela signifie que tes deux dépôts **partagent les mêmes objets Git en mémoire/disque**, sans dupliquer les données.
- Cela économise beaucoup d’espace disque et accélère le clonage, car il n’y a pas besoin de copier les données déjà présentes.

## Comment ça marche techniquement ?

- Dans le dossier `.git/objects/info/alternates` de ton dépôt cloné, il y a un fichier texte contenant le chemin vers le dépôt source.
- Lorsque Git a besoin d’un objet (commit, blob, arbre), il regarde d’abord dans ce dépôt local, puis dans le dépôt indiqué dans les alternates.
- Si un objet existe dans le dépôt source, il ne sera pas copié dans le clone, mais simplement utilisé à partir du dépôt source.

## Commande d’exemple

`bashgit clone --shared /chemin/vers/depot-source /chemin/vers/nouveau-clone`

- Clonera le dépôt en partageant les objets avec le dépôt source pour éviter les duplications.
- Utile pour créer de nombreux clones légers sur la même machine ou réseau.

## Important

- Le clone avec `-shared` est **indépendant**, mais dépend des objets présents dans le dépôt source tant qu’ils ne sont pas copiés.
- Si tu veux que ton clone soit totalement autonome sans dépendance au dépôt source, il faut lancer un `git repack` ou un `git gc` pour copier les objets.

## Résumé

|Option|Fonction|Utilité|
|---|---|---|
|`git clone`|Clone classique avec copie complète des objets Git|Pour un clone totalement autonome|
|`git clone --shared`|Clone qui partage les objets avec le dépôt source|Gain d’espace et rapidité sur local|

Veux-tu que je te montre comment vérifier l’utilisation des alternates dans ton clone ou comment casser la dépendance pour rendre le clone autonome ?

1. [https://git-scm.com/docs/git-clone/fr](https://git-scm.com/docs/git-clone/fr)
2. [https://docs.github.com/fr/repositories/creating-and-managing-repositories/cloning-a-repository](https://docs.github.com/fr/repositories/creating-and-managing-repositories/cloning-a-repository)
3. [https://www.editions-eni.fr/livre/git-maitrisez-la-gestion-de-vos-versions-concepts-utilisation-et-cas-pratiques-4e-edition-9782409039621/partager-un-depot](https://www.editions-eni.fr/livre/git-maitrisez-la-gestion-de-vos-versions-concepts-utilisation-et-cas-pratiques-4e-edition-9782409039621/partager-un-depot)
4. [https://www.atlassian.com/fr/git/tutorials/setting-up-a-repository/git-clone](https://www.atlassian.com/fr/git/tutorials/setting-up-a-repository/git-clone)
5. [https://www.ionos.fr/digitalguide/sites-internet/developpement-web/git-clone/](https://www.ionos.fr/digitalguide/sites-internet/developpement-web/git-clone/)
6. [https://perso.mines-albi.fr/~gaborit/lang/gitmagic/ch03.html](https://perso.mines-albi.fr/~gaborit/lang/gitmagic/ch03.html)
7. [https://www.it-connect.fr/chapitres/git-travailler-en-local-sur-un-depot-github/](https://www.it-connect.fr/chapitres/git-travailler-en-local-sur-un-depot-github/)
8. [https://git-scm.com/book/fr/v2/Les-bases-de-Git-Travailler-avec-des-dépôts-distants](https://git-scm.com/book/fr/v2/Les-bases-de-Git-Travailler-avec-des-d%C3%A9p%C3%B4ts-distants)
9. [https://blog.stephane-robert.info/docs/developper/version/git/](https://blog.stephane-robert.info/docs/developper/version/git/)
10. [https://docs.github.com/fr/repositories/creating-and-managing-repositories/transferring-a-repository](https://docs.github.com/fr/repositories/creating-and-managing-repositories/transferring-a-repository)