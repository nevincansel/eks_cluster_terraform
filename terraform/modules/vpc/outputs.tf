output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "nat_public_ip" {
  value = module.vpc.nat_public_ips
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}