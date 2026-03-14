# Les bases de Jenkins

Jenkins est un serveur d’intégration continue (CI) et de déploiement continu (CD) open-source qui automatise la construction, le test et le déploiement des applications.

## 1. Architecture et composants clés

1. **Master**
    - Cœur de Jenkins qui orchestre les jobs, gère l’interface Web et distribue les tâches aux agents.
2. **Agents (ou Slaves)**
    - Machines distantes exécutant les builds pour répartir la charge.
3. **Jobs (Projets)**
    - Unité de travail configurée pour compiler, tester, analyser et déployer du code.
4. **Plugins**
    - Extensions pour ajouter des fonctionnalités (SCM, notifications, analyse statique, etc.).
5. **Pipeline**
    - Script déclaratif ou compilé (Groovy) définissant les étapes d’un workflow CI/CD de bout en bout.

## 2. Installation et configuration initiale

1. Télécharger Jenkins (war, paquet OS ou container Docker).
2. Démarrer Jenkins :
    - `java -jar jenkins.war`
    - ou `systemctl start jenkins`
3. Accéder à l’interface Web `http://localhost:8080`.
4. Saisir le mot de passe initial généré dans `/var/lib/jenkins/secrets/initialAdminPassword`.
5. Installer les plugins recommandés et créer l’administrateur.

## 3. Création d’un job freestyle

1. Dans « New Item », choisir **Freestyle project**.
2. Définir :
    - **Description**
    - **Source Code Management** (Git, Subversion…), URL et identifiants.
    - **Build Triggers** (push webhooks, polling, minute scheduler).
    - **Build Steps** (invoke Ant, Maven, shell script, Windows batch).
    - **Post-build Actions** (report junit, envoyer email, archive artifacts).
3. Enregistrer et lancer le build manuellement ou selon un déclencheur.

## 4. Pipeline as Code

## Déclaratif (Jenkinsfile)

```jsx
pipeline {
    // Utilise n’importe quel agent disponible pour exécuter ce pipeline
    agent any

    environment {
        // Définition de variables d’environnement globales
        MVN_HOME        = '/usr/share/maven'             // Chemin de Maven
        SONAR_TOKEN     = credentials('sonar-token-id')  // Jeton SonarQube stocké dans Jenkins Credentials
        DOCKER_REGISTRY = 'registry.example.com'         // Endpoint du registry Docker
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))    // Conserve uniquement les 10 derniers builds
        timeout(time: 60, unit: 'MINUTES')               // Timeout global de 60 minutes
        timestamps()                                      // Ajoute des timestamps aux logs
    }

    parameters {
        // Permet à l’utilisateur de choisir la branche Git à builder (default : main)
        string(name: 'BRANCH', defaultValue: 'main', description: 'Branche Git à builder')
    }

    stages {
        stage('Checkout') {
            steps {
                // Récupère le code de la branche spécifiée depuis GitHub
                git branch: "${params.BRANCH}", url: '<https://github.com/monorg/monprojet.git>'
            }
        }

        stage('Compile') {
            steps {
                // Compile le projet avec Maven
                sh "${MVN_HOME}/bin/mvn clean compile"
            }
        }

        stage('Unit Tests') {
            steps {
                // Exécute les tests unitaires
                sh "${MVN_HOME}/bin/mvn test"
                // Archive les rapports JUnit pour affichage dans Jenkins
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Static Analysis') {
            steps {
                // Analyse SonarQube via plugin, injection automatique des variables d’URL et token
                withSonarQubeEnv('SonarQubeServer') {
                    sh """
                        ${MVN_HOME}/bin/mvn sonar:sonar \\
                          -Dsonar.projectKey=monprojet \\
                          -Dsonar.host.url=https://sonar.example.com \\
                          -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Package') {
            steps {
                // Construit l’artefact sans exécuter à nouveau les tests
                sh "${MVN_HOME}/bin/mvn package -DskipTests"
                // Archive le fichier JAR généré et trace son fingerprint
                archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Définit le tag de l’image basé sur le numéro de build
                    def imageTag = "${DOCKER_REGISTRY}/monprojet:${env.BUILD_NUMBER}"
                    // Construction de l’image Docker
                    sh "docker build -t ${imageTag} ."
                    // Connexion sécurisée au registry et push de l’image
                    withCredentials([usernamePassword(credentialsId: 'docker-cred-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo "${DOCKER_PASS}" | docker login ${DOCKER_REGISTRY} \\
                                --username "${DOCKER_USER}" --password-stdin
                            docker push ${imageTag}
                        """
                    }
                }
            }
        }

        stage('Deploy to QA') {
            when {
                // N’exécute ce stage que si on est sur la branche main
                branch 'main'
            }
            steps {
                // Appelle un script shell pour déployer en environnement QA
                sh './scripts/deploy.sh qa ${BUILD_NUMBER}'
            }
        }
    }

    post {
        success {
            // Notification Slack en cas de succès
            slackSend channel: '#ci-cd', color: 'good', message: "Build ${currentBuild.fullDisplayName} réussi : ${env.BUILD_URL}"
        }
        failure {
            // Notification Slack en cas d’échec
            slackSend channel: '#ci-cd', color: 'danger', message: "Build ${currentBuild.fullDisplayName} échoué : ${env.BUILD_URL}"
        }
        always {
            // Publication du rapport de couverture Cobertura si disponible
            publishCoverage adapters: [coberturaAdapter('**/target/site/cobertura/coverage.xml')]
            // Nettoyage du workspace pour libérer l’espace
            cleanWs()
        }
    }
}

```

