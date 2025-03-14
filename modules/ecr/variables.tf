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

#-----ECR_PREVENT_DESTROY
variable "ui_service_ecr_prevent_destroy" {
  type        = bool
  nullable    = false
  description = "Decide wether or not to destroy ui-service ECR repository when run 'terraform destroy'"
}

variable "api_gateway_ecr_prevent_destroy" {
  type        = bool
  nullable    = false
  description = "Decide wether or not to destroy api-gateway ECR repository when run 'terraform destroy'"
}

variable "backend_service_ecr_prevent_destroy" {
  type        = bool
  nullable    = false
  description = "Decide wether or not to destroy backend-service ECR repository when run 'terraform destroy'"
}

variable "database_service_ecr_prevent_destroy" {
  type        = bool
  nullable    = false
  description = "Decide wether or not to destroy database-service ECR repository when run 'terraform destroy'"
}
