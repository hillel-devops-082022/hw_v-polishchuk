# Create provider
provider "aws" {
  region = var.aws_region
}

# Create VPC and subnets
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"


  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = [var.aws_availability_zone]
  private_subnets = [var.subnet_public_cidr]
  public_subnets  = [var.subnet_private_cidr]

  single_nat_gateway = true
  enable_vpn_gateway = true

  tags = var.tags
}

module "security_group_http" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "http"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.tags
}

module "security_group_https" {
  source = "terraform-aws-modules/security-group/aws//modules/https-443"

  name        = "https"
  description = "Security group for web-server with HTTPS ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.tags
}

module "security_group_ssh" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh"
  description = "Security group with SSH ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block, var.sg_ssh_cidr]

  tags = var.tags
}

module "ec2_instance_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(var.ec2_instance_public_names)

  name = "${each.value}-instance"

  ami                         = var.ec2_instance_ami == "" ? data.aws_ami.ubuntu.id : var.ec2_instance_ami
  instance_type               = var.ec2_instance_type
  key_name                    = var.aws_key
  vpc_security_group_ids      = [
    module.security_group_http.security_group_id,
    module.security_group_https.security_group_id,
    module.security_group_ssh.security_group_id
  ]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = var.tags
}

module "ec2_instance_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(var.ec2_instance_private_names)

  name = "${each.value}-instance"

  ami                         = var.ec2_instance_ami == "" ? data.aws_ami.ubuntu.image_id : var.ec2_instance_ami
  instance_type               = var.ec2_instance_type
  key_name                    = var.aws_key
  vpc_security_group_ids      = [module.security_group_ssh.security_group_id]
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address = false

  tags = var.tags
}