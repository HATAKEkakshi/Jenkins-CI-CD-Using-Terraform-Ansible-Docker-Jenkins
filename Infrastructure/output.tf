output "JenkinsPublicIP" {
  description = "Public IP of Jenkins instance"
  value       = aws_instance.Jenkins[0].public_ip
}

output "JenkinsPrivateIP" {
  description = "Private IP of Jenkins instance"
  value       = aws_instance.Jenkins[0].private_ip
}

output "Jenkins_Dns_hostname" {
  description = "DNS hostname of the Jenkins instance"
  value       = aws_instance.Jenkins[0].public_dns
}