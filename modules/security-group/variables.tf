#GLOBAL
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

#VPC
variable "vpc_id" {
  type        = string
  nullable    = false
  description = "ID of vpc"
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

#EKS_CLUSTER
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

#NODE_GROUP
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
