module "secret_manager" {
  source      = "./module/sm_module/"
  secret_name = var.secret_name
  environment = var.environment
  key_name    = var.key_name
}

module "vpc" {
  source             = "./module/vpc_module/"
  cidr               = var.cidr
  tags               = var.tags
  name_prefix        = var.name_prefix
  cidr_num_bits      = var.cidr_num_bits
  max_azs            = var.max_azs
  az_limit           = var.az_limit
  single_nat_gateway = var.single_nat_gateway

}

module "ec2" {
  source            = "./module/ec2_module/"
  region            = var.region
  instance_type     = var.instance_type
  private_subnet_id = module.vpc.private_subnet_ids[0]
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  tags              = var.tags
  vpc_id            = module.vpc.vpc_id
  name_prefix       = var.name_prefix
  public_ip         = var.public_ip
  secret_string     = module.secret_manager.secret_string
  secret_name       = var.secret_name
  environment       = var.environment
  key_name          = var.key_name

  depends_on = [module.vpc]

}
