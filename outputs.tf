output "public_ip" {
  value       = module.ec2.public_ip
  description = "Bastion host's public IP."
}

output "private_ip" {
  value       = module.ec2.private_ip
  description = "Private host's private IP."
}
