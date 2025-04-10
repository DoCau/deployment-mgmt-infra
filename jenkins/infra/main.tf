#-----VPC
resource "aws_vpc" "jenkins_cluster" {
  cidr_block = var.vpc_cidr_block

  tags = {
    "Name"         = "${var.project_name}-jenkins-vpc"
    "Last_updated" = module.utils.last_updated
  }
}

#-----SUBNET
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.jenkins_cluster.id
  map_public_ip_on_launch = var.public_subnet_ip_on_launch
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.public_subnet_availability_zone

  tags = {
    "Name"         = "${var.project_name}-${var.public_subnet_availability_zone}-jenkins-pbl-sn"
    "Last_updated" = module.utils.last_updated
  }
}

#-----ROUTE_TABLE_AND_ASSOCIATION
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.jenkins_cluster.id

  tags = {
    "Name"         = "${var.project_name}-jenkins-public-rtable"
    "Last_updated" = module.utils.last_updated
  }
}

resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#-----INTERNET_GATE_WAY
resource "aws_internet_gateway" "internet_to_jenkins" {
  vpc_id = aws_vpc.jenkins_cluster.id

  tags = {
    "Name"         = "${var.project_name}-jenkins-internet-gw"
    "Last_updated" = module.utils.last_updated
  }
}

resource "aws_route" "internet_route_to_jenkins" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.internet_gateway_desired_destination_cidr_block
  gateway_id             = aws_internet_gateway.internet_to_jenkins.id
}

#-----SECURITY_GROUP
resource "aws_security_group" "jenkins_master" {
  name   = "${var.project_name}-jenkins-master-sg"
  vpc_id = aws_vpc.jenkins_cluster.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.utils.local_machine_cidr]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.jenkins_worker.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.jenkins_worker.id]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Last_updated" = module.utils.last_updated
  }
}

resource "aws_security_group" "jenkins_worker" {
  name   = "${var.project_name}-jenkins-worker-sg"
  vpc_id = aws_vpc.jenkins_cluster.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.utils.local_machine_cidr]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Last_updated" = module.utils.last_updated
  }
}

resource "aws_security_group_rule" "ingress_jenkins_worker_to_master" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.jenkins_master.id
  security_group_id        = aws_security_group.jenkins_worker.id
}

resource "aws_security_group_rule" "egress_jenkins_worker_to_master" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.jenkins_master.id
  security_group_id        = aws_security_group.jenkins_worker.id
}

#-----EC2
resource "aws_instance" "jenkins_master" {
  ami             = var.jenkins_master_ami_id
  instance_type   = var.jenkins_master_instance_type
  key_name        = aws_key_pair.jenkins_master.key_name
  security_groups = [aws_security_group.jenkins_master.id]
  subnet_id       = aws_subnet.public.id

  root_block_device {
    volume_size           = var.jenkins_master_volume_size
    volume_type           = var.jenkins_master_volume_type
    delete_on_termination = var.jenkins_master_ebs_delete_on_termination
  }

  instance_market_options {
    market_type = var.jenkins_master_market_type

    dynamic "spot_options" {
      for_each = (var.jenkins_master_market_type == "spot") ? [1] : []
      content {
        spot_instance_type             = var.jenkins_master_spot_instance_type
        instance_interruption_behavior = var.jenkins_master_interruption_behavior
      }
    }
  }

  tags = {
    "Name"         = "${var.project_name}-jenkins-master-ec2"
    "Last_updated" = module.utils.last_updated
  }

  user_data = <<-EOF
  #!/bin/bash
  set -eux
  #export userdir=$(pwd)
  export userdir="/home/ubuntu"

  #Update system without recommend installations
  sudo apt update  
  sudo apt upgrade -y --no-install-recommends

  #Install addtional packages
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common tree

  #Download & add Docker GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  #Add Docker to apt list
  sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

  #Update system after adding Docker to apt
  sudo apt-get update

  #Install Docker and plugins
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  #Add more configs to Docker
  sudo usermod -aG docker ubuntu
  sudo systemctl enable docker

  #Add file docker-compose, write file content & rename file to .yml
  cat <<EOT > /home/ubuntu/docker-compose
  services:
    jenkins:
      image: docker.io/bitnami/jenkins:2
      ports:
        - '8080:8080'
      environment:
        - JENKINS_USERNAME=${var.jenkins_username}
        - JENKINS_PASSWORD=${var.jenkins_password}
        - JENKINS_PLUGINS=github,github-pullrequest,pipeline-github,pipeline-model-definition,pipeline-stage-view,ssh-slaves,configuration-as-code,credentials,workflow-support
        - CASC_JENKINS_CONFIG=/bitnami/jenkins/casc_configs/jenkins.yaml
        - JENKINS_OPTS=--httpPort=8080 --httpsPort=-1
      volumes:
        - './jenkins_data:/bitnami/jenkins'
        - './jenkins.yml:/bitnami/jenkins/casc_configs/jenkins.yaml'
  EOT
  mv "$userdir/docker-compose" "$userdir/docker-compose.yml"
  
  #Add directory to store Jenkins data
  mkdir -p "$userdir/jenkins_data"
  sudo chmod 777 -R "$userdir/jenkins_data"

  #Add file jenkins.yml to store data of plugin JENKINS-configuration-as-code
  cat <<EOT > "$userdir/jenkins"
  jenkins:
  credentials:
    system:
      domainCredentials:
        - credentials:
            - usernamePassword:
                scope: GLOBAL
                id: "MICROSERVICES_GITHUB_CREDENTIAL"
                username: "${var.github_repos_username}"
                password: "${var.github_repos_password}"
                description: "Jenkins workers can take this credentials to access microvervices repos"
            - basicSSHUserPrivateKey:
                scope: GLOBAL
                id: SSH_CREDENTIALS_FOR_WORKER_NODES
                username: ${var.worker_ssh_username}
                passphrase: ${var.worker_ssh_passphrase}
                description: "SSH private passphrase & key for SSH connection to worker"
                privateKeySource:
                  directEntry:
                    privateKey: "${local_file.jenkins_worker_private_key.content}"
  EOT
  mv "$userdir/jenkins" "$userdir/jenkins.yml"
  sudo chmod 777 "$userdir/jenkins.yml"

  #Start docker
  cd "$userdir"
  docker compose up -d
  EOF
}

