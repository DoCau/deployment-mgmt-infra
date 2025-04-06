#-----BASTION
resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id
  name   = "${var.project_name}-${var.environment}-bastion-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.utils.local_machine_cidr]
  }

  dynamic "egress" {
    for_each = var.list_egresses_of_bastion
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

#-----EKS
resource "aws_security_group" "eks" {
  vpc_id = var.vpc_id
  name   = "${var.project_name}-${var.environment}-eks-sg"

  dynamic "ingress" {
    for_each = var.list_ingresses_of_eks
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.list_egresses_of_eks
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

#-----NODE_GROUP
resource "aws_security_group" "node_group" {
  vpc_id = var.vpc_id
  name   = "${var.project_name}-${var.environment}-node-group-sg"

  dynamic "ingress" {
    for_each = var.list_ingresses_of_node_group
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.list_egresses_of_node_group
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

#-----SEPARATED_SG_RULES_TO_AVOID_LOOP_ERROR
resource "aws_security_group_rule" "ingress_from_node_group_to_eks" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node_group.id
  security_group_id        = aws_security_group.eks.id
}

resource "aws_security_group_rule" "ingress_from_eks_to_node_group" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks.id
  security_group_id        = aws_security_group.node_group.id
}

resource "aws_security_group_rule" "ingress_from_bastion_to_node_group" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.node_group.id
}

#-----IMPORT_UTILITIES
module "utils" {
  source = "../../utils"
}
