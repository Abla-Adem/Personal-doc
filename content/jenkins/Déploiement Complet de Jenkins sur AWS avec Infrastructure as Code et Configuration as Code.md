**Recommandation principale :** Mettre en œuvre un pipeline d’infrastructure reproductible et sécurisé en combinant **Packer** (AMI), **Terraform** (provisionnement AWS), et **Jenkins Configuration as Code (JCasC)** pour un Master Jenkins hautement disponible et des Agents (slaves) dynamiques et fixes.

## 1. Création des AMI avec Packer

## 1.1. AMI Jenkins Master

Fichier `jenkins-master.json` :

```jsx
json{
  "variables": {
    "aws_region":      "eu-west-1",
    "instance_type":   "t3.medium",
    "ssh_username":    "ubuntu",
    "jenkins_version": "2.435.2"
  },
  "builders": [
    {
      "type":              "amazon-ebs",
      "region":            "{{user `aws_region`}}",
      "instance_type":     "{{user `instance_type`}}",
      "source_ami_filter": {
        "filters": {
          "name":                "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*",
          "root-device-type":    "ebs",
          "virtualization-type": "hvm"
        },
        "owners": ["099720109477"],
        "most_recent": true
      },
      "ssh_username":      "{{user `ssh_username`}}",
      "ami_name":          "jenkins-master-{{timestamp}}",
      "tags": {
        "Name":             "jenkins-master",
        "BuiltBy":          "Packer"
      }
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "sudo apt-get update",
        "sudo apt-get install -y openjdk-11-jdk git docker.io jq",
        "curl -fsSL <https://pkg.jenkins.io/debian-stable/jenkins.io.key> | sudo tee /usr/share/keyrings/jenkins-keyring.asc",
        "echo 'deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] <https://pkg.jenkins.io/debian-stable> binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list",
        "sudo apt-get update",
        "sudo apt-get install -y jenkins={{user `jenkins_version`}}",
        "sudo systemctl enable jenkins",
        "sudo usermod -aG docker jenkins",
        "sudo systemctl start jenkins"
      ]
    },
    {
      "type": "shell",
      "inline": [
        "sudo apt-get clean",
        "sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*"
      ]
    }
  ]
}
```

## 1.2. AMI Jenkins Agent EC2

Fichier `jenkins-agent.json` :

```jsx
json{
  "variables": {
    "aws_region":   "eu-west-1",
    "instance_type":"t3.medium",
    "ssh_username": "ec2-user"
  },
  "builders": [
    {
      "type":              "amazon-ebs",
      "region":            "{{user `aws_region`}}",
      "instance_type":     "{{user `instance_type`}}",
      "source_ami_filter": {
        "filters": {
          "name":                "ami-*-amazon-linux-2",
          "root-device-type":    "ebs",
          "virtualization-type": "hvm"
        },
        "owners": ["amazon"],
        "most_recent": true
      },
      "ssh_username":      "{{user `ssh_username`}}",
      "ami_name":          "jenkins-agent-{{timestamp}}",
      "tags": {
        "Name":             "jenkins-agent",
        "BuiltBy":          "Packer"
      }
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "sudo yum update -y",
        "sudo yum install -y java-11-openjdk git docker",
        "wget <http://jenkins.example.com/jnlpJars/agent.jar> -O /home/{{user `ssh_username`}}/agent.jar",
        "chown {{user `ssh_username`}}:{{user `ssh_username`}} /home/{{user `ssh_username`}}/agent.jar",
        "echo '#!/bin/bash' > /home/{{user `ssh_username`}}/start-agent.sh",
        "echo 'java -jar /home/{{user `ssh_username`}}/agent.jar -jnlpUrl <https://jenkins.example.com/computer/ec2-agent-$>(curl -s <http://169.254.169.254/latest/meta-data/instance-id>)/slave-agent.jnlp -secret YOUR_AGENT_SECRET -workDir /home/{{user `ssh_username`}}' >> /home/{{user `ssh_username`}}/start-agent.sh",
        "chmod +x /home/{{user `ssh_username`}}/start-agent.sh"
      ]
    }
  ]
}
```

