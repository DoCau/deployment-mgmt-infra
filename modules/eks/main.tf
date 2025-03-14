#-----EKS_CLUSTER
resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-${var.environment}-eks-cluster"
  version  = var.eks_cluster_version
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids         = var.eks_subnet_ids
    security_group_ids = [var.eks_security_group_id]

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }

  depends_on = [var.iam_roles_of_eks]
}

#-----EKS_CLUSTER_NODE_GROUP
resource "aws_eks_node_group" "this" {
  node_group_name = "${var.project_name}-${var.environment}-node-group"
  subnet_ids      = var.eks_subnet_ids
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn   = var.node_group_role_arn
  version         = aws_eks_cluster.this.version

  ami_type       = var.node_group_ami_type
  disk_size      = var.node_group_disk_size
  instance_types = var.node_group_instance_types

  scaling_config {
    min_size     = var.node_group_min_size
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
  }

  update_config {
    max_unavailable = var.node_group_max_unavailable_nodes
  }

  node_repair_config {
    enabled = true
  }

  remote_access {
    ec2_ssh_key               = aws_key_pair.node_group.key_name
    source_security_group_ids = [var.node_group_security_group_id]
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }

  depends_on = [var.iam_roles_of_node_group]
}

resource "tls_private_key" "node_group" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "node_group" {
  key_name   = "${var.project_name}-${var.environment}-node-group-key-pair"
  public_key = tls_private_key.node_group.public_key_openssh

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "local_file" "node_group_public_key" {
  filename = var.node_group_public_key_file_path
  content  = aws_key_pair.node_group.public_key
}

resource "local_file" "node_group_private_key" {
  filename = var.node_group_private_key_file_path
  content  = tls_private_key.node_group.private_key_openssh
}

#-----EKS_OIDC
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.this.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url             = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
}

#-----IMPORT_UTILITIES
module "utils" {
  source = "../../utils"
}

