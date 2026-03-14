# **🔧 Initialisation & Configuration**

## **`git init`**

**Description :** Initialise un nouveau repository Git.

**Syntaxe :** **`git init [<directory>] [options]`**

Voici un tableau récapitulatif clair et structuré de la commande `git init` avec ses options principales et un exemple d’utilisation pour chacune :

| Option                                       | Description                                                                                   | Exemple                                    |
| -------------------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------------------------ |
|                                              | Initialise un repository Git dans le dossier courant (avec working directory).                | `git init`                                 |
| `--bare`                                     | Initialise un repository _bare_ sans working directory (uniquement les données internes Git). | `git init --bare monrepo.git`              |
| `--template=<répertoire>`                    | Utilise un répertoire de template personnalisé pour initialiser le dépôt (hooks, etc.).       | `git init --template=/chemin/templates`    |
| `--separate-git-dir=<répertoire>`            | Place le dossier `.git` ailleurs (hors du répertoire courant).                                | `git init --separate-git-dir=/chemin/.git` |
| `--shared[=valeur]`                          | Définit les permissions d’accès au dépôt (ex : privé, groupe, public, code octal).            | `git init --shared=group`                  |
| `-q`, `--quiet`                              | Mode silencieux, affiche uniquement les messages critiques ou erreurs.                        | `git init --quiet`                         |
| `-b <branche>`, `--initial-branch=<branche>` | Définit le nom de la branche initiale (ex : `main` ou `master`).                              | `git init --initial-branch=main`           |
| `--object-format=<format>`                   | Définit le format d’objet Git (sha1 par défaut, sha256 si activé).                            | `git init --object-format=sha256`          |
| `--ref-format=<format>`                      | Définit le format des références Git (`files` ou `reftable`).                                 | `git init --ref-format=reftable`           |

### Quelques précisions rapides :

- **`-bare`** : utile pour créer un dépôt central sans copie des fichiers, par exemple pour partager sur un serveur.
- **`-template`** : permet d’ajouter des hooks personnalisés ou fichiers de config au moment de l’initialisation.
- **`-shared`** : très utile sur un serveur ou dépôt multi-utilisateurs pour gérer permissions (ex : `group` pour accès en groupe).
- **`-initial-branch`** : important pour nommer la branche principale, souvent `main` de nos jours au lieu de `master`.

### Explications supplémentaires :

- **Repository bare** : Pas de copie des fichiers sources, uniquement le dossier `.git` à la racine. Utile comme dépôt central.
- **Template** : Permet d'ajouter des hooks ou fichiers par défaut à la création.
- **Separate git dir** : Sépare les données Git du code pour organiser le stockage.
- **Shared** : Pour contrôler qui peut accéder au repo.
- **Initial branch** : Moderne permettant de nommer la branche initiale (ex : `main` au lieu de `master`).
- **Object and ref formats** : Options avancées pour les mécanismes Git internes.

Exemple minimal pour un repo normal :

```jsx
git init
```

Exemple d’un repo bare pour serveur :

```jsx
git init --bare projet.git
```

Exemple avec template personnalisé :

```jsx
git init --template=/usr/share/git-core/templates/mytemplate
```

Exemple pour changer le nom de branche par défaut :

```jsx
git init -b main
```

## **`git config`**

**Description :** Configure les paramètres Git.

**Syntaxe :** **`git config [<file-option>] [type] [--show-origin] [-z|--null] name [value]`**
[[Référence Complète des Sections et Variables de Configuration Git (git config)]]
Voici un tableau récapitulatif de la commande `git config` avec ses options principales accompagnées d'exemples :

|Option|Description|Exemple|
|---|---|---|
|_(sans option)_|Affiche la valeur d'une clé spécifique, ou liste toute la configuration si aucune clé spécifiée|`git config user.name`|
|`--global`|Applique la configuration au niveau global (`~/.gitconfig`)|`git config --global user.email "user@example.com"`|
|`--system`|Applique la configuration au niveau système (/etc/gitconfig ou fichier global)|`git config --system core.editor "vim"`|
|`--local`|Applique la configuration uniquement au dépôt courant (fichier `.git/config`)|`git config --local color.ui true`|
|`--worktree`|Applique la configuration au niveau du worktree (git 2.13+)|`git config --worktree user.name "Worktree User"`|
|`--file <fichier>`|Utilise un fichier de configuration spécifique|`git config --file=./custom.config alias.co checkout`|
|`--list` / `-l`|Liste toutes les configurations chargées|`git config --list`|
|`--unset <clé>`|Supprime la configuration correspondante|`git config --global --unset user.name`|
|`--unset-all <clé>`|Supprime toutes les entrées de la clé|`git config --global --unset-all alias.co`|
|`--add <clé> <valeur>`|Ajoute une nouvelle valeur pour une clé|`git config --global --add alias.lg "log --graph --oneline"`|
|`-e`, `--edit`|Ouvre le fichier de configuration dans l'éditeur par défaut|`git config --global --edit`|
|`--replace-all <clé> <valeur>`|Remplace toutes les valeurs existantes avec celle fournie|`git config --global --replace-all user.email "new@example.com"`|

Quelques exemples concrets

```jsx
*# Configurer le nom d'utilisateur globalement*
git config --global user.name "John Doe"

*# Configurer l'email uniquement pour ce dépôt*
git config --local user.email "john@example.com"

*# Voir toutes les configurations en cours*
git config --list

*# Ajouter un alias pour 'checkout'*
git config --global --add alias.co checkout

*# Supprimer une configuration globale*
git config --global --unset user.signingkey

*# Éditer la configuration globale dans l'éditeur*
git config --global --edit
```

