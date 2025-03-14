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

variable "lb_security_group_id" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ID of security group of load balancer instance"
}

variable "open_port_of_eks_node_that_runs_ui_service" {
  type        = number
  nullable    = false
  sensitive   = true
  description = "A port number of the EKS node that runs ui-service. Purpose is for load balancer to redirect connections to that port"
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

variable "bastion_security_group_id" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ID of security group of Bastion instance"
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
