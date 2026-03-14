Ce sont les blocs auxquels tu peux accéder via `git config section.variable`

|**Section**|**Variables (arguments clés)**|**Description**|
|---|---|---|
|`user`|`name`, `email`, `signingkey`, `useConfigOnly`|Informations d’auteur, email de commit, clé GPG, etc.|
|`core`|`editor`, `autocrlf`, `safecrlf`, `excludesfile`, `fileMode`, `ignorecase`, `symlinks`, `compression`, `eol`, `precomposeunicode`|Comportement global du dépôt et de Git|
|`color`|`ui`, `branch`, `diff`, `interactive`, `status`|Personnalisation de l’affichage couleur dans le terminal|
|`alias`|`<commande>=<alias>` (ex : `co=checkout`, `br=branch`, etc.)|Raccourcis pour des commandes Git|
|`branch`|`autosetupmerge`, `autosetuprebase`, `<branch>.remote`, `<branch>.merge`|Configuration comportement branche, distant par défaut, merge/rebase auto|
|`remote`|`<remote>.url`, `<remote>.fetch`, `<remote>.pushurl`, `<remote>.prune`|Définition des dépôts distants et gestion des URLs|
|`push`|`default`, `followTags`|Définition du comportement par défaut lors d’un `push`|
|`pull`|`rebase`, `ff`, `twohead`, `octopus`|Comportement par défaut pour `git pull`|
|`credential`|`helper`, `useHttpPath`|Réglages gestion des credentials (token, cache, helper système)|
|`http`|`proxy`, `sslVerify`, `cookieFile`, `version`|Options du protocole HTTP (proxy, vérification SSL, cookies)|
|`diff`|`tool`, `mnemonicprefix`, `colorMoved`, `algorithm`, `renames`, `wordRegex`|Options pour la commande `diff`|
|`merge`|`tool`, `conflictStyle`, `strategy`, `ff`, `stat`, `log`|Choix du merge tool, stratégie de fusion, affichage des stats/conflicts|
|`rebase`|`autostash`, `stat`, `preserveMerges`, `interactive`, `abbreviateCommands`|Contrôle le comportement du rebase|
|`rerere`|`enabled`, `autoUpdate`, `resolved`|Réutilisation de la résolution de conflits|
|`gc`|`auto`, `autopacklimit`, `pruneExpire`, `aggressiveWindow`|Nettoyage automatique (garbage collection)|
|`pack`|`window`, `depth`, `threads`, `compression`|Réglages compression d’objets|
|`receive`|`denyCurrentBranch`, `denyDeletes`, `fsckObjects`, `autogc`, `advertisePushOptions`|Contrôle des pushs reçus sur un dépôt|
|`fetch`|`prune`, `recurseSubmodules`, `writeCommitGraph`|Réglages du fetch|
|`init`|`defaultBranch`|Nom de la branche par défaut à l'init|
|`safe`|`directory`|Répertoire déclaré comme sûr pour Git (sécurité)|
|`filter`|`<filter>.clean`, `<filter>.smudge`, `<filter>.required`, `<filter>.process`|Filtres de nettoyage/traitement de contenu (ex : LFS)|
|`status`|`showUntrackedFiles`, `relativePaths`, `short`|Contrôle de la sortie de `git status`|
|`submodule`|`<submodule>.url`, `<submodule>.branch`, `<submodule>.update`|Configuration des submodules|
|`sendemail`|`smtpServer`, `smtpEncryption`, `from`, `to`|Paramètres de l’envoi d’email avec Git|

## Exemple d’utilisation

```bash
git config --global core.editor "vim"
git config --global color.ui true
git config --global alias.st status
git config --global branch.autosetupmerge true
git config --global push.default simple
git config --global credential.helper cache
```

 

**Remarques :**

- Certaines sections telles que `gc`, `pack`, `filter`, etc., sont surtout utilisées dans des cas avancés ou sur des dépôts de grande taille.
    
- La documentation officielle complète se trouve ici :
    
    [git-config Documentation1](https://git-scm.com/docs/git-config)[4](https://www.kernel.org/pub/software/scm/git/docs/git-config.html)
    
- Tu peux consulter ou éditer toutes ces sections via le fichier `~/.gitconfig` ou avec `git config --list`.
    

Si tu veux un détail clé par clé pour une section particulière, dis-le-moi !

1. [https://git-scm.com/docs/git-config](https://git-scm.com/docs/git-config)
2. [https://git-scm.com/book/fr/v2/Personnalisation-de-Git-Configuration-de-Git](https://git-scm.com/book/fr/v2/Personnalisation-de-Git-Configuration-de-Git)
3. [https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
4. [https://www.kernel.org/pub/software/scm/git/docs/git-config.html](https://www.kernel.org/pub/software/scm/git/docs/git-config.html)
5. [https://git-scm.com/docs/git-config/2.16.6](https://git-scm.com/docs/git-config/2.16.6)
6. [https://git-scm.com/docs/git](https://git-scm.com/docs/git)
7. [https://git-scm.com/docs/git-config/fr](https://git-scm.com/docs/git-config/fr)
8. [https://git-scm.com/docs/git/fr](https://git-scm.com/docs/git/fr)
9. [https://git-scm.com/docs/gitcredentials](https://git-scm.com/docs/gitcredentials)
10. [https://stackoverflow.com/questions/10290409/how-to-use-git-config-command-to-configure-sections-with-name](https://stackoverflow.com/questions/10290409/how-to-use-git-config-command-to-configure-sections-with-name)