1. **`sudo yum update -y`**
    
    Met à jour tous les paquets du système pour partir d’une base à jour et sécurisée.
    
2. **`sudo yum install -y java-11-openjdk git docker`**
    
    Installe :
    
    - **Java 11** (nécessaire pour exécuter l’agent JAR),
    - **Git** (souvent utilisé par les builds),
    - **Docker CLI** (si vos builds nécessitent de lancer des conteneurs).
3. **`wget <http://jenkins.example.com/jnlpJars/agent.jar> -O /home/{{user` ssh_username`}}/agent.jar`**
    
    Télécharge le client Jenkins agent (**`agent.jar`**) depuis votre Master Jenkins et le place dans le home de l’utilisateur (par ex. **`/home/ec2-user/agent.jar`**).
    
4. **`chown {{user` ssh_username`}}:{{user` ssh_username`}} /home/{{user` ssh_username`}}/agent.jar`**
    
    Change le propriétaire du fichier téléchargé pour qu’il appartienne à l’utilisateur Linux qui exécutera l’agent.
    
5. **Création du script de démarrage :**
    
    - **`echo '#!/bin/bash' > /home/{{user` ssh_username`}}/start-agent.sh`**
        
        Initialise un nouveau script shell en écrivant la ligne shebang.
        
    - **`echo 'java -jar /home/{{user` ssh_username`}}/agent.jar -jnlpUrl <https://jenkins.example.com/computer/ec2-agent-$>(curl -s <http://169.254.169.254/latest/meta-data/instance-id>)/slave-agent.jnlp -secret YOUR_AGENT_SECRET -workDir /home/{{user` ssh_username`}}' >> /home/{{user` ssh_username`}}/start-agent.sh`**
        
        Ajoute la commande qui lance l’agent :
        
        - **`jnlpUrl`** : URL pointant vers le fichier JNLP unique de cet agent (utilise l’ID de l’instance pour nommer **`ec2-agent-<instance-id>`**).
        - **`secret`** : jeton secret généré par Jenkins pour authentifier l’agent.
        - **`workDir`** : répertoire de travail de l’agent (workspace).
6. **`chmod +x /home/{{user` ssh_username`}}/start-agent.sh`**
    
    Rend le script exécutable.
    

Une fois votre AMI créée, toute instance lancée à partir de cette image pourra démarrer automatiquement l’agent Jenkins en exécutant **`/home/ec2-user/start-agent.sh`** (via **`user_data`** ou un service systemd), se connectant ainsi au Master pour recevoir des builds.

## 2. Provisionnement AWS avec Terraform

## 2.1. Provider et Variables

```jsx
textprovider "aws" {
  region = var.aws_region
}

variable "aws_region"    { default = "eu-west-1" }
variable "subnet_ids"    { type = list(string) }
variable "key_name"      { type = string }
variable "environment"   { default = "prod" }
```

## 2.2. Data Sources AMI

```jsx
textdata "aws_ami" "jenkins_master" {
  most_recent = true
  filter {
    name   = "name"
    values = ["jenkins-master-*"]
  }
  owners = ["self"]
}

data "aws_ami" "jenkins_agent" {
  most_recent = true
  filter {
    name   = "name"
    values = ["jenkins-agent-*"]
  }
  owners = ["self"]
}
```

## 2.3. IAM Roles

