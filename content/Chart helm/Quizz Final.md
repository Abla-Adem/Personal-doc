C'est une excellente initiative. Pour bien maîtriser Helm, il est crucial de comprendre pourquoi une commande ou une fonction est incorrecte, afin d'éviter les erreurs classiques en production.

Voici ton quiz complet avec les **explications détaillées pour chaque proposition fausse**, optimisé pour ton usage sur Obsidian.

---

# ☸️ Certification Helm : Examen Final (30 Questions)

> [!abstract] Instructions
> 
> Pour chaque question, réfléchissez à la réponse avant de cliquer sur **"Correction & Explication"**. Chaque erreur est expliquée pour approfondir la logique Kubernetes/Helm.

---

### 📂 Section 1 : Architecture & Structure

**Q1 : Quel est le rôle principal du fichier `Chart.yaml` ?**

1. Définir les variables utilisateur.
    
2. Stocker les métadonnées et la version du Chart.
    
3. Contenir les fonctions Go Template.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** C'est la carte d'identité du package (nom, version, description).
>     
> - **Pourquoi la 1 est fausse :** Le paramétrage utilisateur se fait exclusivement dans le fichier `values.yaml`.
>     
> - **Pourquoi la 3 est fausse :** La logique et les fonctions réutilisables sont stockées dans le fichier `_helpers.tpl` du dossier `templates/`.
>     

**Q2 : Où doit obligatoirement se trouver le fichier `_helpers.tpl` ?**

1. À la racine du Chart.
    
2. Dans le dossier `templates/`.
    
3. Dans le dossier `charts/`.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Helm scanne le dossier `templates/` pour générer les manifests ; les helpers doivent y être pour être chargés par le moteur.
>     
> - **Pourquoi la 1 est fausse :** Si placé à la racine, le moteur de rendu Helm ignorera le fichier et tes templates nommés (définis par `{{ define ... }}`) seront introuvables.
>     
> - **Pourquoi la 3 est fausse :** Le dossier `charts/` est strictement réservé aux dépendances (sous-charts) compressées ou décompressées.
>     

**Q3 : Que signifie l'underscore (`_`) au début du fichier `_helpers.tpl` ?**

1. Il indique à Helm de ne pas déployer ce fichier comme une ressource K8s.
    
2. C'est un fichier caché pour le système.
    
3. Il sert à indiquer que le fichier est crypté.
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** L'underscore indique au moteur Helm : "Lis ce fichier pour charger les fonctions, mais ne tente pas de transformer son contenu en objet Kubernetes".
>     
> - **Pourquoi la 2 est fausse :** Un fichier commençant par `_` n'est pas un fichier caché au sens OS (contrairement aux fichiers commençant par un point `.`).
>     
> - **Pourquoi la 3 est fausse :** Helm n'utilise pas de convention de nommage pour le chiffrement. Pour les données sensibles, on utilise des outils comme _Helm Secrets_ ou _Sealed Secrets_.
>     

**Q4 : À quoi sert le dossier `charts/` à la racine ?**

1. À stocker les images Docker.
    
2. À stocker les dépendances (sous-charts).
    
3. À archiver les anciennes versions.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Il contient les autres Charts dont ton projet dépend pour fonctionner.
>     
> - **Pourquoi la 1 est fausse :** Helm gère les manifests YAML. Les images Docker résident dans un registre d'images (comme Docker Hub ou ECR) et sont simplement référencées par leur URL dans le YAML.
>     
> - **Pourquoi la 3 est fausse :** Helm gère l'historique des versions via des "Releases" stockées dans le cluster K8s, pas via un dossier d'archive local.
>     

---

### 🔧 Section 2 : Fonctions & Logique Go Template

**Q5 : Quelle fonction permet de définir une valeur de secours si une variable est absente ?**

1. `fallback`
    
2. `default`
    
3. `required`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `{{ .Values.cle | default "valeur" }}` permet d'éviter les erreurs si la clé n'existe pas.
>     
> - **Pourquoi la 1 est fausse :** La fonction `fallback` n'existe pas dans le langage Go Template ni dans la bibliothèque Sprig utilisée par Helm.
>     
> - **Pourquoi la 3 est fausse :** `required` fait l'inverse : il stoppe immédiatement le rendu et affiche une erreur si la valeur est absente.
>     

