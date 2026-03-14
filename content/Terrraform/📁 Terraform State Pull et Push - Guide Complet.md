Les commandes `terraform state pull` et `terraform state push` sont **essentielles** pour la gestion manuelle des fichiers d’état. Voici tout ce que tu dois savoir :

## **🔽 `terraform state pull`**

## **Description :**[1](https://developer.hashicorp.com/terraform/cli/commands/state/pull)[2](https://terraformguru.com/terraform-certification-using-aws-cloud/07-Terraform-State/07-02-Terraform-State-Commands/)[3](https://blog.stephane-robert.info/docs/infra-as-code/provisionnement/terraform/gestion-state/)

Télécharge le fichier d’état depuis le backend (local ou distant) et l’affiche en format JSON sur la sortie standard.

## **Syntaxe :**

`bashterraform state pull`

## **🎯 Qu’est-ce que ça fait exactement ?**[1](https://developer.hashicorp.com/terraform/cli/commands/state/pull)4

- **Télécharge** le state depuis son emplacement actuel (S3, Azure, local…)
- **Met à niveau** la version du state vers celle compatible avec ton Terraform local
- **Affiche** le contenu brut en JSON sur stdout
- **Ne modifie RIEN** - c’est en lecture seule

## **🔼 `terraform state push`**

## **Description :**[5](https://developer.hashicorp.com/terraform/cli/commands/state/push)[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)[7](https://support.hashicorp.com/hc/en-us/articles/40171587510803-Migrating-and-Pushing-Terraform-State-from-One-Backend-to-Another)

Upload un fichier d’état local vers le backend configuré (distant ou local).

## **Syntaxe :**

`bashterraform state push [options] PATH terraform state push terraform.tfstate terraform state push - *# Lecture depuis stdin*`

## **🎯 Qu’est-ce que ça fait exactement ?**[5](https://developer.hashicorp.com/terraform/cli/commands/state/push)[8](https://discuss.hashicorp.com/t/terraform-state-push/64500)

- **Upload** le state spécifié vers le backend configuré
- **Vérifie** la cohérence avant l’upload (lineage, serial)
- **Écrase** le state distant avec la version locale
- **Crée des backups** automatiquement

## **🛠️ Cas d’usage pratiques**

## **1. Sauvegarder le state distant**[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)[2](https://terraformguru.com/terraform-certification-using-aws-cloud/07-Terraform-State/07-02-Terraform-State-Commands/)[9](https://stackoverflow.com/questions/78307858/how-do-i-find-the-location-of-my-terraform-state)

```bash
# Exporter le state vers un fichier local
terraform state pull > backup_state.tfstate
# Ou avec une date
terraform state pull > "state_backup_$(date +%Y%m%d_%H%M%S).tfstate"
```

## **2. Examiner le contenu du state**[2](https://terraformguru.com/terraform-certification-using-aws-cloud/07-Terraform-State/07-02-Terraform-State-Commands/)4

```bash
# Voir tout le state en JSON*
terraform state pull

# Voir uniquement certaines infos avec jq*
terraform state pull | jq '.resources[] | select(.type=="aws_instance")'

# Voir la version du state*
terraform state pull | jq '.terraform_version'
```

## **3. Migration entre backends**[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)[7](https://support.hashicorp.com/hc/en-us/articles/40171587510803-Migrating-and-Pushing-Terraform-State-from-One-Backend-to-Another)[10](https://blog.wahab2.com/different-ways-to-migrate-terraform-state-6497b7baef05)

**Scénario :** Migrer de backend A vers backend B

```bash
# Étape 1: Récupérer le state depuis l'ancien backend*
terraform state pull > current_state.tfstate

# Étape 2: Configurer le nouveau backend dans backend.tf

# Étape 3: Réinitialiser avec le nouveau backend*
terraform init -migrate-state=false

# Étape 4: Pousser le state vers le nouveau backend*
terraform state push current_state.tfstate
```

## **4. Réparation d’urgence du state**[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)[11](https://scalr.com/blog/terraform-state-update)

```bash
# Récupérer le state corrompu*
terraform state pull > corrupted_state.tfstate

# Éditer manuellement (DANGEREUX!)*
vim corrupted_state.tfstate

# Repousser le state corrigé*
terraform state push -force corrupted_state.tfstate
```

## **🛡️ Vérifications de sécurité**

## **Terraform fait des vérifications automatiques :**[5](https://developer.hashicorp.com/terraform/cli/commands/state/push)[8](https://discuss.hashicorp.com/t/terraform-state-push/64500)

**1. Lineage différent :**

- Chaque state a un “lineage” unique (UUID)
- Si les lineages diffèrent ➜ **ERREUR** (probablement des states différents)

**2. Serial plus élevé côté distant :**

- Le “serial” s’incrémente à chaque modification
- Si remote serial > local serial ➜ **ERREUR** (tu vas perdre des données)

## **Exemple de vérifications :**[8](https://discuss.hashicorp.com/t/terraform-state-push/64500)

