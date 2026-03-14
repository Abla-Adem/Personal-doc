Voici la version enrichie de ton quiz Git pour **Obsidian**. J'ai ajouté l'analyse des propositions incorrectes pour chaque question afin de bien comprendre pourquoi elles ne conviennent pas dans le contexte donné.

---

# 🐙 Maîtrise de Git : Le Grand Quiz (30 Questions)

> [!abstract] Instructions
> 
> Cliquez sur la flèche à côté de **"Correction & Explication"** pour révéler la réponse. Ce quiz teste votre connaissance des commandes, des options de sécurité et de la gestion de l'historique.

---

### 🔧 Section 1 : Initialisation & Configuration

**Q1 : Quelle commande permet de créer un dépôt central (serveur) sans dossier de travail pour que les développeurs y poussent leur code ?**

1. `git init`
    
2. `git init --bare`
    
3. `git init --shared`
    
4. `git clone --server`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Un dépôt `--bare` ne contient que le contenu du dossier `.git`. C'est le format standard pour les serveurs (GitHub/GitLab) car personne n'y édite de fichiers directement.
>     
> - **Pourquoi la 1 est fausse :** `git init` crée un répertoire de travail (working directory) destiné à l'édition de fichiers locaux.
>     
> - **Pourquoi la 3 est fausse :** `--shared` définit les permissions d'accès au dépôt pour plusieurs utilisateurs mais ne supprime pas le dossier de travail.
>     
> - **Pourquoi la 4 est fausse :** Cette commande n'existe pas dans Git.
>     

**Q2 : Vous voulez configurer votre email pour TOUS les dépôts de votre ordinateur. Quelle option utilisez-vous ?**

1. `--local`
    
2. `--system`
    
3. `--global`
    
4. `--file`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `--global` écrit dans `~/.gitconfig` et s'applique à tous les projets de l'utilisateur actuel.
>     
> - **Pourquoi la 1 est fausse :** `--local` n'écrit que dans le dépôt actuel (`.git/config`).
>     
> - **Pourquoi la 2 est fausse :** `--system` s'applique à tous les utilisateurs de la machine (souvent `/etc/gitconfig`), ce qui est trop large.
>     
> - **Pourquoi la 4 est fausse :** `--file` permet de lire/écrire dans un fichier spécifique, mais n'est pas un niveau de configuration standard de Git.
>     

**Q3 : Comment renommer la branche par défaut (généralement `master`) en `main` dès l'initialisation du dépôt ?**

1. `git init --branch main`
    
2. `git init -b main`
    
3. `git init --initial-branch=main`
    
4. Toutes les réponses ci-dessus.
    

> [!check]- Correction & Explication
> 
> **Réponse : 4**
> 
> - **Justesse :** Les trois syntaxes sont des alias valides. `-b` est le raccourci de `--initial-branch`.
>     

---

### 📝 Section 2 : Gestion des fichiers & Staging

**Q4 : Quelle commande permet de voir quels fichiers seraient supprimés par `git clean` sans réellement les effacer ?**

1. `git clean -f`
    
2. `git clean -d`
    
3. `git clean -n`
    
4. `git clean -x`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `-n` (ou `--dry-run`) liste les fichiers qui vont être supprimés sans agir.
>     
> - **Pourquoi la 1 est fausse :** `-f` (force) exécute la suppression réelle.
>     
> - **Pourquoi la 2 est fausse :** `-d` indique à Git de supprimer aussi les dossiers vides non suivis.
>     
> - **Pourquoi la 4 est fausse :** `-x` supprime aussi les fichiers normalement ignorés par le `.gitignore`.
>     

**Q5 : Vous avez fait un `git add` sur un fichier par erreur. Comment le retirer de l'index (staging) sans perdre vos modifications dans le fichier ?**

1. `git rm --cached <fichier>`
    
2. `git restore --staged <fichier>`
    
3. `git reset <fichier>`
    
4. Toutes les réponses ci-dessus.
    

