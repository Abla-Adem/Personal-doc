<span class="title-link">[[🔧 L'option backend dans les commandes Terraform]] </span>
<span class="title-link">[[📁 Terraform State Pull et Push - Guide Complet]] </span>
## 🔧 **Initialisation & Configuration**

## **`terraform init`**

**Description :** Initialise un répertoire Terraform, télécharge les providers et configure le backend.

**Options principales :**

- `-input=true|false**` _(défaut : `true`)_ : Active/désactive la saisie interactive
- `-lock=true|false**` _(défaut : `true`)_ : Verrouille le state pendant l’init
- `-upgrade**` _(défaut : non activé)_ : Met à jour tous les providers et modules
- `-backend=true|false**` _(défaut : `true`)_ : Configure le backend
- `-get=true|false**` _(défaut : `true`)_ : Télécharge les modules
- `-verify-plugins=true|false**` _(défaut : `true`)_ : Vérifie les signatures des plugins

**Exemples :**

```jsx
terraform init -upgrade -input=false
terraform init -backend=false
```

## 📋 **Planification**

## **`terraform plan`**

**Description :** Génère un plan d’exécution montrant les changements prévus.

**Options principales :**

- `-out=FICHIER**` _(défaut : aucun)_ : Sauvegarde le plan
- `-destroy**` _(défaut : non activé)_ : Plan de destruction
- `-var="key=value"**` _(défaut : aucune)_ : Définit une variable
- `-var-file=FICHIER**` _(défaut : terraform.tfvars)_ : Fichier de variables
- `-target=RESSOURCE**` _(défaut : toutes)_ : Cible une ressource spécifique
- `-detailed-exitcode**` _(défaut : non activé)_ : Code de sortie détaillé
- `-lock=true|false**` _(défaut : `true`)_ : Verrouille le state
- `-parallelism=N**` _(défaut : `10`)_ : Nombre d’opérations parallèles
- `-refresh=true|false**` _(défaut : `true`)_ : Actualise le state avant le plan
- `-refresh-only**` _(défaut : non activé)_ : Mode refresh uniquement

**Exemples :**

```jsx
terraform plan -out=plan.tfplan -var-file=prod.tfvars
terraform plan -destroy -target=aws_instance.web
terraform plan -refresh-only
```

## ⚡ **Application & Destruction**

## **`terraform apply`**

**Description :** Applique les changements pour créer/modifier l’infrastructure.

**Options principales :**

- `auto-approve` _(défaut : non activé)_ : Applique sans confirmation
- `parallelism=N` _(défaut : `10`)_ : Opérations simultanées
- `lock=true|false` _(défaut : `true`)_ : Verrouille le state
- `target=RESSOURCE` _(défaut : toutes)_ : Cible une ressource
- `var` et `var-file` : Variables comme plan
- `replace=RESSOURCE` _(défaut : aucune)_ : Force le remplacement
- `refresh-only` _(défaut : non activé)_ : Met seulement à jour le state

**Exemples :**

```jsx
terraform apply -auto-approve plan.tfplan
terraform apply -replace="aws_instance.web"
terraform apply -refresh-only
```

## **`terraform destroy`**

**Description :** Détruit toute l’infrastructure gérée par Terraform.

**Options principales :**

- `auto-approve` _(défaut : non activé)_ : Détruit sans confirmation
- `target=RESSOURCE` _(défaut : toutes)_ : Détruit une ressource spécifique
- `var` et `var-file` : Variables comme plan/apply
- `parallelism=N` _(défaut : `10`)_ : Opérations simultanées

**Exemples :**

```jsx
terraform destroy -auto-approve
terraform destroy -target=aws_instance.web
```

## 📝 **Formatage & Validation**

## **`terraform fmt`**

**Description :** Formate les fichiers Terraform selon les conventions.

**Options principales :**

- `recursive` _(défaut : non activé)_ : Formate les sous-dossiers
- `check` _(défaut : non activé)_ : Vérifie sans modifier
- `diff` _(défaut : non activé)_ : Affiche les différences
- `write=true|false` _(défaut : `true`)_ : Écrit les modifications

**Exemples :**

```jsx
terraform fmt -recursive -check
terraform fmt -diff
```

## **`terraform validate`**

**Description :** Valide la syntaxe et la logique des fichiers Terraform.

**Options principales :**

- `backend=true|false` _(défaut : `true`)_ : Valide la configuration backend
- `json` _(défaut : non activé)_ : Sortie au format JSON

**Exemples :**

```jsx
terraform validate -backend=false
terraform validate -json
```

## 🗂️ **Gestion d’État (State)**

## **`terraform state list`**

**Description :** Liste toutes les ressources dans le state file.

**Options principales :**

- `state=FICHIER` _(défaut : terraform.tfstate)_ : Fichier state à utiliser
- `id=ID` _(défaut : aucun)_ : Filtre par ID

**Exemples :**

```jsx
terraform state list
terraform state list -state=backup.tfstate
```

## **`terraform state show`**

**Description :** Affiche les détails d’une ressource spécifique.

**Options principales :**

- `state=FICHIER` _(défaut : terraform.tfstate)_ : Fichier state alternatif

**Exemples :**

```jsx
terraform state show aws_instance.web
terraform state show 'aws_instance.web[0]'
```

## **`terraform state rm`**

**Description :** Retire une ressource du state sans la supprimer.

**Options principales :**

- `dry-run` _(défaut : non activé)_ : Simule l’action
- `lock=true|false` _(défaut : `true`)_ : Verrouille le state
- `state=FICHIER` _(défaut : terraform.tfstate)_ : Fichier state

**Exemples :**

```jsx
terraform state rm aws_instance.old
terraform state rm -dry-run aws_security_group.sg
```

## **`terraform state mv`**

**Description :** Déplace/renomme une ressource dans le state.

**Options principales :**

- `dry-run` _(défaut : non activé)_ : Simule le déplacement
- `lock=true|false` _(défaut : `true`)_ : Verrouille le state

**Exemples :**

```jsx
terraform state mv aws_instance.old aws_instance.new
terraform state mv -dry-run module.old module.new
```

## **`terraform state pull`**

[📁 Terraform State Pull et Push - Guide Complet](https://www.notion.so/Terraform-State-Pull-et-Push-Guide-Complet-31626d1eabaa81c3a858d608edc5ed34?pvs=21) **[📁 Terraform State Pull et Push - Guide Complet](https://www.notion.so/Terraform-State-Pull-et-Push-Guide-Complet-31626d1eabaa81c3a858d608edc5ed34?pvs=21)**

**Description :** Télécharge et affiche le state distant.

**Exemples :**

```jsx
terraform state pull > backup.tfstate
```

## **`terraform state push`**

**Description :** Upload un state local vers le backend distant.

**Options principales :**

- `force` _(défaut : non activé)_ : Force l’upload sans vérification
- `lock=true|false` _(défaut : `true`)_ : Verrouille pendant l’upload

**Exemples :**

```jsx
terraform state push -force backup.tfstate
```

## 📥 **Import & Export**

## **`terraform import`**

**Description :** Importe une ressource existante dans le state Terraform.

**Options principales :**

- `config=CHEMIN` _(défaut : dossier courant)_ : Chemin vers la config
- `input=true|false` _(défaut : `true`)_ : Saisie interactive
- `lock=true|false` _(défaut : `true`)_ : Verrouille le state
- `lock-timeout=DURÉE` _(défaut : 0s)_ : Timeout pour le verrou
- `no-color` _(défaut : non activé)_ : Désactive les couleurs
- `parallelism=N` _(défaut : `10`)_ : Opérations parallèles
- `provider=PROVIDER` _(défaut : auto-détecté)_ : Provider à utiliser
- `state=FICHIER` _(défaut : terraform.tfstate)_ : Fichier state
- `var` et `-var-file` : Variables comme plan/apply

**Exemples :**

```jsx
terraform import aws_instance.web i-0abcd1234567890
terraform import 'aws_instance.web[0]' i-0abcd1234567890
terraform import -provider=aws.east aws_instance.web i-abc123
```

## **`terraform output`**

**Description :** Affiche les valeurs des outputs définis.

**Options principales :**

- `-json**` _(défaut : non activé)_ : Format JSON
- `-state=FICHIER**` _(défaut : terraform.tfstate)_ : Fichier state
- `-no-color**` _(défaut : non activé)_ : Désactive les couleurs
- `-raw**` _(défaut : non activé)_ : Valeur brute sans formatage

**Exemples :**

```jsx
terraform output -json
terraform output instance_ip
terraform output -raw database_password
```

## ⚠️ **Ressources Marquées (Taint/Untaint) — DÉPRÉCIÉES**

## **`terraform taint`** _(DÉPRÉCIÉE)_

**Description :** Marque une ressource pour recréation (remplacée par -replace).

**Options principales :**

- `-allow-missing**` _(défaut : non activé)_ : Succès même si ressource manquante
- `-lock=true|false**` _(défaut : `true`)_ : Verrouille le state
- `-lock-timeout=DURÉE**` _(défaut : 0s)_ : Timeout pour le verrou
- `-state=FICHIER**` _(défaut : terraform.tfstate)_ : Fichier state

**Exemples :**

```jsx
terraform taint aws_instance.web
terraform taint -allow-missing aws_instance.web
```

## **`terraform untaint`** _(DÉPRÉCIÉE)_

**Description :** Retire le marquage taint d’une ressource.

**Options principales :**

- `-allow-missing**` _(défaut : non activé)_ : Succès même si ressource manquante
- `-lock=true|false**` _(défaut : `true`)_ : Verrouille le state
- `-lock-timeout=DURÉE**` _(défaut : 0s)_ : Timeout pour le verrou
- `-state=FICHIER**` _(défaut : terraform.tfstate)_ : Fichier state

**Exemples :**

```jsx
terraform untaint aws_instance.web
```

## 🔄 **Actualisation (Refresh) — DÉPRÉCIÉE**

## **`terraform refresh`** _(DÉPRÉCIÉE)_

**Description :** Met à jour le state avec l’état réel (remplacée par -refresh-only).

**Options principales :** Accepte les mêmes options que `apply`

**Exemples :**

```jsx
terraform refresh
*# Préférer : terraform apply -refresh-only*
```

## 👁️ **Affichage & Inspection**

## **`terraform show`**

**Description :** Affiche le state actuel ou un plan sauvegardé.

**Options principales :**

- `-json**` _(défaut : non activé)_ : Format JSON lisible par machine
- `-no-color**` _(défaut : non activé)_ : Désactive les couleurs

**Exemples :**

```jsx
terraform show
terraform show -json plan.tfplan
terraform show terraform.tfstate
```

## **`terraform console`**

**Description :** Console interactive pour tester les expressions Terraform.

**Options principales :**

- `-state=FICHIER**` _(défaut : terraform.tfstate)_ : Fichier state
- `-var**` et `-var-file**` : Variables comme plan/apply

**Exemples :**

```jsx
terraform console
echo 'split(",", "a,b,c")' | terraform console
echo 'var.region' | terraform console
```

## 🏠 **Espaces de Travail (Workspaces)**

## **`terraform workspace`**

**Description :** Gestion des espaces de travail.

**Sous-commandes :**

- `new NOM**` : Crée un workspace
- `select NOM**` : Sélectionne un workspace
- `list**` : Liste les workspaces
- `show**` : Affiche le workspace courant
- `delete NOM**` : Supprime un workspace

**Options communes :**

- `-state=FICHIER**` : Fichier state (selon sous-commande)

**Exemples :**

```jsx
terraform workspace new dev
terraform workspace select prod
terraform workspace list
terraform workspace delete staging
```

### **⚔️ Git + Backends vs Workspaces**

|**Critère**|**Git + Backends**|**Workspaces**|
|---|---|---|
|**Isolation**|✅ Maximale (buckets séparés)|⚠️ Partielle (même backend)|
|**Credentials**|✅ Différents par env|❌ Identiques pour tous|
|**Versions**|✅ Versions différentes possibles|❌ Même code obligatoire|
|**CI/CD**|✅ Naturel avec branches|⚠️ Nécessite logique custom|
|**Visibilité**|✅ Clair dans Git|❌ Caché dans workspaces|
|**Complexité**|⚠️ Plus de fichiers de config|✅ Simple|

## 🔌 **Providers & Dépendances**

## **`terraform providers`**

**Description :** Affiche des informations sur les providers.

**Sous-commandes :**

- **providers** : Liste les providers
- **providers schema** : Schéma des providers
- **providers lock** : Verrouille les versions de providers

**Exemples :**

```jsx
terraform providers
terraform providers schema -json
```

## **`terraform providers lock`**

**Description :** Met à jour le fichier de verrous des dépendances.

**Options principales :**

- `-fs-mirror=CHEMIN**` _(défaut : aucun)_ : Miroir système de fichiers
- `-net-mirror=URL**` _(défaut : aucun)_ : Miroir réseau
- `-platform=OS_ARCH**` _(défaut : plateforme courante)_ : Plateformes cibles

**Exemples :**

```jsx
terraform providers lock
terraform providers lock -platform=linux_amd64 -platform=darwin_amd64
terraform providers lock -fs-mirror=/usr/share/terraform/plugins
```

## 📊 **Graphiques & Visualisation**

## **`terraform graph`**

**Description :** Génère un graphe des dépendances des ressources.

**Options principales :**

- `-type=plan|apply**` _(défaut : `plan`)_ : Type de graphe
- `-draw-cycles**` _(défaut : non activé)_ : Affiche les cycles
- `-plan=FICHIER**` _(défaut : aucun)_ : Plan à utiliser pour le graphe

**Exemples :**

```jsx
terraform graph | dot -Tpng > graph.png
terraform graph -type=apply -draw-cycles
```

## 🔐 **Authentification & Cloud**

## **`terraform login`**

**Description :** Authentification avec Terraform Cloud/Enterprise.

**Options principales :**

- `[hostname]**` _(défaut : [app.terraform.io](http://app.terraform.io))_ : Serveur d’authentification

**Exemples :**

```jsx
terraform login
terraform login terraform-enterprise.company.com
```

## **`terraform logout`**

**Description :** Déconnexion de Terraform Cloud/Enterprise.

**Options principales :**

- `[hostname]**` _(défaut : [app.terraform.io](http://app.terraform.io))_ : Serveur de déconnexion

**Exemples :**

```jsx
terraform logout
terraform logout terraform-enterprise.company.com
```

## 🔓 **Déverrouillage Forcé**

## **`terraform force-unlock`**

**Description :** Déverrouille manuellement un state verrouillé.

**Options principales :**

- `-force**` _(défaut : non activé)_ : Pas de confirmation

**Exemples :**

```jsx
terraform force-unlock a1b2c3d4-5678-9101
terraform force-unlock -force a1b2c3d4-5678-9101
```

## 🔍 **Utilitaires & Divers**

## **`terraform version`**

**Description :** Affiche la version de Terraform et des providers.

**Options principales :**

- `-json**` _(défaut : non activé)_ : Format JSON

**Exemples :**

```jsx
terraform version
terraform version -json
```

## 🌐 **Options Globales**

_(utilisables avec toutes les commandes)_

- `-chdir=RÉPERTOIRE**` _(défaut : répertoire courant)_ : Change le répertoire de travail
- `-help**` ou `-h**` : Affiche l’aide
- `-version**` : Affiche la version

**Exemples d’options globales :**

```jsx
terraform -chdir=./modules/vpc plan
terraform -help
```

## 💡 **Conseils & Astuces**

- **Toujours tester :** Utilisez `plan` avant `apply`
- **Sauvegardez vos plans :** `terraform plan -out=plan.tfplan`
- **Mode CI/CD :** Utilisez `auto-approve` et `detailed-exitcode`
- **Debugging :** `TF_LOG=DEBUG terraform <commande>`
- **Aide contextuelle :** `terraform <commande> -h` pour les options spécifiques

> 📚 Ressource : Pour chaque commande, utilisez terraform -h pour voir toutes ses options spécifiques et leurs valeurs par défaut !

# <span class="title-link">[[quizz final terraform|🌍 Maîtrise de Terraform : Le Grand Quiz (30 Questions)]] </span>