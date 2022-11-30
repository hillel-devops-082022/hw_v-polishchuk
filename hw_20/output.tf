output "ec2_instance_ami" {
  description = "AWS AMI"
  value = var.ec2_instance_ami == "" ? data.aws_ami.ubuntu.image_id : var.ec2_instance_ami
}
output "ec2_instance_private_id" {
  description = "Private instances IDs"
  value = values(module.ec2_instance_private)[*].id
}
output "ec2_instance_private_public_ip" {
  description = "Private instances IPs"
  value = values(module.ec2_instance_private)[*].public_ip
}
output "ec2_instance_public_id" {
  description = "Public instances IDs"
  value = values(module.ec2_instance_public)[*].id
}
output "ec2_instance_public_public_ip" {
  description = "Public instances IPs"
  value = values(module.ec2_instance_public)[*].public_ip
}