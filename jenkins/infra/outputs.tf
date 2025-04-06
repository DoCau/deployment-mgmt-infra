output "jenkins_master_ui" {
  value       = aws_eip.jenkins_master.public_ip
  sensitive   = false
  description = "Public IP of jenkins master to access to"
}
