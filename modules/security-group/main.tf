#-----LOAD_BALANCER
resource "aws_security_group" "public_load_balancer" {
  vpc_id = var.vpc_id
  name   = "${var.project_name}-${var.environment}-public-lb-sg"
  /*
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.node_group.id, aws_security_group.eks.id, aws_security_group.bastion]
  }
*/
  dynamic "ingress" {
    for_each = var.list_ingresses_of_lb
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.list_egresses_of_lb
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

#-----BASTION
resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id
  name   = "${var.project_name}-${var.environment}-bastion-sg"
  /*
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eks.id, aws_security_group.node_group.id, aws_security_group.public_load_balancer.id]
  }
*/
  dynamic "ingress" {
    for_each = var.list_ingresses_of_bastion
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
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
  /*
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.node_group.id, aws_security_group.public_load_balancer.id, aws_security_group.bastion.id]
  }
*/
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
  /*
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eks.id, aws_security_group.public_load_balancer.id, aws_security_group.bastion.id]
  }
*/
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
resource "aws_security_group_rule" "lb_to_node_group" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node_group.id
  security_group_id        = aws_security_group.public_load_balancer.id
}

resource "aws_security_group_rule" "lb_to_eks" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks.id
  security_group_id        = aws_security_group.public_load_balancer.id
}

resource "aws_security_group_rule" "lb_to_bastion" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.public_load_balancer.id
}

resource "aws_security_group_rule" "bastion_to_eks" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks.id
  security_group_id        = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_to_node_group" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node_group.id
  security_group_id        = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "eks_to_node_group" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node_group.id
  security_group_id        = aws_security_group.eks.id
}

resource "aws_security_group_rule" "node_group_to_eks" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks.id
  security_group_id        = aws_security_group.node_group.id
}

resource "aws_security_group_rule" "node_group_to_bastion" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.node_group.id
}

resource "aws_security_group_rule" "eks_to_bastion" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.eks.id
}

resource "aws_security_group_rule" "node_group_to_lb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.public_load_balancer.id
  security_group_id        = aws_security_group.node_group.id
}

resource "aws_security_group_rule" "eks_to_lb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.public_load_balancer.id
  security_group_id        = aws_security_group.eks.id
}
#-----IMPORT_UTILITIES
module "utils" {
  source = "../../utils"
}
