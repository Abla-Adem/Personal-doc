Voici un quiz complet de 30 questions sur Kubernetes, basé sur votre cours. Il est structuré spécifiquement pour **Obsidian** avec des Callouts repliables (`[!check]`) pour masquer les réponses et les explications.

---

# ☸️ Certification Kubernetes : L'Examen Final (30 Questions)

> [!abstract] Instructions
> 
> Réfléchissez à la réponse avant de cliquer sur **"Correction & Explication"**. Chaque mauvaise réponse est analysée pour renforcer votre compréhension de l'architecture et des composants.

---

### 📂 Section 1 : Le Control Plane (Plan de Contrôle)

**Q1 : Quel composant est le point d'entrée unique du cluster et le seul à communiquer directement avec etcd ?**

1. `kube-scheduler`
    
2. `kube-apiserver`
    
3. `kube-controller-manager`
    
4. `kubelet`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Le `kube-apiserver` expose l'API Kubernetes. C'est le centre nerveux qui valide et configure les données pour les objets API.
> 
> **Pourquoi la 1 est fausse :** Le scheduler surveille l'API pour assigner des nœuds, mais ne gère pas l'entrée globale.
> 
> **Pourquoi la 3 est fausse :** Le controller-manager gère les boucles de contrôle via l'API, il n'est pas le point d'entrée.
> 
> **Pourquoi la 4 est fausse :** La kubelet est un agent sur les nœuds workers, pas dans le control plane.

**Q2 : Quelle est la formule de tolérance aux pannes pour un cluster `etcd` de $n$ nœuds ?**

1. $n - 1$
    
2. $n / 2$
    
3. $(n - 1) / 2$
    
4. $\sqrt{n}$
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** Pour maintenir un quorum (majorité), un cluster etcd peut supporter la perte de la moitié des nœuds moins un.
> 
> **Pourquoi la 1 est fausse :** Cela signifierait qu'un seul nœud suffit pour la cohérence, ce qui est faux pour un système distribué.
> 
> **Pourquoi la 2 est fausse :** Sans le "-1", le système ne pourrait pas garantir une majorité absolue en cas de partition.

**Q3 : Quelle phase du `kube-scheduler` élimine les nœuds qui ne répondent pas aux besoins en ressources d'un Pod ?**

1. Scorage (Scoring)
    
2. Liaison (Binding)
    
3. Filtrage (Filtering)
    
4. Surveillance (Watch)
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** Le filtrage écarte les nœuds incompatibles (mémoire insuffisante, taints, etc.).
> 
> **Pourquoi la 1 est fausse :** Le scorage classe les nœuds _déjà_ filtrés pour trouver le meilleur.
> 
> **Pourquoi la 2 est fausse :** Le binding est l'étape finale d'association une fois le nœud choisi.

**Q4 : Quel composant du Control Plane est responsable de l'auto-réparation (recréer un Pod si celui-ci meurt) ?**

1. `etcd`
    
2. `cloud-controller-manager`
    
3. `kube-controller-manager`
    
4. `kube-proxy`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** C'est lui qui exécute les boucles de contrôle (comme le Deployment Controller) pour faire correspondre l'état réel à l'état désiré.
> 
> **Pourquoi la 1 est fausse :** etcd n'est qu'une base de données, il ne prend aucune décision d'action.
> 
> **Pourquoi la 4 est fausse :** kube-proxy ne gère que le réseau et le routage.

**Q5 : Quel contrôleur spécifique du `cloud-controller-manager` crée un Load Balancer chez votre fournisseur Cloud (AWS/GCP) ?**

1. Route Controller
    
2. Node Controller
    
3. Service Controller
    
4. Volume Controller
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** Le Service Controller du CCM interagit avec l'API Cloud pour provisionner des équilibreurs de charge externes.
> 
> **Pourquoi la 1 est fausse :** Le Route Controller configure les routes réseau (VPC), pas les Load Balancers.
> 
> **Pourquoi la 2 est fausse :** Le Node Controller synchronise l'état des instances (santé, labels).

---

