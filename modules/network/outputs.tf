output "vpc_id" {
  value       = aws_vpc.vpc.id
  sensitive   = true
  description = "ID of the VPC"
}

output "private_subnet_1_id" {
  value       = aws_subnet.private_1.id
  sensitive   = true
  description = "ID of private subnet-1"
}

output "private_subnet_2_id" {
  value       = aws_subnet.private_2.id
  sensitive   = true
  description = "ID of private subnet-2"
}

#EXPORT_IPs_TO_VIEW
output "bastion_host_public_ip" {
  value       = aws_eip.bastion.public_ip
  sensitive   = true
  description = "The public IP of bastion host, but this is actually IP of EIP that connected to bastion host"
}

output "bastion_host_private_ip" {
  value       = aws_instance.bastion_host.private_ip
  sensitive   = true
  description = "The private IP of bastion host, this ip has nothing to do with EIP"
}

output "load_balancer_public_ip" {
  value       = aws_lb.public.dns_name
  sensitive   = false
  description = "DNS of load balancer. Access this DNS to view the page of project"
}

output "nat_gateway_public_ip" {
  value       = aws_eip.nat_1.public_ip
  sensitive   = true
  description = "The public IP of NAT gateway, but this is actually IP of EIP that connected to NAT gw"
}

output "nat_gateway_private_ip" {
  value       = aws_nat_gateway.nat_1.private_ip
  sensitive   = true
  description = "The private IP of NAT gw, but this has nothing to do with the EIP"
}



