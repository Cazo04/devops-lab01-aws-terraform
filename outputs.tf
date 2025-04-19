output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_public_subnets_id" {
  value = module.vpc.public_subnets_id
}
output "vpc_private_subnets_id" {
  value = module.vpc.private_subnets_id
}
output "public_ec2_id" {
    value = module.ec2.public_ec2_id
}

output "public_sg_id" {
    value = module.sg.public_sg_id
}

output "private_sg_id" {
    value = module.sg.private_sg_id
}

output "public_ec2_public_ip" {
    value = module.ec2.public_ec2_public_ip
}

output "private_ec2_id" {
    value = module.ec2.private_ec2_id
}

output "private_ec2_private_ip" {
    value = module.ec2.private_ec2_private_ip
}