```json
json{
  "version": 4,
  "terraform_version": "1.0.0",
  "serial": 15,          # Numéro de version
  "lineage": "abc-123-def", # UUID unique
  "outputs": {},
  "resources": []
}
```

**Scénarios :**

- **Local serial = 10, Remote serial = 10** ➜ ✅ OK
- **Local serial = 11, Remote serial = 10** ➜ ✅ OK (push autorisé)
- **Local serial = 10, Remote serial = 11** ➜ ❌ BLOQUÉ (données plus récentes côté distant)

## **⚠️ Options importantes**

## **`terraform state push` options :**[5](https://developer.hashicorp.com/terraform/cli/commands/state/push)

- **`force` :**

```bash
terraform state push -force terraform.tfstate
*# ⚠️ DANGEREUX: Bypass toutes les vérifications de sécurité*
```

- **`ignore-remote-version` (Terraform Cloud uniquement) :**

```bash
terraform state push -ignore-remote-version terraform.tfstate
*# Ignore les conflits de version avec Terraform Cloud*
```

## **📋 Workflow complet d’exemple**

## **Migration d’état entre environnements :**[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)[7](https://support.hashicorp.com/hc/en-us/articles/40171587510803-Migrating-and-Pushing-Terraform-State-from-One-Backend-to-Another)

```hcl
# 1. Configuration actuelle (backend dev)*
terraform {
  backend "s3" {
    bucket = "terraform-state-dev"
    key    = "myapp/terraform.tfstate"
    region = "us-west-2"
  }
}

# 2. Exporter le state dev*
terraform state pull > dev_state.tfstate

# 3. Backup de sécurité*
cp dev_state.tfstate dev_state_backup_$(date +%Y%m%d).tfstate

# 4. Modifier la configuration pour prod*
terraform {
  backend "s3" {
    bucket = "terraform-state-prod"  *# Nouveau bucket*
    key    = "myapp/terraform.tfstate"
    region = "us-west-2"
  }
}

# 5. Réinitialiser sans migration automatique*
terraform init -reconfigure

# 6. Pousser le state vers prod*
terraform state push dev_state.tfstate

# 7. Vérifier que tout fonctionne*
terraform plan
```

## **🚨 Précautions et bonnes pratiques**

## **1. Toujours faire des backups**[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)[12](https://developer.hashicorp.com/terraform/cli/commands/state)

```bash
# Avant toute manipulation manuelle*
terraform state pull > backup_$(date +%Y%m%d_%H%M%S).tfstate
```

## **2. Vérifier le state après push**[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)

```bash
terraform state push modified_state.tfstate
terraform plan  # Doit montrer "No changes" si tout va bien*
```

## **3. Problèmes Windows/PowerShell**[1](https://developer.hashicorp.com/terraform/cli/commands/state/pull)[13](https://github.com/hashicorp/terraform/issues/24986)

```bash
# ❌ Problème avec BOM et line endings*
terraform state pull > state.txt

# ✅ Solution recommandée*
terraform state pull | Set-Content terraform.tfstate

# ✅ Alternative*
terraform state pull | Out-File -Encoding UTF8NoBOM terraform.tfstate
```

## **4. Coordination en équipe**[8](https://discuss.hashicorp.com/t/terraform-state-push/64500)

- **Communiquer** avant toute manipulation manuelle
- **Bloquer** les autres opérations Terraform pendant la maintenance
- **Vérifier** qu’aucun apply concurrent ne se lance

## **🔧 Debugging et maintenance**

## **Examiner un state corrompu :**

```bash
# Récupérer le state*
terraform state pull > debug_state.tfstate

# Analyser la structure*
jq '.' debug_state.tfstate | head -20

# Vérifier les ressources problématiques*
jq '.resources[] | select(.instances[].attributes.id == null)' debug_state.tfstate
```

## **Nettoyer un state :**

```bash
# Supprimer les ressources orphelines du state*
terraform state pull > clean_state.tfstate

# Éditer pour supprimer les ressources non désirées*
vim clean_state.tfstate

# Repousser le state nettoyé*
terraform state push clean_state.tfstate
```

## **💡 Alternatives plus sûres**

## **Au lieu de pull/push manuel, préfère :**[12](https://developer.hashicorp.com/terraform/cli/commands/state)

```bash
# Gestion via commandes natives*
terraform state mv old_resource new_resource
terraform state rm unwanted_resource
terraform import resource.name existing_id

# Refresh pour synchroniser*
terraform apply -refresh-only
```

**🎯 En résumé :**

