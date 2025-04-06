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

variable "vpc_id" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ID of the vpc"
}

#-----EKS_CLUSTER
variable "eks_cluster_version" {
  type        = number
  nullable    = false
  sensitive   = true
  description = "Version of EKS cluster, also version of EKS node group"
}

variable "eks_role_arn" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Amazon Resource Name of EKS aws_iam_role. Example: aws_iam_role.example.arn"
}

variable "eks_subnet_ids" {
  type        = list(string)
  nullable    = false
  sensitive   = true
  description = "A list of subnet that will be used for EKS cluser & EKS node group"
}

variable "iam_roles_of_eks" {
  nullable    = false
  sensitive   = true
  description = "A object value of an iam_role for eks cluster"
}

variable "iam_roles_of_node_group" {
  nullable    = false
  sensitive   = true
  description = "A object value of an iam_role for eks node group"
}

variable "eks_security_group_id" {
  nullable    = false
  sensitive   = true
  description = "ID of security group of EKS cluster"
}

#-----EKS_NODE_GROUP
variable "node_group_role_arn" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Amazon Resource Name of node group's aws_iam_role. Example: aws_iam_role.example.arn"
}

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

variable "node_group_security_group_id" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ID of security group of node group"
}

#-----SECURITY_GROUPS
/*
variable "lb_security_group_id" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "ID of security group of load balancer instance"
}
*/
variable "bastion_security_group_id" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "ID of security group of bastion instance"
}

