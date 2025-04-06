#-----COMMON
variable "project_name" {
  type        = string
  sensitive   = false
  nullable    = false
  description = "Name of the project"
}

#-----VPC
variable "vpc_cidr_block" {
  type        = string
  sensitive   = false
  nullable    = false
  description = "CIDR block of the VPC"
}

#-----SUBNET
variable "public_subnet_ip_on_launch" {
  type        = bool
  sensitive   = false
  nullable    = false
  description = "Set condition wether resources within this subnet will have a public IP upon being created"
}

variable "public_subnet_cidr_block" {
  type        = string
  sensitive   = false
  nullable    = false
  description = "CIDR block of subnet"
}

variable "public_subnet_availability_zone" {
  type        = string
  sensitive   = false
  nullable    = false
  description = "Availability zone of the subnet"
}

#-----INTERNET_GATEWAY
variable "internet_gateway_desired_destination_cidr_block" {
  type        = string
  sensitive   = false
  nullable    = true
  default     = "0.0.0.0/0"
  description = "CIDR block to specify allowed-incoming-ip from internet gateway to public route table"
}

#-----EC2
variable "jenkins_master_ami_id" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Ami of a OS. Usually in format: ami-xxxxxxxxxxxxxx. Recommend using Ubuntu"
}

variable "jenkins_master_instance_type" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Type of AMI instance. Usually in format: t2.micro, t2.medium,..."
}

variable "jenkins_username" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Default jenkins admin username"
}

variable "jenkins_password" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Default jenkins admin password"
}

variable "github_repos_username" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Github username in order to pull repositories"
}

variable "github_repos_password" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Github password in order to pull repositories, can be in format: github_pat_xxxxxxxx"
}

variable "worker_ssh_username" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Username of worker node(s) in order for Jenkins master to SSH to, can be AMI default username"
}

variable "worker_ssh_passphrase" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Passphrase of worker node(s) in order for Jenkins master to SSH to, can be content of SSH private key"
}

variable "jenkins_worker_ami_id" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Ami of a OS. Usually in format: ami-xxxxxxxxxxxxxx. Recommend using Ubuntu"
}

variable "jenkins_worker_instance_type" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Type of AMI instance. Usually in format: t2.micro, t2.medium,..."
}

variable "aws_access_key_id" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "AWS access key ID in order to config aws-cli on worker machine(s)"
}

variable "aws_secret_access_key" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "AWS secret access key in order to config aws-cli on worker machine(s)"
}

variable "aws_access_key_region" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "AWS access key region in order to config aws-cli on worker machine(s), should use same region with provider in provider.tf"
}

variable "aws_account_id" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "AWS account id, which should be account id of the account that owns the aws_access_key_id, aws_secret_access_key, aws_access_key_region"
}

#-----KEY_PAIR
variable "jenkins_master_public_key_file_path" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Path to save the .pub key file on local machine. Example: secr/locked/keys/this-is-the-key.pub"
}

variable "jenkins_master_private_key_file_path" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Path to save the .pem key file on local machine. Example: secr/locked/keys/this-is-the-key.pem"
}

variable "jenkins_worker_public_key_file_path" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Path to save the .pub key file on local machine. Example: secr/locked/keys/this-is-the-key.pub"
}

variable "jenkins_worker_private_key_file_path" {
  type        = string
  sensitive   = true
  nullable    = false
  description = "Path to save the .pem key file on local machine. Example: secr/locked/keys/this-is-the-key.pem"
}

variable "jenkins_worker_volume_size" {
  type        = number
  sensitive   = false
  nullable    = true
  default     = 20
  description = "Size of OS disk of jenkins worker up on launching the instance"
}

variable "jenkins_worker_volume_type" {
  type        = string
  sensitive   = false
  nullable    = false
  description = "Volume type of the OS disk of Jenkins worker"
}

