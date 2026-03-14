Voici la différence claire entre un **`git clone` normal** et **`git clone --mirror`** (sans parler de bare) :

## 1. `git clone` (normal)

- **Crée un nouveau dossier** contenant les fichiers sources du projet pour être modifiés (_working directory_).
- **Copie l’historique Git** (commits, branches principales, tags) nécessaires pour travailler, mais certains types de références avancées (comme notes, certains hooks, reflogs, refs personnalisées) ne sont pas toujours récupérés.
- Le remote par défaut s’appelle généralement `origin`, configuré pour fetch/push les branches suivies.

## 2. `git clone --mirror`

- **Crée une copie totale** du dépôt, reprenant **absolument toutes les références Git** :
    - branches principales **et** secondaires, tags, notes, refs de hooks, refs personnalisées, etc.
- **Ne crée pas de dossier de travail avec les fichiers à modifier** : c’est un duplicata destiné à être un miroir exact pour la synchronisation ou la migration.
- Configure le remote pour que toute mise à jour (avec `git remote update`) synchronise **absolument tout** et écrase ce qui existe localement si besoin.
- Utile pour :
    - migrer l’intégralité d’un dépôt sur un autre serveur ou service,
    - garder une synchronisation parfaite entre plusieurs serveurs.

## Tableau résumé

|Commande|Reçoit les fichiers sources ?|Lanceur pour développement ?|Copie toutes les références ?|Utilisation principale|
|---|---|---|---|---|
|`git clone`|Oui|Oui|Non (juste celles suivies)|Développer, collaborer localement|
|`git clone --mirror`|Non|Non|Oui (100% refs, tags, notes)|Duplication totale, migration, sauvegarde|

**En résumé** :

- Un `clone` normal sert à travailler, éditer le code, faire des commits au quotidien.
- Un `clone --mirror` sert à faire une copie parfaite pour transfert, archivage ou synchronisation approfondie, mais PAS pour développer ou modifier les fichiers en direct.