```jsx
text# Master Role
resource "aws_iam_role" "jenkins_master" {
  name               = "jenkins-master-role"
  assume_role_policy = data.aws_iam_policy_document.master_assume_role.json
}
data "aws_iam_policy_document" "master_assume_role" {
  statement {
    actions    = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy" "master_policy" {
  name   = "jenkins-master-policy"
  role   = aws_iam_role.jenkins_master.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow", Action = ["s3:GetObject","s3:PutObject","s3:ListBucket"], Resource = ["arn:aws:s3:::jenkins-artifacts/*","arn:aws:s3:::jenkins-backups/*"] },
      { Effect = "Allow", Action = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"], Resource = "arn:aws:logs:*:*:*" },
      { Effect = "Allow", Action = ["ecs:DescribeClusters","ecs:ListTasks","ecs:RunTask"], Resource = "*" }
    ]
  })
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions    = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Agent Role
resource "aws_iam_role" "ecs_agent" {
  name               = "jenkins-ecs-agent-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}
resource "aws_iam_role_policy" "ecs_agent_policy" {
  name = "jenkins-ecs-agent-policy"
  role = aws_iam_role.ecs_agent.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow", Action = ["s3:GetObject","s3:PutObject"], Resource = "arn:aws:s3:::jenkins-artifacts/*" },
      { Effect = "Allow", Action = ["secretsmanager:GetSecretValue"], Resource = "arn:aws:secretsmanager:eu-west-1:*:secret:*" }
    ]
  })
}
```

## 2.4. Masters EC2 (ASG)

```jsx
textresource "aws_launch_template" "jenkins_master" {
  name_prefix   = "jenkins-master-"
  image_id      = data.aws_ami.jenkins_master.id
  instance_type = "t3.large"
  iam_instance_profile { name = aws_iam_instance_profile.jenkins_master_profile.name }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    systemctl start jenkins
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = { Name = "jenkins-master", Env = var.environment }
  }
}
resource "aws_autoscaling_group" "jenkins_master_asg" {
  name_prefix          = "jenkins-master-asg-"
  launch_template {
    id      = aws_launch_template.jenkins_master.id
    version = "$Latest"
  }
  vpc_zone_identifier  = var.subnet_ids
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  target_group_arns    = [aws_lb_target_group.jenkins_master.arn]
  health_check_type    = "EC2"
}
```

## 2.5. Agents EC2 (ASG)

```jsx
textresource "aws_launch_template" "jenkins_agent" {
  name_prefix   = "jenkins-agent-"
  image_id      = data.aws_ami.jenkins_agent.id
  instance_type = "t3.medium"
  key_name      = var.key_name
  user_data = base64encode(<<-EOF
    #!/bin/bash
    /home/ec2-user/start-agent.sh &
  EOF
  )
}
resource "aws_autoscaling_group" "jenkins_agents_asg" {
  name_prefix          = "jenkins-agents-asg-"
  launch_template {
    id      = aws_launch_template.jenkins_agent.id
    version = "$Latest"
  }
  vpc_zone_identifier  = var.subnet_ids
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  health_check_type    = "EC2"
}
```

## 2.6. Cluster ECS & Fargate Service

```jsx
textresource "aws_ecs_cluster" "jenkins" {
  name = "jenkins-ecs-cluster"
}

resource "aws_ecs_task_definition" "jenkins_agent" {
  family                   = "jenkins-agent-fargate"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_agent.arn
  container_definitions    = jsonencode([{
    name         = "jenkins-agent"
    image        = "${aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/jenkins-agent:latest"
    essential    = true
    environment  = [
      { name = "JENKINS_URL",       value = "<https://jenkins.example.com/>" },
      { name = "JENKINS_AGENT_NAME",value = "fargate-\\${RANDOM}" }
    ]
    portMappings = [{ containerPort = 50000, protocol = "tcp" }]
  }])
}

resource "aws_ecs_service" "jenkins_agent_service" {
  name            = "jenkins-agent-service"
  cluster         = aws_ecs_cluster.jenkins.id
  task_definition = aws_ecs_task_definition.jenkins_agent.arn
  desired_count   = 0
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs_agents.id]
    assign_public_ip = false
  }
}
```

