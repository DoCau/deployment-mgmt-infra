output "eks_public_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  sensitive   = true
  description = "Endpoint for kubectl to connect to remote EKS"
}

output "eks_oidc_arn" {
  value       = aws_iam_openid_connect_provider.eks_oidc.arn
  sensitive   = true
  description = "ARN of OIDC provider..."
}

output "eks_oidc_url" {
  value       = aws_iam_openid_connect_provider.eks_oidc.url
  sensitive   = true
  description = "URL of OIDC provider..."
}