resource "aws_instance" "jenkins_worker" {
  ami             = var.jenkins_worker_ami_id
  instance_type   = var.jenkins_worker_instance_type
  key_name        = aws_key_pair.jenkins_worker.key_name
  security_groups = [aws_security_group.jenkins_worker.id]
  subnet_id       = aws_subnet.public.id

  root_block_device {
    volume_size           = var.jenkins_worker_volume_size
    volume_type           = var.jenkins_worker_volume_type
    delete_on_termination = var.jenkins_worker_ebs_delete_on_termination
  }

  instance_market_options {
    market_type = var.jenkins_worker_market_type

    dynamic "spot_options" {
      for_each = (var.jenkins_worker_market_type == "spot") ? [1] : []
      content {
        spot_instance_type             = var.jenkins_worker_spot_instance_type
        instance_interruption_behavior = var.jenkins_worker_interruption_behavior
      }
    }
  }

  tags = {
    "Name"         = "${var.project_name}-jenkins-worker-ec2"
    "Last_updated" = module.utils.last_updated
  }

  user_data = <<-EOF
  #!/bin/bash
  set -eux
  #export userdir=$(pwd)
  export userdir="/home/ubuntu"

  #Update system without recommend installations
  sudo apt update
  sudo apt upgrade -y --no-install-recommends

  #Install addtional packages
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common openjdk-21-jre-headless tree unzip

  #Download & add Docker GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  #Add Docker to apt list
  sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

  #Update system after adding Docker to apt
  sudo apt-get update

  #Install Docker and plugins
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  #Add more configs to Docker
  sudo usermod -aG docker ubuntu
  sudo systemctl enable docker

  #Start Docker
  sudo systemctl start docker

  #Install GIT SCM
  sudo apt-get install -y git

  #Download & install aws-cli
  curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o "awscliv2.zip"

  #Unzip downloaded file
  unzip awscliv2.zip -d "$userdir"

  #Install aws-cli
  sudo chmod 777 -R "$userdir/aws"
  sudo "$userdir/aws/install"

  #Update system after adding aws-cli
  sudo apt-get update

  #Add credentials to aws cli
  cd "$userdir"
  mkdir -p "$userdir/.aws"
  sudo chmod 777 "$userdir/.aws"
  aws configure set aws_access_key_id ${var.aws_access_key_id}
  aws configure set aws_secret_access_key ${var.aws_secret_access_key}
  aws configure set region ${var.aws_access_key_region}
  aws configure set output json


  #Add workdir for Jenkins
  cd "$userdir"
  mkdir -p "$userdir/var"
  mkdir -p "$userdir/var/jenkins"
  sudo chmod 777 -R "$userdir/var/jenkins"

  #Login Docker with AWS ECR credentials
  export passwordE=$(aws ecr get-login-password --region ${var.aws_access_key_region})
  sudo docker login --username AWS --password "$passwordE" ${var.aws_account_id}.dkr.ecr.${var.aws_access_key_region}.amazonaws.com

  echo "Done!"
  EOF
}

#-----KEYPAIR
resource "tls_private_key" "jenkins_master" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_private_key" "jenkins_worker" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "jenkins_master" {
  key_name   = "jenkins-master-key-pair"
  public_key = tls_private_key.jenkins_master.public_key_openssh

  tags = {
    "Last_updated" = module.utils.last_updated
  }
}

resource "aws_key_pair" "jenkins_worker" {
  key_name   = "jenkins-worker-key-pair"
  public_key = tls_private_key.jenkins_worker.public_key_openssh

  tags = {
    "Last_updated" = module.utils.last_updated
  }
}

resource "local_file" "jenkins_master_public_key" {
  filename = var.jenkins_master_public_key_file_path
  content  = aws_key_pair.jenkins_master.public_key
}

resource "local_file" "jenkins_master_private_key" {
  filename = var.jenkins_master_private_key_file_path
  content  = tls_private_key.jenkins_master.private_key_openssh
}

resource "local_file" "jenkins_worker_public_key" {
  filename = var.jenkins_worker_public_key_file_path
  content  = aws_key_pair.jenkins_worker.public_key
}

resource "local_file" "jenkins_worker_private_key" {
  filename = var.jenkins_worker_private_key_file_path
  content  = tls_private_key.jenkins_worker.private_key_openssh
}

#-----EIP
resource "aws_eip" "jenkins_master" {

  tags = {
    "Name"         = "${var.project_name}-jenkins-master-eip"
    "Last_updated" = module.utils.last_updated
  }
}

resource "aws_eip_association" "jenkins_master" {
  instance_id   = aws_instance.jenkins_master.id
  allocation_id = aws_eip.jenkins_master.id
}

#-----IMPORT_UTILITIES
module "utils" {
  source = "../../utils"
}


