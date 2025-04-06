#EXPORT_IPs_TO_VIEW
output "bastion_host_public_ip" {
  value       = module.network.bastion_host_public_ip
  sensitive   = false
  description = "The public IP of bastion host, but this is actually IP of EIP that connected to bastion host"
}

output "bastion_host_private_ip" {
  value       = module.network.bastion_host_private_ip
  sensitive   = false
  description = "The private IP of bastion host, this ip has nothing to do with EIP"
}
/*
output "load_balancer_public_ip" {
  value       = module.network.load_balancer_public_ip
  sensitive   = false
  description = "DNS of load balancer. Access this DNS to view the page of project"
}
*/
output "nat_gateway_public_ip" {
  value       = module.network.nat_gateway_public_ip
  sensitive   = false
  description = "The public IP of NAT gateway, but this is actually IP of EIP that connected to NAT gw"
}

output "nat_gateway_private_ip" {
  value       = module.network.nat_gateway_private_ip
  sensitive   = false
  description = "The private IP of NAT gw, but this has nothing to do with the EIP"
}

output "eks_public_endpoint" {
  value       = module.eks_cluster.eks_public_endpoint
  sensitive   = false
  description = "Endpoint for kubectl to connect to remote EKS"
}
