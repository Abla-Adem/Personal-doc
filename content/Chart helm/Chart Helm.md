Tester et debug:[https://helm-playground.com/](https://helm-playground.com/)

Formation intéressante: [Cours chart helm](https://www.datacamp.com/tutorial/helm-chart?utm_cid=19589720821&utm_aid=186331394309&utm_campaign=230119_1-ps-other%7Edsa-tofu%7Eall_2-b2c_3-emea_4-prc_5-na_6-na_7-le_8-pdsh-go_9-nb-e_10-na_11-na&utm_loc=9197145-&utm_mtd=-m&utm_kw=&utm_source=google&utm_medium=paid_search&utm_content=ps-other%7Eemea-en%7Edsa%7Etofu%7Etutorial%7Ekubernetes&gad_source=1&gad_campaignid=19589720821&gbraid=0AAAAADQ9WsHdkC-Bef_Frx1hIwfDXzxRf&gclid=CjwKCAjwyMnNBhBNEiwA-Kcgu651L7kmUasLP0CGA545HiiR8S7IOKABNjGypWUyo1p5TlthkqOeaxoC5BUQAvD_BwE&dc_referrer=https%3A%2F%2Fwww.google.com%2F)

# 🚀 Module : Fonctionnement Global, Architecture & Écosystème

Helm n'est pas seulement un moteur de template, c'est le **gestionnaire de paquets** standard pour Kubernetes. Il permet de packager, partager et déployer des applications complexes de manière industrielle.

## 1. Structure et Composants d'un Chart

Un Chart est un dossier organisé selon une hiérarchie stricte :

```yaml
mon-chart/
├── Chart.yaml
├── values.yaml
├── charts/
└── templates/             
    ├── _helpers.tpl       
    ├── deployment.yaml
    ├── service.yaml
    └── NOTES.txt          
```

### **`Chart.yaml`** : La carte d'identité (Nom, version de l'app, type de chart)

Ce fichier contient les métadonnées. Il indique à Helm comment traiter le package.

|**Champ**|**Obligatoire**|**Description**|
|---|---|---|
|`apiVersion`|**Oui**|`v2` pour Helm 3 (le standard actuel).|
|`name`|**Oui**|Le nom de ton Chart (ex: `mon-api-python`).|
|`version`|**Oui**|La version **du Chart** (ex: `1.0.5`). À incrémenter à chaque modif du code Helm.|
|`appVersion`|Non|La version **de ton application** (ex: `v2.4.0`). Souvent utilisé comme tag d'image.|
|`type`|Non|`application` (par défaut) ou `library` (pour les fonctions partagées).|
|`description`|Non|Une phrase expliquant ce que fait le Chart.|
|`dependencies`|Non|Liste des autres charts nécessaires (ex: `postgresql`, `redis`).|

**Exemple de `Chart.yaml` :**

```yaml
apiVersion: v2
name: ma-super-app
description: Un chart Helm pour mon application web
type: application
version: 0.1.0
appVersion: "1.16.0"
dependencies:
  - name: mariadb
    version: 11.x.x
    repository: <https://charts.bitnami.com/bitnami>
```

### **`values.yaml`** : Le fichier de configuration utilisateur

C'est ici que l'utilisateur définit ses variables. Ce fichier injecte les données dans les templates.

- **Structure libre** : Tu peux organiser tes variables comme tu veux (par blocs).
- **Bonne pratique** : Utiliser des noms explicites et regrouper par ressource (bloc `image`, bloc `service`, etc.).

**Exemple type :**

```yaml
replicaCount: 2

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "stable"

service:
  type: ClusterIP
  port: 80

resources:
  limits:
    cpu: 100m
    memory: 128Mi
```

### **`templates/`** : Les manifests Kubernetes contenant la logique (fonctions, helpers, conditions).

Ce dossier contient les fichiers Kubernetes standards, mais "templatisés". Les plus courants sont :

A. `deployment.yaml`

Définit tes Pods, le nombre de réplicas et l'image à utiliser.

- _Lien clé_ : Utilise `{{ .Values.image.repository }}` pour récupérer l'image du `values.yaml`.

B. `service.yaml`

Expose ton application sur le réseau.

- _Lien clé_ : Utilise les labels définis dans `_helpers.tpl` pour cibler les bons Pods.

C. `ingress.yaml`

Gère l'accès externe (URL/DNS). Souvent entouré d'un `{{- if .Values.ingress.enabled }}` car tout le monde n'en a pas besoin.

D. `_helpers.tpl`

Ce n'est pas un manifeste Kubernetes, mais un fichier de stockage pour tes fonctions réutilisables.

### **`charts/` (Le dossier des Dépendances)** :

Contient les "sous-charts". Si ton app a besoin d'une base de données Redis, Helm télécharge le chart Redis et le stocke ici.

### Les fichiers de "Verrouillage" & Ignorance

`values.schema.json` (Optionnel mais Pro)

Permet de forcer un format pour le `values.yaml`. Par exemple, si l'utilisateur met du texte à la place d'un nombre pour `replicaCount`, Helm affichera une erreur avant même de tenter le déploiement.

[`.helmignore`](https://www.notion.so/helmignore-32226d1eabaa80a9ad03e3d8d4b6dcdc?pvs=21)

Fonctionne comme un `.gitignore`. Il permet d'exclure des fichiers (comme des notes perso ou des tests locaux) afin qu'ils ne soient pas inclus dans le package final `.tgz`.

|**Fichier**|**Rôle en une phrase**|
|---|---|
|**`Chart.yaml`**|Je dis **qui** je suis et de **quoi** j'ai besoin.|
|**`values.yaml`**|Je propose des **options** de configuration.|
|**`templates/`**|Je décris **comment** l'app doit être installée sur K8s.|
|**`_helpers.tpl`**|Je centralise les **calculs** et les noms complexes.|

## 2. Typologie des Charts (Modèles de conception)

Selon ton architecture, tu utiliseras différents types de charts :

|**Type de Chart**|**Rôle**|**Particularité**|
|---|---|---|
|**Application Chart**|Déployer une application.|Contient des Deployments, Services, etc.|
|**Library Chart**|Partager de la logique.|`type: library`. Ne déploie rien, contient uniquement des helpers.|
|**Umbrella Chart**|Piloter une stack complète.|Regroupe plusieurs sous-charts (Frontend + Backend + DB).|

---

## 3. L'Écosystème des Plugins

Helm est extensible. Les plugins ajoutent des commandes pour répondre à des besoins spécifiques en entreprise :

- **`helm-diff`** : Affiche la différence exacte entre ce qui tourne sur le cluster et ce que tu vas déployer (évite les erreurs fatales).
- **`helm-unittest`** : Permet d'écrire des tests unitaires sur tes templates pour vérifier que tes `if/else` génèrent le bon YAML.
- **`helm-push`** : Permet d'envoyer tes packages vers un registre privé (Harbor, Nexus, Artifact Hub).

---

## 4. Commandes Essentielles (Le "Survival Kit")

### Installation & Cycle de vie

- `helm install [nom] [path]` : Crée une nouvelle **Release**.
- `helm upgrade [nom] [path]` : Met à jour une application existante.
- `helm rollback [nom] [version]` : Retour arrière immédiat si la mise à jour échoue.
- `helm uninstall [nom]` : Supprime proprement toutes les ressources liées à l'application.

### Debug & Développement

- **`-dry-run --debug`** : Indispensable. Affiche le YAML final dans la console sans rien installer sur le cluster.
- `helm lint` : Analyse ton code pour détecter les erreurs de syntaxe ou les mauvaises pratiques.
- `helm dependency update` : Télécharge les sous-charts listés dans le `Chart.yaml` pour remplir le dossier `charts/`.

---

## 5. Le Workflow Helm : Du Template à la Release

1. **Récupération** : Helm télécharge le Chart et les dépendances.
2. **Rendu (Templating)** : Le moteur fusionne les fichiers du dossier `templates/` avec les données du `values.yaml`.
3. **Expédition** : Helm envoie le YAML généré à l'API Kubernetes.
4. **Suivi** : Helm crée une **Release** (une instance de ton application) et garde un historique des versions.

---

## 💡 Résumé pour Notion (Concepts clés)

- **Chart** : Le modèle / Le code source.
- **Release** : L'application installée sur le cluster (une instance du chart).
- **Scope ($ vs .)** : Vital dans les boucles pour ne pas perdre l'accès aux variables globales.
- **Library vs Umbrella** : Le premier partage du code, le second orchestre des services.

### 🎓 Dernier Tips de pro : Les "Custom Values"

On ne modifie jamais le `values.yaml` par défaut quand on déploie. On crée un fichier spécifique pour chaque environnement : `helm install mon-app ./chart -f values-prod.yaml`

Cela permet de garder un Chart "générique" et de ne changer que les variables selon les besoins (Prod, Dev, Staging).

## [Quizz fondamentale](https://gemini.google.com/share/e2ad3ae74d95)

# 🧠 Module : Logique, Conditions et Boucles

## 1. Les Conditions (`if / else`)

Helm permet de tester des valeurs pour adapter le manifest.

### ⚠️ Le concept de "Truthy" vs "Falsy"

Helm ignore le bloc `if` si la valeur est considérée comme "fausse" ou "vide".

|**Valeur dans values.yaml**|**Résultat du if**|**Pourquoi ?**|
|---|---|---|
|`true` ou `"texte"`|✅ **Passé**|Valeur positive ou remplie.|
|`123`|✅ **Passé**|Tout nombre différent de 0 est vrai.|
|`false`, `""`, `0`|❌ **Ignoré**|Valeurs considérées comme "fausses".|
|`[]` ou `{}`|❌ **Ignoré**|Liste ou dictionnaire vide.|

---

## 2. Opérateurs de Comparaison et Logiques

**Attention :** Helm utilise la syntaxe Go. L'opérateur se place **avant** les arguments.

`{{ if eq .A .B }}` et non `{{ if .A == .B }}`.

### A. Les Comparateurs

|**Opérateur**|**Signification**|**Exemple**|
|---|---|---|
|`eq`|Égal à|`{{ if eq .Values.type "nginx" }}`|
|`ne`|Différent de|`{{ if ne .Values.env "prod" }}`|
|`lt` / `gt`|Plus petit / Plus grand|`{{ if gt .Values.replicas 3 }}`|
|`le` / `ge`|Inférieur ou égal / Supérieur ou égal|`{{ if le .Values.cpu 1 }}`|

### B. Les Opérateurs Logiques

Ils permettent de combiner plusieurs tests.

- **`and`** : Toutes les conditions doivent être vraies.
- **`or`** : Au moins une condition doit être vraie.
- **`not`** : Inverse le résultat.

**Exemple complexe :**

```yaml
{{- if and .Values.ingress.enabled (or (eq .Values.env "prod") .Values.ingress.force) }}
# Ce bloc s'affiche si l'ingress est activé ET (si on est en prod OU si force est vrai)
{{- end }}
```

---

## 3. Les Boucles (`range`)

Elles servent à répéter un bloc pour chaque élément d'une liste.

### ⚠️ Le changement de Scope (Le "Point" vs le "Dollar")

À l'intérieur d'un `range`, le point `.` change de sens : il devient l'item de la liste.

- **`.`** : L'objet de la boucle.
- **`$`** : Le contexte global (pour revenir à `.Values` ou `.Release`).

```yaml
env:
{{- range .Values.envList }}
  - name: {{ .name | quote }}
    value: {{ .value | default $.Values.globalDefault | quote }}
{{- end }}
```

---

## 4. Exemple "Master" : Le sélecteur intelligent

On combine ici une condition, une comparaison et le passage de contexte global.

### Source : `values.yaml`

```yaml
appType: "web"
monitoring:
  enabled: true
  endpoints:
    - port: 8080
    - port: 9090
```

### Source : `templates/config.yaml`

```yaml
{{- if and .Values.monitoring.enabled (eq .Values.appType "web") -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
data:
  {{- range .Values.monitoring.endpoints }}
  # On utilise le "." pour le port de l'item actuel
  # On utilise le "$" pour le nom du Chart (racine)
  service-{{ .port }}: {{ printf "App %s sur port %d" $.Chart.Name .port | quote }}
  {{- end }}
{{- end -}}
```

### 🏁 Résultat Final (YAML généré)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ma-release-config
data:
  service-8080: "App mon-chart sur port 8080"
  service-9090: "App mon-chart sur port 9090"
```

---

## 💡 Résumé "Tricheur" (Cheat Sheet Logique)

1. **Syntaxe Préfixée** : Toujours `{{ if eq A B }}`.
2. **Parenthèses** : Utilise des parenthèses pour grouper les `and` et `or`.
3. **End** : Tout `if` et tout `range` doit se terminer par `{{- end }}`.
4. **Tirets** : `{{-` au début et `}}` à la fin pour supprimer les lignes vides fantômes.

---

## [Quizz if/Range](https://gemini.google.com/share/e22f2a44d674)

# 🧰 Catalogue des Fonctions Helm

Les fonctions s'utilisent généralement avec le "pipe" (`|`), ce qui permet d'enchaîner les transformations (ex: `valeur | fonction1 | fonction2`).

## 1. Fonctions de Transformation de Texte

### `quote` / `squote`

- **Rôle** : Entoure la valeur de guillemets doubles (`"`) ou simples (`'`).
- **Pourquoi ?** : Indispensable pour les chaînes qui ressemblent à des nombres ou des booléens (ex: "true", "012345") pour que Kubernetes ne change pas leur type.
- **Exemple** : `version: {{ .Values.appVersion | quote }}`
- **Résultat** : `version: "1.2.3"`

### `upper` / `lower` / `title`

- **Rôle** : Change la casse du texte.
- **Exemple** : `env: {{ .Values.envName | upper }}`
- **Résultat** : `env: PRODUCTION`

### `replace`

- **Rôle** : Remplace un caractère ou une chaîne par une autre.
- **Exemple** : `hostname: {{ .Values.url | replace "." "-" }}`
- **Résultat** : `hostname: mon-site-com`

---

## 2. Fonctions de Sécurité et Logique

### `default`

- **Rôle** : Donne une valeur de secours si la variable est absente ou vide.
- **Exemple** : `replicas: {{ .Values.replicaCount | default 1 }}`
- **Résultat** : `replicas: 1` (si non défini dans values.yaml)

### `required`

- **Rôle** : Interrompt le déploiement avec un message si la valeur est manquante.
- **Exemple** : `token: {{ .Values.apiToken | required "Le token API est obligatoire !" }}`
- **Résultat** : `Error: Le token API est obligatoire !` (si manquant)

---

## 3. Fonctions de Structure (YAML & Indentation)

### `toYaml`

- **Rôle** : Transforme une liste ou un dictionnaire complexe en format YAML.
    
- **Exemple** :YAMLYAML
    
    ```yaml
    # values.yaml
    labels:
      team: data
      project: analysis
    ```
    
    ```yaml
    # template.yaml
    metadata:
      labels:
        {{- toYaml .Values.labels | nindent 4 }}
    ```
    
- **Résultat** :
    
    `metadata: labels: team: data project: analysis`
    

### `nindent`

- **Rôle** : Ajoute une nouvelle ligne + X espaces avant le texte.
- **Pourquoi ?** : C'est la fonction la plus importante pour que le YAML généré soit valide.
- **Exemple** : `{{ include "mon_helper" . | nindent 8 }}`
- **Résultat** : Décale tout le bloc de 8 espaces à droite après avoir sauté une ligne.

---

## 4. Fonctions d'Encodage

### `b64enc` / `b64dec`

- **Rôle** : Encode ou décode en Base64.
- **Pourquoi ?** : Obligatoire pour les `Secrets` Kubernetes.
- **Exemple** : `password: {{ .Values.rawPassword | b64enc | quote }}`
- **Résultat** : `password: "YWRtaW4xMjM="`

---

## 5. Fonctions de Calcul et Listes

### `printf`

- **Rôle** : Construit une chaîne formatée (comme en C ou en Go).
- **Exemple** : `image: {{ printf "%s/%s:%s" .Values.reg .Values.repo .Values.tag }}`
- **Résultat** : `image: docker.io/my-app:v1.0`

### `join`

- **Rôle** : Fusionne les éléments d'une liste avec un séparateur.
- **Exemple** : `hosts: {{ join "," .Values.ingress.hosts }}`
- **Résultat** : `hosts: site1.com,site2.com`

---

## 💡 Le Flux de Données

Voici comment une donnée traverse les fonctions dans un template Helm professionnel :

**Exemple combiné ultime :**

`{{ .Values.dbPassword | required "Manquant" | b64enc | quote }}`

1. On vérifie s'il existe (`required`).
2. On l'encode pour K8s (`b64enc`).
3. On sécurise le format YAML (`quote`).

## ⚡ Helm Functions : Le Cheat Sheet

|**Catégorie**|**Fonction**|**Syntaxe Courte**|**Résultat Attendu**|
|---|---|---|---|
|**Sécurité**|`required`|`{{ .V.cle|required "Err" }}`|
|**Sécurité**|`default`|`{{ .V.cle|default 1 }}`|
|**Format**|`quote`|`{{ .V.cle|quote }}`|
|**Format**|`nindent`|`{{ include "x" .|nindent 4 }}`|
|**Texte**|`upper`|`{{ .V.cle|upper }}`|
|**Texte**|`printf`|`{{ printf "%s-%s" .V.a .V.b }}`|`valeurA-valeurB`|
|**Secret**|`b64enc`|`{{ .V.cle|b64enc }}`|
|**Objet**|`toYaml`|`{{ toYaml .V.objet }}`|Sérialise un bloc entier en YAML.|
|**Boucle**|`dict`|`(dict "k1" . "k2" $)`|Emballe plusieurs arguments.|

---

## 🚀 3 Enchaînements "Incontournables" à copier-coller

### 1. Le bloc de configuration dynamique

Idéal pour injecter tout un dictionnaire du `values.yaml` dans un ConfigMap ou un Deployment.

YAML

`{{- toYaml .Values.config | nindent 2 }}`

### 2. Le secret ultra-sécurisé

Vérifie la présence, encode en base64 et ajoute les guillemets.

YAML

`password: {{ .Values.db.pwd | required "MDP requis" | b64enc | quote }}`

### 3. Le nom de ressource standardisé

Combine le nom de la release et le nom du chart, le tout tronqué pour respecter la limite K8s de 63 caractères.

YAML

`name: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}`

### Important :

> **Le secret du "Pipe" (`|`)** : On fait toujours `required` avant de transformer la donnée. On termine toujours par `quote` ou `nindent` pour l'esthétique du fichier final.

## [Quizz fonction](https://gemini.google.com/share/742cb92b6ffa)

# 🏗️ Module : Maîtriser le `_helpers.tpl`

Le fichier `_helpers.tpl` est la bibliothèque de fonctions de votre Chart. Il permet de centraliser la logique complexe pour garder vos fichiers YAML (Deployments, Services) lisibles.

## 1. Concept : Le "Tampon" Réutilisable

Au lieu de copier-coller 10 lignes de labels dans chaque fichier, vous créez un **Named Template** (un modèle nommé) dans `_helpers.tpl`.

- **Définition** : `{{- define "monapp.labels" -}} ... {{- end -}}`
- **Appel** : `{{ include "monapp.labels" . }}`

---

## 2. Gestion des Valeurs & Sécurité (Niveau Intermédiaire)

|**Fonction**|**Rôle technique**|**Pourquoi l'utiliser ?**|**Exemple**|
|---|---|---|---|
|**`default`**|Valeur de repli|**Éviter le vide.** Si l'option est absente, le Chart ne plante pas.|`{{ .Values.port|
|**`required`**|Arrêt immédiat|**Forcer la saisie.** Indispensable pour les secrets ou URL.|`{{ .Values.dbUrl|
|**`quote`**|Force le type String|**Éviter les erreurs YAML.** Empêche un nombre d'être mal interprété.|`{{ .Values.version|
|**`nindent`**|Retour ligne + Espaces|**Indentation propre.** Aligne parfaitement le texte généré.|`{{ include "..." .|
|**`b64enc`**|Encodage Base64|**Conformité K8s.** Obligatoire pour les objets `Secret`.|`{{ .Values.pwd|

---

## 3. La Logique Avancée : Contextes & Multi-Arguments

- **Le piège de la boucle (`range`)** : Dans un `range`, le point `.` devient l'élément de la liste. Utilisez le dollar **`$`** pour revenir à la racine : `{{ include "helper" $ }}`.
- **Multi-arguments avec `dict`** : Pour envoyer plusieurs données à un helper, emballez-les dans un dictionnaire : `(dict "clé1" valeur1 "clé2" valeur2)`.

---

## 4. L'Exemple "Master" : Générateur d'Environnement

Cet exemple montre comment transformer une liste simpliste en variables d'environnement Kubernetes robustes.

### Source : `_helpers.tpl`

```yaml
{{- define "monapp.renderEnv" -}}
- name: {{ .envData.name | upper | quote }}
  value: {{ .envData.value | default .root.Values.globalDefaultValue | quote }}
{{- end -}}
```

### Source : `values.yaml`

```yaml
globalDefaultValue: "VALEUR_PAR_DEFAUT"
configs:
  - name: "api_url"
    value: "<https://api.com>"
  - name: "debug_mode"
    # Pas de value ici, le helper utilisera la globale
```

### Appel : `templates/deployment.yaml`

```yaml
env:
{{- range .Values.configs }}
  {{- include "monapp.renderEnv" (dict "envData" . "root" $) | nindent 12 }}
{{- end }}
```

---

### 🏁 Résultat Final (Rendu YAML)

Voici ce que Helm génère réellement et envoie au cluster Kubernetes :

```yaml
# Résultat après exécution
env:
  - name: "API_URL"
    value: "<https://api.com>"
  - name: "DEBUG_MODE"
    value: "VALEUR_PAR_DEFAUT"
```

### 💡 Pourquoi c'est brillant ?

1. **Uniformité** : Tous vos noms de variables sont passés en majuscules automatiquement via `upper`.
2. **Sécurité** : Toutes les valeurs ont des guillemets grâce à `quote`, évitant les crashs sur des valeurs purement numériques.
3. **Flexibilité** : Si vous changez la `globalDefaultValue` dans le `values.yaml`, elle se propage partout instantanément.

---

**Ta formation est maintenant prête ! Veux-tu que je génère un petit exercice "Trouvez l'erreur" pour valider le module ?**

### [Quizz _helpers.tpl](https://gemini.google.com/share/0d4b69e0f608)

# <span class="title-link">[[Quizz Final|🏆 Grand Quiz Final : Maîtrise Totale de Helm]] </span>

[Créer quizz](https://www.notion.so/Cr-er-quizz-32226d1eabaa80f49c17ec668dbc5ccb?pvs=21)