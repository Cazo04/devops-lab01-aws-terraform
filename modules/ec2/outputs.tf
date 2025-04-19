output "public_ec2_id" {
  value = aws_instance.public.id
}

output "public_ec2_public_ip" {
  value = aws_instance.public.public_ip
}

output "private_ec2_id" {
  value = aws_instance.private.id
}

output "private_ec2_private_ip" {
  value = aws_instance.private.private_ip
}