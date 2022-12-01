# Required variables
variable "aws_key" {
  type        = string
  description = "AWS key for access Instances. Key must be valid for chosen region"
}

variable "sg_ssh_cidr" {
  description = "Allowed CIDR for SSH connection to instances (like \"176.38.5.182/32\")"
  type        = string
}

variable "ec2_instance_ami" {
  description = "AWS AMI for instances. If empty, latest Ubuntu server will be used"
  type        = string
}

# Not Required variables
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "aws_availability_zone" {
  type    = string
  default = "us-east-1b"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "subnet_public_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "subnet_private_cidr" {
  type    = string
  default = "10.0.101.0/24"
}
variable "tags" {
  type    = map(any)
  default = {
    Team        = "hillel devops"
    Project     = "modules"
    Environment = "dev"
  }
}
variable "ec2_instance_public_names" {
  description = "List of server names for public subnet"
  type        = list(string)
  default     = ["web"]
}
variable "ec2_instance_private_names" {
  description = "List of server names for private subnet"
  type        = list(string)
  default     = ["db"]
}
variable "ec2_instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t2.micro"
}