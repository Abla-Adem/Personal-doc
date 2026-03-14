Voici la version enrichie de ton quiz Terraform pour **Obsidian**. J'ai ajouté l'analyse systématique des propositions incorrectes pour chaque question, afin de t'aider à comprendre les nuances entre les commandes.

---

# 🌍 Maîtrise de Terraform : Le Grand Quiz (30 Questions)

> [!abstract] Instructions
> 
> Cliquez sur la flèche à côté de **"Correction & Explication"** pour révéler la réponse. Ce quiz teste votre connaissance des commandes, des options de sécurité et de la gestion de l'infrastructure as code.

---

### 🔧 Section 1 : Initialisation & Configuration

**Q1 : Quelle commande télécharge les providers et initialise le backend mais peut aussi mettre à jour les modules existants avec une option spécifique ?**

1. `terraform refresh`
    
2. `terraform init -upgrade`
    
3. `terraform get -update`
    
4. `terraform plan -install`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `terraform init -upgrade` force la mise à jour des versions des providers et des modules selon les contraintes du code.
>     
> - **Pourquoi la 1 est fausse :** `refresh` (déprécié) ne télécharge rien, il interroge l'état du Cloud pour mettre à jour le _state_.
>     
> - **Pourquoi la 3 est fausse :** `terraform get` télécharge les modules mais ne gère ni les providers ni le backend.
>     
> - **Pourquoi la 4 est fausse :** Cette commande n'existe pas. `plan` ne peut pas installer de composants.
>     

**Q2 : Que se passe-t-il si vous lancez `terraform init -backend=false` ?**

1. Terraform initialise les plugins mais ne configure pas le stockage du state.
    
2. Terraform supprime le backend existant.
    
3. Terraform échoue car le backend est obligatoire.
    
4. Terraform utilise un backend local par défaut sans poser de questions.
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** Cela permet d'initialiser les plugins pour la validation ou le linting sans accès au stockage distant.
>     
> - **Pourquoi la 2 est fausse :** Terraform ne supprime rien, il ignore juste la configuration du bloc `backend`.
>     
> - **Pourquoi la 3 est fausse :** Le backend n'est pas obligatoire pour l'initialisation des providers ou la validation locale.
>     
> - **Pourquoi la 4 est fausse :** Si le code définit un backend (S3, etc.), Terraform n'en créera pas un local par défaut si vous lui demandez d'ignorer le backend.
>     

---

### 📋 Section 2 : Planification & Variables

**Q3 : Quelle option de `terraform plan` permet de s'assurer que le plan ne contient que des suppressions de ressources ?**

1. `-destroy`
    
2. `-delete-only`
    
3. `-remove`
    
4. `-refresh-only`
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** `-destroy` crée un plan où l'action de chaque ressource est la destruction.
>     
> - **Pourquoi la 2/3 sont fausses :** Ce ne sont pas des options valides de la CLI Terraform.
>     
> - **Pourquoi la 4 est fausse :** `-refresh-only` ne prévoit aucune modification d'infrastructure, il met seulement à jour le fichier _state_.
>     

**Q4 : Comment sauvegarder un plan pour être certain que l'exécution (`apply`) correspond exactement à ce qui a été validé ?**

1. `terraform plan -save=plan.txt`
    
2. `terraform plan -out=plan.tfplan`
    
3. `terraform plan > plan.tfplan`
    
4. `terraform apply -freeze`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `-out` génère un fichier binaire compressé qui contient le plan exact et l'état des ressources à ce moment précis.
>     
> - **Pourquoi la 1 est fausse :** L'option `-save` n'existe pas.
>     
> - **Pourquoi la 3 est fausse :** Rediriger la sortie textuelle dans un fichier ne crée pas un fichier exploitable par `apply`.
>     
> - **Pourquoi la 4 est fausse :** `-freeze` n'est pas une commande Terraform.
>     

**Q5 : Que fait l'option `-target=aws_instance.web` lors d'un plan ?**

1. Elle définit `aws_instance.web` comme la ressource prioritaire.
    
2. Elle limite l'exécution du plan uniquement à cette ressource et ses dépendances.
    
3. Elle importe la ressource dans le state.
    
