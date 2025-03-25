#-----GLOBAL_VARIABLES
variable "project_name" {
  type        = string
  nullable    = false
  description = "Name of project, hyphen separated"
}

variable "environment" {
  type        = string
  nullable    = false
  description = "Name of environment: dev, stag, uat,..."
}

#-----VPC
variable "vpc_cidr_block" {
  type        = string
  nullable    = false
  description = "CIDR block of vpc. Example: 10.0.0.0/16"
}

#-----SUBNET
variable "public_subnet_cidr_block" {
  type        = string
  nullable    = false
  description = "CIDR block of public lb-attached-subnet"
}

variable "public_subnet_availability_zone" {
  type        = string
  nullable    = false
  description = "Availability zone of public lb-attached-subnet. Example: ap-southeast-2a"
}

variable "nat_subnet_cidr_block" {
  type        = string
  nullable    = false
  description = "CIDR block of public natGW-attached-subnet"
}

variable "nat_subnet_availability_zone" {
  type        = string
  nullable    = false
  description = "Availability zone of natGW-attached-subnet. Recommend using same zone with private subnet-2"
}

variable "private_subnet_1_cidr_block" {
  type        = string
  nullable    = false
  description = "CIDR block of private subnet-1"
}

variable "private_subnet_1_availability_zone" {
  type        = string
  nullable    = false
  description = "Availability zone of private subnet-1. Recommend using same zone with public lb-attached-subnet"
}

variable "private_subnet_2_cidr_block" {
  type        = string
  nullable    = false
  description = "CIDR block of private subnet-2"
}

variable "private_subnet_2_availability_zone" {
  type        = string
  nullable    = false
  description = "Availability zone of private subnet-2. Recommend using same zone with natGW-attached-subnet"
}

#-----INTERNET_GATEWAY
variable "internet_gateway_desired_destination_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block to specify allowed-incoming-ip from internet gateway to public route table"
}

#-----LOAD_BALANCER
variable "s3_bucket_name" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Name of s3 bucket to push load balancer access logs to"
}

variable "s3_path_to_lb_logs" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Path to load balancer logs folder on s3 bucket"
}

variable "open_port_of_eks_node_that_runs_ui_service" {
  type        = number
  nullable    = false
  sensitive   = true
  description = "A port number of the EKS node that runs ui-service. Purpose is for load balancer to redirect connections to that port"
}

variable "list_ingresses_of_lb" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  nullable    = false
  sensitive   = true
  description = "A list of ingresses for the load balancer's security group"
}

variable "list_egresses_of_lb" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  nullable    = false
  sensitive   = true
  description = "A list of egresses for the load balancer's security group"
}

#-----BASTION_HOST
variable "bastion_host_ami" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Ami of a OS. Usually in format: ami-xxxxxxxxxxxxxx. Recommend using Ubuntu"
}

variable "bastion_host_instance_type" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Type of AMI instance. Usually in format: t2.micro, t2.medium,..."
}

variable "list_ingresses_of_bastion" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  nullable    = false
  sensitive   = true
  description = "A list of ingresses for the Bastion's security group"
}

variable "list_egresses_of_bastion" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  nullable    = false
  sensitive   = true
  description = "A list of egresses for the Bastion's security group"
}

variable "bastion_public_key_file_path" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Path to save the .pub key file. Example: secr/locked/keys/this-is-the-key.pub"
}

variable "bastion_private_key_file_path" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Path to save the .pem key file. Example: secr/locked/keys/this-is-the-key.pem"
}

#-----NAT_GATEWAY
variable "nat_gateway_desired_destination_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block to specify allowed-incoming-ip from nat gateway to public route table"
}


#-----EKS_CLUSTER
variable "eks_cluster_version" {
  type        = number
  nullable    = false
  sensitive   = true
  description = "Version of EKS cluster, also version of EKS node group"
}

#-----EKS_NODE_GROUP
variable "node_group_ami_type" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "AMI type for nodes in node group. View more info here: https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType"
}

variable "node_group_disk_size" {
  type        = number
  nullable    = true
  description = "Disk size of each node in node group - Elastic Block Storage EBS. Default 20GB if leaves blank"
}

variable "node_group_instance_types" {
  type        = list(string)
  nullable    = false
  sensitive   = true
  description = "List of instance types for nodes in node group. Example: ['t3.medium']"
}

variable "node_group_min_size" {
  type        = number
  nullable    = false
  sensitive   = true
  description = "Minimum number of active nodes"
}

variable "node_group_max_size" {
  type        = number
  nullable    = false
  sensitive   = true
  description = "Maximum number of active nodes"
}

variable "node_group_desired_size" {
  type        = number
  nullable    = false
  sensitive   = true
  description = "Desired number of active nodes"
}

variable "node_group_max_unavailable_nodes" {
  type        = number
  nullable    = false
  sensitive   = true
  description = "Number of node(s) that can be turned off to update or rollback"
}

variable "node_group_public_key_file_path" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Path to save the .pub key file. Example: secr/locked/keys/this-is-the-key.pub"
}

variable "node_group_private_key_file_path" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Path to save the .pem key file. Example: secr/locked/keys/this-is-the-key.pem"
}

#-----SECURITY_GROUPS
variable "list_ingresses_of_eks" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  nullable    = false
  sensitive   = true
  description = "A list of ingresses for eks's security group, but using option cidr_blocks instead of security_groups"
}

variable "list_egresses_of_eks" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  nullable    = false
  sensitive   = true
  description = "A list of egresses for eks's security group"
}

variable "list_ingresses_of_node_group" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  nullable    = false
  sensitive   = true
  description = "A list of ingresses for node group's security group, but using option cidr_blocks instead of security_groups"
}

variable "list_egresses_of_node_group" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  nullable    = false
  sensitive   = true
  description = "A list of egresses for node group's security group"
}

variable "aws_account_id" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ID of the aws account"
}

/*
variable "s3_bucket_name" {
  type      = string
  nullable  = false
  sensitive = true
  default   = "project_deployment_mgmt_tfstate_caudt1"
}
*/
