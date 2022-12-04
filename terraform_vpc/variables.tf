variable "aws_region" {
  default = "us-west-2"
}
variable "cidr" {
  default = "10.10.0.0/16"
}
variable "cidr_public" {
  default = "10.10.10.0/24"
}
variable "cidr_private" {
  default = "10.10.20.0/24"
}
variable "tags" {
  type = map(any)
  default = {
    Team        = "hillel devops"
    Project     = "vpc"
    Environment = "dev"
  }
}
