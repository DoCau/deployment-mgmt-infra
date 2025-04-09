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

#-----ECR
variable "ui_service_ecr_arn" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ARN of ECR ui-service"
}

variable "api_gateway_ecr_arn" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ARN of ECR api-gateway"
}
variable "backend_service_ecr_arn" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ARN of ECR backend-service"
}
variable "database_service_ecr_arn" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ARN of ECR db-service"
}

variable "eks_oidc_arn" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "ARN of OIDC provider..."
}

variable "eks_oidc_url" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "URL of OIDC provider..."
}
