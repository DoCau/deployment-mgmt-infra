#-----VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-vpc"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

#-----SUBNET
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.public_subnet_availability_zone

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-${var.public_subnet_availability_zone}-public-subnet"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_subnet" "nat" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.nat_subnet_cidr_block
  availability_zone       = var.nat_subnet_availability_zone

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-${var.nat_subnet_availability_zone}-nat-subnet"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnet_1_cidr_block
  availability_zone       = var.public_subnet_availability_zone

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-${var.private_subnet_1_availability_zone}-private-subnet"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnet_2_cidr_block
  availability_zone       = var.private_subnet_2_availability_zone

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-${var.private_subnet_2_availability_zone}-private-subnet"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

#-----INTERNET_GATEWAY_AND_INTERNET_ROUTE
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-internet-gw"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_route" "internet_to_public_subnet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = var.internet_gateway_desired_destination_cidr_block
}

#-----ROUTE_TABLE_AND_ASSOCIATIONS
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-public-rtable"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "nat_route" {
  subnet_id      = aws_subnet.nat.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-private-rtable"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_route_table_association" "private_route_subnet_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_route_subnet_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
/*
#-----LOAD_BALANCER_AND_RELATED_RESOURCES
resource "aws_lb" "public" {
  name                       = "${var.project_name}-${var.environment}-public-lb"
  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = false
  subnets                    = [aws_subnet.public.id, aws_subnet.nat.id]
  security_groups            = [var.lb_security_group_id]
//this access_logs is misconfigured
  access_logs {
    bucket  = var.s3_bucket_name
    prefix  = var.s3_path_to_lb_logs
    enabled = true
  }

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ui_service.arn
  }

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-http-lb-listener"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_lb_target_group" "ui_service" {
  name        = "${var.project_name}-${var.environment}-lb-target-gr"
  vpc_id      = aws_vpc.vpc.id
  port        = var.open_port_of_eks_node_that_runs_ui_service
  protocol    = "HTTP"
  target_type = "ip"

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}
*/
#-----BASTION_HOST_AND_RELATED_RESOURCES
resource "aws_instance" "bastion_host" {
  ami             = var.bastion_host_ami
  instance_type   = var.bastion_host_instance_type
  subnet_id       = aws_subnet.public.id
  key_name        = aws_key_pair.bastion.key_name
  security_groups = [var.bastion_security_group_id]

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-bastion"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_eip" "bastion" {

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-bastion-eip"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion_host.id
  allocation_id = aws_eip.bastion.id
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.project_name}-${var.environment}-bastion-key-pair"
  public_key = tls_private_key.bastion.public_key_openssh

  tags = {
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "local_file" "bastion_public_key" {
  filename = var.bastion_public_key_file_path
  content  = aws_key_pair.bastion.public_key
}

resource "local_file" "bastion_private_key" {
  filename = var.bastion_private_key_file_path
  content  = tls_private_key.bastion.private_key_openssh
}

#-----NAT_GATEWAY_AND_EIP
resource "aws_nat_gateway" "nat_1" {
  subnet_id     = aws_subnet.nat.id
  allocation_id = aws_eip.nat_1.id

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-nat-gw"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_eip" "nat_1" {
  domain = "vpc"

  tags = {
    "Name"         = "${var.project_name}-${var.environment}-nat-gw-eip"
    "Last_updated" = module.utils.last_updated
    "Environment"  = var.environment
  }
}

resource "aws_route" "nat_1" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.nat_gateway_desired_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat_1.id
}

#-----IMPORT_UTILITIES
module "utils" {
  source = "../../utils"
}

