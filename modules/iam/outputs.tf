/*
output "list_iam_roles_of_eks" {
  value       = aws_iam_role_policy_attachment.eks.id
  sensitive   = true
  description = "Export a value of id of aws_iam_role_policy_attachment to use it in eks module - use at block depends_on of aws_eks_cluster"
}

output "list_iam_roles_of_node_group" {
  value       = aws_iam_role_policy_attachment.node.id
  sensitive   = true
  description = "Export a value of id of aws_iam_role_policy_attachment to use it in eks module - use at block depends_on of aws_eks_node_group"

  depends_on = [aws_iam_role_policy_attachment.node, aws_iam_role_policy_attachment.node-cni, aws_iam_role_policy_attachment.node-ssm]
}
*/
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