## 3. Jenkins Configuration as Code (JCasC)

## 3.1. Emplacement et paramétrage

1. Placer le fichier `jenkins-casc.yaml` dans `/var/jenkins_home/casc_configs/`.
    
2. Dans `/etc/default/jenkins`, ajouter :
    
    ```jsx
    textJENKINS_JAVA_OPTIONS="-Djenkins.install.runSetupWizard=false \\
      -Dcasc.jenkins.config=/var/jenkins_home/casc_configs/jenkins-casc.yaml"
    ```
    

## 3.2. Contenu complet du fichier `jenkins-casc.yaml`

```jsx
textjenkins:
  systemMessage: "Master Jenkins AWS"
  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: "admin"
          password: "${ADMIN_PASSWORD}"
  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: false

  clouds:
    - ecs:
        credentialsId: "aws-credentials-id"
        regionName: "eu-west-1"
        cluster: "jenkins-ecs-cluster"
        jenkinsUrl: "<https://jenkins.example.com/>"
        slaveOpts: "-jnlpProtocols JNLP4-connect"
        templates:
          - templateName: "fargate-agent"
            labelString: "ecs-fargate"
            remoteFS: "/home/jenkins"
            taskDefinitionOverride: "jenkins-agent-fargate"
            memory: "2048"
            cpu: "1024"
            subnets:
              - "${var.subnet_ids[0]}"
              - "${var.subnet_ids[1]}"

    - ssh:
        name: "EC2-Agents"
        host: "ec2-agent.example.com"
        credentialsId: "ssh-key-credentials"
        launchTimeoutSeconds: 120
        port: 22
        jvmOpts: "-Xmx512m"
        labels: "linux-ec2"
        connectUsingSSH: true

unclassified:
  location:
    url: "<https://jenkins.example.com/>"

credentials:
  system:
    domainCredentials:
      - credentials:
          - basicSSHUserPrivateKey:
              scope: SYSTEM
              id: "ssh-key-credentials"
              username: "ec2-user"
              privateKeySource:
                directEntry:
                  privateKey: |
                    -----BEGIN RSA PRIVATE KEY-----
                    …  
                    -----END RSA PRIVATE KEY-----
      - credentials:
          - amazonWebServicesCredentials:
              scope: SYSTEM
              id: "aws-credentials-id"
              accessKey: "${AWS_ACCESS_KEY_ID}"
              secretKey: "${AWS_SECRET_ACCESS_KEY}"
```

### **1. Inclusion dans l’AMI via Packer**

Si vous reconstruisez votre AMI Master avec Packer, vous pouvez ajouter un provisioner qui copie **`jenkins-casc.yaml`** dans le répertoire attendu. Par exemple, dans votre template Packer (**`jenkins-master.json`**) :

```jsx
text{
  // …
  "provisioners": [
    // Installation de Jenkins...
    {
      "type": "file",
      "source": "jenkins-casc.yaml",
      "destination": "/tmp/jenkins-casc.yaml"
    },
    {
      "type": "shell",
      "inline": [
        "mkdir -p /var/jenkins_home/casc_configs",
        "mv /tmp/jenkins-casc.yaml /var/jenkins_home/casc_configs/jenkins-casc.yaml",
        "chown -R jenkins:jenkins /var/jenkins_home/casc_configs"
      ]
    }
  ]
}
```

- Le provisioner **`file`** embarque le fichier local **`jenkins-casc.yaml`** dans l’instance temporaire.
- Le provisioner **`shell`** crée le dossier, déplace le fichier au bon endroit et ajuste les permissions.

Ainsi, toute instance lancée depuis cette AMI dispose déjà de la configuration JCasC.

### **2. Téléchargement depuis S3 via Terraform `user_data`**

Vous pouvez stocker **`jenkins-casc.yaml`** dans un bucket S3 privé et, dans votre Launch Template Terraform, ajouter un script **`user_data`** qui le télécharge puis démarre Jenkins :