### 🏗️ Section 2 : Nœuds Workers & Agents

**Q6 : Le `kubelet` s'exécute-t-il à l'intérieur d'un conteneur ?**

1. Oui, c'est un Pod système.
    
2. Non, c'est un service système (daemon) géré par l'OS (ex: systemd).
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** La kubelet doit tourner directement sur l'hôte pour pouvoir piloter le runtime de conteneurs et gérer les ressources du nœud.
> 
> **Pourquoi la 1 est fausse :** Si la kubelet était dans un conteneur, elle dépendrait du runtime qu'elle est censée superviser (problème de l'œuf et de la poule).

**Q7 : Quel agent utilise les "probes" (Liveness/Readiness) pour surveiller la santé des applications ?**

1. `kube-proxy`
    
2. `container runtime`
    
3. `kubelet`
    
4. `kubectl`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** La kubelet exécute les tests de santé définis dans le PodSpec et redémarre les conteneurs si nécessaire.
> 
> **Pourquoi la 1 est fausse :** kube-proxy utilise les résultats des probes pour router le trafic, mais il ne les exécute pas.
> 
> **Pourquoi la 2 est fausse :** Le runtime exécute le conteneur, mais c'est la kubelet qui gère la logique de surveillance Kubernetes.

**Q8 : Qu'est-ce qu'un "Static Pod" ?**

1. Un Pod dont l'IP ne change jamais.
    
2. Un Pod géré directement par le fichier local de la kubelet sans passer par l'API Server.
    