Cette commande est très puissante pour personnaliser Git, définir des alias, les préférences d’utilisateur, et plus encore. N’oublie pas d’utiliser `git config --help` pour afficher toutes les options et la documentation complète.

## **`git clean`**

**Description :** Supprime les fichiers non trackés du working directory.

**Syntaxe :** **`git clean [<options>] [<path>...]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git clean -f`**|Force la suppression des fichiers non trackés|Nettoyer le répertoire de travail|
|**`-d`**|Supprime aussi les répertoires vides|Nettoyage complet|
|**`-n, --dry-run`**|Simule sans supprimer|Voir ce qui serait supprimé|
|**`-i, --interactive`**|Mode interactif|Nettoyage sélectif|
|**`-x`**|Supprime aussi les fichiers ignorés|Nettoyage total (build artifacts, etc.)|
|**`-X`**|Supprime seulement les fichiers ignorés|Nettoyer les fichiers de build|

## **`git gc`**

**Description :** Optimise le dépôt Git (garbage collection).

**Syntaxe :** **`git gc [<options>]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git gc`**|Lance l'optimisation automatique|Maintenance régulière du dépôt|
|**`--aggressive`**|Optimisation plus poussée mais plus lente|Nettoyage en profondeur|
|**`--auto`**|Lance gc seulement si nécessaire|Maintenance conditionnelle|
|**`--prune=<date>`**|Supprime les objets plus anciens que la date|Nettoyage ciblé par âge|

# **📋 Sous-modules**

## **`git submodule`**

**Description :** Gère les sous-modules Git.

**Syntaxe :** **`git submodule [<options>] <command> [<args>]`**

| **Sous-commande**             | **Description**                                         | **Utilisation principale**            |
| ----------------------------- | ------------------------------------------------------- | ------------------------------------- |
| **`git submodule add <url>`** | Ajoute un nouveau sous-module                           | Intégrer un projet externe            |
| **`git submodule init`**      | Initialise les sous-modules                             | Préparer les sous-modules après clone |
| **`git submodule update`**    | Met à jour les sous-modules vers les commits référencés | Synchroniser les sous-modules         |
| **`git submodule status`**    | Affiche l'état des sous-modules                         | Vérifier l'état des dépendances       |
| **`git submodule foreach`**   | Exécute une commande dans chaque sous-module            | Actions en lot sur les sous-modules   |

# **📄 Formatage & Export**

## **`git archive`**

**Description :** Crée une archive des fichiers du dépôt.

**Syntaxe :** **`git archive [<options>] <tree-ish> [<path>...]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git archive <commit>`**|Crée une archive tar du commit spécifié|Export d'une version|
|**`--format=<format>`**|Spécifie le format (tar, zip, etc.)|Archives dans différents formats|
|**`--output=<fichier>`**|Nom du fichier de sortie|Spécifier le nom d'archive|
|**`--prefix=<préfixe>`**|Ajoute un préfixe aux chemins dans l'archive|Organisation de l'archive|

# **📁 Fichiers & Répertoire**

## **`git mv`**

**Description :** Déplace ou renomme un fichier, dossier ou lien symbolique.

**Syntaxe :** **`git mv [<options>] <source> <destination>`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git mv <source> <dest>`**|Déplace ou renomme un fichier/dossier|Renommer ou déplacer des fichiers trackés|
|**`-f, --force`**|Force le déplacement même si la destination existe|Écraser un fichier existant|
|**`-k`**|Ignore les erreurs et continue avec les autres fichiers|Traitement en lot robuste|
|**`-n, --dry-run`**|Simule l'opération sans l'exécuter|Vérifier avant d'agir|
|**`-v, --verbose`**|Affiche les détails des opérations effectuées|Voir ce qui est déplacé|

## **`git rm`**

**Description :** Supprime les fichiers du suivi Git et du disque.

**Syntaxe :** **`git rm [<options>] <fichier>...`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git rm <fichier>`**|Supprime le fichier du suivi Git et du disque|Supprimer définitivement un fichier|
|**`--cached`**|Supprime seulement du suivi Git, laisse le fichier sur disque|Arrêter de tracker sans supprimer|
|**`-r`**|Suppression récursive (pour les dossiers)|Supprimer des répertoires entiers|
|**`-f, --force`**|Force la suppression même si le fichier a des modifications|Supprimer malgré des changements|
|**`-n, --dry-run`**|Simule la suppression sans l'exécuter|Vérifier quels fichiers seraient supprimés|
|**`-q, --quiet`**|Mode silencieux|Suppression sans messages|
|**`--ignore-unmatch`**|Ne pas échouer si les fichiers n'existent pas|Scripts robustes|

## **`git restore`**

**Description :** Restaure les fichiers dans le working directory ou l'index.

