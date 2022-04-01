<!-- BEGIN_TF_DOCS -->
## AUTOMATE AS MUCH AS YOU CAN!!!!!!!

## Instruction
This project is to create two EC2 instances (Baston Host and Private Host)
Only Bastion Host can communicate with Private EC2,

This Terraform module includes.
1. SSH key-pare.
2. AWS secret manager with private and public key store.
3. VPC with public and private subnets.
4. EC2 instances.

## Pre-Requirements
The deployment server should be configured with the following components.
1. terraform cli (https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. aws cli (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3. aws profile - it depends on how you are going to deploy, best practice is to use aws profile when configuring the cross-account deployments (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)

## NOTE :(
For this project terraform state files are stored in a local state file, for a real environment recommended way is to create remote state with dynamodb state lock.
```commandline
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
```
```commandline
}

resource "aws_dynamodb_table" "state_locking" {
  hash_key = "LockID"
  name     = "dynamodb-state-locking"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}
```
REF: https://www.terraform.io/language/settings/backends/s3

REF: https://jhooq.com/terraform-state-file-locking/

## Steps to deploy
1. Update all the details in terraform.tfvars

```commandline
## Environment variables will be pass from this file ##

environment   = # only 'testing', 'development', 'staging' and 'production' are allowed"
profile       = # AWS Profile name, [default] https://registry.terraform.io/providers/hashicorp/aws/latest/docs
region        = # AWS Default region that you need to deploy.
cidr          = # VPC CIDR ex- "10.0.0.0/16"
cidr_num_bits = # Numeric value to create the subnet bits [6 is preferred]
name_prefix   = # Human readable name for your environment [some product name]
public_ip     = # List of public IP addresses to connect with Bastion Host (do not alow "0.0.0.0/0,)
key_name      = # ssh key name ("Human readable name")

instance_type = {
  testing     = "t2.micro"
  development = "t2.small"
  staging     = "t2.medium"
  production  = "t2.large"
}

secret_name    = # [Provide 2 unique names for your secret manager keys public and private]
```

2. Install all provider plugins.
```commandline
terraform init
```
4. Plan terraform resources by executing the following command (This will list all the resources that terraform will create).
```commandline
terraform plan
```
5. Apply terraform.
```commandline
terraform apply
```
A prompt will ask you to give a input (yes/no), type yes to continue.
if you need terraform to automatically run apply without the confirmation.
```commandline
terraform apply -auto-approve
```
## Steps to verify
1. Once you have successfully deployed, you will be getting two outputs for bastion host's public ip and private host's private ip.


2. We have local execution which will copy the private key to your local directory with permission 400 (This is only for testing purpose).

Executing the following command will allow you to login to Bastion Host.

```commandline
ssh -i "{your key name in local directory}" ubuntu@{bastion_publicIP}
```

3. Once you are logged in to bastion host, you can see the private key created in /home/ubuntu/ directory.

```commandline
ls -al
```

```commandline
ssh -i "{private key name}" ubuntu@{replace with private ip of private instance}
```
## Destroying Infrastructure

1. Cleaning up all the resources. execute following command.

```commandline
terraform destroy
```
and type "yes" to confirm.

### References
1. https://stackoverflow.com/questions/63366425/how-to-get-private-key-from-secret-manager
2. https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
3. https://github.com/terraform-docs/terraform-docs
4. https://stackoverflow.com/questions/49743220/how-do-i-create-an-ssh-key-in-terraform


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.69 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./module/ec2_module/ | n/a |
| <a name="module_secret_manager"></a> [secret\_manager](#module\_secret\_manager) | ./module/sm_module/ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./module/vpc_module/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_limit"></a> [az\_limit](#input\_az\_limit) | The absolute limit for Availability Zones. The default is ok for most cases.<br>The variable is only here for future use (and for us-east-1). | `number` | `5` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR of the VPC. | `string` | n/a | yes |
| <a name="input_cidr_num_bits"></a> [cidr\_num\_bits](#input\_cidr\_num\_bits) | Cidr num bits to create subnets. | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The application development stage or environment. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS EC2 instance type. | `map(any)` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | EC2 key-pare name. | `string` | n/a | yes |
| <a name="input_max_azs"></a> [max\_azs](#input\_max\_azs) | The number of AZs you want to use in the VPC. Only values less than 'az\_limit' and the number of available Zones in the Region are honored.<br>The number of the configured AZs will always be the lesser of the 3 values." | `number` | `3` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix used to create resource names. | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS deployment profile. | `string` | n/a | yes |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | Public ips of users that needs to connect to bastion host (for security purpose we are not allowing ssh to all.) | `list(any)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS default region to launch the instance (private, bastion and vpc. | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Human readable name of the new secret. | `list(any)` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Resource tags | `map(string)` | <pre>{<br>  "Type": "coding-challenge"<br>}</pre> | no |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private host's private IP. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Bastion host's public IP. |
<!-- END_TF_DOCS -->