**Q6 : Quelle fonction est indispensable pour transformer une donnée en format Secret Kubernetes ?**

1. `quote`
    
2. `b64enc`
    
3. `toYaml`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Kubernetes exige que les données des `Secrets` soient encodées en base64.
>     
> - **Pourquoi la 1 est fausse :** `quote` se contente d'ajouter des guillemets `" "` autour d'une valeur pour forcer le type _string_, mais ne change pas le contenu.
>     
> - **Pourquoi la 3 est fausse :** `toYaml` convertit une structure de données (liste ou dictionnaire) en bloc YAML, mais laisse les valeurs en clair.
>     

**Q7 : Quelle est la syntaxe correcte pour vérifier si `.Values.env` est égal à `"prod"` ?**

1. `{{ if eq .Values.env "prod" }}`
    
2. `{{ if .Values.env == "prod" }}`
    
3. `{{ if equals .Values.env "prod" }}`
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** Helm utilise la notation préfixée (l'opérateur vient avant les valeurs).
>     
> - **Pourquoi la 2 est fausse :** L'opérateur binaire `==` n'est pas supporté par les Go Templates. On utilise la fonction `eq`.
>     
> - **Pourquoi la 3 est fausse :** Le mot-clé exact est `eq`, `equals` n'est pas une fonction reconnue.
>     

**Q8 : Dans une boucle `range`, que représente le symbole `$` ?**

1. La fin de la boucle.
    
2. Le contexte racine (global).
    
3. Une variable temporaire.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Dans un `range`, le point `.` change de valeur pour devenir l'élément courant. Le `$` permet de revenir à la racine pour accéder à `.Values` ou `.Release`.
>     
> - **Pourquoi la 1 est fausse :** La boucle se termine par le mot-clé `{{ end }}`.
>     
> - **Pourquoi la 3 est fausse :** Bien que l'on puisse déclarer des variables personnalisées (ex: `$maVar`), le symbole `$` seul est une référence globale prédéfinie.
>     

**Q9 : Comment forcer un champ à être une chaîne de caractères (pour éviter que 01 devienne 1) ?**

1. `string()`
    
2. `quote`
    
3. `asString`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `quote` ajoute des guillemets, ce qui empêche le parser YAML de transformer un nombre commençant par 0 en base octale ou en entier.
>     
> - **Pourquoi la 1/3 sont fausses :** Ce ne sont pas des fonctions intégrées à Helm. Helm s'appuie sur les fonctions de la bibliothèque Go _Sprig_.
>     

**Q10 : Quelle fonction permet d'insérer un bloc YAML avec le bon décalage d'espaces ?**

1. `indent`
    
2. `nindent`
    
3. `align`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `nindent` ajoute une nouvelle ligne (`n`) avant d'appliquer le décalage, ce qui est crucial pour la structure YAML.
>     
> - **Pourquoi la 1 est fausse :** `indent` applique le décalage mais ne crée pas de nouvelle ligne. Cela conduit souvent à des erreurs d'alignement sur la première ligne du bloc injecté.
>     
> - **Pourquoi la 3 est fausse :** La fonction `align` n'existe pas dans le moteur de template Helm.
>     

---

### 🚀 Section 3 : Commandes & Gestion des Releases

**Q11 : Quelle commande permet de simuler un déploiement et de voir le YAML généré ?**

1. `helm install --dry-run --debug`
    
2. `helm lint`
    
3. `helm preview`
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** `--dry-run` simule l'installation et `--debug` affiche le YAML final envoyé au cluster.
>     
> - **Pourquoi la 2 est fausse :** `helm lint` vérifie la syntaxe de tes fichiers pour s'assurer qu'ils sont bien formés, mais il ne montre pas le rendu final fusionné avec tes `values`.
>     
> - **Pourquoi la 3 est fausse :** `helm preview` n'est pas une commande standard de la CLI Helm.
>     

**Q12 : Comment appelle-t-on une instance d'un Chart installée sur un cluster ?**

1. Un Chart déployé.
    
2. Une Release.
    
3. Un Snapshot.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Une Release est une version spécifique d'un Chart tournant dans un namespace.
>     
> - **Pourquoi la 1 est fausse :** C'est une description textuelle, mais pas le terme technique utilisé dans la CLI (ex: `helm list` affiche des "Releases").
>     
> - **Pourquoi la 3 est fausse :** Un Snapshot est une capture d'état (souvent pour des disques) ; Helm n'utilise pas ce terme pour ses déploiements.
>     

**Q13 : À quoi sert le plugin `helm-diff` ?**

1. À comparer deux fichiers localement.
    
2. À voir les changements réels sur le cluster avant un `upgrade`.
    
3. À corriger les erreurs.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Il compare l'état actuel du cluster avec ce que le nouveau rendu propose (très utile en CI/CD).
>     
> - **Pourquoi la 1 est fausse :** Pour comparer des fichiers locaux, on utilise la commande système `diff` ou `vimdiff`. Le plugin Helm interroge l'API Kubernetes.
>     
> - **Pourquoi la 3 est fausse :** Le plugin ne modifie pas le code, il se contente d'afficher les différences.
>     

**Q14 : Quelle commande annule un déploiement et revient à la version précédente ?**

1. `helm undo`
    
2. `helm rollback`
    
3. `helm back`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `helm rollback <nom-release> <revision>` permet de revenir en arrière instantanément.
>     
> - **Pourquoi la 1/3 sont fausses :** Ces commandes n'existent pas dans Helm. Le terme standard Kubernetes/Helm pour le retour arrière est "Rollback".
>     

**Q15 : Que fait `helm dependency update` ?**

1. Met à jour la version de Helm.
    
2. Télécharge les charts listés dans `dependencies`.
    
3. Met à jour Kubernetes.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Elle lit ton fichier `Chart.yaml` et télécharge les sous-charts nécessaires dans le dossier `charts/`.
>     
> - **Pourquoi la 1 est fausse :** Pour mettre à jour Helm, il faut télécharger le nouveau binaire sur le site officiel ou via un gestionnaire de paquets (brew, apt).
>     
> - **Pourquoi la 3 est fausse :** Helm n'a aucun pouvoir pour mettre à jour la version du cluster Kubernetes lui-même.
>     

---

### 🧪 Section 4 : Logique Avancée & Types de Charts

**Q16 : Qu'est-ce qu'un "Library Chart" ?**

1. Un chart qui installe une base de données.
    
2. Un chart qui ne contient que des helpers réutilisables.
    
3. Un chart qui contient de la documentation.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Défini par `type: library`, il sert de boîte à outils pour d'autres Charts mais ne crée aucune ressource K8s (Pod, Service) par lui-même.
>     
> - **Pourquoi la 1 est fausse :** Un Chart installant une ressource est un "Application Chart".
>     
> - **Pourquoi la 3 est fausse :** La documentation est gérée par le fichier `README.md` présent dans n'importe quel type de Chart.
>     

**Q17 : Quel est l'intérêt d'un "Umbrella Chart" ?**

1. Protéger le serveur contre la pluie (blague).
    
2. Déployer plusieurs micro-services via un seul point d'entrée.
    
3. Augmenter la sécurité du cluster.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** C'est un Chart parent qui appelle plusieurs sous-charts pour déployer une stack complète (ex: Front + Back + DB).
>     
> - **Pourquoi la 3 est fausse :** L'Umbrella Chart est une structure d'organisation, il n'apporte pas de fonctionnalités de sécurité supplémentaires par rapport à un Chart classique.
>     

**Q18 : Que se passe-t-il si j'écris `{{ if "" }}` ?**

1. Le bloc est exécuté.
    
2. Le bloc est ignoré.
    
3. Erreur de syntaxe.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** En Go Template, une chaîne vide `""` est considérée comme "Falsy" (faux). Le bloc ne sera donc pas rendu.
>     
> - **Pourquoi la 1 est fausse :** Seule une chaîne contenant au moins un caractère est "Truthy".
>     
> - **Pourquoi la 3 est fausse :** La syntaxe est correcte, c'est juste le résultat de l'évaluation qui est négatif.
>     

**Q19 : Quelle fonction arrête le rendu si une variable critique est absente ?**

1. `stop`
    
2. `fail`
    
3. `required`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** Elle permet d'afficher un message personnalisé et de bloquer le déploiement si une donnée manque dans le `values.yaml`.
>     
> - **Pourquoi la 1 est fausse :** La fonction `stop` n'existe pas dans l'écosystème Helm.
>     
> - **Pourquoi la 2 est fausse :** `fail` existe mais elle est utilisée pour forcer l'échec inconditionnel d'un template dans des cas logiques complexes, elle n'est pas spécifiquement conçue pour valider l'existence d'une variable comme le fait `required`.
>     

**Q20 : Comment passer plusieurs variables à un template nommé (helper) ?**

1. Avec des virgules.
    
2. En utilisant la fonction `dict`.
    
3. On ne peut pas.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `{{ include "mon-helper" (dict "cle1" .Val1 "cle2" .Val2) }}` permet de passer plusieurs valeurs via un dictionnaire, car Helm n'accepte qu'un seul argument.
>     
> - **Pourquoi la 1 est fausse :** La syntaxe par virgule n'est pas supportée dans les appels de templates Helm.
>     
> - **Pourquoi la 3 est fausse :** C'est tout à fait possible et même recommandé pour créer des helpers complexes.
>     

---

### 🛡️ Section 5 : Sécurité & Bonnes Pratiques

**Q21 : Où Helm stocke-t-il les informations de ses Releases par défaut ?**

1. Dans un fichier sur votre PC.
    
2. Dans des Secrets Kubernetes au sein du cluster.
    
3. Dans une base SQL externe.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Depuis Helm 3, les releases sont des `Secrets` (ou `ConfigMaps`) dans le namespace de l'application.
>     
> - **Pourquoi la 1 est fausse :** Cela empêcherait le travail collaboratif. Si tu changes de PC, tu n'aurais plus accès aux informations de tes déploiements.
>     
> - **Pourquoi la 3 est fausse :** Helm 2 utilisait un composant appelé _Tiller_ qui pouvait être configuré avec d'autres backends, mais Helm 3 a simplifié cela en utilisant nativement l'API K8s.
>     

**Q22 : Quelle est la limite DNS de caractères pour un nom de ressource K8s ?**

1. 32
    
2. 63
    
3. 256
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** C'est une limite imposée par le standard DNS RFC 1123, car les noms de services K8s deviennent des noms de domaine.
>     
> - **Pourquoi la 1 est fausse :** Trop restrictif pour les noms d'applications modernes.
>     
> - **Pourquoi la 3 est fausse :** C'est la limite pour certains chemins de fichiers ou URLs, mais trop long pour le protocole DNS.
>     

**Q23 : À quoi sert le champ `appVersion` dans `Chart.yaml` ?**

1. À définir la version du Chart Helm.
    
2. À définir la version du logiciel interne (ex: nginx 1.21).
    
3. À définir la version de Kubernetes compatible.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Il permet de savoir quelle version de ton application (le code métier) est empaquetée.
>     
> - **Pourquoi la 1 est fausse :** La version du package Helm lui-même est définie par le champ `version`.
>     
> - **Pourquoi la 3 est fausse :** La compatibilité K8s est définie par le champ `kubeVersion`.
>     

**Q24 : Que fait la fonction `trimSuffix "-" .Name` ?**

1. Supprime tous les tirets du nom.
    
2. Supprime le tirets seulement s'il est à la fin du nom.
    
3. Ajoute un tiret à la fin.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Utile pour nettoyer un nom généré qui pourrait se terminer accidentellement par un tiret (invalide en K8s).
>     
> - **Pourquoi la 1 est fausse :** Pour supprimer tous les tirets, on utiliserait la fonction `replace`.
>     
> - **Pourquoi la 3 est fausse :** Pour cela, on utiliserait `printf` ou la fonction `append`.
>     

**Q25 : Peut-on utiliser des fonctions mathématiques (add, sub) dans Helm ?**

1. Oui, via les fonctions Sprig.
    
2. Non, Helm ne fait que du texte.
    
3. Seulement pour les réplicas.
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** Helm intègre la bibliothèque Sprig qui offre des fonctions arithmétiques.
>     
> - **Pourquoi la 2 est fausse :** Bien que Helm produise du texte, il peut calculer des valeurs (ex: augmenter la mémoire de 10%) avant de les écrire.
>     
> - **Pourquoi la 3 est fausse :** Les calculs peuvent être utilisés n'importe où (limites de ressources, ports, etc.).
>     

---

### 🏁 Section 6 : Questions de Synthèse

**Q26 : Quel est le moteur de template utilisé par Helm ?**

1. Jinja2
    
2. Go Templates
    
3. Mustache
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Helm est codé en langage Go, il utilise donc le package natif `text/template`.
>     
> - **Pourquoi la 1 est fausse :** Jinja2 est utilisé par Ansible (Python).
>     
> - **Pourquoi la 3 est fausse :** Mustache est un moteur de template "logic-less" utilisé principalement en Front-end.
>     

**Q27 : Que fait `toYaml` ?**

1. Transforme une liste/dictionnaire en format YAML lisible.
    
2. Traduit du Python en YAML.
    
3. Vérifie si le YAML est valide.
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** Très pratique pour copier-coller un bloc entier de ton `values.yaml` directement dans un manifest.
>     
> - **Pourquoi la 2 est fausse :** Helm ne communique pas avec Python.
>     
> - **Pourquoi la 3 est fausse :** La validation est faite par `helm lint`.
>     

**Q28 : Quel est le rôle de `printf` ?**

1. Imprimer sur la console de debug.
    
2. Formater une chaîne de caractères complexe.
    
3. Envoyer des logs à Kubernetes.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Permet de concaténer des chaînes et des variables (ex: `{{ printf "%s-%s" .Release.Name .Chart.Name }}`).
>     
> - **Pourquoi la 1 est fausse :** Dans un template, tout ce qui est produit est écrit dans le fichier final, pas dans une console séparée.
>     
> - **Pourquoi la 3 est fausse :** Helm ne gère pas l'envoi de logs applicatifs.
>     

**Q29 : Le fichier `values.yaml` est-il modifiable lors de l'installation ?**

1. Non, il est figé dans le chart.
    
2. Oui, via le flag `-f` ou `--set`.
    
3. Seulement par l'administrateur du cluster.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** C'est la force de Helm : surcharger les valeurs par défaut selon l'environnement (Dev, Prod).
>     
> - **Pourquoi la 1 est fausse :** Si on ne pouvait pas le modifier, on perdrait tout l'intérêt du templating dynamique.
>     
> - **Pourquoi la 3 est fausse :** Quiconque a le droit d'exécuter la commande Helm et possède les droits RBAC sur le cluster peut fournir ses propres valeurs.
>     

**Q30 : Quelle commande permet de voir l'historique d'une release ?**

1. `helm history [NOM]`
    
2. `helm log`
    
3. `helm list --all`
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** Affiche la liste des révisions, la date de déploiement et l'état de chaque mise à jour.
>     
> - **Pourquoi la 2 est fausse :** `helm log` n'existe pas. Pour voir les logs, on utilise `kubectl logs`.
>     
> - **Pourquoi la 3 est fausse :** `helm list` montre les releases actuellement installées, mais ne détaille pas l'historique des versions passées pour une release spécifique.
>     

---

### 💡 Un dernier conseil pour Obsidian

Si tu veux un rendu encore plus visuel, tu peux installer le plugin **"Obsidian Charts"** ou simplement utiliser des blocs de code pour illustrer la structure des fichiers à côté de ce quiz.

**Veux-tu que je fasse le même travail de correction détaillée pour ton quiz Git/Terraform ?**