4. Elle remplace la ressource.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Elle isole la ressource spécifiée pour une intervention chirurgicale.
>     
> - **Pourquoi la 1 est fausse :** Terraform ne gère pas de "priorités", il gère des graphes de dépendances.
>     
> - **Pourquoi la 3 est fausse :** L'import se fait avec `terraform import`.
>     
> - **Pourquoi la 4 est fausse :** Pour remplacer, on utilise `-replace` (ou l'ancien `taint`).
>     

---

### ⚡ Section 3 : Application & Destruction

**Q6 : Quelle option de `terraform apply` permet de forcer la recréation d'une ressource spécifique sans utiliser la commande `taint` ?**

1. `-recreate`
    
2. `-replace="ressource_id"`
    
3. `-force-new`
    
4. `-refresh-only`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** C'est l'option moderne qui marque la ressource pour destruction/création immédiate.
>     
> - **Pourquoi la 1/3 sont fausses :** Ces options n'existent pas.
>     
> - **Pourquoi la 4 est fausse :** Comme pour le plan, cela ne modifie pas l'infrastructure.
>     

**Q7 : Dans quel cas utiliseriez-vous `terraform apply -refresh-only` ?**

1. Pour forcer la création de nouvelles ressources.
    
2. Pour mettre à jour le fichier state local avec la réalité du Cloud sans rien modifier sur l'infrastructure.
    
3. Pour vider le cache des providers.
    
4. Pour valider la syntaxe HCL.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Remplace `terraform refresh`. Détecte le "drift" (dérive) entre le code et le Cloud.
>     
> - **Pourquoi la 1 est fausse :** Cette option exclut toute création.
>     
> - **Pourquoi la 3 est fausse :** Le cache des providers se gère au niveau du dossier `.terraform`.
>     
> - **Pourquoi la 4 est fausse :** C'est le rôle de `terraform validate`.
>     

---

### 📝 Section 4 : Formatage & Validation

**Q8 : Quelle commande permet de vérifier si vos fichiers Terraform sont bien indentés sans les modifier réellement ?**

1. `terraform fmt -check`
    
2. `terraform fmt -verify`
    
3. `terraform validate -fmt`
    
4. `terraform fmt -diff=false`
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** `-check` renvoie un code de sortie d'erreur si le formatage n'est pas parfait, sans modifier les fichiers.
>     
> - **Pourquoi la 2 est fausse :** `-verify` n'est pas une option de `fmt`.
>     
> - **Pourquoi la 3 est fausse :** `validate` vérifie la logique et la syntaxe, pas l'alignement visuel (espaces/tabulations).
>     
> - **Pourquoi la 4 est fausse :** `-diff=false` cacherait les différences mais ne donnerait pas de statut de validation.
>     

**Q9 : Quelle est la différence majeure entre `terraform fmt` et `terraform validate` ?**

1. `fmt` vérifie la logique, `validate` vérifie l'esthétique.
    
2. `fmt` réorganise le texte, `validate` vérifie la syntaxe, les types et la cohérence des arguments.
    
3. Il n'y a aucune différence.
    
4. `validate` télécharge les plugins.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `fmt` est purement cosmétique. `validate` est fonctionnel (vérifie les variables, les types, les blocs obligatoires).
>     
> - **Pourquoi la 1 est fausse :** C'est l'inverse.
>     
> - **Pourquoi la 4 est fausse :** Les plugins sont téléchargés par `init`, pas par `validate`.
>     

---

### 🗂️ Section 5 : Gestion du State (État)

**Q10 : Vous voulez renommer une ressource dans votre code mais ne voulez pas que Terraform la détruise et la recrée. Quelle commande state utilisez-vous ?**

1. `terraform state rm` suivi d'un `import`.
    
2. `terraform state mv`
    
3. `terraform state rename`
    
4. `terraform state pull`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `mv` déplace l'entrée dans le fichier d'état d'un nom vers un autre.
>     
> - **Pourquoi la 1 est fausse :** C'est une solution de contournement manuelle lourde et risquée.
>     
> - **Pourquoi la 3 est fausse :** La commande exacte est `mv` (move), pas `rename`.
>     
> - **Pourquoi la 4 est fausse :** `pull` ne fait que lire le state distant.
>     

**Q11 : Quelle commande permet de retirer une ressource du suivi de Terraform sans la supprimer de votre fournisseur Cloud (AWS/Azure) ?**

1. `terraform destroy -target`
    
2. `terraform state rm`
    
3. `terraform untaint`
    
4. `terraform delete --soft`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `state rm` supprime la ressource du fichier `.tfstate`. Pour Terraform, elle n'existe plus, mais elle reste intacte sur le Cloud.
>     
> - **Pourquoi la 1 est fausse :** `destroy` supprimerait réellement la ressource sur le Cloud.
>     
> - **Pourquoi la 3 est fausse :** `untaint` annule juste un marquage de recréation forcée.
>     
> - **Pourquoi la 4 est fausse :** Commande inexistante.
>     

**Q12 : À quoi sert `terraform force-unlock [ID]` ?**

1. À craquer le mot de passe d'un utilisateur.
    
2. À débloquer manuellement le state si un processus Terraform s'est crashé et n'a pas libéré le verrou.
    
3. À forcer l'accès à un bucket S3.
    
4. À outrepasser les restrictions de sécurité du provider.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Indispensable quand un lock (verrou) persiste après une erreur réseau ou un crash.
>     
> - **Pourquoi la 4 est fausse :** Terraform ne peut pas outrepasser les droits IAM/RBAC du Cloud.
>     

---

### 🏠 Section 6 : Workspaces & Cloud

**Q13 : Quelle est la principale faiblesse des Workspaces par rapport à une isolation via Git + Backends séparés ?**

1. Ils sont plus lents.
    
2. Ils partagent généralement les mêmes credentials et le même backend de stockage.
    
3. On ne peut pas avoir de ressources différentes.
    
4. Ils coûtent plus cher.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Danger de sécurité : un accès au backend permet de voir tous les environnements (dev/prod).
>     
> - **Pourquoi la 3 est fausse :** On peut avoir des ressources différentes via des variables basées sur `terraform.workspace`.
>     

**Q14 : Quelle commande permet d'extraire les données du state distant pour les consulter localement au format JSON ?**

1. `terraform state pull | jq`
    
2. `terraform show -json`
    
3. Les deux sont possibles.
    
4. `terraform state list -format=json`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** `state pull` récupère le JSON brut, `show -json` donne une version formatée plus complète de l'état actuel.
>     
> - **Pourquoi la 4 est fausse :** `state list` ne donne que les noms des ressources, pas leurs détails en JSON.
>     

---

### 📥 Section 7 : Import & Utilitaires

**Q15 : Que devez-vous obligatoirement faire AVANT de lancer `terraform import` ?**

1. Détruire la ressource existante.
    
2. Écrire le bloc de configuration de la ressource dans votre code `.tf`.
    
3. Désactiver le backend.
    
4. Lancer un `terraform destroy`.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Terraform a besoin d'une adresse de ressource dans le code pour savoir où attacher l'import.
>     
> - **Pourquoi la 1/4 sont fausses :** L'import sert justement à ne pas détruire ce qui existe.
>     

**Q16 : Quelle commande permet de tester des fonctions Terraform (comme `split()`, `abs()`) ou de voir la valeur d'une variable sans faire un `apply` ?**

1. `terraform test`
    
2. `terraform console`
    
3. `terraform echo`
    
4. `terraform check`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `console` ouvre un shell interactif pour évaluer les expressions HCL.
>     
> - **Pourquoi la 1 est fausse :** `terraform test` est un framework pour les tests unitaires de modules (plus complexe).
>     

**Q17 : Que signifie l'option `-detailed-exitcode` ?**

1. Elle affiche le log en couleur.
    
2. Elle modifie le code de sortie (0, 1 ou 2) selon qu'il y a des changements, des erreurs ou rien à faire.
    
3. Elle affiche l'heure exacte de chaque création.
    
4. Elle génère un rapport PDF.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Crucial en CI/CD : permet au script de savoir si un `apply` est nécessaire.
>     
> - **Pourquoi la 1 est fausse :** C'est l'option `-no-color` qui gère les couleurs.
>     

---

### 🔄 Section 8 : Questions Avancées & Maintenance

**Q18 : Pourquoi les commandes `taint` et `untaint` sont-elles aujourd'hui dépréciées ?**

1. Parce qu'elles étaient trop dangereuses.
    
2. Parce qu'elles ont été remplacées par l'option `-replace` lors du `apply`.
    
3. Parce que Terraform n'autorise plus la recréation de ressources.
    
4. Parce qu'elles corrompaient le state.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `-replace` permet de déclarer l'intention de recréation au moment du plan/apply sans modifier l'état de façon persistante auparavant.
>     

**Q19 : Quelle commande permet de visualiser les dépendances entre vos ressources sous forme de graphique ?**

1. `terraform visualize`
    
2. `terraform tree`
    
3. `terraform graph`
    
4. `terraform show --graph`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> - **Justesse :** Produit un format GraphViz (DOT).
>     
> - **Pourquoi la 1/2 sont fausses :** Commandes inexistantes.
>     

**Q20 : Quelle variable d'environnement active le mode debug maximum dans les logs de Terraform ?**

1. `DEBUG=true`
    
2. `TF_LOG=TRACE`
    
3. `TERRAFORM_VERBOSE=1`
    
4. `LOG_LEVEL=DEBUG`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `TF_LOG` est la variable standard, `TRACE` est le niveau le plus élevé après `DEBUG`.
>     

**Q21 : Que fait `terraform providers lock` ?**

1. Il empêche la modification des ressources.
    
2. Il génère ou met à jour le fichier `.terraform.lock.hcl` pour garantir que toute l'équipe utilise les mêmes versions de plugins.
    
3. Il verrouille le compte AWS.
    
4. Il crypte les mots de passe.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Assure la sécurité et la reproductibilité des installations.
>     

**Q22 : Quelle option globale permet de lancer une commande Terraform depuis un dossier différent sans se déplacer ?**

1. `-path`
    
2. `-chdir=RÉPERTOIRE`
    
3. `-cwd`
    
4. `-dir`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** `-chdir` doit être placé avant la sous-commande (ex: `terraform -chdir=... plan`).
>     

**Q23 : Comment afficher uniquement la valeur brute d'un output sans guillemets ni formatage ?**

1. `terraform output -raw [nom]`
    
2. `terraform output -json`
    
3. `terraform show output`
    
4. `terraform get output`
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** `-raw` est très pratique pour récupérer des mots de passe ou des IPs dans des scripts Bash.
>     

**Q24 : Quelle est la différence entre `terraform login` et `terraform login [hostname]` ?**

1. Aucune.
    
2. La première utilise app.terraform.io, la seconde cible une instance Terraform Enterprise spécifique.
    
3. La seconde est obligatoire.
    
4. La première est pour les comptes gratuits uniquement.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Permet de s'authentifier sur des instances privées (Enterprise).
>     

**Q25 : Que se passe-t-il si vous lancez `terraform apply -auto-approve` sans fichier de plan ?**

1. Terraform échoue car il a besoin d'un fichier `.tfplan`.
    
2. Terraform génère un plan temporaire et l'applique immédiatement sans demander de confirmation.
    
3. Terraform demande quand même une confirmation pour les ressources critiques.
    
4. Terraform ne fait que rafraîchir le state.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Option utilisée dans les pipelines automatisés. Risqué car aucune vérification humaine n'est faite.
>     

**Q26 : Quelle commande permet de voir les schémas de données attendus par les providers installés ?**

1. `terraform providers schema`
    
2. `terraform inspect`
    
3. `terraform provider -show`
    
4. `terraform debug schema`
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> - **Justesse :** Utile pour les outils d'autocomplétion ou pour comprendre les attributs d'une ressource.
>     

**Q27 : Que fait l'option `-parallelism=N` ?**

1. Elle définit le nombre de cœurs CPU utilisés.
    
2. Elle limite le nombre d'opérations simultanées sur les ressources (défaut : 10).
    
3. Elle permet de déployer sur N régions à la fois.
    
4. Elle définit le nombre de fichiers de config lus.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Utile pour éviter le "rate limiting" (limitation de débit) des APIs Cloud.
>     

**Q28 : Quelle commande permet d'afficher le message d'aide spécifique aux options de `terraform state mv` ?**

1. `terraform help state mv`
    
2. `terraform state mv -h`
    
3. `terraform state -help`
    
4. `terraform h state mv`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Placer `-h` après la commande complète donne l'aide contextuelle.
>     

**Q29 : À quoi sert l'option `-verify-plugins=false` dans `terraform init` ?**

1. À accélérer l'initialisation.
    
2. À ignorer la vérification des signatures numériques des plugins (déconseillé en prod).
    
3. À utiliser des plugins écrits en Python.
    
4. À désactiver la mise à jour des plugins.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** Option de contournement de sécurité.
>     
> - **Pourquoi la 3 est fausse :** Les plugins Terraform sont écrits en Go.
>     

**Q30 : Vous voulez supprimer un workspace nommé `staging`. Quelle est la syntaxe ?**

1. `terraform workspace rm staging`
    
2. `terraform workspace delete staging`
    
3. `terraform destroy workspace staging`
    
4. `terraform workspace -delete staging`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> - **Justesse :** La commande est `delete`.
>     
> - **Note :** On ne peut pas supprimer le workspace "default" ni celui sur lequel on se trouve.
>     

---

### ✅ Prochaines étapes

Tu peux maintenant copier ce bloc dans Obsidian. Veille à ce que le plugin **Admonitions** ou le support natif des Callouts soit activé pour profiter des blocs repliables.

**Veux-tu que je fasse la même chose pour le cours Git que tu as partagé plus haut ?**