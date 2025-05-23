output "bastion_security_group_id" {
  value       = aws_security_group.bastion.id
  sensitive   = true
  description = "ID of security group of Bastion instance"
}

output "eks_security_group_id" {
  value       = aws_security_group.eks.id
  sensitive   = true
  description = "ID of security group of EKS cluster"
}

output "node_group_security_group_id" {
  value       = aws_security_group.node_group.id
  sensitive   = true
  description = "ID of security group of node group"
}
