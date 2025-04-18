output "security_group_ids" {
  value = aws_security_group.my_security_group.*.id
}

output "security_group_names" {
  value = aws_security_group.my_security_group.*.name
}