**Syntaxe :** **`git restore [<options>] <pathspec>...`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git restore <fichier>`**|Restaure le fichier depuis le dernier commit|Annuler les modifications d'un fichier|
|**`--staged`**|Restaure depuis l'index (unstage)|Annuler un git add|
|**`--worktree`**|Restaure dans le répertoire de travail (défaut)|Préciser explicitement la cible|
|**`--source=<commit>`**|Restaure depuis un commit spécifique|Récupérer une version antérieure|
|**`-p, --patch`**|Mode interactif pour restaurer partiellement|Restauration sélective par morceaux|
|**`--staged --worktree`**|Restaure à la fois l'index et le working directory|Restauration complète|
|**`-q, --quiet`**|Mode silencieux|Restauration sans messages|

# **📦 Téléchargement & Clonage**

## **`git clone`**

**Description :** Clone un repository distant.

**Syntaxe :** **`git clone [<options>] <repository> [<directory>]`**

Voici un tableau synthétique des principales options/arguments de la commande `git clone` avec leur description et un exemple :

| Option                                                                                           | Description                                                                                         | Exemple                                                    |
| ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| `(aucune)`                                                                                       | Clone le dépôt distant (toutes les branches, HEAD checkout)                                         | `git clone <https://github.com/user/repo.git`>             |
| `-b <nom>`, `--branch <nom>`                                                                     | Clone et positionne le HEAD sur la branche ou le tag indiqué                                        | `git clone -b develop <https://github.com/user/repo.git`>  |
| `-o <nom>`, `--origin <nom>`                                                                     | Donne un nom personnalisé au remote (au lieu de <span class="code-clickable">[[origin]]</span><br>) | `git clone -o upstream <https://github.com/user/repo.git`> |
| `--bare`                                                                                         | Crée un dépôt _bare_ (sans working directory), utilisé comme dépôt central                          | `git clone --bare <https://github.com/user/repo.git`>      |
| <span class="code-clickable">[[Mirror\|--mirror]]</span><br>                                     | Crée un miroir complet (inclut toutes les refs, tags, branches, hooks - pour duplication exacte)    | `git clone --mirror <https://github.com/user/repo.git`>    |
| <span class="code-clickable">[[Depth\| --depth]]</spane>                                         | Clone en mode _shallow_ : récupère seulement les `n` derniers commits                               | `git clone --depth 1 <https://github.com/user/repo.git`>   |
| `--single-branch`                                                                                | Ne clone que la branche spécifiée (par défaut avec `--depth`, sinon toutes les branches)            | `git clone --single-branch -b develop ...`                 |
| <span class="code-clickable">[[no-single-branch\|--no-single-branch]]</span><br>                 | Avec `--depth`, récupère aussi les branches proches non _shallow_                                   | `git clone --depth 10 --no-single-branch ...`              |
| <span class="code-clickable">[[recursive\|recursive]]</span><br>, `--recurse-submodules`         | Clone le dépôt ainsi que ses submodules                                                             | `git clone --recursive ...`                                |
| `--shallow-submodules`                                                                           | Clone les submodules aussi en mode shallow                                                          | `git clone --recurse-submodules --shallow-submodules ...`  |
| `-c <clé>=<valeur>`, `--config <clé>=<valeur>`                                                   | Applique une configuration spécifique au dépôt cloné (`git config` initiale)                        | `git clone -c core.autocrlf=false ...`                     |
| <br><span class="code-clickable">[[template\|--template]]</span>`=<dossier>`                     | Utiliser un dossier de template personnalisé (hook, etc.)                                           | `git clone --template=/chemin/template ...`                |
| `-q`, `--quiet`                                                                                  | Mode silencieux : messages succincts                                                                | `git clone --quiet ...`                                    |
| `-v`, `--verbose`                                                                                | Mode verbeux : affiche plus d’informations                                                          | `git clone --verbose ...`                                  |
| `-n`, <span class="code-clickable">[[no-checkout\|--no-checkout]]</span>                         | Ne fait pas le checkout après clone (juste le dépôt)                                                | `git clone --no-checkout ...`                              |
| `-l`, `--local`                                                                                  | Clone optimisé pour dépôt local (hardlinks sur objets, par défaut pour chemins locaux)              | `git clone -l /chemin/vers/repo`                           |
| `--no-local`                                                                                     | Force un clone “normal” même si le dépôt source est local                                           | `git clone --no-local /chemin/vers/repo`                   |
| `-s`, <span class="code-clickable">[[shared\|--shared]]</span>                                   | Clone en partageant les objets avec le repo source (alternates, pas de duplicata)                   | `git clone -s /chemin/vers/repo`                           |
| <span class="code-clickable">[[no-hardlinks\|--no-hardlinks]]</span>                             | Désactive l’utilisation de hardlinks même pour clone local                                          | `git clone --no-hardlinks /chemin/vers/repo`               |
| <span class="code-clickable">[[reference\|--reference]]</span>`<repo>`                           | Utilise déjà des objets existants dans un autre dépôt comme cache                                   | `git clone --reference=../autrerepo ...`                   |
| `-u <upload-pack>`,<span class="code-clickable">[[ upload-pack\|--upload-pack]]</span>`<chemin>` | Chemin d’un programme upload-pack distant pour SSH                                                  | `git clone -u ssh-upload-pack ...`                         |

