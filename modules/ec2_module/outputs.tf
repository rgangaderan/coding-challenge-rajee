output "public_ip" {
  value       = aws_instance.ec2_bastion.public_ip
  description = "Bastion host's public IP."
}

output "private_ip" {
  value       = aws_instance.ec2_private.private_ip
  description = "Private host's private IP."
}
