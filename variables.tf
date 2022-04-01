variable "profile" {
  type        = string
  description = "AWS deployment profile."
}
variable "region" {
  type        = string
  description = "AWS default region to launch the instance (private, bastion and vpc."
}

variable "instance_type" {
  type        = map(any)
  description = "AWS EC2 instance type."
}

variable "cidr" {
  description = "The CIDR of the VPC."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to create resource names."
  type        = string
}

variable "max_azs" {
  description = <<EOF
The number of AZs you want to use in the VPC. Only values less than 'az_limit' and the number of available Zones in the Region are honored.
The number of the configured AZs will always be the lesser of the 3 values."
EOF

  type    = number
  default = 3
}

variable "az_limit" {
  description = <<EOF
The absolute limit for Availability Zones. The default is ok for most cases.
The variable is only here for future use (and for us-east-1).
EOF

  type    = number
  default = 5
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"

  type    = bool
  default = true
}

variable "tags" {
  description = "AWS Resource tags"
  default = {
    "Type" = "coding-challenge"
  }
  type = map(string)
}

variable "public_ip" {
  description = "Public ips of users that needs to connect to bastion host (for security purpose we are not allowing ssh to all.)"
  type        = list(any)
}

variable "secret_name" {
  type        = list(any)
  description = "Human readable name of the new secret."
}

variable "environment" {
  description = "The application development stage or environment."
  type        = string
  validation {
    condition     = contains(["development", "testing", "staging", "production"], var.environment)
    error_message = "Environment must be one of \"development\", \"testing\", \"staging\", \"production\"."
  }
}

variable "cidr_num_bits" {
  description = "Cidr num bits to create subnets."
  type        = number
}

variable "key_name" {
  type        = string
  description = "EC2 key-pare name."
}