> [!check]- Correction & Explication
> 
> **Réponse : 4**
> 
> - **Justesse :** Toutes ces commandes permettent de "désindexer" le fichier tout en gardant le contenu sur le disque. `restore --staged` est la recommandation moderne.
>     

**Q6 : Quelle option de `git commit` permet de modifier le message du tout dernier commit effectué ?**

1. `--fix`
    
2. `--amend`
    
3. `--edit`
    
4. `--update`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `--amend` remplace le dernier commit par un nouveau contenant vos changements actuels ou un message modifié.
>     
> - **Pourquoi la 1 est fausse :** `--fix` n'est pas une option standard (souvent confondue avec `fixup` en rebase interactif).
>     
> - **Pourquoi la 3 est fausse :** `--edit` (ou `-e`) est utilisé pour ouvrir l'éditeur, mais ne permet pas de modifier un commit passé seul.
>     
> - **Pourquoi la 4 est fausse :** Cette option n'existe pas pour la commande `commit`.
>     

**Q7 : Quelle est la différence entre `git add .` et `git add -u` ?**

1. Aucune.
    
2. `.` ajoute les nouveaux fichiers, `-u` ne traite que les fichiers déjà suivis.
    
3. `-u` ajoute tout, `.` seulement le dossier courant.
    
4. `.` est plus rapide.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `-u` (update) ignore les fichiers "untracked".
>     
> - **Pourquoi la 1 est fausse :** `.` inclut les nouveaux fichiers alors que `-u` ne le fait pas.
>     
> - **Pourquoi la 3 est fausse :** C'est l'inverse : `.` ajoute tout le contenu du dossier courant, incluant les nouveaux fichiers.
>     
> - **Pourquoi la 4 est fausse :** La vitesse n'est pas le critère de distinction.
>     

---

### 🌿 Section 3 : Branches & Fusions

**Q8 : Quelle est la différence majeure entre `git switch` et `git checkout` pour changer de branche ?**

1. `switch` est plus rapide.
    
2. `checkout` peut aussi restaurer des fichiers, `switch` est dédié uniquement aux branches.
    
3. `switch` ne fonctionne que sur les serveurs.
    
4. `checkout` est obsolète.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `switch` a été créé pour éviter la confusion de `checkout` qui servait à la fois à changer de branche et à écraser des fichiers locaux.
>     
> - **Pourquoi la 1 est fausse :** Ils ont la même performance.
>     
> - **Pourquoi la 3 est fausse :** Les deux sont des commandes locales.
>     
> - **Pourquoi la 4 est fausse :** `checkout` n'est pas obsolète mais "déconseillé" aux débutants pour limiter les erreurs.
>     

**Q9 : Vous voulez fusionner la branche `feature` dans `main` mais en gardant un historique linéaire (sans commit de merge). Quelle technique utilisez-vous ?**

1. `git merge --no-ff`
    
2. `git rebase main` depuis la branche `feature`.
    
3. `git cherry-pick`
    
4. `git branch -m`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Rebaser permet de réécrire l'historique de `feature` au-dessus de `main` pour permettre une fusion "Fast-forward".
>     
> - **Pourquoi la 1 est fausse :** `--no-ff` force justement la création d'un commit de merge, brisant la linéarité.
>     
> - **Pourquoi la 3 est fausse :** `cherry-pick` copie des commits un par un, c'est fastidieux pour toute une branche.
>     
> - **Pourquoi la 4 est fausse :** `-m` sert uniquement à renommer une branche.
>     

**Q10 : Que fait l'option `--squash` lors d'un `git merge` ?**

1. Elle compresse les fichiers pour prendre moins de place.
    
2. Elle fusionne tous les commits de la branche source en un seul commit unique sur la branche cible.
    
3. Elle supprime la branche source après fusion.
    
4. Elle ignore les conflits.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Cela permet de condenser 50 petits commits de développement en un seul propre sur `main`.
>     
> - **Pourquoi la 1 est fausse :** Git ne compresse pas les fichiers via cette commande.
>     
> - **Pourquoi la 3 est fausse :** La branche source doit être supprimée manuellement après.
>     
> - **Pourquoi la 4 est fausse :** Les conflits doivent toujours être résolus manuellement.
>     