3. Un Pod qui ne peut pas être scalé.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Très utile pour démarrer les composants du Control Plane (comme l'API Server lui-même) avant que le cluster ne soit pleinement opérationnel.
> 
> **Pourquoi la 1 est fausse :** L'IP d'un Pod est toujours dynamique par nature dans K8s.

**Q9 : Quel composant est chargé de télécharger les images depuis Docker Hub ou Quay.io ?**

1. `kubelet`
    
2. `kube-apiserver`
    
3. `container runtime`
    
4. `etcd`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** C'est le rôle du runtime (containerd, CRI-O) de gérer le stockage et le cycle de vie des images.
> 
> **Pourquoi la 1 est fausse :** La kubelet donne l'ordre (via CRI), mais c'est le runtime qui effectue physiquement le téléchargement.

**Q10 : Quelle interface permet à Kubernetes d'être agnostique du logiciel de conteneur utilisé (Docker vs containerd) ?**

1. CNI
    
2. CSI
    
3. CRI
    
4. OCI
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** CRI (Container Runtime Interface) est le protocole de communication entre Kubelet et le runtime.
> 
> **Pourquoi la 1 est fausse :** CNI (Container Network Interface) concerne le réseau.
> 
> **Pourquoi la 2 est fausse :** CSI (Container Storage Interface) concerne les volumes de stockage.

---

### 🌐 Section 3 : Réseau & Services

**Q11 : Peut-on "pinguer" une adresse `ClusterIP` depuis l'extérieur du cluster ?**

1. Oui, si les routes sont configurées.
    
2. Non, c'est une IP virtuelle accessible uniquement en interne et gérée par des règles réseau.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** La ClusterIP n'existe pas sur une interface réseau physique ; c'est une construction logique gérée par kube-proxy.
> 
> **Pourquoi la 1 est fausse :** Comme elle ne répond pas aux protocoles ICMP standards de la même façon qu'une interface réelle, le ping échouera souvent même avec des routes.

**Q12 : Quel mode de `kube-proxy` est recommandé pour les clusters de très grande taille (>1000 services) ?**

1. Userspace
    
2. IPTables
    
3. IPVS
    
4. Kernelspace
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** IPVS utilise des tables de hachage plus performantes que la recherche séquentielle de IPTables.
> 
> **Pourquoi la 2 est fausse :** IPTables devient lent car chaque paquet doit traverser une liste de règles qui s'allonge avec le nombre de services.

**Q13 : À quel niveau du modèle OSI `kube-proxy` intervient-il principalement ?**

1. Couche 7 (HTTP)
    
2. Couche 4 (TCP/UDP)
    
3. Couche 2 (Ethernet)
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Il gère le routage basé sur les adresses IP et les ports, sans comprendre le contenu des messages applicatifs.
> 
> **Pourquoi la 1 est fausse :** Le niveau 7 est géré par l'Ingress Controller (nginx, etc.).

**Q14 : Quel objet Kubernetes contient la liste réelle des adresses IP des Pods associés à un Service ?**

1. ConfigMap
    
2. Endpoint
    
3. DaemonSet
    
4. PodSpec
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Kubernetes crée un objet Endpoint (ou EndpointSlice) pour chaque Service afin de suivre les Pods sains.
> 
> **Pourquoi la 1 est fausse :** Une ConfigMap stocke des données de configuration textuelles, pas des états réseau dynamiques.

**Q15 : Quel composant met à jour les règles `iptables` ou `ipvs` sur chaque nœud worker ?**

1. `kube-apiserver`
    
2. `kube-scheduler`
    
3. `kube-proxy`
    
4. `cloud-controller-manager`
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** C'est sa fonction primaire : synchroniser les règles réseau locales avec les Services définis dans l'API.

---

### 🔒 Section 4 : Sécurité & Communication

**Q16 : Qu'est-ce que le "mTLS" (Mutual TLS) apporte de plus que le TLS standard ?**

1. Un chiffrement plus fort (AES-512).
    
2. L'authentification mutuelle : le client doit aussi prouver son identité au serveur.
    
3. Une vitesse de transfert accrue.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** En mTLS, les deux parties présentent des certificats X.509. C'est la base du modèle "Zero Trust".
> 
> **Pourquoi la 1 est fausse :** Le niveau de chiffrement dépend de la suite de chiffrement choisie, pas du fait que ce soit mutuel ou non.

**Q17 : Quel protocole est utilisé pour les communications haute performance entre les composants Kubernetes ?**

1. HTTP/1.1
    
2. gRPC
    
3. FTP
    
4. SMTP
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** gRPC (basé sur HTTP/2) permet des échanges binaires rapides et du streaming bidirectionnel.
> 
> **Pourquoi la 1 est fausse :** HTTP/1.1 est moins efficace à cause de la sérialisation JSON textuelle et de l'absence de multiplexage.

**Q18 : Où sont persistées toutes les configurations et tous les secrets du cluster ?**

1. Sur le disque dur du nœud master.
    
2. Dans la base de données `etcd`.
    
3. Dans le cache de `kube-apiserver`.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** etcd est l'unique source de vérité persistante pour l'état du cluster.
> 
> **Pourquoi la 3 est fausse :** Un cache est volatil ; si l'API Server redémarre, les données seraient perdues sans etcd.

---

### 🛠️ Section 5 : Gestion & Outils

**Q19 : Quel outil est l'interface en ligne de commande standard pour administrer Kubernetes ?**

1. `kubeadm`
    
2. `kubectl`
    
3. `helm`
    
4. `minikube`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** `kubectl` communique avec le kube-apiserver pour envoyer des instructions au cluster.
> 
> **Pourquoi la 1 est fausse :** `kubeadm` est un outil pour _installer_ et configurer un cluster, pas pour l'utiliser au quotidien.

**Q20 : Quelle est l'utilité du "Consensus Raft" dans `etcd` ?**

1. Chiffrer les données.
    
2. Garantir que tous les nœuds du cluster `etcd` s'entendent sur la même valeur (cohérence).
    
3. Compresser les sauvegardes.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Raft permet de choisir un leader et de répliquer les journaux de transactions de façon sécurisée entre les membres.

---

### 🕵️ Section 6 : Logique Avancée & Architecture

**Q21 : Si le composant `kube-scheduler` est arrêté, que se passe-t-il pour les Pods existants ?**

1. Ils s'arrêtent immédiatement.
    
2. Ils continuent de fonctionner, mais les nouveaux Pods resteront à l'état "Pending".
    
3. Ils sont déplacés vers d'autres nœuds.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Le scheduler n'intervient que lors du placement initial. Une fois planifié, le Pod dépend de la kubelet.
> 
> **Pourquoi la 3 est fausse :** Sans scheduler, aucun déplacement (planification) n'est possible.

**Q22 : Quel composant est considéré comme le "StatefulSet" unique du plan de contrôle ?**

1. `kube-apiserver`
    
2. `etcd`
    
3. `kube-proxy`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** etcd nécessite une identité stable et un stockage persistant ordonné, contrairement aux autres composants qui sont souvent stateless.

**Q23 : Quel standard garantit qu'un conteneur créé avec Docker pourra rouler sur un runtime CRI-O ?**

1. CNI
    
2. OCI (Open Container Initiative)
    
3. gRPC
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** L'OCI standardise le format de l'image et le comportement du runtime de bas niveau (`runc`).

**Q24 : Que signifie le terme "Control Loop" (boucle de contrôle) ?**

1. Une erreur infinie dans le code.
    
2. Un processus qui compare l'état désiré à l'état réel et corrige les écarts.
    
3. Le cycle de boot d'un serveur.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** C'est le principe fondamental des contrôleurs Kubernetes (Deployment, Node, etc.).

**Q25 : Quel est le rôle du `Route Controller` dans le Cloud Controller Manager ?**

1. Gérer les noms DNS.
    
2. Configurer les tables de routage de l'infrastructure physique/cloud (VPC).
    
3. Déterminer la route entre deux conteneurs sur le même nœud.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Il assure que les paquets peuvent voyager entre les nœuds du cluster sur le réseau du fournisseur Cloud.

**Q26 : Dans un environnement de production, comment est généralement déployé le Control Plane ?**

1. Sur un seul nœud très puissant.
    
2. Sur plusieurs nœuds pour garantir la Haute Disponibilité (HA).
    
3. Sur chaque nœud worker.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** La réplication du Control Plane évite qu'une seule panne ne paralyse tout le cluster.

**Q27 : Quelle interface utilise `cAdvisor` pour collecter des métriques de performance ?**

1. La kubelet.
    
2. Le kube-apiserver.
    
3. etcd.
    

> [!check]- Correction & Explication
> 
> **Réponse : 1**
> 
> **Justesse :** `cAdvisor` est intégré à la `kubelet` pour surveiller l'utilisation des ressources par les conteneurs.

**Q28 : Quel plugin est responsable de l'attribution d'une adresse IP à un nouveau Pod ?**

1. Plugin CSI
    
2. Plugin CRI
    
3. Plugin CNI (Container Network Interface)
    

> [!check]- Correction & Explication
> 
> **Réponse : 3**
> 
> **Justesse :** CNI gère l'allocation des IPs et la connectivité réseau inter-Pods.

**Q29 : Que se passe-t-il si `etcd` perd son quorum (ex: 2 nœuds sur 3 tombent) ?**

1. Le cluster continue en mode dégradé.
    
2. Plus aucune modification (écriture) n'est possible sur le cluster.
    
3. Les Pods sont supprimés.
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Sans quorum, etcd ne peut plus garantir la cohérence forte et refuse donc les écritures pour protéger l'intégrité des données.

**Q30 : Quel composant possède un "Proxy intégré" pour accéder aux services ClusterIP depuis l'extérieur (via kubectl proxy) ?**

1. `kube-proxy`
    
2. `kube-apiserver`
    
3. `etcd`
    

> [!check]- Correction & Explication
> 
> **Réponse : 2**
> 
> **Justesse :** Le kube-apiserver peut servir de proxy pour exposer des services internes à des fins de debug.
> 
> **Pourquoi la 1 est fausse :** kube-proxy gère le trafic _interne_ au réseau du cluster, pas le tunnel de management `kubectl proxy`.

---

### 💡 Conclusion

Si vous avez obtenu plus de **25/30**, vous avez une excellente compréhension de l'architecture interne de Kubernetes. Ce quiz est un support idéal pour réviser avant une certification (CKA/CKAD).

**N'oubliez pas d'utiliser le mode Lecture (Ctrl+E) dans Obsidian pour masquer les corrections !**