**Explications détaillées après le code**

- **agent any** : utilise un nœud Jenkins disponible pour exécuter le pipeline.
- **environment** : définit des variables globales : chemin Maven, token Sonar et adresse du registry Docker.
- **options** :
    - **`buildDiscarder`** garde seulement les 10 derniers builds pour économiser de l’espace.
    - **`timeout`** limite la durée totale à 60 minutes.
    - **`timestamps`** injecte des horodatages dans les logs.
- **parameters** : paramètre **`BRANCH`** pour choisir dynamiquement la branche Git à builder.
- **stages** : étape par étape :
    1. **Checkout** : clone le dépôt sur la branche choisie.
    2. **Compile** : compilation Maven.
    3. **Unit Tests** : exécution des tests unitaires et publication des rapports JUnit.
    4. **Static Analysis** : exécution de SonarQube pour l’analyse qualité.
    5. **Package** : création du JAR et archivage comme artefact.
    6. **Build Docker Image** : construction d’une image Docker, connexion au registry et push.
    7. **Deploy to QA** : déploiement en QA, conditionné à la branche **`main`**.
- **post** : actions post-build : notifications Slack selon le résultat, publication du rapport de couverture Cobertura, et nettoyage du workspace.

[Directives essentielles d’un Jenkins Pipeline (1)](https://www.notion.so/Directives-essentielles-d-un-Jenkins-Pipeline-1-31526d1eabaa804a87f1f9001f0850e9?pvs=21)

## 5. Gestion des agents

1. Dans **Manage Jenkins > Manage Nodes and Clouds** :
    
    - Ajouter un agent manuellement (SSH, JNLP, Docker).
    - Configurer le nombre d’exécuteurs (threads de build).
2. Dans le Pipeline :
    
    `groovypipeline { agent { label 'linux && docker' } … }`
    
    pour cibler un agent avec les labels correspondants.
    

## 6. Triggers et notifications

- **Poll SCM** : `H/5 * * * *` toutes les 5 minutes.
- **Webhook GitHub/GitLab** : déclenchement instantané.
- **Build periodically** : scheduler cron.
- **Notifications** : e-mail, Slack, Teams, webhook HTTP via plugins.

## 7. Bonnes pratiques

- Versionner le Jenkinsfile dans le même dépôt que le code.
- **Diviser** les pipelines en **multi-branch** ou **folder pipelines**.
- Utiliser **credentials store** pour stocker mots de passe et tokens.
- Nettoyer régulièrement les anciens builds et artefacts.
- Garder Jenkins à jour et surveiller la sécurité des plugins.

## 8. Extensions incontournables

- **Git Plugin** : intégration Git.
- **Pipeline Plugin** : support Jenkinsfile.
- **Blue Ocean** : interface pipeline moderne.
- **Credentials Plugin** : gestion sécurisée des identifiants.
- **JUnit** : rapports de test.
- **Docker Pipeline** : builds isolés dans des containers.

Ces bases te permettront de démarrer avec Jenkins, de créer et automatiser tes builds, et d’implémenter des pipelines CI/CD robustes.
## 9. Exemple Pipeline
- <span class="title-link">[[Déploiement Complet de Jenkins sur AWS avec Infrastructure as Code et Configuration as Code]] </span>