## Environment variables will be pass from this file ##

environment   = "development" # only 'testing', 'development', 'staging' and 'production' are allowed"
profile       = "raj-personal" # AWS Profile name, [default]
region        = "eu-west-1" # AWS Default region that you need to deploy.
cidr          = "10.0.0.0/16" # VPC CDIR ex- "10.0.0.0/16"
cidr_num_bits = 6 # Numeric value to create the subnet bits [6 is preferred]
name_prefix   = "coding_challenge" # Human readable name for your environment [some product name]
public_ip     = ["175.157.46.160/32", "116.206.246.239/32"] # List of public IP addresses to connect with Bastion Host (do not alow "0.0.0.0/0,)
key_name      = "bastion-key" # ssh key name ("Human readable name")

## base on the environment terraform will pick instance type form the map below. ##
instance_type = {
  testing     = "t2.micro"
  development = "t2.small"
  staging     = "t2.medium"
  production  = "t2.large"
}

secret_name = ["bastion_public_key", "bastion_private_key"] # [Provide 2 unique names for your secret manager keys public and private]