---

### 🔄 Section 4 : Synchronisation & Remotes

**Q11 : Quelle commande récupère les données du serveur mais ne modifie pas vos fichiers locaux ?**

1. `git pull`
    
2. `git fetch`
    
3. `git update`
    
4. `git clone`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `fetch` télécharge les objets et les références, mais ne touche pas à votre `working directory`.
>     
> - **Pourquoi la 1 est fausse :** `pull` fait un `fetch` puis un `merge` automatique qui modifie vos fichiers.
>     
> - **Pourquoi la 3 est fausse :** `update` n'est pas une commande Git standard (souvent utilisée dans SVN).
>     
> - **Pourquoi la 4 est fausse :** `clone` crée un tout nouveau dépôt et fait un checkout initial.
>     

**Q12 : Vous voulez envoyer une branche locale vers le serveur pour la première fois. Quelle option crée le lien de suivi (tracking) ?**

1. `--first-time`
    
2. `-u` (ou `--set-upstream`)
    
3. `--link`
    
4. `-f`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `-u` lie la branche locale à la branche distante pour faciliter les futurs `pull` et `push`.
>     
> - **Pourquoi la 1/3 sont fausses :** Ce ne sont pas des options valides pour `push`.
>     
> - **Pourquoi la 4 est fausse :** `-f` (force) écrase l'historique distant sans créer de lien de suivi.
>     

**Q13 : Quelle est la différence entre `--force` et `--force-with-lease` lors d'un push ?**

1. Aucune, ce sont des alias.
    
2. `--force-with-lease` est plus dangereux.
    
3. `--force-with-lease` échoue si quelqu'un d'autre a poussé des commits sur le serveur entre-temps.
    
4. `--force` vérifie les permissions.
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** C'est une sécurité qui vérifie que votre version locale du serveur est à jour avant d'écraser.
>     
> - **Pourquoi la 1 est fausse :** Ce sont deux comportements différents.
>     
> - **Pourquoi la 2 est fausse :** Au contraire, c'est l'option la plus sûre des deux.
>     
> - **Pourquoi la 4 est fausse :** `force` ignore l'état du serveur ; la vérification des permissions est gérée par le serveur lui-même, pas par l'option.
>     

---

### 🔍 Section 5 : Historique & Débogage

**Q14 : Quel outil permet de trouver par recherche binaire le commit exact qui a introduit un bug ?**

1. `git blame`
    
2. `git grep`
    
3. `git bisect`
    
4. `git reflog`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `bisect` découpe l'historique en deux pour identifier rapidement le commit coupable.
>     
> - **Pourquoi la 1 est fausse :** `blame` montre qui a modifié une ligne, mais pas si la ligne est buggée.
>     
> - **Pourquoi la 2 est fausse :** `grep` cherche du texte, pas un changement d'état (bug).
>     
> - **Pourquoi la 4 est fausse :** `reflog` est un journal des mouvements de HEAD, pas un outil de débogage de code.
>     

**Q15 : Quelle commande affiche qui a modifié chaque ligne d'un fichier pour la dernière fois ?**

1. `git show`
    
2. `git log --author`
    
3. `git blame`
    
4. `git status`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `blame` annote chaque ligne d'un fichier avec l'auteur et le commit.
>     
> - **Pourquoi la 1 est fausse :** `show` affiche les détails d'un seul objet (souvent un commit).
>     
> - **Pourquoi la 2 est fausse :** `log --author` filtre les commits d'un auteur mais ne détaille pas les lignes de fichiers.
>     
> - **Pourquoi la 4 est fausse :** `status` montre l'état actuel (modifié/stagé) des fichiers.
>     

**Q16 : Vous avez supprimé une branche par erreur ou fait un reset hard. Comment retrouver le SHA-1 du commit perdu ?**

1. `git log`
    
2. `git reflog`
    
3. `git fsck`
    
