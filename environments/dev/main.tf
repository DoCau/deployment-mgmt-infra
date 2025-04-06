terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
//need to config s3_bucket with lb access_logs

module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  environment  = var.environment
  #VPC
  vpc_cidr_block = var.vpc_cidr_block
  #SUBNET
  public_subnet_cidr_block        = var.public_subnet_cidr_block
  public_subnet_availability_zone = var.public_subnet_availability_zone

  nat_subnet_cidr_block        = var.nat_subnet_cidr_block
  nat_subnet_availability_zone = var.nat_subnet_availability_zone

  private_subnet_1_cidr_block        = var.private_subnet_1_cidr_block
  private_subnet_1_availability_zone = var.private_subnet_1_availability_zone

  private_subnet_2_cidr_block        = var.private_subnet_2_cidr_block
  private_subnet_2_availability_zone = var.private_subnet_2_availability_zone
  #INTERNET_GATEWAY
  internet_gateway_desired_destination_cidr_block = var.internet_gateway_desired_destination_cidr_block
  #ROUTE_TABLE

  #BASTION_HOST
  bastion_host_ami           = var.bastion_host_ami
  bastion_host_instance_type = var.bastion_host_instance_type

  bastion_security_group_id = module.security_groups.bastion_security_group_id

  bastion_public_key_file_path  = var.bastion_public_key_file_path
  bastion_private_key_file_path = var.bastion_private_key_file_path
  #NAT_GATEWAY
  nat_gateway_desired_destination_cidr_block = var.nat_gateway_desired_destination_cidr_block
}

module "eks_cluster" {
  source = "../../modules/eks"

  project_name = var.project_name
  environment  = var.environment
  #VPC
  vpc_id = module.network.vpc_id
  #EKS
  eks_cluster_version   = var.eks_cluster_version
  eks_role_arn          = module.iam_role.eks_role_arn
  eks_subnet_ids        = [module.network.private_subnet_1_id, module.network.private_subnet_2_id]
  iam_roles_of_eks      = module.iam_role.iam_roles_of_eks
  eks_security_group_id = module.security_groups.eks_security_group_id
  #NODE_GROUP
  node_group_role_arn          = module.iam_role.node_group_role_arn
  node_group_ami_type          = var.node_group_ami_type
  node_group_disk_size         = var.node_group_disk_size
  node_group_instance_types    = var.node_group_instance_types
  node_group_security_group_id = module.security_groups.node_group_security_group_id

  node_group_min_size     = var.node_group_min_size
  node_group_desired_size = var.node_group_desired_size
  node_group_max_size     = var.node_group_max_size

  node_group_max_unavailable_nodes = var.node_group_max_unavailable_nodes

  iam_roles_of_node_group = module.iam_role.iam_roles_of_node_group

  node_group_public_key_file_path  = var.node_group_public_key_file_path
  node_group_private_key_file_path = var.node_group_private_key_file_path

  bastion_security_group_id = module.security_groups.bastion_security_group_id
}

module "iam_role" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment

  ui_service_ecr_arn       = module.ecr.ui_service_ecr_arn
  api_gateway_ecr_arn      = module.ecr.api_gateway_ecr_arn
  backend_service_ecr_arn  = module.ecr.backend_service_ecr_arn
  database_service_ecr_arn = module.ecr.database_service_ecr_arn

  eks_oidc_arn = module.eks_cluster.eks_oidc_arn
  eks_oidc_url = module.eks_cluster.eks_oidc_url
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "security_groups" {
  source = "../../modules/security-group"

  vpc_id = module.network.vpc_id

  project_name = var.project_name
  environment  = var.environment

  list_ingresses_of_eks = var.list_ingresses_of_eks
  list_egresses_of_eks  = var.list_egresses_of_eks

  list_ingresses_of_node_group = var.list_ingresses_of_node_group
  list_egresses_of_node_group  = var.list_egresses_of_node_group

  list_egresses_of_bastion = var.list_egresses_of_bastion
}

