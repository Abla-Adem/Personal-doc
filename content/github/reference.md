## Option `-reference` dans `git clone`

- Cette option permet à Git de **réutiliser les objets (commits, blobs, etc.) déjà présents dans un autre dépôt local** au lieu de les retélécharger ou reconstruire.
- Concrètement, si tu as un dépôt existant sur ta machine, Git l’utilise comme **cache** pour accélérer le clonage d’un nouveau dépôt, en évitant de dupliquer les mêmes objets.
- Cela réduit ainsi la taille du clone, accélère le processus, et économise de l’espace disque.
- Le nouveau dépôt cloné sera complet et indépendant, mais va chercher les objets communs dans le dépôt de référence tant qu’ils existent.

## Exemple d’utilisation

```jsx
git clone --reference /chemin/vers/depot-existant <https://github.com/user/projet.git>
```

- Git utilisera en priorité le dépôt `/chemin/vers/depot-existant` pour récupérer des objets déjà présents.
- Si certains objets ne sont pas dans le dépôt de référence, ils seront récupérés depuis Internet/dépôt distant normalement.

## En résumé

- `-reference` utilise un dépôt local déjà existant comme cache d’objets pour un nouveau clone.
- Cela permet un clonage plus rapide et moins gourmand en espace.
- Le nouveau clone reste un dépôt indépendant, mais optimise ses données en utilisant les objets disponibles localement.

Veux-tu que je t’explique plus en détail comment configurer ou vérifier l’utilisation de cette option ?