- **`terraform state pull`** = **Télécharger** et **visualiser** le state[1](https://developer.hashicorp.com/terraform/cli/commands/state/pull)[2](https://terraformguru.com/terraform-certification-using-aws-cloud/07-Terraform-State/07-02-Terraform-State-Commands/)
- **`terraform state push`** = **Uploader** un state modifié[5](https://developer.hashicorp.com/terraform/cli/commands/state/push)[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)
- **Utiliser avec précaution** - toujours faire des backups[6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)[12](https://developer.hashicorp.com/terraform/cli/commands/state)
- **Parfait pour migrations** et réparations d’urgence[7](https://support.hashicorp.com/hc/en-us/articles/40171587510803-Migrating-and-Pushing-Terraform-State-from-One-Backend-to-Another)[10](https://blog.wahab2.com/different-ways-to-migrate-terraform-state-6497b7baef05)
- **Coordination équipe essentielle** pour éviter les conflits[8](https://discuss.hashicorp.com/t/terraform-state-push/64500)

Ces commandes sont

**puissantes mais dangereuses**

- à utiliser uniquement quand les commandes natives ne suffisent pas [5](https://developer.hashicorp.com/terraform/cli/commands/state/push) [6](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull) [12](https://developer.hashicorp.com/terraform/cli/commands/state)

Add to follow-up

1. [https://developer.hashicorp.com/terraform/cli/commands/state/pull](https://developer.hashicorp.com/terraform/cli/commands/state/pull)
2. [https://terraformguru.com/terraform-certification-using-aws-cloud/07-Terraform-State/07-02-Terraform-State-Commands/](https://terraformguru.com/terraform-certification-using-aws-cloud/07-Terraform-State/07-02-Terraform-State-Commands/)
3. [https://blog.stephane-robert.info/docs/infra-as-code/provisionnement/terraform/gestion-state/](https://blog.stephane-robert.info/docs/infra-as-code/provisionnement/terraform/gestion-state/)
4. [https://www.youtube.com/watch?v=ushoyLCzwfw](https://www.youtube.com/watch?v=ushoyLCzwfw)
5. [https://developer.hashicorp.com/terraform/cli/commands/state/push](https://developer.hashicorp.com/terraform/cli/commands/state/push)
6. [https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull](https://support.hashicorp.com/hc/en-us/articles/360001151948-Migrate-Workspace-State-Using-Terraform-State-Push-Pull)
7. [https://support.hashicorp.com/hc/en-us/articles/40171587510803-Migrating-and-Pushing-Terraform-State-from-One-Backend-to-Another](https://support.hashicorp.com/hc/en-us/articles/40171587510803-Migrating-and-Pushing-Terraform-State-from-One-Backend-to-Another)
8. [https://discuss.hashicorp.com/t/terraform-state-push/64500](https://discuss.hashicorp.com/t/terraform-state-push/64500)
9. [https://stackoverflow.com/questions/78307858/how-do-i-find-the-location-of-my-terraform-state](https://stackoverflow.com/questions/78307858/how-do-i-find-the-location-of-my-terraform-state)
10. [https://blog.wahab2.com/different-ways-to-migrate-terraform-state-6497b7baef05](https://blog.wahab2.com/different-ways-to-migrate-terraform-state-6497b7baef05)
11. [https://scalr.com/blog/terraform-state-update](https://scalr.com/blog/terraform-state-update)
12. [https://developer.hashicorp.com/terraform/cli/commands/state](https://developer.hashicorp.com/terraform/cli/commands/state)
13. [https://github.com/hashicorp/terraform/issues/24986](https://github.com/hashicorp/terraform/issues/24986)
14. [https://jhooq.com/terraform-manage-state/](https://jhooq.com/terraform-manage-state/)
15. [https://notes.kodekloud.com/docs/Terraform-Associate-Certification-HashiCorp-Certified/Use-the-Terraform-CLI/Basic-Terraform-Commands](https://notes.kodekloud.com/docs/Terraform-Associate-Certification-HashiCorp-Certified/Use-the-Terraform-CLI/Basic-Terraform-Commands)
16. [https://techblog.flaviusdinu.com/terraform-from-0-to-hero-11-state-ada02632508a](https://techblog.flaviusdinu.com/terraform-from-0-to-hero-11-state-ada02632508a)
17. [https://spacelift.io/blog/terraform-commands-cheat-sheet](https://spacelift.io/blog/terraform-commands-cheat-sheet)
18. [https://spacelift.io/blog/terraform-migrate-state](https://spacelift.io/blog/terraform-migrate-state)
19. [https://www.youtube.com/watch?v=gAZtVP7I-GM](https://www.youtube.com/watch?v=gAZtVP7I-GM)
20. [https://www.youtube.com/watch?v=m8ZCmWokrgk](https://www.youtube.com/watch?v=m8ZCmWokrgk)
21. [https://www.youtube.com/watch?v=5ocM_K6bqsc](https://www.youtube.com/watch?v=5ocM_K6bqsc)
22. [https://www.youtube.com/watch?v=UDBVCzg2IRo](https://www.youtube.com/watch?v=UDBVCzg2IRo)
23. [https://www.youtube.com/watch?v=LzWBPIgbrXM](https://www.youtube.com/watch?v=LzWBPIgbrXM)
24. [https://www.youtube.com/watch?v=NgRDiH0SuQo](https://www.youtube.com/watch?v=NgRDiH0SuQo)
25. [https://www.youtube.com/watch?v=XYPuarDVz3M](https://www.youtube.com/watch?v=XYPuarDVz3M)