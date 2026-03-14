# 🛡️ Sécurité des Images Docker : Les Fondamentaux

## 1. Analyse des Vulnérabilités (Scan de CVE)

Une image Docker est constituée de multiples couches superposées (OS de base, bibliothèques système, dépendances applicatives). La sécurisation de ces images repose sur l'identification et la correction des **CVE** (_Common Vulnerabilities and Exposures_).

Le processus de scan automatisé s'effectue en deux phases clés :

- **Génération du SBOM 📝 :** L'outil d'analyse (scanner) crée un _Software Bill of Materials_ (nomenclature logicielle). Il dresse l'inventaire exhaustif de tous les paquets installés et de leurs versions exactes dans chaque couche de l'image.
- **Comparaison ⚖️ :** Cet inventaire est croisé avec les bases de données publiques de vulnérabilités (comme la NVD - _National Vulnerability Database_).
- **Remédiation 🩹 :** La méthode de correction standard consiste à mettre à jour l'image de base (ex: migrer vers une version LTS plus récente de l'OS) ou à monter en version (_bump_) les dépendances vulnérables pour intégrer les correctifs des éditeurs.

## 2. Évaluation de la Gravité (Score CVSS)

Pour aider les équipes à prioriser les corrections, chaque CVE se voit attribuer un score **CVSS** (_Common Vulnerability Scoring System_) allant de 0 à 10.

Ce score évalue l'impact technique de la faille selon la triade **CID** :

- **C**onfidentialité 🤫 : Risque d'accès non autorisé à des données sensibles (fuite de secrets, clés API, code source).
- **I**ntégrité 🛡️ : Risque d'altération des données, d'exécution de code arbitraire (RCE) ou d'élévation de privilèges.
- **D**isponibilité 🛑 : Risque de déni de service (DoS), de saturation des ressources ou de crash du conteneur.

**Critères d'une faille "Critique" (Score 9.0 - 10.0) :** Une vulnérabilité atteint ce score maximal lorsqu'elle compromet sévèrement un ou plusieurs piliers de la triade CID, tout en ayant un vecteur d'attaque très simple (ex: exploitable à distance via le réseau, sans interaction utilisateur et sans nécessiter d'authentification préalable).