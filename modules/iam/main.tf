#-----IAM_ROLE_FOR_EKS
resource "aws_iam_role" "eks" {
  name = "${var.project_name}-${var.environment}-eks-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-service" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

#-----IAM_ROLE_FOR_NODE_GROUP
resource "aws_iam_role" "node_group" {
  name = "${var.project_name}-${var.environment}-node-group-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node-cni" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node-ssm" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "node-ecr" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

#-----IAM_ROLE_FOR_NODE_GROUP_TO_PULL_IMAGES_FROM_ECR
resource "aws_iam_policy" "ui_service_ecr_pull_access" {
  name        = "${var.project_name}-${var.environment}-nodes-ui-ecr"
  description = "Allow EKS worker nodes to pull images from ECR ui-service"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability"],
        Resource = "${var.ui_service_ecr_arn}"
      },
      {
        Effect   = "Allow",
        Action   = ["ecr:GetAuthorizationToken"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "api_gateway_ecr_pull_access" {
  name        = "${var.project_name}-${var.environment}-nodes-gw-ecr"
  description = "Allow EKS worker nodes to pull images from ECR api-gateway"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability"],
        Resource = "${var.api_gateway_ecr_arn}"
      },
      {
        Effect   = "Allow",
        Action   = ["ecr:GetAuthorizationToken"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "backend_service_ecr_pull_access" {
  name        = "${var.project_name}-${var.environment}-nodes-bk-ecr"
  description = "Allow EKS worker nodes to pull images from ECR backend-service"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability"],
        Resource = "${var.backend_service_ecr_arn}"
      },
      {
        Effect   = "Allow",
        Action   = ["ecr:GetAuthorizationToken"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "database_service_ecr_pull_access" {
  name        = "${var.project_name}-${var.environment}-nodes-db-ecr"
  description = "Allow EKS worker nodes to pull images from ECR database-service"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability"],
        Resource = "${var.database_service_ecr_arn}"
      },
      {
        Effect   = "Allow",
        Action   = ["ecr:GetAuthorizationToken"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_ui_ecr_accesses" {
  policy_arn = aws_iam_policy.ui_service_ecr_pull_access.arn
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_node_gw_ecr_accesses" {
  policy_arn = aws_iam_policy.api_gateway_ecr_pull_access.arn
  role       = aws_iam_role.node_group.name
}
resource "aws_iam_role_policy_attachment" "eks_node_bk_ecr_accesses" {
  policy_arn = aws_iam_policy.backend_service_ecr_pull_access.arn
  role       = aws_iam_role.node_group.name
}
resource "aws_iam_role_policy_attachment" "eks_node_db_ecr_accesses" {
  policy_arn = aws_iam_policy.database_service_ecr_pull_access.arn
  role       = aws_iam_role.node_group.name
}

#-----EKS_LOAD_BALANCER_CONTROLLER
resource "aws_iam_role" "aws_lb_controller_role" {
  name = "${var.project_name}-${var.environment}-lb-ctrler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.eks_oidc_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${var.eks_oidc_url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_lb_controller" {
  policy_arn = aws_iam_policy.aws_lb_controller_policy.arn
  role       = aws_iam_role.aws_lb_controller_role.name
}

resource "aws_iam_policy" "aws_lb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM Policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/aws-load-balancer-controller-policy.json")
}

