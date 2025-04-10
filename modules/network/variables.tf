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

variable "bastion_volume_size" {
  type        = number
  sensitive   = false
  nullable    = true
  default     = 20
  description = "Size of OS disk of Bastion host upon launching the instance"
}

variable "bastion_volume_type" {
  type        = string
  sensitive   = false
  nullable    = false
  description = "Volume type of the OS disk of Bastion host"
}

variable "bastion_ebs_delete_on_termination" {
  type        = bool
  sensitive   = false
  default     = true
  description = "This option specifies that if ebs of instance should be deleted when instance is terminated or not"
}

variable "bastion_market_type" {
  type        = string
  sensitive   = false
  default     = "on-demand"
  description = "Market type of Bastion host EC2 instance, can only be spot or on-demand"
  validation {
    condition     = contains(["on-demand", "spot"], var.bastion_market_type)
    error_message = "Only on-demand or spot is allowed!"
  }
}

variable "bastion_spot_instance_type" {
  type        = string
  sensitive   = false
  description = "Option to decide wether spot instance should be restarted once or always, can only be one-time or persistent"
  validation {
    condition     = contains(["one-time", "persistent"], var.bastion_spot_instance_type)
    error_message = "Only one-time or persistent is allowed"
  }
}

variable "bastion_interruption_behavior" {
  type        = string
  sensitive   = false
  description = "Option to decide behavior of spot instance when it is interrupted, can only be terminate or stop or hibernate"
  validation {
    condition     = contains(["terminate", "stop", "hibernate"], var.bastion_interruption_behavior)
    error_message = "Only terminate or stop or hibernate is allowed"
  }
}

#-----NAT_GATEWAY
variable "nat_gateway_desired_destination_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block to specify allowed-incoming-ip from nat gateway to public route table"
}
