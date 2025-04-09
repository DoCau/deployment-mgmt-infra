output "eks_role_arn" {
  value       = aws_iam_role.eks.arn
  sensitive   = true
  description = "ARN of EKS IAM role"
}

output "node_group_role_arn" {
  value       = aws_iam_role.node_group.arn
  sensitive   = true
  description = "ARN of node group IAM role"
}

output "iam_roles_of_eks" {
  value       = aws_iam_role_policy_attachment.eks
  sensitive   = true
  description = "A EKS IAM attachment to be used in depends_on block of module EKS"
}

output "iam_roles_of_node_group" {
  value       = aws_iam_role_policy_attachment.node
  sensitive   = true
  description = "A node group IAM attachment to be used in depends_on block of module EKS"
}