```jsx
textresource "aws_launch_template" "jenkins_master" {
  # …
  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Installer AWS CLI si nécessaire
    yum install -y aws-cli

    # Créer le dossier JCasC
    mkdir -p /var/jenkins_home/casc_configs

    # Télécharger le fichier depuis S3 (ajustez le bucket et la région)
    aws s3 cp s3://mon-bucket-config/jenkins-casc.yaml /var/jenkins_home/casc_configs/jenkins-casc.yaml

    # Donner les droits à Jenkins
    chown -R jenkins:jenkins /var/jenkins_home/casc_configs

    # Désactiver l’assistant de premier lancement et définir le chemin JCasC
    echo 'JENKINS_JAVA_OPTIONS="-Djenkins.install.runSetupWizard=false -Dcasc.jenkins.config=/var/jenkins_home/casc_configs/jenkins-casc.yaml"' >> /etc/default/jenkins

    # Démarrer Jenkins
    systemctl enable jenkins
    systemctl start jenkins
  EOF
  )
}
```

- Le script installe **`aws-cli`** (préinstallé si vous utilisez une AMI AWS par défaut).
- Il crée le répertoire, copie le YAML depuis S3 et ajuste les permissions.
- Il met à jour **`/etc/default/jenkins`** pour pointer vers le fichier JCasC.
- Enfin, il démarre Jenkins.

### **3. Résumé du flux de déploiement**

1. **Stockage du YAML**
    - Soit inclus dans l’AMI via Packer,
    - Soit déposé dans un bucket S3 versionné.
2. **Provisionnement EC2 Master**
    - Via Terraform Launch Template (**`user_data`**) ou AMI Packer.
3. **Démarrage Jenkins**
    - Jenkins lit automatiquement l’option Java **`Dcasc.jenkins.config`** définie dans **`/etc/default/jenkins`**.
4. **Application de la configuration**
    - Le plugin **Configuration as Code** importe le YAML et configure le Master (sécurité, clouds, credentials, URL).

Ainsi, votre Master EC2 récupère et applique la configuration JCasC sans intervention manuelle.

## 4. Reconnaissance du Master et des Noeuds par Jenkins

- **Master** : démarre depuis l’AMI préconfigurée, lit le paramètre Java `Dcasc.jenkins.config` pour charger JCasC. Le plugin JCasC :
    - Crée les utilisateurs et la stratégie d’accès.
    - Configure les clouds (ECS, SSH) et leurs templates d’agents.
    - Importe les credentials AWS et SSH.
- **Noeuds (Agents)** :
    - **ECS/Fargate** : Jenkins lance des tâches Fargate via le cloud ECS configuré, l’agent JNLP se connecte automatiquement au Master grâce au `jenkinsUrl` et aux labels.
    - **EC2 fixes** : via le cloud SSH (SSH Launcher), Jenkins se connecte aux instances dont le hostname correspond au pattern et démarre l’agent JAR avec le secret.

Les labels `ecs-fargate` et `linux-ec2` permettent aux pipelines de cibler dynamiquement les agents souhaités.

## 5. Utilisation en Pipeline

```jsx
groovypipeline {
  agent { label 'ecs-fargate' }
  stages { … }
}

pipeline {
  agent { label 'linux-ec2' }
  stages { … }
}
```

## 6. Observabilité et Maintenance

- **Backups** : snapshots EBS + S3 (AWS Backup).
- **Logs** : CloudWatch Logs pour Master et Agents.
- **Monitoring** : CloudWatch Alarms + Prometheus/Grafana.
- **Mises à jour** : reconstruct AMI via Packer, appliquer Terraform pour rolling update ASG.

Cette architecture garantit une solution Jenkins **scalable**, **sécurisée**, **reproductible** et entièrement **déclarative**, optimisée pour un cloud AWS moderne.