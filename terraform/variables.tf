variable "instance_type" {
  default = "t2.micro"
}
variable "instance_count" {
  default = 2
}
variable "aws_key" {
  type        = string
  description = "AWS key for access Instances (like \"key_name\")"
}
variable "private_key_path" {
  type        = string
  description = "Path to SSH private key (like \"./keys/key_name.pem\""
}
variable "sg_ssh_cidr" {
  description = "Allowed CIDR for SSH connection to instances (like \"176.38.5.182/32\")"
  type        = string
}
variable "tags" {
  type = map(string)
  default = {
    Team    = "hillel_devops"
    Project = "realworld"
  }
}