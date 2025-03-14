output "ui_service_ecr_arn" {
  value       = aws_ecr_repository.ui_service.arn
  sensitive   = true
  description = "ARN of ECR ui-service"
}

output "api_gateway_ecr_arn" {
  value       = aws_ecr_repository.api_gateway.arn
  sensitive   = true
  description = "ARN of ECR api-gateway"
}

output "backend_service_ecr_arn" {
  value       = aws_ecr_repository.backend_service.arn
  sensitive   = true
  description = "ARN of ECR backend-service"
}

output "database_service_ecr_arn" {
  value       = aws_ecr_repository.database_service.arn
  sensitive   = true
  description = "ARN of ECR db-service"
}