[Origin](https://www.notion.so/Origin-31526d1eabaa81cf800be22f02e1fd7a?pvs=21)

[Mirror](https://www.notion.so/Mirror-31526d1eabaa813f9c6cfbc9a2b19c5d?pvs=21)

[Depth](https://www.notion.so/Depth-31526d1eabaa81c2849cef0111d5a6ac?pvs=21)

[**no-single-branch**](https://www.notion.so/no-single-branch-31526d1eabaa810ca7b7c83624c9a004?pvs=21)

[Recursive](https://www.notion.so/Recursive-31526d1eabaa8182a77fc3ce9d0d3f58?pvs=21)

[Template](https://www.notion.so/Template-31526d1eabaa8149be7ac46757b6a685?pvs=21)

[No-checkout](https://www.notion.so/No-checkout-31526d1eabaa8155a0d0e8be78ce5a33?pvs=21)

[Reference](https://www.notion.so/Reference-31526d1eabaa813fb6bdc37de1e2897b?pvs=21)

[shared](https://www.notion.so/shared-31526d1eabaa816f91aef610973056ca?pvs=21)

[`No-hardlinks`](https://www.notion.so/No-hardlinks-31526d1eabaa81b2a481ebb71392c8f7?pvs=21)

[Upload-pack](https://www.notion.so/Upload-pack-31526d1eabaa818381b2f170d1683986?pvs=21)

**Points importants**

- `c` permet d’injecter une config git locale dès le clonage.
- Avec un repo _bare_, pas de working directory : utile pour les serveurs d’intégration ou de backup.
- `-mirror` clone absolument tout, pas seulement branches et tags, parfait pour de la migration/backup complet.
- `b` permet de cloner et d’être tout de suite sur la bonne branche, même si ce n’est pas le HEAD.

Pour la liste exhaustive :

Cf. : [Documentation officielle git-clone1](https://git-scm.com/docs/git-clone)[3](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-clone)[5](https://git-scm.com/docs/git-clone/2.43.0)[8](https://git-scm.com/docs/git-clone/fr)[6](https://git-scm.com/docs/git-clone/2.21.0)[4](https://stackoverflow.com/questions/29644467/how-can-i-pass-multiple-config-key-value-pairs-to-git-clone)

# **🔄 Synchronisation**

## **`git pull`**

**Description :** Récupère et fusionne les changements du repository distant.

**Syntaxe :** **`git pull [<options>] [<repository> [<refspec>...]]`**

Voici un tableau récapitulatif des options courantes de la commande `git pull` avec leur description et utilisation :

| Option              | Description                                                                                | Utilisation principale                              |
| ------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------- |
| `git pull <remote>` | Récupère le contenu du dépôt distant spécifié et fusionne avec la branche locale actuelle. | Mise à jour standard d’une branche locale           |
| `--no-commit`       | Fait un fetch et un merge, mais ne crée pas automatiquement de commit de fusion.           | Permet de contrôler la validation manuellement      |
| `--rebase`          | Au lieu de faire un merge, applique un rebase des commits locaux sur les commits distants. | Historique linéaire et plus propre                  |
| `--verbose`         | Affiche des informations détaillées sur le processus de fetch et merge.                    | Pour déboguer ou voir ce qui est réellement fait    |
| `--quiet`           | Supprime les messages lors du pull.                                                        | Pour réduire la sortie, utile dans les scripts      |
| `--all`             | Récupère tous les remotes configurés, pas uniquement le remote courant.                    | Travaux avec plusieurs dépôts distants              |
| `--dry-run`         | Simule un pull, montre les actions qui seraient entreprises sans les exécuter.             | Pour vérifier avant d’agir                          |
| `--depth <n>`       | Permet de faire un pull en limitant la profondeur d’historique (shallow pull).             | Pour économiser de la bande passante et du stockage |
| `--prune`           | Supprime les références distantes qui ont été supprimées sur le serveur.                   | Pour nettoyer les branches distantes obsolètes      |
| `--no-tags`         | N’inclut pas les tags lors du fetch/pull.                                                  | Pour éviter de récupérer les tags                   |
| `--ff-only`         | Refuse le pull sauf si la mise à jour peut être effectuée en fast-forward (sans merge).    | Pour éviter les merges automatiques                 |
| `--no-ff`           | Crée toujours un commit de merge, même si fast-forward possible.                           | Pour garder un historique plus visible              |
| `--squash`          | Combine toutes les modifications distantes en un seul commit lors de la fusion.            | Préparer un commit unique à partir de plusieurs     |

1. [https://www.atlassian.com/fr/git/tutorials/syncing/git-pull](https://www.atlassian.com/fr/git/tutorials/syncing/git-pull)
2. [https://git-scm.com/docs/git-pull/fr](https://git-scm.com/docs/git-pull/fr)
3. [https://git-scm.com/docs/git-pull](https://git-scm.com/docs/git-pull)
4. [https://www.dreamhost.com/blog/fr/commandes-git-21-options-incontournables-fr/](https://www.dreamhost.com/blog/fr/commandes-git-21-options-incontournables-fr/)
5. [https://www.gitkraken.com/learn/git/commands](https://www.gitkraken.com/learn/git/commands)
6. [https://www.ionos.fr/digitalguide/sites-internet/developpement-web/git-pull/](https://www.ionos.fr/digitalguide/sites-internet/developpement-web/git-pull/)
7. [https://git-scm.com/docs/git-pull/2.1.4](https://git-scm.com/docs/git-pull/2.1.4)
8. [https://www.hostinger.com/fr/tutoriels/commandes-git](https://www.hostinger.com/fr/tutoriels/commandes-git)
9. [https://blog.stephane-robert.info/docs/developper/version/git/](https://blog.stephane-robert.info/docs/developper/version/git/)
10. [https://git.goffinet.org/13-annexe-c-commandes-git](https://git.goffinet.org/13-annexe-c-commandes-git)

## **`git push`**

**Description :** Envoie les commits locaux vers le repository distant.

**Syntaxe :** **`git push [<options>] [<repository> [<refspec>...]]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git push <remote>`**|Envoie les commits de la branche locale vers la branche distante correspondante|Push standard vers origin|
|**`-u, --set-upstream`**|Établit le lien de suivi entre branche locale et distante|Premier push d'une nouvelle branche|
|**`-f, --force`**|Force le push même si cela réécrira l'historique distant|Attention : peut écraser le travail d'autres|
|**`--force-with-lease`**|Force le push mais seulement si personne d'autre n'a poussé entre temps|Push forcé plus sûr que --force|
|**`-d, --delete`**|Supprime la branche ou le tag distant|Nettoyer les branches distantes obsolètes|
|**`--all`**|Pousse toutes les branches locales vers le distant|Synchronisation massive|
|**`--tags`**|Pousse tous les tags vers le distant|Partager les versions/releases|
|**`-n, --dry-run`**|Simule le push sans l'exécuter|Vérifier avant d'agir|
|**`-q, --quiet`**|Mode silencieux|Pour les scripts|
|**`-v, --verbose`**|Mode verbeux avec détails|Débogage|
|**`--prune`**|Supprime les références distantes qui n'existent plus localement|Nettoyage des références|

# **📝 Staging & Commits**

## **`git add`**

**Description :** Ajoute des fichiers à la zone de staging.

**Syntaxe :** **`git add [<options>] [--] <pathspec>...`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git add <fichier>`**|Ajoute un fichier spécifique au staging|Staging ciblé|
|**`git add .`**|Ajoute tous les fichiers du répertoire courant|Staging de tous les changements|
|**`-A, --all`**|Ajoute tous les fichiers du projet (même supprimés)|Staging complet du projet|
|**`-u, --update`**|Ajoute seulement les fichiers déjà trackés et modifiés|Mise à jour des fichiers existants|
|**`-p, --patch`**|Mode interactif pour choisir les parties à stager|Staging partiel d'un fichier|
|**`-i, --interactive`**|Mode interactif complet|Contrôle fin du staging|
|**`-n, --dry-run`**|Simule l'ajout sans l'exécuter|Vérification avant staging|
|**`-f, --force`**|Force l'ajout même pour les fichiers ignorés|Ajouter des fichiers .gitignore|
|**`-v, --verbose`**|Mode verbeux|Voir ce qui est ajouté|
|**`--ignore-errors`**|Continue même si certains fichiers ne peuvent être ajoutés|Batch processing robuste|

## **`git commit`**

**Description :** Crée un commit avec les changements stagés.

**Syntaxe :** **`git commit [<options>] [--] <pathspec>...`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git commit`**|Ouvre l'éditeur pour saisir le message de commit|Commit standard avec message détaillé|
|**`-m <message>`**|Spécifie le message de commit directement|Commit rapide avec message court|
|**`-a, --all`**|Commite automatiquement tous les fichiers trackés modifiés|Commit rapide sans staging préalable|
|**`-am <message>`**|Combine -a et -m|Commit ultra-rapide|
|**`--amend`**|Modifie le dernier commit au lieu d'en créer un nouveau|Corriger le dernier commit|
|**`--no-edit`**|Ne pas ouvrir l'éditeur (avec --amend)|Amend rapide sans changer le message|
|**`-v, --verbose`**|Affiche le diff dans l'éditeur de message|Voir les changements lors du commit|
|**`-n, --no-verify`**|Ignore les hooks pre-commit et commit-msg|Bypass des vérifications|
|**`--dry-run`**|Simule le commit sans le créer|Vérification avant commit|
|**`-s, --signoff`**|Ajoute une ligne "Signed-off-by"|Conformité aux standards de contribution|

# **🌿 Branches & Merge**

## **`git rebase`**

**Description :** Applique une suite de commits sur une autre base.

**Syntaxe :** **`git rebase [<options>] [<upstream> [<branch>]]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git rebase <branche>`**|Rejoue les commits de la branche courante sur la branche spécifiée|Lineariser l'historique|
|**`-i, --interactive`**|Mode interactif pour modifier, réordonner, fusionner les commits|Réécriture d'historique avancée|
|**`--onto <branche>`**|Spécifie la nouvelle base pour le rebase|Rebase sur une branche différente|
|**`--continue`**|Continue le rebase après résolution des conflits|Reprendre après conflit|
|**`--abort`**|Annule le rebase et revient à l'état initial|Abandonner un rebase problématique|
|**`--skip`**|Ignore le commit courant et continue|Passer un commit conflictuel|
|**`--autosquash`**|Réorganise automatiquement les commits marqués pour fixup/squash|Nettoyage automatique de l'historique|
|**`--preserve-merges`**|Préserve les commits de merge|Garder la structure des fusions|
|**`-X <strategy-option>`**|Options pour la stratégie de fusion|Résolution personnalisée des conflits|

## **`git switch`**

**Description :** Change de branche de manière simplifiée (alternative moderne à checkout).

**Syntaxe :** **`git switch [<options>] [<branch>]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git switch <branche>`**|Change vers la branche spécifiée|Navigation simple entre branches|
|**`-c <branche>`**|Crée une nouvelle branche et y bascule|Créer et basculer en une commande|
|**`-C <branche>`**|Force la création d'une branche (écrase si elle existe)|Recréer une branche|
|**`--detach`**|Bascule en mode HEAD détaché sur un commit|Explorer un commit sans créer de branche|
|**`-f, --force`**|Force le changement même avec des modifications non commitées|Changement forcé (perte possible de modifications)|
|**`--discard-changes`**|Jette les modifications locales avant de basculer|Nettoyage automatique avant changement|
|**`--merge`**|Effectue un merge à trois voies si nécessaire|Récupérer les modifications lors du changement|
|**`-t, --track`**|Configure le suivi d'une branche distante|Lier à une branche distante|
|**`--no-track`**|Ne configure pas le suivi|Branche locale indépendante|
|**`--guess`**|Devine la branche distante à suivre (défaut)|Création automatique de branche de suivi|
|**`--no-guess`**|Désactive la détection automatique|Contrôle strict de la création|

## **`git branch`**

**Description :** Gestion des branches.

**Syntaxe :** **`git branch [<options>] [-r | -a] [--merged | --no-merged] [<pattern>...]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git branch`**|Liste les branches locales|Voir les branches disponibles|
|**`-a, --all`**|Liste toutes les branches (locales et distantes)|Vue complète des branches|
|**`-r, --remotes`**|Liste seulement les branches distantes|Voir les branches du serveur|
|**`-v, --verbose`**|Affiche le dernier commit de chaque branche|Plus d'informations sur les branches|
|**`<nom>`**|Crée une nouvelle branche|Créer une branche|
|**`-d, --delete`**|Supprime une branche (sécurisé)|Nettoyer les branches fusionnées|
|**`-D`**|Force la suppression d'une branche|Supprimer une branche non fusionnée|
|**`-m, --move`**|Renomme une branche|Changer le nom d'une branche|
|**`--merged`**|Liste les branches déjà fusionnées|Identifier les branches à nettoyer|
|**`--no-merged`**|Liste les branches non fusionnées|Voir les branches actives|
|**`--set-upstream-to=<upstream>`**|Définit la branche de suivi|Configurer le lien avec une branche distante|

## **`git checkout`**

**Description :** Change de branche ou restaure des fichiers.

**Syntaxe :** **`git checkout [<options>] <branch>`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git checkout <branche>`**|Change vers la branche spécifiée|Navigation entre branches|
|**`-b <branche>`**|Crée et change vers une nouvelle branche|Créer et basculer en une commande|
|**`-B <branche>`**|Force la création et le changement vers une branche|Recréer une branche existante|
|**`<fichier>`**|Restore un fichier depuis le dernier commit|Annuler les modifications d'un fichier|
|**`<commit> -- <fichier>`**|Restore un fichier depuis un commit spécifique|Récupérer une version antérieure|
|**`-p, --patch`**|Mode interactif pour restaurer partiellement|Restauration sélective|
|**`-f, --force`**|Force le changement même avec des modifications non commitées|Changement forcé (perte de modifications)|
|**`--detach`**|Détache HEAD (mode detached HEAD)|Explorer un commit spécifique|
|**`--track`**|Crée une branche de suivi pour une branche distante|Suivre une branche distante|
|**`--no-track`**|Ne crée pas de lien de suivi|Branche indépendante|

## **`git merge`**

**Description :** Fusionne une branche dans la branche courante.

**Syntaxe :** **`git merge [<options>] [<commit>...]`**

**Options principales :**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git merge <branche>`**|Fusionne la branche spécifiée dans la branche courante|Fusion standard|
|**`--no-ff`**|Crée toujours un commit de merge (pas de fast-forward)|Historique explicite des fusions|
|**`--ff-only`**|Refuse la fusion sauf si fast-forward possible|Éviter les commits de merge|
|**`--squash`**|Fusionne en un seul commit sans créer de commit de merge|Simplifier l'historique|
|**`-m <message>`**|Spécifie le message du commit de merge|Message personnalisé|
|**`--abort`**|Annule une fusion en cours en cas de conflit|Annuler une fusion problématique|
|**`--continue`**|Continue une fusion après résolution des conflits|Finaliser une fusion après conflits|
|**`-X <strategy-option>`**|Options pour la stratégie de fusion|Fusion personnalisée|
|**`--no-commit`**|Effectue la fusion sans créer le commit automatiquement|Contrôle manuel du commit de fusion|
|**`-v, --verbose`**|Mode verbeux|Détails de la fusion|

# **📊 Historique & Information**

## **`git show`**

**Description :** Affiche les détails d'un objet Git (commit, tag, arbre, blob).

**Syntaxe :** **`git show [<options>] [<objet>...]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git show <commit>`**|Affiche les détails d'un commit avec ses modifications|Examiner un commit spécifique|
|**`--stat`**|Affiche les statistiques des fichiers modifiés|Résumé quantitatif des changements|
|**`-p, --patch`**|Affiche le diff complet (défaut pour les commits)|Voir le contenu des modifications|
|**`--name-only`**|Affiche seulement les noms des fichiers modifiés|Liste des fichiers changés|
|**`--name-status`**|Affiche les noms et statuts des fichiers|Voir les types de modifications|
|**`--pretty=<format>`**|Format d'affichage du commit|Personnaliser la présentation|
|**`--abbrev-commit`**|Utilise des SHA-1 abrégés|Affichage plus compact|
|**`--no-patch`**|N'affiche pas le diff|Voir seulement les métadonnées|
|**`<commit>:<fichier>`**|Affiche le contenu d'un fichier à un commit donné|Examiner une version spécifique d'un fichier|

## **`git log`**

**Description :** Affiche l'historique des commits.

**Syntaxe :** **`git log [<options>] [<revision range>] [[--] <path>...]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git log`**|Affiche l'historique complet|Voir l'historique des commits|
|**`--oneline`**|Affiche un commit par ligne (format condensé)|Vue rapide de l'historique|
|**`--graph`**|Affiche un graphique ASCII des branches|Visualiser les fusions et branches|
|**`-n <nombre>`**|Limite le nombre de commits affichés|Voir seulement les derniers commits|
|**`--since=<date>`**|Affiche les commits depuis une date|Historique filtré par date|
|**`--until=<date>`**|Affiche les commits jusqu'à une date|Historique borné dans le temps|
|**`--author=<auteur>`**|Filtre par auteur|Voir les commits d'une personne|
|**`--grep=<motif>`**|Filtre par message de commit|Recherche dans les messages|
|**`-p, --patch`**|Affiche les différences pour chaque commit|Voir le contenu des modifications|
|**`--stat`**|Affiche les statistiques des fichiers modifiés|Résumé des changements|
|**`--pretty=<format>`**|Format d'affichage personnalisé|Personnaliser la sortie|

## **`git status`**

**Description :** Affiche l'état du working directory et staging area.

**Syntaxe :** **`git status [<options>] [--] [<pathspec>...]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git status`**|Affiche l'état complet du dépôt|Vue d'ensemble des modifications|
|**`-s, --short`**|Format court et condensé|Vue rapide de l'état|
|**`-b, --branch`**|Affiche les informations de la branche|Voir la branche courante et son état|
|**`--porcelain`**|Format adapté aux scripts|Parsing automatique|
|**`-u, --untracked-files`**|Contrôle l'affichage des fichiers non trackés|Gérer l'affichage des nouveaux fichiers|
|**`--ignored`**|Affiche aussi les fichiers ignorés|Debug des règles .gitignore|
|**`-z`**|Terminaison par NUL des noms de fichiers|Processing sécurisé des noms de fichiers|

## **`git diff`**

**Description :** Montre les différences entre commits, branches, fichiers.

**Syntaxe :** **`git diff [<options>] [<commit>] [--] [<path>...]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git diff`**|Différences entre working directory et staging area|Voir les modifications non stagées|
|**`--cached`**|Différences entre staging area et dernier commit|Voir ce qui sera committé|
|**`<commit1>..<commit2>`**|Différences entre deux commits|Comparer des versions|
|**`--name-only`**|Affiche seulement les noms des fichiers modifiés|Liste des fichiers changés|
|**`--stat`**|Affiche les statistiques des modifications|Résumé quantitatif|
|**`-w, --ignore-all-space`**|Ignore les changements d'espaces|Diff sans les espaces|
|**`--color-words`**|Colore les mots modifiés|Vue fine des changements|
|**`-U<n>`**|Nombre de lignes de contexte|Contrôler le contexte|

## **`git grep`**

**Description :** Recherche dans le contenu des fichiers avec motifs.

**Syntaxe :** **`git grep [<options>] <motif> [--] [<paths>...]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git grep <motif>`**|Recherche le motif dans tous les fichiers trackés|Recherche basique|
|**`-n, --line-number`**|Affiche les numéros de ligne|Localiser précisément|
|**`-i, --ignore-case`**|Ignore la casse|Recherche insensible à la casse|
|**`-w, --word-regexp`**|Cherche seulement les mots entiers|Recherche précise|
|**`-v, --invert-match`**|Inverse la recherche (lignes ne contenant pas le motif)|Recherche inversée|
|**`-c, --count`**|Affiche seulement le nombre d'occurrences par fichier|Statistiques de recherche|
|**`-l, --files-with-matches`**|Affiche seulement les noms de fichiers contenant le motif|Liste des fichiers concernés|
|**`-p, --show-function`**|Affiche la fonction englobante|Contexte de programmation|
|**`--cached`**|Recherche dans l'index au lieu du working directory|Recherche dans les fichiers stagés|
|**`-e <motif>`**|Spécifie le motif (utile si le motif commence par -)|Motifs complexes|

# **🔄 Annulation & Correction**

## **`git stash`**

**Description :** Sauvegarde temporairement les modifications non commitées.

**Syntaxe :** **`git stash [<options>] [<message>]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git stash`**|Sauvegarde les modifications dans une pile temporaire|Changer de branche rapidement|
|**`git stash pop`**|Applique et supprime le dernier stash|Récupérer ses modifications|
|**`git stash list`**|Liste tous les stashs sauvegardés|Voir les sauvegardes disponibles|
|**`git stash apply`**|Applique le stash sans le supprimer|Réutiliser un stash plusieurs fois|
|**`git stash drop`**|Supprime un stash spécifique|Nettoyer les stashs obsolètes|
|**`git stash show`**|Affiche le résumé d'un stash|Voir ce qui est dans un stash|
|**`-u, --include-untracked`**|Inclut les fichiers non trackés|Stash complet avec nouveaux fichiers|
|**`-k, --keep-index`**|Garde les modifications dans l'index|Stash sélectif|
|**`-p, --patch`**|Mode interactif pour choisir les parties à stasher|Stash partiel|

## **`git cherry-pick`**

**Description :** Applique les modifications d'un commit spécifique sur la branche courante.

**Syntaxe :** **`git cherry-pick [<options>] <commit>...`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git cherry-pick <commit>`**|Applique les modifications du commit sur la branche courante|Récupérer un commit d'une autre branche|
|**`-n, --no-commit`**|Applique sans créer de commit automatiquement|Préparer plusieurs cherry-picks|
|**`-x`**|Ajoute "(cherry picked from commit ...)" au message|Traçabilité du cherry-pick|
|**`--continue`**|Continue après résolution de conflits|Finaliser un cherry-pick conflictuel|
|**`--abort`**|Annule le cherry-pick en cours|Abandonner un cherry-pick problématique|
|**`-m <parent-number>`**|Pour cherry-pick un merge, spécifie quel parent utiliser|Cherry-pick d'une fusion|

## **`git reset`**

**Description :** Reset HEAD courante vers état spécifié.

**Syntaxe :** **`git reset [<mode>] [<commit>]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git reset <commit>`**|Reset soft vers le commit (garde staging et working directory)|Défaire des commits en gardant les changements|
|**`--soft <commit>`**|Reset seulement HEAD, garde staging et working directory|Recommitter différemment|
|**`--mixed <commit>`**|Reset HEAD et staging, garde working directory (défaut)|Défaire le staging|
|**`--hard <commit>`**|Reset HEAD, staging et working directory|Tout annuler vers un état propre|
|**`<fichier>`**|Retire un fichier du staging|Défaire un git add|
|**`HEAD~<n>`**|Reset vers n commits en arrière|Revenir en arrière|

## **`git revert`**

**Description :** Crée nouveaux commits qui annulent commits existants.

**Syntaxe :** **`git revert [<options>] <commit>...`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git revert <commit>`**|Crée un commit qui annule les changements du commit spécifié|Annuler un commit de façon sûre|
|**`-n, --no-commit`**|Effectue le revert sans créer le commit automatiquement|Préparer plusieurs reverts|
|**`-m <parent-number>`**|Pour reverter un merge, spécifie quel parent garder|Reverter une fusion|
|**`--continue`**|Continue un revert après résolution de conflits|Finaliser un revert conflictuel|
|**`--abort`**|Annule un revert en cours|Abandonner un revert problématique|
|**`--edit`**|Ouvre l'éditeur pour modifier le message|Personnaliser le message de revert|
|**`--no-edit`**|Utilise le message par défaut|Revert automatique|

## **`git bisect`**

---

**Description :** Utilise la recherche binaire pour trouver un commit qui introduit un bug.

**Syntaxe :** **`git bisect <subcommande> [<options>]`**

|**Sous-commande**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git bisect start`**|Démarre une session de bisect|Début de recherche de bug|
|**`git bisect bad [<commit>]`**|Marque un commit comme contenant le bug|Indiquer un commit défaillant|
|**`git bisect good [<commit>]`**|Marque un commit comme ne contenant pas le bug|Indiquer un commit fonctionnel|
|**`git bisect reset`**|Termine la session et revient à la branche originale|Fin de recherche|
|**`git bisect skip`**|Ignore le commit courant (non testable)|Passer un commit problématique|
|**`git bisect log`**|Affiche le journal de la session bisect|Suivi de la recherche|
|**`git bisect replay <file>`**|Rejoue une session depuis un fichier de log|Répéter une recherche|
|**`git bisect run <cmd>`**|Automatise le bisect avec une commande de test|Recherche automatisée|

# **🔍 Analyse & Débug**

## **`git blame`**

**Description :** Affiche qui a modifié chaque ligne d'un fichier et quand.

**Syntaxe :** **`git blame [<options>] <fichier>`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git blame <fichier>`**|Affiche l'auteur et le commit pour chaque ligne|Trouver qui a écrit une ligne de code|
|**`-L <début>,<fin>`**|Limite l'analyse à une plage de lignes|Analyser une section spécifique|
|**`-C`**|Détecte les lignes copiées/déplacées dans le même commit|Analyse approfondie des modifications|
|**`-M`**|Détecte les lignes déplacées/copiées entre fichiers|Suivi des refactorisations|
|**`-w`**|Ignore les changements d'espaces|Focus sur les vraies modifications|

## **`git reflog`**

**Description :** Affiche l'historique des références (où HEAD a pointé).

**Syntaxe :** **`git reflog [<options>] [<ref>]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git reflog`**|Affiche l'historique de HEAD|Récupérer des commits "perdus"|
|**`git reflog <branche>`**|Affiche l'historique d'une branche spécifique|Analyser l'évolution d'une branche|
|**`--all`**|Affiche le reflog de toutes les références|Vue globale des mouvements|
|**`-n <nombre>`**|Limite le nombre d'entrées affichées|Voir seulement les dernières actions|

# **🌐 Remote (Distant)**

## **`git fetch`**

**Description :** Récupère les objets et refs depuis un dépôt distant.

**Syntaxe :** **`git fetch [<options>] [<repository> [<refspec>...]]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git fetch <remote>`**|Récupère les nouvelles données du dépôt distant sans merger|Mise à jour des références distantes|
|**`--all`**|Récupère depuis tous les remotes configurés|Synchronisation multi-remotes|
|**`-p, --prune`**|Supprime les références de branches distantes supprimées|Nettoyage des branches obsolètes|
|**`--dry-run`**|Simule le fetch sans télécharger|Prévisualisation|
|**`--depth <n>`**|Limite la profondeur de l'historique récupéré|Économie de bande passante|
|**`--unshallow`**|Convertit un clone shallow en clone complet|Récupérer tout l'historique|
|**`-f, --force`**|Force la mise à jour des références même en cas de fast-forward impossible|Synchronisation forcée|
|**`-t, --tags`**|Récupère aussi tous les tags|Synchronisation des versions|
|**`--no-tags`**|N'inclut pas les tags|Fetch ciblé sur le code|
|**`-v, --verbose`**|Mode verbeux|Détails du processus|

## **`git remote`**

**Description :** Gestion des repositories distants.

**Syntaxe :** **`git remote [-v | --verbose]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git remote`**|Liste les remotes configurés|Voir les dépôts distants|
|**`-v, --verbose`**|Affiche les URLs des remotes|Détails des remotes|
|**`add <nom> <url>`**|Ajoute un nouveau remote|Configurer un nouveau dépôt distant|
|**`remove <nom>`**|Supprime un remote|Nettoyer les remotes obsolètes|
|**`rename <ancien> <nouveau>`**|Renomme un remote|Réorganiser les remotes|
|**`set-url <nom> <url>`**|Change l'URL d'un remote|Modifier l'adresse d'un remote|
|**`show <nom>`**|Affiche les informations détaillées d'un remote|Diagnostiquer un remote|
|**`prune <nom>`**|Supprime les références des branches distantes supprimées|Nettoyage des références|

# **🏷️ Tags**

## **`git tag`**

**Description :** Crée, liste, supprime tags.

**Syntaxe :** **`git tag [-a | -s | -u <keyid>] [-f] [-m <msg> | -F <file>] [-e] <tagname> [<commit>]`**

|**Option**|**Description**|**Utilisation principale**|
|---|---|---|
|**`git tag`**|Liste tous les tags|Voir les versions disponibles|
|**`<tagname>`**|Crée un tag léger sur le commit courant|Marquer une version simple|
|**`-a <tagname>`**|Crée un tag annoté|Tag avec métadonnées complètes|
|**`-m <message>`**|Message pour le tag annoté|Description de la version|
|**`-d <tagname>`**|Supprime un tag|Nettoyer les tags obsolètes|
|**`-l <pattern>`**|Liste les tags correspondant au motif|Filtrer les tags|
|**`-f, --force`**|Force la création/modification d'un tag existant|Remplacer un tag|
|**`-s`**|Crée un tag signé (GPG)|Tag authentifié|
|**`-v <tagname>`**|Vérifie la signature d'un tag|Contrôle d'authenticité|
|**`--sort=<key>`**|Trie les tags selon différents critères|Organisation des tags|
# <span class="title-link">[[quizz final github|🐙 Maîtrise de Git : Le Grand Quiz (30 Questions)]] </span>