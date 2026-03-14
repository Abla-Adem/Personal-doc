# Synthèse des composants Kubernetes

Kubernetes repose sur une architecture modulaire où chaque composant joue un rôle précis afin d’automatiser la gestion, la résilience et le déploiement des applications conteneurisées. Voici une vue d’ensemble des principaux éléments, classés selon leur emplacement et leur utilité [**1**](https://devopscube.com/kubernetes-architecture-explained/).
![[eaa7da9f-5c61-492d-b972-141664a014db.png]]
# 1. **Control Plane** (Plan de contrôle)

Le control plane orchestre l’ensemble du cluster et prend toutes les décisions d’administration.

## **kube-apiserver**
![[eaa7da9f-5c61-492d-b972-141664a014db 1.png]]

_Point d’entrée unique_, il valide les requêtes et distribue les tâches aux autres composants. il est responsable de:

|Fonction|Description|
|---|---|
|Gestion de l’API|Expose le endpoint de l’API du cluster, gère toutes les requêtes API, versionne l’API et supporte plusieurs versions simultanément.|
|Authentification et Autorisation|Gère l’authentification (certificats clients, jetons porteurs, authentification HTTP Basic) et autorisation (évaluation ABAC/RBAC).|
|Validation et mutation|Traite les requêtes API et valide les objets de l’API (pods, services, etc.) via les controllers Validation et Mutation Admission.|
|Coordination du cluster|Coordonne les processus entre les composants du plan de contrôle (control plane) et les nœuds de travail (workers).|
|Aggregation Layer|Permet d’étendre l’API Kubernetes avec des ressources et contrôleurs personnalisés via une couche d’agrégation.|
|Communication avec etcd|Le seul composant auquel le kube-apiserver initie une connexion est etcd ; tous les autres composants se connectent à l’API server.|
|Surveillance (watch) des ressources|Supporte la surveillance en temps réel des ressources : permet de recevoir des notifications lors de modifications (création, suppression, etc.).|
|Surveillance indépendante par composant|Chaque composant (Kubelet, scheduler, controllers) surveille l’API server pour déterminer ses actions à effectuer.|
|Proxy intégré|Contient un proxy natif pour permettre un accès aux services ClusterIP depuis l’extérieur du cluster.|

## **etcd**

Base de données distribué clé/valeur qui stocke tout l’état du cluster (objets, configurations, secrets…).

### Rôle d’etcd dans Kubernetes

Kubernetes est un système distribué et nécessite une base de données distribuée efficace telle que **etcd** pour répondre à sa nature. etcd fait à la fois office de service de découverte backend et de base de données : c’est le “cerveau” du cluster Kubernetes.

### Fonctionnalités clés d’etcd

|Fonctionnalité|Description|
|---|---|
|**Cohérence forte**|Lorsqu’une mise à jour est effectuée sur un nœud, elle est immédiatement répliquée à tous les autres nœuds du cluster. Selon le théorème CAP, il est impossible d’atteindre à la fois 100% de disponibilité, cohérence forte, et tolérance au partitionnement.|
|**Distribué**|etcd fonctionne sous forme de cluster multi-nœuds sans compromis sur la cohérence.|
|**Key Value Store**|Stocke les données sous forme de paires clé-valeur. Il propose une API clé-valeur et repose sur BboltDB (un fork de BoltDB).|
|**Algorithme Raft**|Utilise l’algorithme consensus Raft pour garantir la cohérence et la disponibilité, avec une organisation leader-membres pour la haute disponibilité et la tolérance aux pannes.|

### etcd et Kubernetes : Fonctionnement

- Toute opération réalisée avec `kubectl` (lecture ou écriture d’objets Kubernetes) se traduit par une lecture ou une écriture dans etcd.
- Quand vous déployez un objet (ex. pod), une entrée est créée dans etcd.

### Points essentiels à retenir sur etcd

|Élément|Détail|
|---|---|
|**Stockage**|Stocke toutes les configurations, états et métadonnées des objets Kubernetes : pods, secrets, daemonsets, déploiements, configmaps, statefulsets, etc.|
|**Surveillance (Watch)**|Permet à un client de s’abonner aux événements via l’API `Watch()`. Le kube-apiserver utilise cette fonctionnalité pour suivre les changements d’état des objets.|
|**API gRPC**|Expose une API clé-valeur via gRPC. Le gRPC gateway permet aussi un accès REST, ce qui en fait une base idéale pour Kubernetes.|
|**Hiérarchie de stockage**|Tous les objets sont enregistrés sous le préfixe `/registry` (ex: `/registry/pods/default/nginx` pour un pod “nginx” du namespace “default”).|
|**Composant Statefulset**|etcd est le seul composant Statefulset du plan de contrôle Kubernetes.|
![[5953b85f-06a3-4cd4-84d6-c19af56edf88.png]]


### Tolérance aux pannes d’un cluster etcd

|Nombre de nœuds|Nombre de pannes tolérées|Quorum requis|
|---|---|---|
|3|1|2|
|5|2|3|
|7|3|4|

_Formule générale de tolérance aux pannes :_

$$ \text{tolérance aux pannes} = \frac{n-1}{2} $$

_où n est le nombre total de nœuds du cluster._

## **kube-scheduler**

Le **kube-scheduler** est responsable de la planification des pods sur les nœuds de travail dans un cluster Kubernetes. Dès qu’un nouveau pod est créé, il vérifie ses besoins (CPU, mémoire, affinité, tolérances, priorités, volumes persistants, etc.) et choisit le nœud le plus adapté.[kubernetes.io+2](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/)

### Principes de fonctionnement du scheduler
![[eaa7da9f-5c61-492d-b972-141664a014db 2.png]]


|Étape|Description|
|---|---|
|**Écoute des événements**|Le scheduler surveille l’API server à la recherche de pods à planifier.|
|**Cycle de planification**|Comprend deux phases : **filtrage** des nœuds (nodes éligibles) et **scorage** (classement).|
|**Filtrage (Filtering)**|Élimine les nœuds qui ne conviennent pas (pas assez de ressources, contraintes non respectées, etc.). N’utilise pas forcément tous les nœuds : la valeur par défaut pour le paramètre `percentageOfNodesToScore` est 50% (5% dans les très grands clusters), pour optimiser les performances[kubernetes.io+1](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/).|
|**Scorage (Scoring)**|Attribue un score à chaque nœud restant via différents plugins ou fonctions : celui avec le score le plus élevé est sélectionné. Si égalité, sélection aléatoire[kubernetes.io+1](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/).|
|**Binding (liaison)**|Une fois le nœud choisi, le scheduler informe l’API server pour lier le pod au nœud concerné (événement de “binding”)[kubernetes.io+1](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/).|
![[5f810e07-74a2-4faf-bdc5-95273939b044.png]]


### Fonctionnalités clés et options avancées

|Fonctionnalité|Détail|
|---|---|
|**Priorité**|Les pods avec la priorité la plus haute sont planifiés en premier ; possibilité d’éviction/migration de pods si nécessaire.|
|**Schedulers personnalisés**|Possibilité de déployer plusieurs schedulers personnalisés en parallèle du scheduler natif. Un pod peut utiliser un scheduler spécifique déclaré dans son manifeste de déploiement[overcast.blog+1](https://overcast.blog/creating-a-custom-scheduler-in-kubernetes-a-practical-guide-2d9f9254f3b5).|
|**Cadre extensible (Framework)**|Le scheduler propose un framework modulaire : on peut y ajouter des plugins de scheduling personnalisés pour étendre ses fonctionnalités (filtrage, scorage, binding, etc.)[w3cub.com+1](https://docs.w3cub.com/kubernetes/concepts/scheduling-eviction/scheduling-framework.html).|
|**Gestion des gros clusters**|Utilisation de l’option `percentageOfNodesToScore` pour limiter le nombre de nœuds évalués et gagner en efficacité sur des clusters volumineux.|
|**Surveillance des pods**|Après la planification, certains pods peuvent être déplacés ou évincés selon les besoins du cluster ou les changements de priorité[hackernoon.com](https://hackernoon.com/inside-kubernetes-scheduling-how-your-pods-fight-for-a-place-to-exist).|

### Résumé de l’algorithme de planification

```jsx
text1. Détection d’un pod non planifié par le scheduler.
2. Phase de filtrage : sélection des nœuds répondant aux exigences du pod.
3. Phase de scorage : classement des nœuds restants via des plugins/scoring functions.
4. Sélection du meilleur nœud (ou aléatoirement en cas d’égalité).
5. Événement de binding envoyé à l’API server pour lier le pod au nœud.
```

### Tableau synthétique — kube-scheduler pour Notion

|Fonction/Phase|Explication (FR)|
|---|---|
|Surveillance|Observe l’API server : détecte les pods à planifier.|
|Filtrage|Écarte les nœuds ne convenant pas (ressources, affinités, tolérances, etc.).|
|Scorage|Attribue un score à chaque nœud restant (plugins, règles).|
|Binding|Associe le pod au nœud le mieux noté.|
|Priorité des pods|Les pods prioritaires sont planifiés en premier ; gestion d’éviction si nécessaire.|
|Scheduling context|Ensemble cycle de scheduling (sélection du nœud) + cycle de binding (application de la décision).|
|Schedulers multiples et plugins|Prise en charge de schedulers personnalisés et de plugins pour filtrer/classer selon des règles spécifiques.|

Cet agencement peut être copié directement dans Notion sous forme de tableaux ou de sections organisées, pour documenter de façon claire et synthétique le fonctionnement du kube-scheduler dans Kubernetes.[kubernetes.io+6](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/)

## **kube-controller-manager**

Un **controller** est un programme qui exécute en continu une **boucle de contrôle infinie** (_control loop_). Il observe l’état **actuel** et l’état **désiré** des objets Kubernetes. Si une différence est détectée, le controller agit pour rapprocher l’état actuel de l’état désiré.

### Concept clé (extrait de la documentation officielle)

> Dans Kubernetes, les controllers sont des boucles de contrôle qui surveillent l’état de votre cluster et effectuent, ou demandent, les modifications nécessaires. Chaque controller tente de rapprocher l’état actuel du cluster de l’état désiré.
![[545f7b37-7778-4dd0-baf2-afce6025b315.png]]


### Exemple concret

Vous déclarez un **Deployment** avec un manifeste YAML indiquant l’état désiré (exemple : 2 réplicas, montage d’un volume, configmap, etc.).

- Le **Deployment Controller** intégré s’assure que cet état est maintenu constamment.
- Si vous modifiez le déploiement à 5 réplicas, ce controller détecte le changement et agit pour qu’il y ait effectivement 5 réplicas.

En résumé :

|**Composant**|**Rôle dans la création des pods**|
|---|---|
|kube-controller-manager|Gère les contrôleurs qui créent/modifient les ressources Pod en respectant l’état désiré|
|kube-scheduler|Assigne un pod à un nœud adapté|
|kubelet|Sur le nœud worker, démarre effectivement les conteneurs du pod|

Le kube-controller-manager ne “crée pas” les pods dans le sens d’exécution, mais il crée les objets pods dans l’API Kubernetes pour que le système les prenne en charge et les maintienne.

### Rôle du Kube Controller Manager

|Fonction|Description|
|---|---|
|Gestionnaire central|Gère tous les controllers Kubernetes (comme Deployment, ReplicaSet, Job, Namespace, Node, etc.).|
|Contrôleurs multiples|Chaque controller est responsable d’un type spécifique d’objet Kubernetes.|
|Intégration avec le Scheduler|Le scheduler est aussi un controller géré par le Kube Controller Manager.(mais le kube-scheduler ne fait pas partie du kub controller)|
|Extensibilité|Supporte les controllers personnalisés associés à des définitions de ressources personnalisées (CRD).|

### Liste des principaux controllers intégrés dans Kubernetes

|**Controller**|**Fonction principale**|
|---|---|
|**Deployment Controller**|Gère le cycle de vie des Deployments : s’assure que le bon nombre de pods est en cours d’exécution|
|**ReplicaSet Controller**|Maintient le nombre souhaité de pods identiques pour l’échelle et la disponibilité|
|**DaemonSet Controller**|Garantit qu’un pod spécifique s’exécute sur chaque nœud (ou certains nœuds sélectionnés)|
|**StatefulSet Controller**|Gère les applications nécessitant des identifiants, du stockage persistant et un ordonnancement strict|
|**Job Controller**|Lance des tâches batch devant s’exécuter jusqu’à leur complétion|
|**CronJob Controller**|Planifie des jobs à exécuter périodiquement selon un cron|
|**Endpoints Controller**|Met à jour la liste des endpoints attachés à chaque service|
|**Service Controller**|Crée et gère les services virtuels réseau (ClusterIP, NodePort, LoadBalancer)|
|**Namespace Controller**|Gère la création, la suppression et la finalisation des namespaces|
|**ServiceAccount Controller**|Administre la création de comptes de service associés à chaque namespace|
|**Node Controller**|Surveille et met à jour l’état des nœuds du cluster|
|**Horizontal Pod Autoscaler (HPA) Controller**|Ajuste automatiquement le nombre de pods via autoscaling horizontal (CPU, mémoire, custom metrics)|
|**Replica Controller**|Prédécesseur du ReplicaSet, gère le nombre d’instances d’un pod (classic, moins utilisé aujourd’hui)|
|**Volume Controller**|Gère l’attachement et le détachement des volumes persistants (PV/PVC)|
|**PersistentVolumeClaim (PVC) Controller**|Attribution automatique des volumes aux pods qui le requièrent|
|**Job/CronJob Controllers**|Supervision, planification et gestion des jobs uniques ou périodiques|
|**Ingress Controller**|Gère l’accès HTTP/S externe vers les services internes (peut être natif ou tiers, selon le choix d’implémentation)|
|**Cloud Controller Manager Controllers**||

### Schéma simplifié du fonctionnement des Controllers

|Étape|Description|
|---|---|
|Surveillance|Boucle infinie qui observe les ressources via l’API server.|
|Détection d’écart|Compare état actuel avec état désiré.|
|Actions correctives|Crée, modifie ou supprime des ressources pour aligner les états.|
|Mise à jour de l’état|Rapport de l’état actuel corrigé à l’API server.|

### Notes complémentaires

- Les controllers ne manipulent pas directement les ressources, mais envoient des requêtes à l’API server pour appliquer les changements.
- Les contrôleurs sont conçus pour être simples et indépendants, ce qui améliore la robustesse du cluster (si un controller échoue, un autre peut prendre le relais).
- Vous pouvez créer vos propres controllers personnalisés pour gérer des ressources spécifiques via des Custom Resource Definitions (CRD).

## **cloud-controller-manager**

### Rôle du Cloud Controller Manager

Le **Cloud Controller Manager (CCM)** joue le rôle de pont entre les APIs des plateformes cloud (ex : AWS, Azure, GCP) et un cluster Kubernetes déployé dans le cloud. Il permet aux composants Kubernetes de fonctionner indépendamment tout en offrant aux fournisseurs cloud un point d’intégration via des plugins. Grâce à cette architecture, les clusters Kubernetes peuvent automatiquement gérer des ressources cloud externes : instances, load balancers, volumes de stockage, etc.
![[62fa51bc-d0cb-42dd-a7b6-104d1680996c.png]]


### Fonctionnement général

- Sépare la logique spécifique au cloud de la logique native Kubernetes.
- Intègre Kubernetes avec les principaux fournisseurs cloud à travers des plugins modulaires.
- Permet de provisionner et gérer automatiquement des ressources cloud en fonction des besoins du cluster.

### Principaux contrôleurs du Cloud Controller Manager

|Contrôleur|Rôle principal|
|---|---|
|**Node Controller**|Synchronise les informations des nœuds avec l’API du fournisseur cloud (labels, annotations, santé, etc).|
|**Route Controller**|Configure les routes réseau entre les nœuds pour assurer la communication inter-pod multi-nœud.|
|**Service Controller**|Déploie des Load Balancers cloud pour les services Kubernetes, attribue des IP, gère le routage.|

### Exemples d’utilisation typiques

- **Déploiement d’un service LoadBalancer** : création automatique d’un Load Balancer cloud relié au service Kubernetes correspondant.
- **Provisionnement de volumes persistants** : création et attachement automatique de volumes cloud (EBS, Disk, etc.) pour les pods.
- **Synchronisation dynamique** : gestion automatisée de l’ajout, de la suppression ou du marquage de nœuds cloud selon l’état réel du cluster.

### Récapitulatif synthétique

|Élément clé|Description|
|---|---|
|Intégration cloud-native|Gère la communication entre Kubernetes et les APIs des plateformes cloud|
|Extensibilité|Supporte les plugins pour différents providers (AWS, GCP, Azure, etc.)|
|Contrôleurs intégrés|Node Controller, Route Controller, Service Controller|
|Exemples|Provisionnement d’instances/nœuds, de LoadBalancers, de volumes de stockage (PV)|
|Gestion du cycle de vie|Supervise toutes les ressources cloud nécessaires au fonctionnement du cluster Kubernetes|

### Résumé du fonctionnement général

1. CCM détecte les besoins du cluster concernant des ressources cloud (nœuds, routes, services…).
2. Communique avec les APIs du cloud provider pour provisionner ou modifier ces ressources.
3. Met à jour Kubernetes pour refléter la réalité du cloud.
4. Garde une synchronisation continue entre l’état désiré et l’état réel des ressources cloud du cluster.

### Exemple d’utilisation d’AWS EKS avec le Cloud Controller Manager

Imaginons que vous déployez une application web (par exemple, Nginx) sur un cluster Kubernetes EKS, et souhaitez la rendre accessible via un Load Balancer AWS. Voici comment les composants de Kubernetes et le Cloud Controller Manager (CCM) d’AWS interagissent :

1. Création du cluster EKS

- AWS gère le **Control Plane** Kubernetes (API server, etcd, controlleurs…).
- Le CCM d’AWS s’intègre au plan de contrôle pour automatiser la gestion des ressources cloud : nodes EC2, volumes EBS, Load Balancers, etc. Le CCM fonctionne majoritairement “en arrière-plan”, sans intervention manuelle nécessaire sur EKS.[linkedin.com+1](https://www.linkedin.com/posts/ayush-vishwakarma-6a225314a_eks-aws-cloud-activity-7242584234660380672-XMr9)

1. Déploiement de l’application (exemple Nginx)

- Vous appliquez un manifeste Kubernetes type **Deployment** :
    
    ```jsx
    textapiVersion: apps/v1
    kind: Deployment
    metadata:
    name: nginx-deployment
    labels:
    app: nginx
    spec:
    replicas: 3
    selector:
    matchLabels:
      app: nginx
    template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
    ```
    
- Puis, vous exposez ce déploiement à l’aide d’un **Service** de type LoadBalancer :
    
    ```jsx
    textapiVersion: v1
    kind: Service
    metadata:
    name: nginx-service
    spec:
    type: LoadBalancer
    ports:
    - port: 80
      targetPort: 80
    selector:
    app: nginx
    ```
    
- Après application (`kubectl apply ...`), le CCM :
    
- Surveille la création du Service de type LoadBalancer.
    
- Crée automatiquement un Load Balancer AWS (ex. : ELB, NLB, ALB) et attribue une IP publique à votre service.[aws.amazon.com+1](https://docs.aws.amazon.com/eks/latest/userguide/sample-deployment.html)
    

### Ce que fait le Cloud Controller Manager EKS dans ce scénario

|Action|Ressource AWS impliquée|Contrôleur responsable (dans CCM)|
|---|---|---|
|Création d’un node worker|Instance EC2|Node Controller|
|Synchronisation node/cluster|ENI, VPC, Route 53|Node Controller|
|Provisionnement d’un load balancer|ELB, NLB, ALB|Service Controller|
|Attribution route réseau|Routes dans le VPC AWS|Route Controller|
|Provisionnement volume persistant|EBS|Persistent Volume Controller (CSI)|

### Points importants à retenir

- Quand un pod est créé, il est planifié sur un worker. Si des volumes sont requis, c’est le CCM qui provisionne et attache dynamiquement un volume EBS.
- Si un Service de type LoadBalancer est déployé, le CCM crée et configure un Load Balancer AWS qui route le trafic externe vers les pods Kubernetes.
- Lors de l’ajout ou la suppression d’instances, le CCM synchronise automatiquement l’état des nodes Kubernetes avec ceux du cloud AWS (labels, santé, routes…).
- EKS automatise ces actions et fournit transparence et robustesse, tout en permettant d’utiliser les APIs AWS depuis les pods via IAM et services accounts pour la sécurité fine.

### Exemple visuel du cycle dans EKS

|Étape|Action|
|---|---|
|Déploiement des manifestes|kubectl apply|
|CCM détecte le Service LB|Crée un Load Balancer AWS|
|CCM synchronise les nodes|Met à jour leur état/info|
|CCM provisionne le stockage|Crée un volume EBS partagé|

Vous pouvez ainsi, sans action manuelle sur AWS, bénéficier de la gestion automatisée des ressources cloud via le Cloud Controller Manager d’EKS.[aws.amazon.com+2](https://docs.aws.amazon.com/eks/latest/userguide/sample-deployment.html)

Pour tester ce scénario :

1. Créez un cluster EKS (console AWS/EKSCTL/Terraform).
2. Déployez un simple Deployment + Service type LoadBalancer.
3. Observez la création du Load Balancer dans la console AWS et l’affichage d’une adresse IP/hostname externe utilisable.

# 2. Scénario illustratif : Actions de chaque composant du control plane Kubernetes

Imaginons que vous déployez une application web (un pod Nginx avec un service associé) sur votre cluster Kubernetes. Voici comment chaque composant du **control plane** intervient :

## 1. kube-apiserver

- **Point d’entrée unique de l’API Kubernetes** : tout passe par lui.
- Reçoit d’abord la requête `kubectl apply -f nginx.yaml` du user pour créer un pod, un service, etc.
- **Valide les données et l’authentification** (ex.: vérifie les droits du user, la syntaxe, les règles d’admission…).
- Écrit l’intention (ex. : créer un pod) dans le storage central (etcd).
- Informe les autres composants (scheduler, controller-manager…) des nouveaux objets à traiter.

## 2. etcd

- **Stocke l’état désiré et courant** du cluster sous forme clé-valeur.
- Mémorise chaque objet (pod, service, replica), sa config, ses métadonnées, etc.
- Sert de source de vérité : toutes les décisions et modifications passent par les lectures/écritures sur etcd.

## 3. kube-scheduler

- **Détecte les pods nouvellement créés** (qui n’ont pas encore de nœud assigné).
- Analyse les ressources et contraintes de chaque worker node (CPU dispo, affinités, taints/tolerations, etc.).
- Sélectionne **le nœud le plus adapté** pour exécuter le nouveau pod Nginx.
- Émet un “bind” pour attacher le pod au nœud choisi (toujours via l’API server).

## 4. kube-controller-manager

- Gère plusieurs **controllers intégrés** (Deployment, ReplicaSet, Node, Job, etc.).
- Dans notre scénario, le **Deployment Controller** vérifie qu’il existe toujours le bon nombre de réplicas du pod Nginx.
- **Auto-réparation :** si un pod meurt ou un node part en panne, le controller crée automatiquement de nouveaux pods pour garantir la disponibilité voulue.
- Les autres controllers gèrent la création des services, endpoints, comptes de service, etc., toujours pour rapprocher l’état “réel” de l’état “désiré”.

## 5. (optionnel) kube-cloud-controller-manager

- Gère l’intégration avec le cloud provider si votre cluster est sur AWS, GCP, Azure…
- Exemples : attribuer une IP flottante au service de l’app, créer un load balancer externe, gérer le cycle de vie des nodes cloud.

## Tableau synthétique – Rôles des composants du control plane

|Composant|Rôle principal|Exemple dans le scénario|
|---|---|---|
|kube-apiserver|Point d’entrée de l’API, validation, authentification, communication avec tous les autres|Reçoit et traite la requête de création|
|etcd|Stockage central clé-valeur, état du cluster|Mémorise les objets pods/services|
|kube-scheduler|Planification sur les nodes, attribution pods → nodes|Affecte le pod Nginx à un worker|
|kube-controller-manager|Execution des “control loops”, maintien de l’état désiré|Restaure un pod Nginx si un tombe|
|kube-cloud-controller-manager|Intégration avec le cloud provider (optionnel)|Crée un LoadBalancer pour le service|

Ainsi, chaque composant du control plane travaille en boucle continue pour s’assurer que l’état “réel” de votre cluster correspond à l’état “désiré” que vous avez exprimé dans vos fichiers YAML et votre commande `kubectl`.

Add to follow-upCheck sources

# 3. **Composants présents sur chaque nœud worker**

Les nœuds de calcul exécutent les workloads (applications et microservices).

## **kubelet**

Le **kubelet** est un agent qui s’exécute sur **chaque nœud** (worker ou master) d’un cluster Kubernetes. Il n’est pas lancé dans un conteneur, mais fonctionne en tant que service système (géré souvent par systemd).

Sa mission principale : **garantir que les pods** (et donc les conteneurs du pod) qui doivent tourner sur le nœud local sont bien présents, sains, et selon la configuration attendue (le “podSpec”).

### Fonctionnement global

1. **Enregistrement du nœud** : le kubelet enregistre le nœud auprès de l’API server pour qu’il soit reconnu dans le cluster.[kubernetes.io+1](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)
2. **Lecture du podSpec** : récupère la description des pods à lancer, principalement depuis l’API server, mais aussi depuis des fichiers ou endpoints HTTP (utile pour les “static pods”).
3. **Mise en conformité** : s’assure que les containers sont créés/modifiés/supprimés pour correspondre au podSpec.[kubernetes.io](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)
4. **Surveillance/contrôle** : exécute et surveille les probes (liveness, readiness, startup), monte les volumes, supervise l’état et la santé du nœud et des pods, expose un endpoint pour logs/exec.[armosec.io+1](https://www.armosec.io/glossary/kubelet/)
5. **Reporting** : remonte régulièrement l’état du nœud et des pods auprès de l’API server.

### Tableau synthétique

|Fonction|Explication|
|---|---|
|Démarrage du kubelet|Agent système (daemon, via systemd) qui tourne sur chaque nœud, non dans un conteneur.|
|Enregistrement du nœud|Le nœud est signalé à l’API server pour être intégré au cluster.|
|Lecture du podSpec|Récupère les définitions de pods depuis l’API server, un fichier ou un endpoint HTTP (pour les static pods)[kubernetes.io+2](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/).|
|Gestion des conteneurs|Crée, modifie ou supprime les conteneurs pour chaque pod selon son podSpec.|
|Probes (liveness/readiness/startup)|Surveille l’état des conteneurs pour détecter pannes ou problèmes d’application.|
|Montage de volumes|Monte les volumes nécessaires aux pods (via CSI).|
|Récupération de l’état|Utilise cAdvisor et CRI pour collecter les infos de santé/status, reportées ensuite à l’API server[armosec.io+1](https://www.armosec.io/glossary/kubelet/).|
|Interface Container Runtime (CRI)|Passe par CRI (gRPC) pour lancer les containers via le runtime (containerd, CRI-O…).|
|Interface stockage (CSI)|Utilise CSI pour configurer les block volumes ou disques persistants.|
|Interface réseau (CNI)|Utilise un plugin CNI pour attribuer une IP au pod et configurer le routage réseau du pod.|
|Static Pods|Peut gérer des pods locaux indépendamment de l’API server (utile pour démarrer le control plane).|
|Exposition de logs/exec|Fournit un accès HTTP/stream pour logs et exécution de commandes dans les containers.|
|[linkedin.com+6](https://www.linkedin.com/pulse/using-static-pods-kubernetes-christopher-adamson-14joc)||

---

### Éclaircissements

- **Kubelet = chef d’orchestre local** : sur chaque nœud, c’est le composant qui fait le lien entre la description théorique d’un pod et sa réalité concrète sur le serveur. Rien ne s’exécute sur un nœud sans l’action du kubelet.
- **CRI, CSI, CNI = adaptateurs universels** : le kubelet n’exécute pas lui-même les conteneurs, ne monte pas les disques, ni ne configure le réseau, mais emploie différentes interfaces standards pour déléguer ces tâches à des plugins spécialisés et interchangeables.
- **Static Pods = pods “hors contrôle”** : contrairement aux pods ordinaires créés via l’API server, les static pods sont déclenchés par la simple présence d’un manifest YAML sur le disque du nœud. Parfait pour démarrer l’infrastructure essentielle du cluster même sans API server entièrement opérationnel.[linkedin.com+1](https://www.linkedin.com/pulse/using-static-pods-kubernetes-christopher-adamson-14joc)
- **Cycle de vie du pod** : le kubelet lance, surveille (probes), redémarre si besoin, et arrête les conteneurs. Il s’assure que leur état corresponde à la déclaration YAML—c’est le garant de l’exécution locale.

### Exemples concrets pour mieux comprendre

- **Déploiement d’un pod classique** : vous appliquez un manifeste sur l’API server. Le kubelet de chaque nœud voit s’il doit héberger ce pod et, si oui, lance le/les containers décrits selon la podSpec.
- **Static pods au boot du cluster** : pour initialiser un cluster (ex : kubeadm), les composants principaux (API server, scheduler…) sont eux-mêmes des static pods générés via des manifests placés dans `/etc/kubernetes/manifests`.[kubernetes.io+1](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)
- **Réseau et stockage** : le kubelet n’a pas à gérer le détail technique – il fait appel au plugin réseau (CNI) et stockage (CSI) configurés pour allouer l’IP et monter un disque à chaque nouveau pod.

## **container runtime**

De la même façon que le **Java Runtime Environment (JRE)** est le logiciel nécessaire pour exécuter des programmes Java sur une machine[1](https://aws.amazon.com/what-is/java-runtime-environment/), un **container runtime** est le composant logiciel indispensable pour faire fonctionner des conteneurs sur un hôte.

Le **container runtime** s’exécute sur tous les nœuds d’un cluster Kubernetes et prend en charge :

- Le téléchargement (“pull”) des images de conteneurs depuis les registres (Docker Hub, [Quay.io](http://Quay.io), etc.).
- Le démarrage, l’arrêt et la suppression des conteneurs.
- L’allocation, l’isolation et la gestion des ressources (CPU, mémoire, réseaux, stockage) pour chaque conteneur.
- La supervision du cycle de vie complet du conteneur sur chaque hôte.

### Deux concepts fondamentaux

|Concept|Explication enrichie|
|---|---|
|**Container Runtime Interface (CRI)**|Spécification d’APIs standardisées qui permet à Kubernetes de communiquer et piloter diverses solutions de container runtime (Docker, containerd, CRI-O…). Grâce au CRI, Kubernetes devient **agnostique du runtime de conteneurs**, permettant d’échanger/mettre à jour le runtime sans casser l’intégration. Le CRI définit toutes les opérations : création, démarrage, arrêt et suppression de conteneurs, gestion des images et des réseaux, etc.|
|**Open Container Initiative (OCI)**|Initiative open source pour standardiser les formats d’images de conteneurs et les spécifications de runtime : garantit que des conteneurs créés sur un environnement sont exécutables sur n’importe quel runtime conforme. L’OCI définit la structure des images, des métadonnées et la manière dont elles doivent être lancées (`runc` est le runtime de référence pour OCI).|

![image.png](attachment:ed2e1467-0c42-4fe5-8083-0956d3843b56:ed2e1467-0c42-4fe5-8083-0956d3843b56.png)

image.png

### Runtimes courants compatibles Kubernetes

Kubernetes supporte plusieurs runtimes compatibles CRI : CRI-O, Docker Engine (legacy), containerd, etc. Tous exposent des APIs gRPC définies par le CRI pour interagir avec le cluster.
![[ed2e1467-0c42-4fe5-8083-0956d3843b56.png]]
### Tableau synthétique

|Runtime|Points clefs|
|---|---|
|**containerd**|Léger, rapide, moderne, maintenu indépendamment de Docker.|
|**CRI-O**|Spécifique à Kubernetes, 100% compatible CRI, utilise `runc` pour lancer les conteneurs.|
|**Docker Engine**|Historiquement utilisé, remplacé peu à peu par containerd/CRI-O dans Kubernetes récent.|
|**runc**|Runtime bas-niveau conforme OCI (utilisé par CRI-O, containerd…)|

### Exemple de cycle « pod → conteneur » avec CRI-O

1. L’utilisateur ou un controller soumet une requête de création de pod via l’API server.
2. **kubelet** (agent par nœud) reçoit cette requête, puis appelle le runtime via les APIs CRI (gRPC).
3. **CRI-O** :

- Vérifie si l’image demandée est dispo localement, sinon la télécharge depuis un registre via la bibliothèque containers/image.
- Génère une spécification de conteneur conforme OCI (JSON).
- Lance **`runc`** pour créer le process conteneur selon la spec.

1. kubelet surveille ensuite la santé du conteneur, remonte les états/status à l’API server et gère les redémarrages selon la stratégie du pod.

### Schéma simplifié du flux (explication)

`textUtilisateur → API server → kubelet → CRI-O → container registry → image → runc → conteneur lancé`

### Points à retenir

- C’est le **container runtime** qui s’occupe de toute la partie opérationnelle des conteneurs : récupération d’images, isolement, démarrage/arrêt/surveillance, gestion bas-niveau.
- Le **kubelet** discute exclusivement avec ce runtime via le CRI.
- Grâce à l’OCI et au CRI, Kubernetes reste compatible avec de nombreux runtimes, offrant flexibilité et évolutivité au cluster.
- Des alternatives comme **gVisor** ou **Kata Containers** peuvent également être utilisées pour une isolation renforcée.

**Résumé** :

Dans Kubernetes, le container runtime est la “couche d’exécution” basse qui garantit la portabilité, la flexibilité et l’automatisation du cycle de vie des conteneurs, orchestrés depuis les niveaux supérieurs du cluster (API Server et kubelet)[1](https://aws.amazon.com/what-is/java-runtime-environment/).

## **kube-proxy**

### 1. Concepts de base à connaître

- **Service Kubernetes** : Abstraction qui permet d’exposer un ensemble de pods (appli web, backend, etc.) derrière une **IP virtuelle** appelée _ClusterIP_. Cette IP est uniquement accessible à l’intérieur du cluster.
- **Endpoint** : Objet qui contient toutes les adresses IP et ports des pods associés à un Service. C’est la liaison réelle entre le Service et ses pods cibles.

> À retenir :
> 
> - On ne peut pas _ping_ une ClusterIP : elle n’est utilisée que pour la découverte de service et le routage interne, pas pour l’accès direct.

### 2. Rôle de kube-proxy

Fonction essentielle du kube-proxy:

- **Daemon** qui tourne sur chaque nœud du cluster (sous forme de _DaemonSet_).
- Gère la partie “proxy” : il implémente le fonctionnement des Services Kubernetes en créant des **règles réseau** qui acheminent le trafic vers les pods derrière un Service (équilibrage de charge inclus).
- Fonctionne pour les protocoles TCP, UDP, SCTP, mais **pas au niveau HTTP** (ce n’est pas un reverse proxy type nginx).

### Résumé caricatural

> Kube-proxy = répartiteur de trafic réseau interne pour tous les services Kubernetes, sur tous les nœuds du cluster.
![[c548358d-35f7-4b6f-902a-f2b09f1db75b.png]]


### 3. Modes de fonctionnement de kube-proxy

Kube-proxy maintient les règles réseau via trois modes principaux :

|Mode|Explication|Usage / Notes|
|---|---|---|
|**IPTables**|Par défaut : génère des règles iptables qui capturent le trafic vers une ClusterIP et le redirigent vers les pods.|Simple, robuste, mais peut devenir lent si beaucoup de services/règles.|
|**NFTables**|Nouvelle génération (mode bêta), vise à offrir de meilleures performances et scalabilité que iptables.|Adapté aux très grands clusters, remplace progressivement iptables.|
|**IPVS**|Basé sur IP Virtual Server : offre un load balancing performant avec plusieurs algorithmes de choix des pods.|Préféré pour >1,000 services ; supporte round robin, least connection, etc.|
|Userspace|Ancien mode, très lent, déconseillé aujourd’hui.|Pour mémoire/histoire seulement.|
|Kernelspace|Réservé à Windows nodes.|Peu utilisé sur Linux.|

### Algorithmes IPVS principaux

- **rr** : Round Robin (par défaut)
- **lc** : Least connection
- **dh/sh** : Hashing (destination/source)
- **sed/nq** : Délai minimal / ne jamais mettre en queue

### 4. Schéma du fonctionnement de kube-proxy

|Étape|Description|
|---|---|
|1|Récupère la config des Services/Endpoints via l’API server|
|2|Surveille les changements (nouveau pod, nouveau service, etc.)|
|3|Met à jour dynamiquement les règles réseau locales (selon le mode)|
|4|Acheminer le trafic réçu sur la ClusterIP vers un pod cible (endpoint)|

### Illustration notionnelle

> Exemple :
> 
> - Un client veut contacter un Service via la ClusterIP (par exemple, front-end).
> - kube-proxy redirige le trafic vers l’une des IPs réelles des pods associés, en faisant du load balancing.

### 5. Points clefs et clarification

- kube-proxy **ne comprend pas** le protocole applicatif : il s’arrête au niveau réseau (couche 4).
- Il **ne fait pas office de reverse proxy HTTP** (nginx, HAproxy… : ce rôle est tenu par l’Ingress Controller dans Kubernetes).
- Il est **indispensable à l’interconnexion réseau** interne des services pods → pods et services → pods.
- On peut aussi utiliser des solutions alternatives à kube-proxy, comme **Cilium**, qui suppriment le besoin de proxy par iptables/ipvs via une implémentation eBPF.
- Tous les nœuds d’un cluster exécutent une instance de kube-proxy : la configuration est donc **auto-répliquée** dès qu’un service ou un endpoint change.

### 6. Résumé de kube-proxy

|Élément|Explication courte|
|---|---|
|Rôle|Acheminer et équilibrer le trafic réseau vers les pods derrière un Service (ClusterIP)|
|Emplacement|S’exécute sur chaque nœud Linux/Windows du cluster (DaemonSet)|
|Fonctionnement principal|Crée & met à jour dynamiquement les règles réseau pour chaque service/endpoint|
|Modes|iptables (par défaut), nftables (beta), IPVS (performance), userspace (legacy), kernelspace (Windows)|
|Prise en charge protocole|UDP, TCP, SCTP (couche 4 uniquement)|
|Spécificité|Ne comprend pas HTTP ; gestion fine du load balancing au niveau IP/port|
|Alternatives possibles|Solutions eBPF comme Cilium qui peuvent remplacer totalement kube-proxy|
|Spécificités cluster large|IPVS/nftables recommandés pour les très gros clusters (>1,000 services)|

**En résumé** :

_kube-proxy_ agit comme un gestionnaire de trafic automatique, invisible mais capital, qui assure que chaque Service Kubernetes route correctement le trafic vers ses pods, avec équilibrage de charge—et ce, de façon totalement transparente pour l’utilisateur ou les applications.

### **Scénario : Exposer une application web interne**

Imaginons que vous déployez une application web (par exemple, un service front-end Nginx) dans un cluster Kubernetes, et que vous souhaitez que d’autres applications internes puissent y accéder facilement, sans connaître l’IP de chaque pod.

1. **Déploiement du service**

- Vous créez un **Deployment** Kubernetes contenant plusieurs pods Nginx.
    
- Ensuite, vous créez un **Service** de type **`ClusterIP`** pour exposer ces pods :
    
    ```jsx
    textapiVersion: v1
    kind: Service
    metadata:
      name: nginx-service
    spec:
      selector:
        app: nginx
      ports:
        - protocol: TCP
          port: 80
          targetPort: 80
      type: ClusterIP
    ```
    

1. **Rôle du Service et des Endpoints**

- Le Service reçoit une **ClusterIP** (ex. 10.96.25.100), utilisable par toutes les applications du cluster.
- Le contrôleur Endpoints référence dynamiquement toutes les IPs des pods du déploiement (**`nginx-xyz`**) associés au Service.

**3. Intervention de kube-proxy**

- Sur chaque nœud du cluster, **kube-proxy** configure des règles réseau locales (par défaut avec iptables) :
- Si une application tente d’accéder à l’IP 10.96.25.100:80 (ClusterIP), le trafic est intercepté par cette règle.
- kube-proxy sélectionne alors de façon transparente l’IP d’un des pods “Nginx” pour faire transiter la requête (load balancing).

**4. Conséquence pratique**

Pour le développeur ou l’application cliente :

- Il suffit d’utiliser le nom DNS du service (**`nginx-service`**) ou directement son ClusterIP, sans jamais se soucier des adresses IP réelles des pods (qui peuvent changer lors d’un redémarrage).
- Si un pod Nginx meurt ou est remplacé, kube-proxy ajuste automatiquement les règles pour retirer l’IP obsolète et ajouter la nouvelle, sans aucune coupure.

**5. Schéma simplifié**

|**Action**|**Composant intervenant**|
|---|---|
|Déploiement de pods Nginx|Deployment/Pods|
|Création d’un Service de type ClusterIP|Service/Endpoints|
|Ajustement auto des règles réseau|kube-proxy sur chaque nœud|
|Répartition du trafic entre pods Nginx|kube-proxy (load balancing IP)|

**Résumé**

Grâce à kube-proxy :

- Tous les flux entrants à destination de l’IP virtuelle du Service sont transparents pour les applications.
- Le routage, la tolérance aux pannes et la mise à l’échelle des pods sont automatisés : la connectivité reste toujours opérationnelle, quelle que soit la mobilité des pods dans le cluster.

# 4. **Clients, Outils et Interfaces externes**

Permettent aux utilisateurs et aux systèmes tiers d’interagir avec le cluster.

- **kubectl**
    
    Interface en ligne de commande pour gérer et administrer Kubernetes.
    
- **Dashboards**
    
    Interfaces web pour le monitoring et la gestion.
    
- **Pipelines CI/CD, Monitoring, etc.**
    
    Utilisent l’API pour automatiser les déploiements ou superviser l’état du cluster.
    

## 5. **Architecture & Communication**

- **Tous les échanges passent par le kube-apiserver** (API REST sécurisée).
- Les autres composants consomment ou reportent l’état via cette API ; ils ne communiquent pas directement entre eux.
- Toutes les instructions, créations, modifications et lectures sont **persistées dans etcd** par l’API.

### mTLS (Mutual TLS) : C’est quoi ?

**mTLS** ou “Mutual TLS” est une version renforcée du chiffrement réseau TLS où client et serveur s’authentifient mutuellement.

- **Authentification des deux côtés** : en TLS classique, seul le serveur présente un certificat au client. En mTLS, chacun doit montrer un certificat valide – ce qui prouve son identité à l’autre.
- **Utilisation de certificats X.509** : les certificats sont signés par une Autorité de Certification (CA) de confiance.
- **Chiffrement** : après authentification, toutes les données échangées sont chiffrées.
- **Applications** : utilisé pour sécuriser les échanges entre microservices, APIs, équipements sensibles (IoT) ou dans les architectures “Zero Trust” où rien n’est implicitement digne de confiance[1](https://www.cloudflare.com/learning/access-management/what-is-mutual-tls/)[2](https://www.securew2.com/blog/mutual-tls-mtls-authentication)[3](https://www.cloudflare.com/fr-fr/learning/access-management/what-is-mutual-tls/).

**Résumé du fonctionnement :**

1. Le serveur présente son certificat, que le client vérifie.
2. Le client présente également son certificat, que le serveur vérifie à son tour.
3. Si tout est validé, une connexion chiffrée s’établit et les deux parties communiquent en toute confiance.

### gRPC : C’est quoi ?

**gRPC** (Google Remote Procedure Call) est un framework moderne pour faire communiquer des applications distribuées ou des microservices, publié en open source par Google[4](https://en.wikipedia.org/wiki/GRPC)[5](https://dev.to/samueld/introduction-to-grpc-and-how-it-works-30l5)[6](https://konghq.com/blog/learning-center/what-is-grpc).

- **Fondé sur HTTP/2** : permet la multiplexation, la compression des headers et la gestion efficace du streaming bidirectionnel.
- **Interface contractuelle** : on décrit les services et messages dans des fichiers `.proto` avec le langage Protocol Buffers (“protobuf”).
- **Code généré** : à partir du contrat, gRPC produit du code client/serveur dans de nombreux langages (Go, Java, Python, etc.).
- **Appels distants** : côté client, on invoque directement une méthode distante comme si elle était locale (il n’y a pas à gérer manuellement le transport HTTP ou la (dé)sérialisation).
- **Types d’échanges** :
- Appel simple (“unary”)
- Streaming client
- Streaming serveur
- Streaming bidirectionnel (réellement en temps réel)
- **Sécurité** : gRPC supporte TLS/mTLS pour chiffrer et authentifier les échanges.

**Utilité :**

- Très utilisé pour la communication rapide et structurée entre microservices, sur le cloud ou dans les systèmes distribués modernes, car il est nettement plus efficace (vitesse, consommations, format binaire) qu’un API REST “classique”[4](https://en.wikipedia.org/wiki/GRPC)[5](https://dev.to/samueld/introduction-to-grpc-and-how-it-works-30l5)[6](https://konghq.com/blog/learning-center/what-is-grpc).

|Concept|mTLS (Mutual TLS)|gRPC|
|---|---|---|
|**Domaine**|Sécurité réseau, authentification, chiffrement|Communication inter-applications (RPC)|
|**Principe**|Authentification bidirectionnelle via certificats X.509|Appels de méthodes distantes via Protocol Buffers|
|**Utilité**|Sécuriser et valider l’identité des deux parties|Simplifier et accélérer les échanges automatisés|
|**Protocoles**|TLS (avec mutualisation)|HTTP/2 + Protocol Buffers|
|**Usage**|Microservices, API, IoT, postes sensibles, “Zero Trust”|Microservices, cloud, systèmes distribués|

En résumé :

- **mTLS** protège les communications en forçant une reconnaissance mutuelle et un chiffrement total.
- **gRPC** facilite des échanges structurés, rapides et modernes entre services ou machines, en supportant en plus la sécurité offerte par mTLS

## 6. **Synthèse schématique**

|Catégorie|Composants principaux|Rôle/Emplacement|
|---|---|---|
|**Control Plane**|kube-apiserver, etcd, scheduler, controller-manager, cloud-ctrl|Décisions et orchestration (nœuds dédiés, HA en prod)|
|**Worker Node (calcul)**|kubelet, kube-proxy, container runtime|Exécution des Pods (tous les nœuds worker)|
|**Clients & outils externes**|kubectl, Dashboard, CI/CD|Interaction et automatisation|

## 7. **Haute disponibilité et déploiement**

- En petit environnement/test : tout le control plane sur un seul nœud.
- En production : **plusieurs nœuds control plane**, chacun hébergeant l’ensemble des services critiques pour garantir la résilience du cluster.

## 8. **Automatisation et auto-réparation**

- Les _controllers_ maintiennent l’état cible malgré les défauts (perte de Pod, crash nœud, etc.).
- Grâce à cette architecture : Kubernetes s’auto-ajuste et automatise le cycle de vie complet des applications.

**En résumé :**

Kubernetes organise son fonctionnement autour d’un plan de contrôle centralisé, de nœuds d’exécution spécialisés (avec leurs propres agents), et d’une communication sécurisée, ce qui lui permet d’être robuste, auto-réparant et apte à l’automatisation à grande échelle.
# <span class="title-link">[[quizz final kubernetes|☸️ Certification Kubernetes : L'Examen Final (30 Questions)]] </span>