4. `git status`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `reflog` garde trace de toutes les actions, même celles qui ne sont plus dans l'historique visible.
>     
> - **Pourquoi la 1 est fausse :** `log` ne montre que les commits accessibles depuis la branche actuelle.
>     
> - **Pourquoi la 3 est fausse :** `fsck` vérifie l'intégrité de la base de données, mais n'est pas l'outil primaire pour naviguer dans l'historique perdu.
>     
> - **Pourquoi la 4 est fausse :** `status` ne montre que les changements non commités.
>     

---

### 📦 Section 6 : Sous-modules & Archivage

**Q17 : Après avoir cloné un projet contenant des sous-modules, quelle commande les télécharge réellement ?**

1. `git pull --sub`
    
2. `git submodule init` suivi de `git submodule update`
    
3. `git submodule install`
    
4. `git get-sub`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `init` enregistre les chemins et `update` récupère le contenu.
>     
> - **Pourquoi la 1/3/4 sont fausses :** Ce ne sont pas des commandes Git existantes.
>     

**Q18 : Vous voulez créer un fichier .zip de votre code sans inclure le dossier .git. Quelle commande utilisez-vous ?**

1. `git export`
    
2. `git zip`
    
3. `git archive`
    
4. `tar -czf`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `archive` crée un package du contenu du dépôt à un état précis sans les métadonnées Git.
>     
> - **Pourquoi la 1/2 sont fausses :** Commandes inexistantes.
>     
> - **Pourquoi la 4 est fausse :** `tar` est un outil système qui inclurait le dossier `.git` s'il est présent dans le répertoire.
>     

---

### ⚠️ Section 7 : Annulation & Correction

**Q19 : Quelle est la différence entre `git reset --soft` et `git reset --hard` ?**

1. `--soft` supprime les fichiers, `--hard` les garde.
    
2. `--soft` annule le commit mais garde vos changements dans l'index. `--hard` détruit tout changement non committé.
    
3. Ils sont identiques si on ne spécifie pas de fichier.
    
4. `--soft` demande une confirmation.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `--hard` réinitialise tout (index + working directory) alors que `--soft` ne touche qu'à l'historique.
>     
> - **Pourquoi la 1 est fausse :** C'est exactement l'inverse.
>     
> - **Pourquoi la 3 est fausse :** Ils ont des effets très différents sur votre travail en cours.
>     
> - **Pourquoi la 4 est fausse :** Git ne demande jamais de confirmation par défaut.
>     

**Q20 : Comment annuler un commit déjà partagé sur un serveur public sans réécrire l'historique (pour ne pas perturber les collègues) ?**

1. `git reset --hard`
    
2. `git revert <commit>`
    
3. `git checkout HEAD^`
    
4. `git commit --amend`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `revert` crée un nouveau commit "inverse", ce qui est sûr pour le travail collaboratif.
>     
> - **Pourquoi la 1/4 sont fausses :** Ces commandes réécrivent l'historique, ce qui est interdit sur une branche partagée (risque de conflits majeurs pour les autres).
>     
> - **Pourquoi la 3 est fausse :** Cela déplace juste votre `HEAD` mais ne crée pas d'annulation officielle.
>     

**Q21 : Vous travaillez sur une tâche mais devez changer de branche en urgence sans committer votre travail inachevé. Quelle commande sauve vos modifs de côté ?**

1. `git save`
    
2. `git cache`
    
3. `git stash`
    
4. `git pause`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `stash` met vos modifications dans une pile temporaire.
>     
> - **Pourquoi la 1/2/4 sont fausses :** Commandes inexistantes.
>     

---

### ⚙️ Section 8 : Maintenance & Divers

**Q22 : Quelle commande Git permet de nettoyer les fichiers inutiles et d'optimiser la base de données locale ?**

1. `git clean`
    
2. `git prune`
    
3. `git gc` (Garbage Collect)
    
4. `git optimize`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `gc` compresse l'historique et nettoie les objets orphelins.
>     
> - **Pourquoi la 1 est fausse :** `clean` supprime les fichiers non suivis du disque.
>     
> - **Pourquoi la 2 est fausse :** `prune` supprime les objets orphelins mais fait partie de `gc`.
>     
> - **Pourquoi la 4 est fausse :** Commande inexistante.
>     

