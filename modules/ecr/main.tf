#-----ECR
resource "aws_ecr_repository" "ui_service" {
  name                 = "${var.project_name}-${var.environment}-ui-service-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = var.ui_service_ecr_prevent_destroy
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_ecr_repository" "api_gateway" {
  name                 = "${var.project_name}-${var.environment}-api-gateway-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = var.api_gateway_ecr_prevent_destroy
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_ecr_repository" "backend_service" {
  name                 = "${var.project_name}-${var.environment}-backend-svc-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = var.backend_service_ecr_prevent_destroy
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_ecr_repository" "database_service" {
  name                 = "${var.project_name}-${var.environment}-db-service-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = var.database_service_ecr_prevent_destroy
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

#-----IMPORT_UTILITIES
module "utils" {
  source = "../../utils"
}
