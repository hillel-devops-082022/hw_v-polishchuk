output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.this.id, "")
}
output "subnet_public_id" {
  description = "Public subnet ID"
  value       = try(aws_subnet.public.id, "")
}
output "subnet_private_id" {
  description = "Private subnet ID"
  value       = try(aws_subnet.private.id, "")
}
output "security_group_public_id" {
  description = "Public security group ID"
  value       = try(aws_security_group.public.id, "")
}
output "security_group_private_id" {
  description = "Private security group ID"
  value       = try(aws_security_group.private.id, "")
}