**Q23 : Comment vérifier l'URL du dépôt distant configuré sous le nom `origin` ?**

1. `git remote -v`
    
2. `git remote show origin`
    
3. Les deux réponses ci-dessus.
    
4. `git config --remote`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `-v` donne les URL brutes, `show origin` donne un rapport détaillé.
>     
> - **Pourquoi la 4 est fausse :** `git config --remote` n'est pas la syntaxe correcte.
>     

**Q24 : Que fait la commande `git cherry-pick <SHA>` ?**

1. Elle sélectionne le meilleur auteur du projet.
    
2. Elle applique un commit spécifique d'une autre branche sur la branche actuelle.
    
3. Elle supprime les branches inutiles.
    
4. Elle trie les fichiers par taille.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Permet de ramener un correctif précis sans fusionner toute une branche.
>     
> - **Pourquoi la 1/3/4 sont fausses :** Ce sont des définitions fantaisistes.
>     

---

### 🕵️ Section 9 : Cas Avancés (Hors cours direct)

**Q25 : Dans .gitignore, comment ignorer tous les fichiers .log sauf le fichier important.log ?**

1. `*.log` et `!important.log`
    
2. `*.log` et `keep important.log`
    
3. `ignore all .log`
    
4. C'est impossible.
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** Le `!` est l'opérateur de négation dans le `.gitignore`.
>     

**Q26 : Quelle commande affiche un historique très compact avec un graphique des branches en ASCII ?**

1. `git log --pretty`
    
2. `git log --oneline --graph --all`
    
3. `git show-branches`
    
4. `git branch --tree`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** C'est la commande de visualisation standard.
>     
> - **Pourquoi la 1 est fausse :** `--pretty` nécessite un format spécifique après pour être utile.
>     
> - **Pourquoi la 3/4 sont fausses :** Commandes inexistantes.
>     

**Q27 : Qu'est-ce qu'un "Détached HEAD" ?**

1. Un bug critique de Git.
    
2. Un état où vous n'êtes sur aucune branche, mais sur un commit spécifique.
    
3. Un utilisateur sans droits d'accès.
    
4. Un commit sans message.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Arrive quand on fait un `checkout` sur un commit ou un tag plutôt que sur une branche.
>     
> - **Pourquoi la 1 est fausse :** Ce n'est pas un bug, c'est un comportement normal pour explorer le passé.
>     
> - **Pourquoi la 3/4 sont fausses :** Définitions fausses.
>     

**Q28 : Comment changer l'éditeur de texte par défaut utilisé par Git (ex: passer de Vim à Nano) ?**

1. `git config --global core.editor nano`
    
2. `git set editor nano`
    
3. C'est impossible, Git utilise Vim par défaut.
    
4. Modifier le fichier .git/editor
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** `core.editor` est la clé de configuration correcte.
>     

**Q29 : Que fait `git diff --cached` ?**

1. Compare le dossier de travail et le dernier commit.
    
2. Compare l'index (staging area) et le dernier commit.
    
3. Compare deux branches distantes.
    
4. Supprime le cache Git.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Permet de voir ce que l'on va réellement committer.
>     
> - **Pourquoi la 1 est fausse :** C'est le rôle de `git diff` sans option.
>     

**Q30 : Vous voulez chercher le mot "API_KEY" dans tout l'historique de tous les fichiers committés. Quel outil est le plus adapté ?**

1. `git grep`
    
2. `git log -S "API_KEY"`
    
3. `git find`
    
4. `git status`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** L'option `-S` (pickaxe) cherche les commits où le nombre d'occurrences d'une chaîne change.
>     
> - **Pourquoi la 1 est fausse :** `grep` cherche dans l'état actuel des fichiers, pas dans l'historique complet.
>     

---

### 💡 Conclusion

Si vous avez obtenu plus de 25/30, vous avez une excellente maîtrise des workflows Git. Pour Obsidian, n'oubliez pas d'utiliser le mode Lecture pour profiter des Callouts repliables !