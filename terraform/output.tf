output "instance_id" {
  value = aws_instance.srv[*].id
}
output "instance_public_ip" {
  value = aws_instance.srv[*].public_ip
}
output "elb_url" {
  value = aws_elb.elb.dns_name
}
