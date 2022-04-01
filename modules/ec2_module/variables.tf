variable "environment" {
  description = "The application development stage that this AWS workloads account is associated with, as defined in ADR-2."
  type        = string
  validation {
    condition     = contains(["development", "testing", "staging", "production"], var.environment)
    error_message = "Environment must be one of \"development\", \"testing\", \"staging\", \"production\"."
  }
}

variable "instance_type" {
  type        = map(any)
  description = "The instance type to use for the instance"
}

variable "public_subnet_id" {
  type        = string
  description = "VPC public subnet id to launch bastion host."
}

variable "private_subnet_id" {
  type        = string
  description = "VPC private subnet id to launch private host."
}

variable "region" {
  type        = string
  description = "AWS Default region to launch the private and public hosts"
}

variable "tags" {
  type        = map(string)
  description = "AWS resource tags."
}

variable "vpc_id" {
  type        = string
  description = "VPC Id to create Security Groups for EC2 instances."
}

variable "name_prefix" {
  description = "Prefix used to create resource names."
  type        = string
}

variable "public_ip" {
  description = "Public IP only allows limited users to connect with bastion host (For security purpose we are not allowing ssh to all.)"
  type        = list(any)
}

variable "secret_name" {
  type        = list(any)
  description = "Human readable name of the new secret."
}

variable "secret_string" {
  type        = string
  description = "Private Key."
}

variable "key_name" {
  type        = string
  description = "EC2 key-pare name."
}
